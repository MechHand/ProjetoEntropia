class_name PhysicisComponent extends PlaceableObject


@export_category("Physical Status")
@export var current_temperature : float = 30.0 ## Represents the current temperature, Celsius?.
@export var max_temperature : float = 200.0 ## The maximum temperature that can get.
@export var temperature_resitivity : float = 0.25
@export var heating_value : float = 1.0
@export var colding_value : float = 0.4
@export var fluid_ebulition_point : float = 100.0
var mass_loss : float = 1.0
@export_group("Preassure")
@export var fluid_force : float
@export var current_preassure : float
@export var physical_area : float
@export var matter_acceleration : float
@export var matter_mass : float
@export_subgroup("Physical Limits")
@export var preassure_limit : float = 3.0
@export_group("Visual Parameters")
@export var temperature_modulation : GradientTexture1D
@export var temperature_color : Color

static var ambient_temperature : float = 30.0


func _physics_process(delta: float) -> void:
	
	_manage_temperature()
	
	if current_preassure > preassure_limit:
		_preassure_exceeded()


func _preassure_exceeded() -> void:
	pass


func _get_newtown() -> float:
	var newtown : float = (matter_mass) * matter_acceleration
	
	return newtown


func _manage_preassure(force : float) -> void:
	force = absf(force)
	
	if physical_area != NAN and physical_area != null and physical_area > 0.0:
		current_preassure = (force / physical_area)
		fluid_force = force
		#print(name, " current preassure : ", current_preassure, " | fluid_force : ", fluid_force, " | force : ", force)
	else:
		print("ERROR! ", name, " cannot calculate this preassure, area is : ", physical_area)


func _manage_temperature() -> void:
	if temperature_modulation:
		temperature_color = temperature_modulation.gradient.sample(inverse_lerp(0.0, max_temperature, current_temperature))


func _distribute_temperature(delta : float, emitter : PhysicisComponent, receiver : PhysicisComponent) -> void:
	if emitter != null and receiver != null:
		receiver.current_temperature += ((emitter.current_temperature - receiver.current_temperature) * (delta * temperature_resitivity))
	
	if emitter != receiver:
		current_temperature += (ambient_temperature - current_temperature) * (delta * (temperature_resitivity * 0.1))
		
		if current_temperature > fluid_ebulition_point:
			mass_loss = inverse_lerp(fluid_ebulition_point, 10000.0, current_temperature)
		else:
			mass_loss = lerpf(mass_loss, 0.0, 0.1)
		
		matter_mass = clampf(matter_mass - mass_loss, 0.0, 1000.0)


func _distribute_preassure(delta : float, emitter : PhysicisComponent, receiver : PhysicisComponent) -> void:
	if emitter != null and receiver != null:
		receiver.current_preassure += ((((emitter.current_preassure - receiver.current_preassure)) * delta) * (current_temperature / 50.0))


func _gain_temperature(delta : float, emitter : HeatSource) -> void:
	if emitter != null:
		self.current_temperature += ((emitter.heat_temperature - self.current_temperature) * (delta * temperature_resitivity))
