extends CanvasLayer


@export var game_scene : GameManager

@onready var trabalho_label: Label = %TrabalhoLabel


func _on_create_pipe_button_pressed() -> void:
	game_scene._spawn_entity("Pipe")


func _on_create_recipient_button_pressed() -> void:
	game_scene._spawn_entity("WaterRecipient")


func _on_temperature_edit_text_submitted(new_text: String) -> void:
	var new_temperature : float = float(new_text)
	
	PhysicisComponent.ambient_temperature = new_temperature
	print(PhysicisComponent.ambient_temperature)


func _physics_process(delta: float) -> void:
	trabalho_label.text = str("Trabalho Gerado : ", snapped(PistonEntity.work_generated, 0.1))
	
	if PistonEntity.work_generated >= 10.0:
		trabalho_label.modulate = Color.GREEN
	else:
		trabalho_label.modulate = Color.WHITE
