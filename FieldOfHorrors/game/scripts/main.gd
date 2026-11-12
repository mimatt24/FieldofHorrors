extends Node2D
## Runs one Pitcher survival run: spawns Zombie Fans on a rising curve,
## opens the Referee King boss gate, and tracks win, loss, and score.

const Palette = preload("res://scripts/palette.gd")
const ArenaScript = preload("res://scripts/arena.gd")
const PlayerScript = preload("res://scripts/player.gd")
const EnemyScript = preload("res://scripts/enemy.gd")
const BossScript = preload("res://scripts/referee_king.gd")
const ProjectileScript = preload("res://scripts/projectile.gd")
const BombScript = preload("res://scripts/whistle_bomb.gd")
const RingScript = preload("res://scripts/fx_ring.gd")
const HudScript = preload("res://scripts/hud.gd")

enum State { TITLE, PLAYING, WON, LOST }

const CONTROLS_TEXT: String = "Move: WASD / left stick     Aim: mouse / right stick\nFastball: LMB / RT     Curveball: RMB / LT\nWhistle Bomb: hold and release Q / RB     Dash: Space / A\nPause: Esc / Start"

var state: int = State.TITLE
var arena: Rect2 = Rect2(0, 0, 2400, 1400)
var world: Node2D
var entities: Node2D
var camera: Camera2D
var hud = null
var player = null
var boss = null

var run_time: float = 0.0
var spawn_left: float = 0.0
var elite_left: float = 0.0
var kills: int = 0
var score: int = 0
var hits_taken: int = 0
var boss_spawned: bool = false
var capstone_unlocked: bool = false


func _ready() -> void:
	randomize()
	process_mode = Node.PROCESS_MODE_ALWAYS
	_register_controls()
	arena = Rect2(0.0, 0.0, Tuning.num("world/arena_width"), Tuning.num("world/arena_height"))

	world = Node2D.new()
	world.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(world)
	var field = ArenaScript.new()
	field.rect = arena
	world.add_child(field)
	entities = Node2D.new()
	world.add_child(entities)

	camera = Camera2D.new()
	camera.position = arena.get_center()
	camera.limit_left = int(arena.position.x) - 200
	camera.limit_top = int(arena.position.y) - 200
	camera.limit_right = int(arena.end.x) + 200
	camera.limit_bottom = int(arena.end.y) + 200
	add_child(camera)
	camera.make_current()

	hud = HudScript.new()
	add_child(hud)
	hud.show_center("FIELD OF HORRORS", "Pitcher vertical slice\n\n%s\n\nPress Enter or A to start" % CONTROLS_TEXT, Palette.SLIME)

	# Automated check: godot --headless --path . -- --smoke-test
	if OS.get_cmdline_user_args().has("--smoke-test"):
		var smoke = load("res://tests/smoke_test.gd").new()
		smoke.game = self
		add_child(smoke)


# --- Controls ---------------------------------------------------------------

func _register_controls() -> void:
	_bind("move_left", [KEY_A, KEY_LEFT], [], [], [[JOY_AXIS_LEFT_X, -1.0]])
	_bind("move_right", [KEY_D, KEY_RIGHT], [], [], [[JOY_AXIS_LEFT_X, 1.0]])
	_bind("move_up", [KEY_W, KEY_UP], [], [], [[JOY_AXIS_LEFT_Y, -1.0]])
	_bind("move_down", [KEY_S, KEY_DOWN], [], [], [[JOY_AXIS_LEFT_Y, 1.0]])
	_bind("aim_left", [], [], [], [[JOY_AXIS_RIGHT_X, -1.0]])
	_bind("aim_right", [], [], [], [[JOY_AXIS_RIGHT_X, 1.0]])
	_bind("aim_up", [], [], [], [[JOY_AXIS_RIGHT_Y, -1.0]])
	_bind("aim_down", [], [], [], [[JOY_AXIS_RIGHT_Y, 1.0]])
	_bind("fire", [], [MOUSE_BUTTON_LEFT], [], [[JOY_AXIS_TRIGGER_RIGHT, 1.0]])
	_bind("curveball", [], [MOUSE_BUTTON_RIGHT], [], [[JOY_AXIS_TRIGGER_LEFT, 1.0]])
	_bind("bomb", [KEY_Q, KEY_E], [], [JOY_BUTTON_RIGHT_SHOULDER], [])
	_bind("dash", [KEY_SPACE, KEY_SHIFT], [], [JOY_BUTTON_A], [])
	_bind("capstone", [KEY_F], [], [JOY_BUTTON_Y], [])
	_bind("start", [KEY_ENTER, KEY_KP_ENTER], [], [JOY_BUTTON_A], [])
	_bind("pause", [KEY_ESCAPE], [], [JOY_BUTTON_START], [])


func _bind(action: String, keys: Array, mouse_buttons: Array, pad_buttons: Array, pad_axes: Array) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action, 0.3)
	for key in keys:
		var key_event: InputEventKey = InputEventKey.new()
		key_event.physical_keycode = key
		InputMap.action_add_event(action, key_event)
	for button in mouse_buttons:
		var mouse_event: InputEventMouseButton = InputEventMouseButton.new()
		mouse_event.button_index = button
		InputMap.action_add_event(action, mouse_event)
	for button in pad_buttons:
		var pad_event: InputEventJoypadButton = InputEventJoypadButton.new()
		pad_event.device = -1
		pad_event.button_index = button
		InputMap.action_add_event(action, pad_event)
	for axis in pad_axes:
		var axis_event: InputEventJoypadMotion = InputEventJoypadMotion.new()
		axis_event.device = -1
		axis_event.axis = axis[0]
		axis_event.axis_value = axis[1]
		InputMap.action_add_event(action, axis_event)


func _unhandled_input(event: InputEvent) -> void:
	if state == State.PLAYING:
		if event.is_action_pressed("pause"):
			var now_paused: bool = not get_tree().paused
			get_tree().paused = now_paused
			if now_paused:
				hud.show_center("PAUSED", CONTROLS_TEXT + "\n\nPress Esc or Start to resume", Palette.BONE)
			else:
				hud.show_center("", "", Palette.BONE)
	elif event.is_action_pressed("start"):
		start_run()


# --- Run loop ---------------------------------------------------------------

func start_run() -> void:
	for child in entities.get_children():
		child.queue_free()
	run_time = 0.0
	spawn_left = 1.5
	elite_left = Tuning.num("spawns/elite_interval")
	kills = 0
	score = 0
	hits_taken = 0
	boss = null
	boss_spawned = false
	capstone_unlocked = false

	player = PlayerScript.new()
	player.setup(self)
	player.position = arena.get_center()
	entities.add_child(player)

	hud.clear_log()
	hud.show_center("", "", Palette.BONE)
	hud.add_log("Survive to the boss gate")
	get_tree().paused = false
	state = State.PLAYING


func _process(delta: float) -> void:
	if state == State.PLAYING and not get_tree().paused:
		run_time += delta
		_update_spawns(delta)
		if not capstone_unlocked and run_time >= Tuning.num("capstone/unlock_time"):
			capstone_unlocked = true
			hud.add_log("Capstone unlocked: Grand Slam Pitch")
		if not boss_spawned and run_time >= Tuning.num("run/boss_time"):
			_spawn_boss()
	if player != null and is_instance_valid(player):
		camera.position = player.position
	hud.refresh(self)


func _update_spawns(delta: float) -> void:
	if boss_spawned:
		return
	var phase: Dictionary = _current_phase()
	if phase.is_empty():
		return
	elite_left -= delta
	spawn_left -= delta
	if spawn_left > 0.0:
		return
	spawn_left = float(phase["interval"])
	if get_tree().get_nodes_in_group("enemies").size() >= int(phase["cap"]):
		return
	var make_elite: bool = elite_left <= 0.0
	if make_elite:
		elite_left = Tuning.num("spawns/elite_interval")
		hud.add_log("Elite Zombie Fan")
	var enemy = EnemyScript.new()
	enemy.setup(self, make_elite)
	enemy.position = _spawn_point()
	entities.add_child(enemy)


func _current_phase() -> Dictionary:
	for phase in Tuning.list("spawns/phases"):
		if run_time < float(phase["until"]):
			return phase
	return {}


## A point on the arena edge, away from the player.
func _spawn_point() -> Vector2:
	var point: Vector2 = arena.get_center()
	for attempt in range(10):
		var side: int = randi() % 4
		match side:
			0:
				point = Vector2(randf_range(arena.position.x, arena.end.x), arena.position.y + 20.0)
			1:
				point = Vector2(randf_range(arena.position.x, arena.end.x), arena.end.y - 20.0)
			2:
				point = Vector2(arena.position.x + 20.0, randf_range(arena.position.y, arena.end.y))
			_:
				point = Vector2(arena.end.x - 20.0, randf_range(arena.position.y, arena.end.y))
		if point.distance_to(player.position) >= 520.0:
			break
	return point


func _spawn_boss() -> void:
	boss_spawned = true
	boss = BossScript.new()
	boss.setup(self)
	var side: float = arena.end.x - 150.0
	if player.position.x > arena.get_center().x:
		side = arena.position.x + 150.0
	boss.position = Vector2(side, arena.get_center().y)
	entities.add_child(boss)
	hud.add_log("BOSS GATE: Referee King")


func phase_text() -> String:
	match state:
		State.TITLE:
			return ""
		State.WON:
			return "FINAL WHISTLE"
		State.LOST:
			return "EJECTED"
	if boss_spawned:
		return "BOSS: REFEREE KING"
	var left: int = int(ceil(Tuning.num("run/boss_time") - run_time))
	return "Boss gate in %d:%02d" % [left / 60, left % 60]


# --- Helpers used by the entities --------------------------------------------

func clamp_to_arena(point: Vector2, margin: float) -> Vector2:
	return Vector2(
		clampf(point.x, arena.position.x + margin, arena.end.x - margin),
		clampf(point.y, arena.position.y + margin, arena.end.y - margin)
	)


func spawn_fastball(from: Vector2, direction: Vector2, flaming: bool) -> void:
	var ball = ProjectileScript.new()
	ball.game = self
	ball.kind = "fastball"
	ball.position = from
	ball.dir = direction.normalized()
	ball.speed = Tuning.num("fastball/speed")
	ball.damage = Tuning.num("fastball/damage")
	ball.pierce_left = int(Tuning.num("fastball/pierce"))
	ball.max_distance = Tuning.num("fastball/range")
	if flaming:
		ball.flaming = true
		ball.burn_dps = Tuning.num("capstone/burn_dps")
		ball.burn_time = Tuning.num("capstone/burn_time")
	entities.add_child(ball)


func spawn_curveball(from: Vector2, target: Vector2) -> void:
	var offset: Vector2 = target - from
	if offset.length() < 1.0:
		offset = Vector2.RIGHT
	var ball = ProjectileScript.new()
	ball.game = self
	ball.kind = "curveball"
	ball.position = from
	ball.start = from
	ball.dir = offset.normalized()
	ball.speed = Tuning.num("curveball/speed")
	ball.damage = Tuning.num("curveball/damage")
	ball.max_distance = Tuning.num("curveball/range")
	ball.slow_factor = Tuning.num("curveball/slow_factor")
	ball.slow_time = Tuning.num("curveball/slow_time")
	ball.arc_time = maxf(offset.length() / ball.speed, 0.2)
	ball.arc_size = Tuning.num("curveball/arc") * clampf(offset.length() / ball.max_distance, 0.3, 1.0)
	entities.add_child(ball)


func spawn_bomb(from: Vector2, target: Vector2, fuse_left: float) -> void:
	var bomb = BombScript.new()
	bomb.game = self
	bomb.from = from
	bomb.to = clamp_to_arena(target, 10.0)
	bomb.position = from
	bomb.fuse_left = fuse_left
	bomb.flight_time = Tuning.num("whistle_bomb/flight_time")
	bomb.blast_radius = Tuning.num("whistle_bomb/radius")
	entities.add_child(bomb)


## Whistle Bomb blast. If it went off in the player's hand it hurts them too.
func explode(at: Vector2, in_hand: bool) -> void:
	var blast: float = Tuning.num("whistle_bomb/radius")
	var damage: float = Tuning.num("whistle_bomb/damage")
	spawn_ring(at, blast, Palette.FLAME, 0.35, true)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy) or enemy.dead:
			continue
		if at.distance_to(enemy.position) <= blast + enemy.radius:
			enemy.apply_stagger(Tuning.num("whistle_bomb/stagger"))
			enemy.take_damage(damage)
	if in_hand and player != null and not player.dead:
		hud.add_log("Cooked it too long!")
		player.take_damage(damage * 0.5)


func spawn_ring(at: Vector2, radius: float, color: Color, duration: float, filled: bool) -> void:
	var ring = RingScript.new()
	ring.position = at
	ring.max_radius = radius
	ring.color = color
	ring.duration = duration
	ring.filled = filled
	entities.add_child(ring)


# --- Events -------------------------------------------------------------------

func on_enemy_killed(enemy) -> void:
	kills += 1
	if enemy.elite:
		score += int(Tuning.num("score/elite"))
		hud.add_log("Elite down")
	else:
		score += int(Tuning.num("score/kill"))
	spawn_ring(enemy.position, enemy.radius * 2.0, Palette.BLOOD, 0.25, true)


func on_boss_killed(dead_boss) -> void:
	kills += 1
	score += int(Tuning.num("score/boss"))
	score += int(run_time * Tuning.num("score/per_second"))
	var no_hit: bool = hits_taken == 0
	if no_hit:
		score += int(Tuning.num("score/no_hit_bonus"))
	spawn_ring(dead_boss.position, 300.0, Palette.FLAG_YELLOW, 0.6, true)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_instance_valid(enemy) and not enemy.dead:
			enemy.take_damage(999999.0)
	state = State.WON
	var seconds: int = int(run_time)
	var body: String = "Referee King defeated in %d:%02d\nKills %d     Score %d" % [seconds / 60, seconds % 60, kills, score]
	if no_hit:
		body += "\nNo-hit bonus!"
	hud.show_center("YOU WIN", body + "\n\nPress Enter or A to play again", Palette.SLIME)


func on_player_hit() -> void:
	hits_taken += 1


func on_player_died() -> void:
	if state != State.PLAYING:
		return
	state = State.LOST
	score += int(run_time * Tuning.num("score/per_second"))
	var seconds: int = int(run_time)
	hud.show_center("EJECTED", "Survived %d:%02d\nKills %d     Score %d\n\nPress Enter or A to try again" % [seconds / 60, seconds % 60, kills, score], Palette.BLOOD)
