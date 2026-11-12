extends Node2D
## A ring that grows and fades, used for explosions and hit feedback.

var max_radius: float = 100.0
var duration: float = 0.3
var color: Color = Color.WHITE
var filled: bool = false
var age: float = 0.0


func _process(delta: float) -> void:
	age += delta
	if age >= duration:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var t: float = clampf(age / duration, 0.0, 1.0)
	var c: Color = Color(color, 1.0 - t)
	if filled:
		draw_circle(Vector2.ZERO, max_radius * t, Color(color, 0.35 * (1.0 - t)))
	draw_arc(Vector2.ZERO, max_radius * t, 0.0, TAU, 48, c, 5.0)
