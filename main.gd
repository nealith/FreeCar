extends Node2D

export (PackedScene) var Car
export (PackedScene) var CarIntroduction
export (PackedScene) var Road
export (PackedScene) var RoadBlock
export (PackedScene) var SpikesStrip

var dy = 0
var elapsed_dy_since_last_event = 0
var p = 0.8

var roadblocks = []
var spikesstrips = []

var road = null
var car = null
var car_intro = null
var is_in_car_intro = false

var avoided_roadblock_label = "Avoided Roadblock : "
var avoided_roadblock_count = 0

func game_over():
	deinit_game()

func random_int(min_value,max_value, inclusive_range = false):
	if inclusive_range:
		max_value += 1
	var range_size = max_value - min_value
	return (randi() % range_size) + min_value

func _roadblock():
	if roadblocks.size() < 1:
		var rb = RoadBlock.instance()
		add_child(rb)
		rb.connect("roadblock_worked",self,"game_over")
		roadblocks.append({"instance":rb,"distance":random_int(480,1080)})

func _spikesstrip():
	pass

func init_car_introduction(is_game_over = false):
	is_in_car_intro = true
	car_intro = CarIntroduction.instance()
	car_intro.set_game_over(is_game_over)
	add_child(car_intro)
	
func deinit_car_introduction():
	is_in_car_intro = false
	if car_intro != null:
		remove_child(car_intro)
		car_intro = null

func init_game():
	avoided_roadblock_count = 0
	deinit_car_introduction()
	road = Road.instance()
	add_child(road)
	car = Car.instance()
	add_child(car)
	car.translate(Vector2(427,455))
	car.connect("camera_movement",get_node("background"),"_on_car_camera_movement")
	get_node("avoided roadblock").text = avoided_roadblock_label + String(avoided_roadblock_count)
	get_node("avoided roadblock").visible = true
	
func deinit_game():
	get_node("avoided roadblock").visible = false
	remove_child(road)
	car.disconnect("camera_movement",get_node("background"),"_on_car_camera_movement")
	remove_child(car)
	car = null
	road = null
	while(roadblocks.size() > 0):
		remove_child(roadblocks[0]["instance"])
		roadblocks.remove(0)
		
	init_car_introduction(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	init_car_introduction()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_in_car_intro == true and Input.is_action_pressed("ui_accept"):
		init_game()
	else:
		elapsed_dy_since_last_event += delta/100.0
		
		randomize()
		if randf() + elapsed_dy_since_last_event > p :
			elapsed_dy_since_last_event = 0
			_roadblock()
		
		var z_base = roadblocks.size()
		var to_remove = []
		var i = 0
		for roadblock in roadblocks:
			roadblock["distance"] -= delta*50
			
			if(roadblock["distance"] < 240):
				roadblock["distance"] -= delta*50
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
			avoided_roadblock_count += 1
			get_node("avoided roadblock").text = avoided_roadblock_label + String(avoided_roadblock_count)
			remove_child(roadblocks[tr]["instance"])
			roadblocks.remove(tr)