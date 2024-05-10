class_name Recipient extends StructureComponent

@export_group("Internal Nodes")
@export var spritesheet_node : Sprite2D
@export var pipe_entrance_1 : PipeEntrance
@export var connecting_from : PipeEntity



func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	_manage_temperature_color()
	_manage_fluids()
	_distribute_temperature(delta, self, self)
	
	if current_temperature >= 100.0:
		contains_fluid = true
	else:
		contains_fluid = false


func _manage_fluids() -> void:
	if contains_fluid == true:
		pipe_entrance_1._manage_particles()
	else:
		pipe_entrance_1._manage_particles()
	
	if contains_fluid == true:
		if pipe_entrance_1.connecting_to != null:
			pipe_entrance_1.connecting_to.contains_fluid = true
			pipe_entrance_1.connecting_to.fluid_type = fluid_type
			pipe_entrance_1.connecting_to._manage_preassure(_get_newtown())
			pipe_entrance_1.connecting_to.matter_mass = matter_mass


func _manage_temperature_color() -> void:
	spritesheet_node.modulate = temperature_color
