extends Node2D
## Referee King, Phase 1 only: Stun Flag Toss and Whistle Shockwave.
## Timings come from design/bosses/referee_king_telegraphs.md.

const Palette = preload("res://scripts/palette.gd")

enum Mode { MOVE, FLAG_TELEGRAPH, WAVE_TELEGRAPH, WAVE_ACTIVE }

var game = null
var dead: bool = false
var hp: float = 2000.0
var max_hp: float = 2000.0
var radius: float = 42.0
var move_speed: float = 95.0

var mode: int = Mode.MOVE
var mode_left: float = 0.0
var mode_total: float = 1.0
var flag_cd: float = 3.0
var wave_cd: float = 6.0
var contact_cd: float = 0.0
var flag_target: Vector2 = Vector2.ZERO
var wave_hit: bool = false
var strafe_sign: float = 1.0
var strafe_left: float = 0.0

var slow_factor: float = 1.0
var slow_left: float = 0.0
var burn_dps: float = 0.0
var burn_left: float = 0.0
var flash_left: float = 0.0


func setup(g) -> void:
	game = g
	max_hp = Tuning.num("zombie_fan/hp") * Tuning.num("referee_king/hp_x_trash")
	hp = max_hp
	radius = Tuning.num("referee_king/radius")
	move_speed = Tuning.num("referee_king/move_speed")
	add_to_group("enemies")


## Below the enrage threshold the boss acts faster (design: +15%).
func _action_speed() -> float:
	if hp / max_hp < Tuning.num("referee_king/enrage_below"):
		return Tuning.num("referee_king/enrage_speed")
	return 1.0


func _process(delta: float) -> void:
	if dead:
		return
	var rate: float = _action_speed()
	flash_left = maxf(flash_left - delta, 0.0)
	contact_cd = maxf(contact_cd - delta, 0.0)
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

	var player = game.player
	if player == null or player.dead:
		return
	var to_player: Vector2 = player.position - position
	var distance: float = to_player.length()

	if distance <= radius + player.radius and contact_cd <= 0.0:
		contact_cd = 1.0
		player.take_damage(Tuning.num("referee_king/contact_damage"))

	match mode:
		Mode.MOVE:
			flag_cd -= delta * rate
			wave_cd -= delta * rate
			_move(delta, to_player, distance)
			if wave_cd <= 0.0 and distance < Tuning.num("referee_king/shockwave_radius") * 0.9:
				_enter(Mode.WAVE_TELEGRAPH, Tuning.num("referee_king/shockwave_telegraph") / rate)
			elif flag_cd <= 0.0:
				flag_target = player.position
				_enter(Mode.FLAG_TELEGRAPH, Tuning.num("referee_king/flag_telegraph") / rate)
		Mode.FLAG_TELEGRAPH:
			mode_left -= delta
			if mode_left <= 0.0:
				_land_flag()
				flag_cd = randf_range(Tuning.num("referee_king/flag_cooldown_min"), Tuning.num("referee_king/flag_cooldown_max"))
				_enter(Mode.MOVE, 0.0)
		Mode.WAVE_TELEGRAPH:
			mode_left -= delta
			if mode_left <= 0.0:
				wave_hit = false
				_enter(Mode.WAVE_ACTIVE, Tuning.num("referee_king/shockwave_active"))
		Mode.WAVE_ACTIVE:
			mode_left -= delta
			var ring: float = _wave_radius()
			if not wave_hit and distance <= ring + player.radius:
				wave_hit = true
				if player.take_damage(Tuning.num("referee_king/shockwave_damage")):
					var push: Vector2 = Vector2.RIGHT
					if distance > 0.001:
						push = to_player / distance
					player.apply_knockback(push * Tuning.num("referee_king/shockwave_knockback"))
			if mode_left <= 0.0:
				wave_cd = randf_range(Tuning.num("referee_king/shockwave_cooldown_min"), Tuning.num("referee_king/shockwave_cooldown_max"))
				_enter(Mode.MOVE, 0.0)


func _enter(new_mode: int, time: float) -> void:
	mode = new_mode
	mode_left = time
	mode_total = maxf(time, 0.001)


func _move(delta: float, to_player: Vector2, distance: float) -> void:
	if distance < 0.001:
		return
	var forward: Vector2 = to_player / distance
	var step: Vector2 = Vector2.ZERO
	if distance > 260.0:
		step = forward
	else:
		strafe_left -= delta
		if strafe_left <= 0.0:
			strafe_left = randf_range(1.5, 3.0)
			strafe_sign = -strafe_sign
		step = forward.orthogonal() * strafe_sign
	position += step * move_speed * slow_factor * delta
	position = game.clamp_to_arena(position, radius)


func _land_flag() -> void:
	var player = game.player
	game.spawn_ring(flag_target, Tuning.num("referee_king/flag_radius"), Palette.FLAG_YELLOW, 0.25, true)
	if player.position.distance_to(flag_target) <= Tuning.num("referee_king/flag_radius") + player.radius:
		if player.take_damage(Tuning.num("referee_king/flag_damage")):
			player.apply_root(Tuning.num("referee_king/flag_root"))


func _wave_radius() -> float:
	var t: float = 1.0 - clampf(mode_left / mode_total, 0.0, 1.0)
	return radius + (Tuning.num("referee_king/shockwave_radius") - radius) * t


func take_damage(amount: float, show_flash: bool = true) -> void:
	if dead:
		return
	hp -= amount
	if show_flash:
		flash_left = 0.07
	if hp <= 0.0:
		dead = true
		remove_from_group("enemies")
		game.on_boss_killed(self)
		queue_free()


## The boss shrugs off most of a slow.
func apply_slow(factor: float, time: float) -> void:
	slow_factor = minf(slow_factor, lerpf(1.0, factor, 0.5))
	slow_left = maxf(slow_left, time)


func apply_burn(dps: float, time: float) -> void:
	burn_dps = maxf(burn_dps, dps)
	burn_left = maxf(burn_left, time)


## Bosses do not stagger.
func apply_stagger(_time: float) -> void:
	pass


func _draw() -> void:
	# Body: black and white referee stripes.
	var body: Color = Palette.BONE
	if flash_left > 0.0:
		body = Color.WHITE
	draw_circle(Vector2.ZERO, radius, body)
	if flash_left <= 0.0:
		var x: float = -radius + 10.0
		while x < radius:
			var half: float = sqrt(maxf(radius * radius - x * x, 0.0))
			draw_line(Vector2(x, -half), Vector2(x, half), Palette.INK, 6.0)
			x += 20.0
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 48, Palette.INK, 4.0)
	if hp / max_hp < Tuning.num("referee_king/enrage_below"):
		draw_arc(Vector2.ZERO, radius + 6.0, 0.0, TAU, 48, Palette.BLOOD, 4.0)

	var progress: float = 1.0 - clampf(mode_left / mode_total, 0.0, 1.0)
	match mode:
		Mode.FLAG_TELEGRAPH:
			var local_target: Vector2 = flag_target - position
			var flag_radius: float = Tuning.num("referee_king/flag_radius")
			draw_line(Vector2.ZERO, local_target, Color(Palette.FLAG_YELLOW, 0.6), 3.0)
			draw_circle(local_target, flag_radius * progress, Color(Palette.FLAG_YELLOW, 0.3))
			draw_arc(local_target, flag_radius, 0.0, TAU, 40, Palette.FLAG_YELLOW, 4.0)
		Mode.WAVE_TELEGRAPH:
			var full: float = Tuning.num("referee_king/shockwave_radius")
			draw_arc(Vector2.ZERO, full, 0.0, TAU, 64, Color(Palette.BLOOD, 0.4 + 0.5 * progress), 4.0)
			draw_circle(Vector2.ZERO, radius + 10.0 * progress, Color(Palette.BLOOD, 0.35))
		Mode.WAVE_ACTIVE:
			draw_arc(Vector2.ZERO, _wave_radius(), 0.0, TAU, 64, Palette.BLOOD, 10.0)
