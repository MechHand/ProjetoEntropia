class_name HeatSource extends PlaceableObject

@onready var heat_area: Area2D = $HeatArea

var heat_temperature : float = 500.0
var physical_components : Array[PhysicisComponent]


func _physics_process(delta: float) -> void:
	for physical in physical_components:
		if is_instance_valid(physical):
			physical._gain_temperature(delta, self)


func _on_heat_area_area_entered(area: Area2D) -> void:
	if area is PhysicalCollision:
		physical_components.append(area.physical_parent)


func _on_heat_area_area_exited(area: Area2D) -> void:
	if area is PhysicalCollision:
		var index = physical_components.find(area.physical_parent)
		physical_components.pop_at(index)
