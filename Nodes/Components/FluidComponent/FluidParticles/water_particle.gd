class_name WaterParticle extends CPUParticles2D

## A self contained class that checks for the temperature to change itself.

@export_category("Fluid Property")
@export var current_temperature : float = 30.0 ## The current temperature of the fluid.
@export var ebulition_point : float = 100.0 ## The point where the temperature change the behaviour of the fluid.
@export_category("Visual parameters")
@export var preassure_multiplier : float = 1.0


## This function updates the current state of fluid using the current temperature as comparition.
func _manage_fluid_state() -> void:
	if current_temperature >= ebulition_point:
		gravity.y = 0.0
		scale_amount_min = 1.2
		scale_amount_max = 2.4
		initial_velocity_min = clampf(128.0 * preassure_multiplier, 24.0, 516.0)
		initial_velocity_max = clampf(256.0 * preassure_multiplier, 32.0, 516.0)
		damping_min = 128.0
		color = Color(0.725, 0.827, 0.839, 0.25)
	else:
		gravity.y = 980.0
		scale_amount_min = 0.6
		scale_amount_max = 1.4
		initial_velocity_min = clampf(64.0 * preassure_multiplier, 24.0, 516.0)
		initial_velocity_max = clampf(128.0 * preassure_multiplier, 32.0, 516.0)
		damping_min = 0.0
		color = Color(0.333, 0.761, 0.886, 1.0)


func _update_preassure_multiplier(current_pascal : float) -> void:
	preassure_multiplier = current_pascal
