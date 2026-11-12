extends Node
## Headless smoke test. Plays through the whole loop with scripted input:
## start, shoot, kill, bomb, dash, boss gate, capstone, win, restart, lose.
## Run with:  godot --headless --path . -- --smoke-test

const TIME_SCALE: float = 8.0
const REAL_TIMEOUT_MSEC: int = 150000

var game = null
var started_msec: int = 0
var finished: bool = false
var pending_press: Array = []
var pending_release: Array = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Run before every other node so a press made here counts as
	# "just pressed" for the player in the same frame, like real input.
	process_priority = -1000
	started_msec = Time.get_ticks_msec()
	Engine.time_scale = TIME_SCALE
	_run.call_deferred()


func _process(_delta: float) -> void:
	for action in pending_press:
		Input.action_press(action)
	pending_press.clear()
	for action in pending_release:
		Input.action_release(action)
	pending_release.clear()
	if not finished and Time.get_ticks_msec() - started_msec > REAL_TIMEOUT_MSEC:
		_fail("timed out")


func _press(action: String) -> void:
	pending_press.append(action)


func _release(action: String) -> void:
	pending_release.append(action)


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _fail(reason: String) -> void:
	if finished:
		return
	finished = true
	print("SMOKE TEST FAILED: " + reason)
	get_tree().quit(1)


func _check(condition: bool, reason: String) -> bool:
	if not condition:
		_fail(reason)
	return condition


func _keep_alive() -> void:
	game.player.hp = game.player.max_hp
	game.player.stamina = game.player.stamina_max


func _run() -> void:
	# 1. Start a run.
	game.start_run()
	if not _check(game.state == game.State.PLAYING, "run did not start"):
		return
	if not _check(game.player != null, "no player after start"):
		return
	print("smoke: run started")

	# 2. Move and dash.
	var start_position: Vector2 = game.player.position
	_press("move_right")
	await _wait(0.5)
	_press("dash")
	await _wait(0.1)
	_release("dash")
	await _wait(0.4)
	_release("move_right")
	if not _check(game.player.position.x > start_position.x + 50.0, "player did not move"):
		return
	print("smoke: movement ok")

	# 3. Wait for the first spawn, then shoot it with fastballs.
	var waited: float = 0.0
	while get_tree().get_nodes_in_group("enemies").is_empty() and waited < 10.0:
		await _wait(0.25)
		waited += 0.25
	var enemies: Array = get_tree().get_nodes_in_group("enemies")
	if not _check(not enemies.is_empty(), "no enemy spawned in 10s"):
		return
	var target = enemies[0]
	target.position = game.player.position + game.player.aim_dir * 220.0
	_press("fire")
	waited = 0.0
	while game.kills < 1 and waited < 8.0:
		_keep_alive()
		if is_instance_valid(target) and not target.dead:
			target.position = game.player.position + game.player.aim_dir * 220.0
		await _wait(0.1)
		waited += 0.1
	_release("fire")
	if not _check(game.kills >= 1, "fastballs did not kill an enemy"):
		return
	print("smoke: fastball kill ok")

	# 4. Curveball, then a cooked Whistle Bomb.
	_press("curveball")
	await _wait(1.0)
	_release("curveball")
	_press("bomb")
	await _wait(1.0)
	if not _check(game.player.cooking, "bomb did not start cooking"):
		return
	_release("bomb")
	await _wait(3.0)
	if not _check(game.player.cd_bomb > 0.0, "bomb did not go on cooldown"):
		return
	_keep_alive()
	print("smoke: curveball and bomb ok")

	# 5. Jump the clock to the boss gate.
	game.run_time = Tuning.num("run/boss_time") - 0.5
	await _wait(1.5)
	if not _check(game.boss != null and is_instance_valid(game.boss), "boss did not spawn"):
		return
	if not _check(game.capstone_unlocked, "capstone did not unlock"):
		return
	print("smoke: boss gate ok")

	# 6. Capstone, then let the boss run its attacks for a while.
	var boss_hp_before: float = game.boss.hp
	game.boss.position = game.player.position + game.player.aim_dir * 250.0
	_press("capstone")
	await _wait(0.1)
	_release("capstone")
	await _wait(1.0)
	if not _check(game.player.cd_capstone > 0.0, "capstone did not fire"):
		return
	if not _check(game.boss.hp < boss_hp_before, "capstone did not damage the boss"):
		return
	var fight_time: float = 0.0
	while fight_time < 30.0:
		_keep_alive()
		await _wait(0.25)
		fight_time += 0.25
	if not _check(game.hits_taken > 0, "boss never hit the player in 30s"):
		return
	print("smoke: boss attacks ok")

	# 7. Win.
	game.boss.take_damage(game.boss.hp + 1.0)
	await _wait(0.2)
	if not _check(game.state == game.State.WON, "killing the boss did not win the run"):
		return
	print("smoke: win ok")

	# 8. Restart and lose.
	game.start_run()
	await _wait(0.5)
	game.player.take_damage(99999.0)
	await _wait(0.2)
	if not _check(game.state == game.State.LOST, "player death did not end the run"):
		return
	print("smoke: loss ok")

	finished = true
	print("SMOKE TEST PASSED")
	get_tree().quit(0)
