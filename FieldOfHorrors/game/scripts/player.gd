extends Node2D
## The Pitcher. Stats come from data/tuning.json (copied from classes.json).
## Controls are registered in main.gd.

const Palette = preload("res://scripts/palette.gd")

var game = null
var dead: bool = false
var radius: float = 16.0

var max_hp: float = 100.0
var hp: float = 100.0
var grit_cap: float = 25.0
var grit: float = 25.0
var stamina_max: float = 100.0
var stamina: float = 100.0
var move_speed: float = 300.0

var aim_dir: Vector2 = Vector2.RIGHT
var using_pad: bool = false
var cd_fastball: float = 0.0
var cd_curveball: float = 0.0
var cd_bomb: float = 0.0
var cd_capstone: float = 0.0
var cooking: bool = false
var cook_time: float = 0.0

var dash_left: float = 0.0
var dash_dir: Vector2 = Vector2.RIGHT
var iframes_left: float = 0.0
var root_left: float = 0.0
var knockback: Vector2 = Vector2.ZERO
var since_hit: float = 99.0
var flash_left: float = 0.0


func setup(g) -> void:
	game = g
	max_hp = Tuning.num("player/hp")
	hp = max_hp
	grit_cap = Tuning.num("player/grit")
	grit = grit_cap
	stamina_max = Tuning.num("player/stamina")
	stamina = stamina_max
	move_speed = Tuning.num("player/spd") * Tuning.num("world/units_per_spd")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		using_pad = false
	elif event is InputEventJoypadButton:
		using_pad = true
	elif event is InputEventJoypadMotion and absf(event.axis_value) > 0.4:
		using_pad = true


func _process(delta: float) -> void:
	if dead:
		return
	_tick_timers(delta)
	_update_aim()
	_move(delta)
	_use_weapons(delta)
	queue_redraw()


func _tick_timers(delta: float) -> void:
	cd_fastball = maxf(cd_fastball - delta, 0.0)
	cd_curveball = maxf(cd_curveball - delta, 0.0)
	cd_bomb = maxf(cd_bomb - delta, 0.0)
	cd_capstone = maxf(cd_capstone - delta, 0.0)
	iframes_left = maxf(iframes_left - delta, 0.0)
	root_left = maxf(root_left - delta, 0.0)
	flash_left = maxf(flash_left - delta, 0.0)
	since_hit += delta
	stamina = minf(stamina + Tuning.num("player/stamina_regen") * delta, stamina_max)
	if since_hit >= Tuning.num("player/grit_regen_delay"):
		grit = minf(grit + Tuning.num("player/grit_regen_rate") * delta, grit_cap)


func _update_aim() -> void:
	if using_pad:
		var stick: Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		if stick.length() > 0.3:
			aim_dir = stick.normalized()
	else:
		var to_mouse: Vector2 = get_global_mouse_position() - position
		if to_mouse.length() > 1.0:
			aim_dir = to_mouse.normalized()


## Where thrown weapons should land: the mouse cursor, or a fixed distance
## along the aim direction on a gamepad.
func _aim_point(max_range: float) -> Vector2:
	var offset: Vector2 = aim_dir * minf(320.0, max_range)
	if not using_pad:
		offset = get_global_mouse_position() - position
	if offset.length() > max_range:
		offset = offset.normalized() * max_range
	return position + offset


func _move(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocity: Vector2 = Vector2.ZERO

	if root_left <= 0.0:
		if dash_left <= 0.0 and Input.is_action_just_pressed("dash") and stamina >= Tuning.num("player/dash_cost"):
			stamina -= Tuning.num("player/dash_cost")
			dash_left = Tuning.num("player/dash_time")
			iframes_left = maxf(iframes_left, Tuning.num("player/dash_iframes"))
			dash_dir = aim_dir
			if input_dir.length() > 0.1:
				dash_dir = input_dir.normalized()
		if dash_left > 0.0:
			dash_left -= delta
			velocity = dash_dir * Tuning.num("player/dash_speed")
		else:
			velocity = input_dir * move_speed
	else:
		dash_left = 0.0

	position += (velocity + knockback) * delta
	knockback = knockback.move_toward(Vector2.ZERO, Tuning.num("player/knockback_decay") * delta)
	position = game.clamp_to_arena(position, radius)


func _use_weapons(delta: float) -> void:
	var muzzle: Vector2 = position + aim_dir * (radius + 6.0)

	if Input.is_action_pressed("fire") and cd_fastball <= 0.0 and not cooking:
		cd_fastball = 1.0 / Tuning.num("fastball/rate")
		game.spawn_fastball(muzzle, aim_dir, false)

	if Input.is_action_pressed("curveball") and cd_curveball <= 0.0 and not cooking:
		cd_curveball = 1.0 / Tuning.num("curveball/rate")
		game.spawn_curveball(muzzle, _aim_point(Tuning.num("curveball/range")))

	# Whistle Bomb: press to light the fuse, release to throw. Holding it
	# "cooks" the fuse; holding too long blows it up in your hand.
	if cooking:
		cook_time += delta
		if cook_time >= Tuning.num("whistle_bomb/fuse"):
			cooking = false
			cd_bomb = Tuning.num("whistle_bomb/cooldown")
			game.explode(position, true)
		elif not Input.is_action_pressed("bomb"):
			cooking = false
			cd_bomb = Tuning.num("whistle_bomb/cooldown")
			var fuse_left: float = Tuning.num("whistle_bomb/fuse") - cook_time
			game.spawn_bomb(position, _aim_point(Tuning.num("whistle_bomb/throw_range")), fuse_left)
	elif Input.is_action_just_pressed("bomb") and cd_bomb <= 0.0:
		cooking = true
		cook_time = 0.0

	if Input.is_action_just_pressed("capstone") and game.capstone_unlocked and cd_capstone <= 0.0:
		cd_capstone = Tuning.num("capstone/cooldown")
		var balls: int = int(Tuning.num("capstone/balls"))
		var spread: float = deg_to_rad(Tuning.num("capstone/spread_deg"))
		for i in range(balls):
			var t: float = 0.5
			if balls > 1:
				t = float(i) / float(balls - 1)
			game.spawn_fastball(muzzle, aim_dir.rotated(lerpf(-spread * 0.5, spread * 0.5, t)), true)


## Returns true if the hit landed (false while dashing through it).
func take_damage(amount: float) -> bool:
	if dead or iframes_left > 0.0:
		return false
	since_hit = 0.0
	flash_left = 0.08
	game.on_player_hit()
	var soaked: float = minf(grit, amount)
	grit -= soaked
	hp -= amount - soaked
	if hp <= 0.0:
		hp = 0.0
		dead = true
		cooking = false
		queue_redraw()
		game.on_player_died()
	return true


func apply_root(time: float) -> void:
	root_left = maxf(root_left, time)


func apply_knockback(impulse: Vector2) -> void:
	knockback = impulse


func _draw() -> void:
	var body: Color = Palette.BONE
	if dead:
		body = Palette.BLOOD
	elif flash_left > 0.0:
		body = Color.WHITE
	elif iframes_left > 0.0:
		body = Color(Palette.BONE, 0.5)
	draw_circle(Vector2.ZERO, radius, body)
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 32, Palette.INK, 3.0)
	if dead:
		return
	# Cap brim shows facing; thin line shows aim.
	draw_line(aim_dir * radius, aim_dir * (radius + 14.0), Palette.MAROON, 8.0)
	draw_line(aim_dir * (radius + 16.0), aim_dir * (radius + 70.0), Color(Palette.BONE, 0.25), 2.0)
	if grit > 0.0:
		draw_arc(Vector2.ZERO, radius + 5.0, -PI / 2.0, -PI / 2.0 + TAU * grit / grit_cap, 32, Palette.SLIME, 3.0)
	if root_left > 0.0:
		draw_arc(Vector2.ZERO, radius + 10.0, 0.0, TAU, 6, Palette.FLAG_YELLOW, 4.0)
	if cooking:
		var t: float = clampf(cook_time / Tuning.num("whistle_bomb/fuse"), 0.0, 1.0)
		draw_arc(Vector2.ZERO, radius + 16.0, -PI / 2.0, -PI / 2.0 + TAU * (1.0 - t), 32, Palette.FLAME.lerp(Palette.BLOOD, t), 5.0)
