class_name PipeEntrance extends Area2D


## The pipe entrance acts like a hitbox that verifies other connections to performs actions and able that the pipe distribute it's physical properties.

var pipe_parent : StructureComponent ## A reference to the pipe.

var connecting_to : StructureComponent ## Stores what other entrance is connecting to.

@onready var water_particle : WaterParticle = %Water_Particle ## A reference to the water particle.
@export var entrance_orientation : Vector2 = Vector2(1.0,0.0)
@export var pipe_sprite : PipeSprite

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	if get_parent() is PipeEntity:
		pipe_parent = get_parent()
		collision_shape_2d.disabled = true
		
		if pipe_parent.pipe_entrance_1 == self:
			water_particle.direction.x = -1.0
		elif pipe_parent.pipe_entrance_2 == self:
			water_particle.direction.x = 1.0
		
		pipe_parent.placed.connect(_activate_collision)
		pipe_sprite.pipe_sprite_changed.connect(_update_water_diretion)
		
	elif get_parent() is Recipient:
		pipe_parent = get_parent()
		
		water_particle.direction.x = 1.0


## Activate the collisions of this entrance.
func _activate_collision() -> void:
	monitoring = true
	monitorable = true
	
	collision_shape_2d.disabled = false


func _update_water_diretion() -> void:
	water_particle.direction = entrance_orientation


## Send information to the water particles, including temperature and emittion.
func _manage_particles() -> void:
	if pipe_parent.contains_fluid == true and pipe_parent._placed == true:
		if connecting_to != null:
			water_particle.emitting = false
		else:
			water_particle.emitting = true
			water_particle.current_temperature = pipe_parent.current_temperature
			water_particle._manage_fluid_state()
			water_particle._update_preassure_multiplier(pipe_parent.current_preassure)
	else:
		water_particle.emitting = false


## When other collision enters this collision, the class of the collision is verified, and a connection is stablished between the pipe entrances.
func _on_area_entered(area: Area2D) -> void:
	if area is PipeEntrance:
		if pipe_parent is PipeEntity:
			if pipe_parent.connecting_to == null and (pipe_parent._placed == true and area.pipe_parent._placed == true):
				
				connecting_to = area.pipe_parent
				#area.pipe_parent._manage_preassure(pipe_parent.fluid_force)
				
		elif pipe_parent is Recipient:
			if pipe_parent.connecting_to == null:
				
				connecting_to = area.pipe_parent
				#area.pipe_parent._manage_preassure(pipe_parent.fluid_force)
		
		print(pipe_parent, " is connecting to ", area.pipe_parent)


## When other collision exits this collision, the class of the collision is verified, and the old connection is ended between the pipe entrances.
func _on_area_exited(area: Area2D) -> void:
	if area is PipeEntrance:
		if pipe_parent is PipeEntity and (pipe_parent._placed == true and area.pipe_parent._placed == true):
			connecting_to = null
		elif pipe_parent is Recipient:
			connecting_to = null
			pipe_parent.connecting_to = null
			
			area.pipe_parent.connecting_to = null
			area.pipe_parent.pipe_entrance_1.connecting_to = null
			area.pipe_parent.contains_fluid = false
		
		print(pipe_parent, " is disconnected to ", area.pipe_parent)
