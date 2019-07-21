extends Node2D

export (PackedScene) var RoadBlock
export (PackedScene) var SpikesStrip

var dy = 0
var elapsed_dy_since_last_event = 0
var p = 0.999999999999

var roadblocks = []
var spikesstrips = []

func random_int(min_value,max_value, inclusive_range = false):
	if inclusive_range:
		max_value += 1
	var range_size = max_value - min_value
	return (randi() % range_size) + min_value

func _roadblock():
	if roadblocks.size() < 1:
		var rb = RoadBlock.instance()
		print("add roadblock")
		add_child(rb)
		roadblocks.append({"instance":rb,"distance":random_int(480,1080)})

func _spikesstrip():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dy += delta*1000
	elapsed_dy_since_last_event += delta/100.0
	
	randomize()
	if randf() + elapsed_dy_since_last_event > p :
		elapsed_dy_since_last_event = 0
		_roadblock()
	
	var z_base = roadblocks.size()
	var to_remove = []
	var i = 0
	for roadblock in roadblocks:
		roadblock["distance"] -= delta*100
		
		if(roadblock["distance"] < 240):
			if (roadblock["distance"] < 0):
				to_remove.append(i)
			else:
				var c_percent = 0.95 * (roadblock["distance"]/240.0)
				var road_width = 854* (1.0-c_percent)
				var road_offset = (854 - road_width)/2
			
				roadblock["instance"].position = Vector2(road_offset,480-roadblock["distance"])
				roadblock["instance"].set_scale(Vector2((1.0-c_percent),(1.0-c_percent)))
				roadblock["instance"].z_index = z_base
			z_base -= 1
		
		i+=1
		
	for tr in to_remove:
		print("remove roablock")
		roadblocks.remove(tr)