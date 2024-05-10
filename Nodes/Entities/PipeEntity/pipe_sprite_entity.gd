@tool
class_name PipeSprite extends Sprite2D

signal pipe_sprite_changed

@export var pipe_parent : PipeEntity
@export var entrance_sync : AnimationPlayer

func _ready() -> void:
	if get_parent() is PipeEntity:
		if pipe_parent == null:
			pipe_parent = get_parent()
	
	_set_sprite()


func _set_sprite():
	if pipe_parent:
		match pipe_parent.pipe_type:
			pipe_parent.PipeTypes.Horizontal:
				frame = 0
				pipe_parent.pipe_entrance_1.entrance_orientation = Vector2(-1, 0)
				pipe_parent.pipe_entrance_2.entrance_orientation = Vector2(1, 0)
				entrance_sync.play("HorizontalPipe")
			pipe_parent.PipeTypes.Vertical:
				frame = 1
				pipe_parent.pipe_entrance_1.entrance_orientation = Vector2(0, -1)
				pipe_parent.pipe_entrance_2.entrance_orientation = Vector2(0, 1)
				entrance_sync.play("VerticalPipe")
			pipe_parent.PipeTypes.Lshape:
				frame = 2
				pipe_parent.pipe_entrance_1.entrance_orientation = Vector2(-1, -1)
				pipe_parent.pipe_entrance_2.entrance_orientation = Vector2(0, 1)
				entrance_sync.play("LshapePipe")
			pipe_parent.PipeTypes.xLshape:
				frame = 3
				pipe_parent.pipe_entrance_1.entrance_orientation = Vector2(0, -1)
				pipe_parent.pipe_entrance_2.entrance_orientation = Vector2(1, 0)
				entrance_sync.play("xLshapePipe")
			pipe_parent.PipeTypes.yLshape:
				frame = 4
				pipe_parent.pipe_entrance_1.entrance_orientation = Vector2(0, -1)
				pipe_parent.pipe_entrance_2.entrance_orientation = Vector2(0, -1)
				entrance_sync.play("reverse_xLshapePipe")
			pipe_parent.PipeTypes.xyLshape:
				frame = 5
				pipe_parent.pipe_entrance_1.entrance_orientation = Vector2(1, 0)
				pipe_parent.pipe_entrance_2.entrance_orientation = Vector2(-1, 0)
				entrance_sync.play("reverse_LshapePipe")
		
		pipe_sprite_changed.emit()
