extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal camera_movement()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_car_camera_movement(mov):
	emit_signal("camera_movement",mov)
