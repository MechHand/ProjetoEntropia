class_name PistonEntity extends Node2D

var pipe_connected : PipeEntity

@onready var piston_animation = $PistonAnimation

var max_dist : float = 80.0

static var work_generated : float = 0.0
var is_generating_work : bool = false


func _physics_process(delta):
	_update_piston()
	
	if is_generating_work == true:
		work_generated += 1.0 * delta


func _on_verifier_area_area_entered(area):
	if area.get_parent() is PipeEntity:
		pipe_connected = area.get_parent()


func _on_verifier_area_area_exited(area):
	if area.get_parent() is PipeEntity:
		if not pipe_connected == null:
			pipe_connected = null


func _update_piston() -> void:
	if pipe_connected != null:
		if pipe_connected.current_temperature >= 100.0:
			is_generating_work = true
			piston_animation.play("piston_working")
		else:
			is_generating_work = false
			piston_animation.play("piston_not_working")
	else:
		piston_animation.play("piston_not_working")
