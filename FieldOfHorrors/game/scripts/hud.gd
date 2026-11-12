extends CanvasLayer
## HUD laid out per design/ui_hud.md: HP/Grit/Stamina top-left, timer and
## phase top-right, weapons bottom-left, event log bottom-right.
## Built in code so there is no scene file to keep in sync.

const Palette = preload("res://scripts/palette.gd")

const MARGIN: int = 24
const FONT_BODY: int = 22
const FONT_BIG: int = 34
const FONT_HUGE: int = 64

var hp_bar: ProgressBar
var grit_bar: ProgressBar
var stamina_bar: ProgressBar
var hp_label: Label
var timer_label: Label
var phase_label: Label
var score_label: Label
var weapons_label: Label
var log_label: Label
var boss_box: VBoxContainer
var boss_bar: ProgressBar
var center_title: Label
var center_body: Label
var log_lines: Array = []


func _ready() -> void:
	var root: Control = Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	# Top-left: class, HP, Grit, Stamina.
	var top_left: VBoxContainer = _corner(root, Control.PRESET_TOP_LEFT, Control.GROW_DIRECTION_END, Control.GROW_DIRECTION_END)
	top_left.add_child(_label("PITCHER", FONT_BODY, Palette.BONE))
	hp_bar = _bar(Palette.BLOOD, 320.0, 26.0)
	top_left.add_child(hp_bar)
	hp_label = _label("", FONT_BODY, Palette.BONE)
	top_left.add_child(hp_label)
	grit_bar = _bar(Palette.SLIME, 320.0, 12.0)
	top_left.add_child(grit_bar)
	stamina_bar = _bar(Palette.FLAG_YELLOW, 320.0, 12.0)
	top_left.add_child(stamina_bar)

	# Top-right: timer, phase, score.
	var top_right: VBoxContainer = _corner(root, Control.PRESET_TOP_RIGHT, Control.GROW_DIRECTION_BEGIN, Control.GROW_DIRECTION_END)
	timer_label = _label("0:00", FONT_BIG, Palette.BONE)
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	top_right.add_child(timer_label)
	phase_label = _label("", FONT_BODY, Palette.SLIME)
	phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	top_right.add_child(phase_label)
	score_label = _label("", FONT_BODY, Palette.BONE)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	top_right.add_child(score_label)

	# Bottom-left: weapons and cooldowns.
	var bottom_left: VBoxContainer = _corner(root, Control.PRESET_BOTTOM_LEFT, Control.GROW_DIRECTION_END, Control.GROW_DIRECTION_BEGIN)
	weapons_label = _label("", FONT_BODY, Palette.BONE)
	bottom_left.add_child(weapons_label)

	# Bottom-right: mini-log.
	var bottom_right: VBoxContainer = _corner(root, Control.PRESET_BOTTOM_RIGHT, Control.GROW_DIRECTION_BEGIN, Control.GROW_DIRECTION_BEGIN)
	log_label = _label("", FONT_BODY, Palette.BONE)
	log_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	bottom_right.add_child(log_label)

	# Top-center: boss bar.
	boss_box = _corner(root, Control.PRESET_CENTER_TOP, Control.GROW_DIRECTION_BOTH, Control.GROW_DIRECTION_END)
	var boss_name: Label = _label("REFEREE KING", FONT_BODY, Palette.FLAG_YELLOW)
	boss_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boss_box.add_child(boss_name)
	boss_bar = _bar(Palette.FLAG_YELLOW, 520.0, 22.0)
	boss_box.add_child(boss_bar)
	boss_box.visible = false

	# Center: title, win, and loss messages.
	var center: VBoxContainer = _corner(root, Control.PRESET_CENTER, Control.GROW_DIRECTION_BOTH, Control.GROW_DIRECTION_BOTH)
	center_title = _label("", FONT_HUGE, Palette.SLIME)
	center_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	center.add_child(center_title)
	center_body = _label("", FONT_BODY, Palette.BONE)
	center_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	center.add_child(center_body)


func _corner(root: Control, preset: Control.LayoutPreset, grow_h: Control.GrowDirection, grow_v: Control.GrowDirection) -> VBoxContainer:
	var box: VBoxContainer = VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.grow_horizontal = grow_h
	box.grow_vertical = grow_v
	root.add_child(box)
	box.set_anchors_and_offsets_preset(preset, Control.PRESET_MODE_MINSIZE, MARGIN)
	return box


func _label(text: String, size: int, color: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Palette.INK)
	label.add_theme_constant_override("outline_size", 8)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _bar(fill: Color, width: float, height: float) -> ProgressBar:
	var bar: ProgressBar = ProgressBar.new()
	bar.custom_minimum_size = Vector2(width, height)
	bar.show_percentage = false
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var back: StyleBoxFlat = StyleBoxFlat.new()
	back.bg_color = Palette.INK
	back.set_border_width_all(3)
	back.border_color = Palette.NIGHT
	var front: StyleBoxFlat = StyleBoxFlat.new()
	front.bg_color = fill
	front.set_border_width_all(3)
	front.border_color = Palette.INK
	bar.add_theme_stylebox_override("background", back)
	bar.add_theme_stylebox_override("fill", front)
	return bar


func add_log(text: String) -> void:
	log_lines.append(text)
	while log_lines.size() > 4:
		log_lines.pop_front()
	log_label.text = "\n".join(PackedStringArray(log_lines))


func clear_log() -> void:
	log_lines.clear()
	log_label.text = ""


func show_center(title: String, body: String, color: Color) -> void:
	center_title.text = title
	center_title.add_theme_color_override("font_color", color)
	center_body.text = body


func refresh(game) -> void:
	var player = game.player
	if player != null and is_instance_valid(player):
		hp_bar.max_value = player.max_hp
		hp_bar.value = player.hp
		hp_label.text = "HP %d / %d" % [int(ceil(player.hp)), int(player.max_hp)]
		grit_bar.max_value = player.grit_cap
		grit_bar.value = player.grit
		stamina_bar.max_value = player.stamina_max
		stamina_bar.value = player.stamina
		weapons_label.text = _weapons_text(game, player)

	var seconds: int = int(game.run_time)
	timer_label.text = "%d:%02d" % [seconds / 60, seconds % 60]
	phase_label.text = game.phase_text()
	score_label.text = "Kills %d   Score %d" % [game.kills, game.score]

	var boss = game.boss
	if boss != null and is_instance_valid(boss) and not boss.dead:
		boss_box.visible = true
		boss_bar.max_value = boss.max_hp
		boss_bar.value = boss.hp
	else:
		boss_box.visible = false


func _weapons_text(game, player) -> String:
	var lines: PackedStringArray = PackedStringArray()
	lines.append("Fastball  [LMB / RT]")
	lines.append("Curveball  [RMB / LT]")
	if player.cooking:
		lines.append("Whistle Bomb  COOKING %.1fs" % maxf(Tuning.num("whistle_bomb/fuse") - player.cook_time, 0.0))
	elif player.cd_bomb > 0.0:
		lines.append("Whistle Bomb  %.1fs" % player.cd_bomb)
	else:
		lines.append("Whistle Bomb  [Q / RB]  READY")
	if not game.capstone_unlocked:
		var left: int = int(ceil(Tuning.num("capstone/unlock_time") - game.run_time))
		lines.append("Grand Slam Pitch  unlocks in %d:%02d" % [left / 60, left % 60])
	elif player.cd_capstone > 0.0:
		lines.append("Grand Slam Pitch  %.1fs" % player.cd_capstone)
	else:
		lines.append("Grand Slam Pitch  [F / Y]  READY")
	lines.append("Dash  [Space / A]")
	return "\n".join(lines)
