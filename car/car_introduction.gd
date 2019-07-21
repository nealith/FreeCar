extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_game_over(visible):
	get_node("game_over").visible = visible

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("press_enter/AnimationPlayer").play("Alpha")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("press_enter/AnimationPlayer").play("Alpha")
