extends Node2D
## Fastball and Curveball. Moves itself and checks hits against the
## "enemies" group by distance (no physics bodies in the slice).

const Palette = preload("res://scripts/palette.gd")

var game = null
var kind: String = "fastball"
var dir: Vector2 = Vector2.RIGHT
var speed: float = 1000.0
var damage: float = 10.0
var pierce_left: int = 0
var radius: float = 7.0
var max_distance: float = 1000.0
var travelled: float = 0.0
var slow_factor: float = 1.0
var slow_time: float = 0.0
var burn_dps: float = 0.0
var burn_time: float = 0.0
var flaming: bool = false
var hit_ids: Array = []

# Curveball arc: sideways offset that returns to the aim line at arc_time.
var start: Vector2 = Vector2.ZERO
var arc_time: float = 0.0
var arc_size: float = 0.0
var age: float = 0.0


func _process(delta: float) -> void:
	age += delta
	travelled += speed * delta
	if kind == "curveball" and arc_time > 0.0 and age < arc_time:
		var side: Vector2 = dir.orthogonal()
		position = start + dir * speed * age + side * sin(PI * age / arc_time) * arc_size
	else:
		position += dir * speed * delta
	if travelled >= max_distance or not game.arena.grow(60.0).has_point(position):
		queue_free()
		return
	_check_hits()
	queue_redraw()


func _check_hits() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy) or enemy.dead:
			continue
		var id: int = enemy.get_instance_id()
		if hit_ids.has(id):
			continue
		if position.distance_to(enemy.position) > radius + enemy.radius:
			continue
		hit_ids.append(id)
		if slow_time > 0.0:
			enemy.apply_slow(slow_factor, slow_time)
		if burn_time > 0.0:
			enemy.apply_burn(burn_dps, burn_time)
		enemy.take_damage(damage)
		if pierce_left <= 0:
			queue_free()
			return
		pierce_left -= 1


func _draw() -> void:
	var color: Color = Palette.BONE
	if kind == "curveball":
		color = Palette.ICE
	if flaming:
		color = Palette.FLAME
		draw_circle(Vector2.ZERO, radius + 4.0, Color(Palette.FLAME, 0.35))
	draw_circle(Vector2.ZERO, radius, color)
	draw_line(Vector2.ZERO, -dir * 18.0, Color(color, 0.5), 3.0)
