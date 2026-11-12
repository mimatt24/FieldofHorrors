extends Node
## Loads res://data/tuning.json once at startup.
## Every gameplay number in the slice is read from that file.

var data: Dictionary = {}


func _ready() -> void:
	var file: FileAccess = FileAccess.open("res://data/tuning.json", FileAccess.READ)
	if file == null:
		push_error("Tuning: could not open res://data/tuning.json")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Tuning: tuning.json is not a JSON object")
		return
	data = parsed


## Returns a number by path, for example num("fastball/damage").
func num(path: String) -> float:
	var value: Variant = _lookup(path)
	if value == null:
		return 0.0
	return float(value)


## Returns an array by path, for example list("spawns/phases").
func list(path: String) -> Array:
	var value: Variant = _lookup(path)
	if typeof(value) != TYPE_ARRAY:
		return []
	return value


func _lookup(path: String) -> Variant:
	var current: Variant = data
	for key in path.split("/"):
		if typeof(current) != TYPE_DICTIONARY or not current.has(key):
			push_error("Tuning: missing value '%s'" % path)
			return null
		current = current[key]
	return current
