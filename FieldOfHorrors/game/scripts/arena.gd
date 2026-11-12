extends Node2D
## Draws the stadium field: turf, yard lines, hash marks, and the boundary.

const Palette = preload("res://scripts/palette.gd")

var rect: Rect2 = Rect2(0, 0, 2400, 1400)


func _draw() -> void:
	draw_rect(rect.grow(400.0), Palette.INK, true)
	draw_rect(rect, Palette.TURF, true)
	var line_color: Color = Color(Palette.BONE, 0.25)
	var x: float = rect.position.x + 200.0
	while x < rect.end.x:
		draw_line(Vector2(x, rect.position.y), Vector2(x, rect.end.y), line_color, 3.0)
		var hash_x: float = x - 150.0
		while hash_x < x:
			draw_line(Vector2(hash_x, rect.get_center().y - 160.0), Vector2(hash_x, rect.get_center().y - 140.0), line_color, 2.0)
			draw_line(Vector2(hash_x, rect.get_center().y + 140.0), Vector2(hash_x, rect.get_center().y + 160.0), line_color, 2.0)
			hash_x += 50.0
		x += 200.0
	draw_rect(rect, Palette.BONE, false, 6.0)
