class_name UltraEpicShader extends ShaderMaterial


@export var next_2D_pass : Shader


func _process(delta):
	set_shader(next_2D_pass)
