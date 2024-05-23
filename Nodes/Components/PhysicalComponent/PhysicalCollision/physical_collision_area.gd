class_name PhysicalCollision extends Area2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var object_area : float 
@export var physical_parent : PhysicisComponent
@export var should_calculate_area : bool = true

var diametro : float
var raio : float
var altura : float

func _ready() -> void:
	
	if physical_parent == null:
		if get_parent() is PhysicisComponent:
			physical_parent = get_parent()
		else:
			queue_free()
	
	if should_calculate_area == true:
		_update_object_area()


func _update_object_area() -> void:
	diametro = collision_shape_2d.shape.get_rect().size.y
	raio = diametro / 2.0
	altura = collision_shape_2d.shape.get_rect().size.x
	
	object_area = ((2 * PI) * raio * altura) + (2 * PI)
	physical_parent.physical_area = object_area
	physical_parent.total_area = object_area
	
	print(physical_parent.physical_area / 10.0)
