class_name GameManager extends Node2D

static var connected_pipes : Array[PipeEntity]

## The class that holds useful information and functions about the game.


## A Dictionary with all spawnable objects.
var spawnable_objects : Dictionary = {
	"Pipe" : preload("res://Nodes/Entities/PipeEntity/pipe_entity.tscn"),
	"WaterRecipient" : preload("res://Nodes/Entities/RecipientEntity/water_recipient.tscn")
}


## This function should be used to spawn objects in the mouse position.
func _spawn_entity(entity_key : String) -> void:
	var new_entity = spawnable_objects.get(entity_key).instantiate()
	
	add_child(new_entity)
	new_entity.global_position = get_global_mouse_position()
	if new_entity is PipeEntity:
		new_entity.current_temperature = randf_range(0, 200) # TODO : Remove this in the final game.


static func _get_total_area() -> float:
	var area : float
	
	for pipe in connected_pipes:
		area += pipe.physical_area / 10.0
	
	return area
