class_name ReclicableArea extends Area2D

@export var placeble_parent : PlaceableObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouse:
		if event.is_pressed() == true:
			print("Mouse presset at ", placeble_parent.name)
			
			print(placeble_parent.name, "was positioned at : ", placeble_parent.grid_history.find(placeble_parent.global_position))
			placeble_parent.grid_history.remove_at(placeble_parent.grid_history.find(placeble_parent.global_position))
			
			placeble_parent._placed = false
			placeble_parent._ready()
