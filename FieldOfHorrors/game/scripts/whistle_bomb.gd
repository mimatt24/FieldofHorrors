extends Node2D
## Whistle Bomb: thrown in an arc to a landing spot, explodes when the
## fuse runs out. The fuse may already be partly burned ("cooked").

const Palette = preload("res://scripts/palette.gd")

var game = null
var from: Vector2 = Vector2.ZERO
var to: Vector2 = Vector2.ZERO
var flight_time: float = 0.45
var fuse_left: float = 3.0
var blast_radius: float = 130.0
var age: float = 0.0


func _process(delta: float) -> void:
	age += delta
	fuse_left -= delta
	var t: float = clampf(age / flight_time, 0.0, 1.0)
	position = from.lerp(to, t)
	if fuse_left <= 0.0:
		game.explode(position, false)
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var t: float = clampf(age / flight_time, 0.0, 1.0)
	# Landing marker and blast radius, so the throw is readable.
	var landing: Vector2 = to - position
	draw_arc(landing, blast_radius, 0.0, TAU, 48, Color(Palette.FLAG_YELLOW, 0.5), 3.0)
	# Fake height: the bomb looks bigger at the top of the arc.
	var lift: float = sin(PI * t)
	draw_circle(Vector2(0.0, 6.0), 9.0, Color(0.0, 0.0, 0.0, 0.35))
	draw_circle(Vector2(0.0, -40.0 * lift), 9.0 + 4.0 * lift, Palette.MAROON)
	# Fuse blink speeds up as it runs down.
	var blink_rate: float = 4.0 + 10.0 * (1.0 - clampf(fuse_left / 3.0, 0.0, 1.0))
	if fmod(age * blink_rate, 1.0) < 0.5:
		draw_circle(Vector2(0.0, -40.0 * lift), 4.0, Palette.FLAG_YELLOW)
