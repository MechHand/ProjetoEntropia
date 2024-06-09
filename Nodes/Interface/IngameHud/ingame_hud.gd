extends CanvasLayer


@export var game_scene : GameManager

@onready var trabalho_label: Label = %TrabalhoLabel
@onready var dica_label: Label = $Control/MarginContainer4/Panel/DicaLabel


func _on_create_pipe_button_pressed() -> void:
	game_scene._spawn_entity("Pipe")


func _on_create_recipient_button_pressed() -> void:
	game_scene._spawn_entity("WaterRecipient")


func _on_temperature_edit_text_submitted(new_text: String) -> void:
	var new_temperature : float = float(new_text)
	
	PhysicisComponent.ambient_temperature = new_temperature
	print(PhysicisComponent.ambient_temperature)


func _physics_process(delta: float) -> void:
	trabalho_label.text = str("Trabalho Gerado  :  ", snapped(PistonEntity.work_generated, 0.1))
	
	if PistonEntity.work_generated >= 10.0:
		trabalho_label.modulate = Color.GREEN
		dica_label.text = "O trabalho necessário foi gerado"
	else:
		trabalho_label.modulate = Color.WHITE
		
	var temperatura_media: float
	for Pipe in GameManager.connected_pipes:
		if is_instance_valid(Pipe):
			temperatura_media += Pipe.current_temperature

	temperatura_media /= GameManager.connected_pipes.size()
	
	if game_scene.recipient.current_temperature <= 100:
			dica_label.text = "Aumente a temperatura do recipiente para transportar a água"
	elif game_scene.recipient:
		if not game_scene.recipient.pipe_entrance_1.connecting_to:
			dica_label.text = "Conecte um cano no recipiente"
		else:
			if game_scene.piston:
				if not game_scene.piston.pipe_connected:
					dica_label.text = "Conecte o cano no pistão"
				else:
					dica_label.text = "Aqueça os canos"
	if is_instance_valid(GameManager.connected_pipes.back()):
		if GameManager.connected_pipes.back().current_temperature >= 100 and game_scene.piston.pipe_connected:
			dica_label.text = "O pistão está gerando trabalho"
			
	if PistonEntity.work_generated >= 10.0:
		dica_label.text = "O trabalho necessário foi gerado"

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")
