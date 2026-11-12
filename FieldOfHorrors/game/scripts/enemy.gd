extends Node2D
## Zombie Fan: the baseline trash enemy. Walks at the player, winds up
## briefly (so the hit is readable), then swings.

const Palette = preload("res://scripts/palette.gd")

var game = null
var elite: bool = false
var dead: bool = false
var hp: float = 54.0
var max_hp: float = 54.0
var radius: float = 16.0
var speed: float = 130.0
var contact_damage: float = 10.0
var attack_windup: float = 0.35
var attack_cooldown: float = 0.9
var attack_reach: float = 14.0

var windup_left: float = -1.0
var cooldown_left: float = 0.0
var slow_factor: float = 1.0
var slow_left: float = 0.0
var burn_dps: float = 0.0
var burn_left: float = 0.0
var stun_left: float = 0.0
var flash_left: float = 0.0


func setup(g, is_elite: bool) -> void:
	game = g
	elite = is_elite
	radius = Tuning.num("zombie_fan/radius")
	max_hp = Tuning.num("zombie_fan/hp")
	speed = Tuning.num("zombie_fan/speed_spd") * Tuning.num("world/units_per_spd")
	contact_damage = Tuning.num("zombie_fan/contact_damage")
	attack_windup = Tuning.num("zombie_fan/attack_windup")
	attack_cooldown = Tuning.num("zombie_fan/attack_cooldown")
	attack_reach = Tuning.num("zombie_fan/attack_reach")
	if elite:
		max_hp *= Tuning.num("zombie_fan/elite_hp_mult")
		speed *= Tuning.num("zombie_fan/elite_speed_mult")
		radius *= 1.35
	hp = max_hp
	add_to_group("enemies")


func _process(delta: float) -> void:
	if dead:
		return
	flash_left = maxf(flash_left - delta, 0.0)
	cooldown_left = maxf(cooldown_left - delta, 0.0)
	if slow_left > 0.0:
		slow_left -= delta
		if slow_left <= 0.0:
			slow_factor = 1.0
	if burn_left > 0.0:
		burn_left -= delta
		take_damage(burn_dps * delta, false)
		if dead:
			return
	queue_redraw()
	if stun_left > 0.0:
		stun_left -= delta
		windup_left = -1.0
		return

	var player = game.player
	if player == null or player.dead:
		return
	var to_player: Vector2 = player.position - position
	var distance: float = to_player.length()
	var reach: float = radius + player.radius + attack_reach

	if windup_left >= 0.0:
		windup_left -= delta
		if windup_left < 0.0:
			cooldown_left = attack_cooldown
			if distance <= reach + 10.0:
				player.take_damage(contact_damage)
		return

	if distance <= reach:
		if cooldown_left <= 0.0:
			windup_left = attack_windup
	elif distance > 0.001:
		position += to_player / distance * speed * slow_factor * delta
	_separate(delta)
	position = game.clamp_to_arena(position, radius)


func _separate(delta: float) -> void:
	for other in get_tree().get_nodes_in_group("enemies"):
		if other == self or not is_instance_valid(other) or other.dead:
			continue
		var away: Vector2 = position - other.position
		var min_gap: float = radius + other.radius
		var gap: float = away.length()
		if gap < min_gap and gap > 0.001:
			position += away / gap * (min_gap - gap) * minf(8.0 * delta, 1.0)


func take_damage(amount: float, show_flash: bool = true) -> void:
	if dead:
		return
	hp -= amount
	if show_flash:
		flash_left = 0.07
	if hp <= 0.0:
		dead = true
		remove_from_group("enemies")
		game.on_enemy_killed(self)
		queue_free()


func apply_slow(factor: float, time: float) -> void:
	slow_factor = minf(slow_factor, factor)
	slow_left = maxf(slow_left, time)


func apply_burn(dps: float, time: float) -> void:
	burn_dps = maxf(burn_dps, dps)
	burn_left = maxf(burn_left, time)


func apply_stagger(time: float) -> void:
	stun_left = maxf(stun_left, time)


func _draw() -> void:
	var body: Color = Palette.CLAY
	if elite:
		body = Palette.SLIME
		draw_arc(Vector2.ZERO, radius + 5.0, 0.0, TAU, 32, Color(Palette.SLIME, 0.6), 3.0)
	if slow_left > 0.0:
		body = body.lerp(Palette.ICE, 0.5)
	if burn_left > 0.0:
		draw_arc(Vector2.ZERO, radius + 2.0, 0.0, TAU, 24, Palette.FLAME, 3.0)
	if flash_left > 0.0:
		body = Color.WHITE
	draw_circle(Vector2.ZERO, radius, body)
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 32, Palette.INK, 3.0)
	# Wind-up tell: a red ring that closes in before the swing lands.
	if windup_left >= 0.0 and attack_windup > 0.0:
		var t: float = clampf(windup_left / attack_windup, 0.0, 1.0)
		draw_arc(Vector2.ZERO, radius + 6.0 + 16.0 * t, 0.0, TAU, 32, Palette.BLOOD, 4.0)
	if hp < max_hp:
		var w: float = radius * 2.0
		draw_rect(Rect2(-radius, -radius - 12.0, w, 5.0), Palette.INK, true)
		draw_rect(Rect2(-radius, -radius - 12.0, w * clampf(hp / max_hp, 0.0, 1.0), 5.0), Palette.BLOOD, true)
