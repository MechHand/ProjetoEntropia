class_name PlaceableObject extends Node2D


signal placed


static var grid_size : Vector2 = Vector2(32, 32)
static var grid_history : PackedVector2Array

@export var _placed : bool = false

var hearing_input : bool = false


func _ready() -> void:
	global_position = snapped(global_position, grid_size)
	
	var timer := get_tree().create_timer(0.25)
	timer.timeout.connect(_start_hearing)


func _process(delta: float) -> void:
	if _placed == false:
		global_position = lerp(global_position, snapped(get_global_mouse_position(), grid_size), 0.75)
		modulate.a = 0.75
		if hearing_input == true:
			if Input.is_action_just_released("mouse_click") and (_verify_grid_pos() == true):
				grid_history.append(global_position)
				
				_placed = true
				modulate.a = 1.0
				placed.emit()


func _start_hearing() -> void:
	hearing_input = true


func _verify_grid_pos() -> bool:
	var _result : bool = true
	var _current_pos : Vector2 = global_position
	
	_result = not grid_history.has(_current_pos)
	
	print(grid_history)
	if _result == true:
		print("Free Pos")
	else:
		print("Occupied Pos")
	
	return _result
