extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cars = []
var positions = [{"pos":Vector2(165,291),"taken":false},{"pos":Vector2(297,423),"taken":false},{"pos":Vector2(429,555),"taken":false},{"pos":Vector2(561,687),"taken":false}]

# Called when the node enters the scene tree for the first time.
func _ready():
	cars = [get_node("police_car_roadblock1"),get_node("police_car_roadblock2"),get_node("police_car_roadblock3")]
	var i = 0
	while (i<3):
		for position in positions:
			randomize ()
			if position.taken == false and randf() >= 0.7 and i < 3:
				position.taken = true
				i+=1
	i = 0
	for position in positions:
		if position.taken :
			cars[i].translate(Vector2((position.pos.y - position.pos.x)/2+position.pos.x,0.0))
			i+=1
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
