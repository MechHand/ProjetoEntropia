class_name PipeEntity extends StructureComponent


@export_group("Pipe Parameters")
enum PipeTypes {Horizontal, Vertical, Lshape, xLshape, yLshape, xyLshape}
@export var pipe_type : PipeTypes = PipeTypes.Horizontal
@export_group("Internal Nodes")
@export var spritesheet_node : Sprite2D
@export var pipe_entrance_1 : PipeEntrance
@export var pipe_entrance_2 : PipeEntrance


@export_group("External Nodes")
@export_subgroup("Pipe connections")
@export var connecting_from : PipeEntity
@export var heat_animation : AnimationPlayer


func _enter_tree() -> void:
	name = str("PipeEntity", randi_range(0, 2048))


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if _placed == false:
		if Input.is_action_just_pressed("mouse_right_click"):
			match pipe_type:
				PipeTypes.Horizontal:
					pipe_type = PipeTypes.Vertical
				PipeTypes.Vertical:
					pipe_type = PipeTypes.Lshape
				PipeTypes.Lshape:
					pipe_type = PipeTypes.xLshape
				PipeTypes.xLshape:
					pipe_type = PipeTypes.yLshape
				PipeTypes.yLshape:
					pipe_type = PipeTypes.xyLshape
				PipeTypes.xyLshape:
					pipe_type = PipeTypes.Horizontal
			
			spritesheet_node._set_sprite()
	
	_check_connections(delta)
	_manage_temperature_color()
	_manage_fluids()
	
	if current_temperature > (max_temperature / 2.0):
		heat_animation.speed_scale = current_temperature / 100.0
		heat_animation.play(&"HeatLoop")
	else:
		heat_animation.stop()


## Send information to all pipe entrances to update its fluid property.
func _manage_fluids() -> void:
	pipe_entrance_1._manage_particles()
	pipe_entrance_2._manage_particles()
	
	if contains_fluid == true:
		if pipe_entrance_1.connecting_to != null:
			pipe_entrance_1.connecting_to.contains_fluid = true
			pipe_entrance_1.connecting_to.fluid_type = fluid_type
		if pipe_entrance_2.connecting_to != null:
			pipe_entrance_2.connecting_to.contains_fluid = true
			pipe_entrance_2.connecting_to.fluid_type = fluid_type
		if pipe_entrance_1.connecting_to == null and pipe_entrance_2.connecting_to == null:
			contains_fluid = false


func _check_connections(delta : float) -> void:
	if pipe_entrance_1.connecting_to:
		_distribute_temperature(delta, pipe_entrance_1.connecting_to, self)
		_distribute_temperature(delta, self, pipe_entrance_1.connecting_to)
		
		if contains_fluid == true :
			if pipe_entrance_1.connecting_to != Recipient:
				pipe_entrance_1.connecting_to._manage_preassure(fluid_force * mass_lost)
				
				if pipe_entrance_1.connecting_to.matter_mass < matter_mass:
					pipe_entrance_1.connecting_to.matter_mass = matter_mass * mass_lost
		else:
			if pipe_entrance_1.connecting_to is PipeEntity:
				pipe_entrance_1.connecting_to._remove_fluids()
				
	if pipe_entrance_2.connecting_to:
		_distribute_temperature(delta, pipe_entrance_2.connecting_to, self)
		_distribute_temperature(delta, self, pipe_entrance_2.connecting_to)
		
		if contains_fluid == true :
			if pipe_entrance_2.connecting_to != Recipient:
				pipe_entrance_2.connecting_to._manage_preassure(fluid_force * mass_lost)
				
				if pipe_entrance_2.connecting_to.matter_mass < matter_mass:
					pipe_entrance_2.connecting_to.matter_mass = matter_mass * mass_lost
		else:
			if pipe_entrance_2.connecting_to is PipeEntity:
				pipe_entrance_2.connecting_to._remove_fluids()


func _manage_temperature_color() -> void:
	spritesheet_node.modulate = temperature_color


func _remove_fluids() -> void:
	contains_fluid = false
	
	if pipe_entrance_1.connecting_to != null:
		if pipe_entrance_1.connecting_to.contains_fluid == true:
			pipe_entrance_1.connecting_to.fluid_type = fluid_type
			
			if pipe_entrance_1.connecting_to is PipeEntity:
				pipe_entrance_1.connecting_to._remove_fluids()
	if pipe_entrance_2.connecting_to != null:
		if pipe_entrance_2.connecting_to.contains_fluid == true:
			pipe_entrance_2.connecting_to.fluid_type = fluid_type
			
			if pipe_entrance_2.connecting_to is PipeEntity:
				pipe_entrance_2.connecting_to._remove_fluids()
