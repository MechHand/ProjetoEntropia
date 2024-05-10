class_name PhysicalComponentDebugger extends Control


@onready var label: Label = %Label

@export var physical_parent : PhysicisComponent


func _ready() -> void:
	if physical_parent == null:
		if get_parent() is PhysicisComponent:
			physical_parent = get_parent()
			
			label.visible = false
			set_process(false)
		else:
			queue_free()


func _ref_mouse_entered() -> void:
	label.visible = true
	set_process(true)


func _ref_mouse_exited() -> void:
	label.visible = false
	set_process(false)


func _process(delta: float) -> void:
	if physical_parent:
		if physical_parent is PipeEntity:
			var pipe1_status : String
			var pipe2_status : String
			
			if physical_parent.pipe_entrance_1.connecting_to == null:
				pipe1_status = "Empty"
			else:
				pipe1_status = "Ok"
			if physical_parent.pipe_entrance_2.connecting_to == null:
				pipe2_status = "Empty"
			else:
				pipe2_status = "Ok"
			
			label.text = str(
				physical_parent.name, "\n",
				"Ent1 : ", pipe1_status, "(", _get_pipe_name(physical_parent.pipe_entrance_1.connecting_to), ")"," | Ent2 : ", pipe2_status,"(", _get_pipe_name(physical_parent.pipe_entrance_2.connecting_to), ")", "\n",
				snappedf(physical_parent.current_temperature, 0.01), " Cº", "\n",
				physical_parent.current_preassure, " Pa", "\n",
				"Mass Ratio ", physical_parent.mass_loss, "\n",
				"Mass : ", physical_parent.matter_mass
			)


func _get_pipe_name(pipe : StructureComponent) -> String:
	if pipe != null:
		return pipe.name
	else:
		return "null"
