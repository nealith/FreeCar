extends KinematicBody2D

# Member variables
const GRAVITY = 500 # pixels/second/second

const WALK_FORCE = 800
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 800

const STOP_FORCE = 500

var velocity = Vector2(0,0)

signal camera_movement()

var is_hitten = false
var is_on_floor = false
var is_on_ceil = false 
var is_on_wall = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
		var left = Input.is_action_pressed("ui_left")
		var right = Input.is_action_pressed("ui_right")
		
		var old_velocity = velocity
		
		var gravity = Physics2DServer.area_get_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR)
		
		var force = Vector2(0,GRAVITY)
		
		var lateral_speed_min = WALK_MIN_SPEED 
		var lateral_speed_max = WALK_MAX_SPEED + abs(gravity.x*GRAVITY)
		
		var stop = false
		
		if left == true:
			if velocity.x <= lateral_speed_min and velocity.x > -lateral_speed_max:
				force.x -= WALK_FORCE #* (1+abs(sign(gravity.x)))
			stop = true
		elif right == true:
			if velocity.x >= -lateral_speed_min and velocity.x < lateral_speed_max:
				force.x += WALK_FORCE #* (1+abs(sign(gravity.x)))
			stop = true
				
		var gravity_apply = false
		
		if gravity.x < -0.1:
			if velocity.x <= lateral_speed_min and velocity.x > -lateral_speed_max:
				force.x -= GRAVITY
				gravity_apply = true
		elif gravity.x > 0.1:
			if velocity.x >= -lateral_speed_min and velocity.x < lateral_speed_max:
				force.x += GRAVITY
				gravity_apply = true
				
		if stop == true:
			
			var vsign = sign(velocity.x)
			var vlen = abs(velocity.x)
			
			if gravity_apply == true  and sign(velocity.x) != sign(gravity.x):
				vlen -= STOP_FORCE * 2 * delta
			else:
				vlen -= STOP_FORCE * delta
				
			if vlen < 0:
				vlen = 0
			
			velocity.x = vlen * vsign
			
		# Integrate forces to velocity
		velocity += force * delta
		# Integrate velocity into motion and move
		
		var mov = Vector2(0.0,0.0)
		
		var collision = move_and_collide(velocity) 
		
		if collision:
			is_on_floor = is_on_floor() #(collision.normal.y < 0)
			 #(collision.normal.y > 0 and collision.normal.x < 0.1 and collision.normal.x > -0.1)
			is_on_wall = is_on_wall() #(collision.normal.x > 0.9 or collision.normal.x < -0.9 and collision.normal.y < 0.1)
	
			#if is_on_ceil and collision.collider.get_class() == "KinematicBody2D":
			#	hit()
				
			velocity = velocity.slide(collision.normal)
			
			mov = collision.travel
			
		else:
			is_on_wall = false
			is_on_ceil = false
			is_on_floor = false
			
		
		
			if (velocity-old_velocity)*0.1 > Vector2(1.0,1.0):
				mov = Vector2(1.0,1.0)
			elif (velocity-old_velocity)*0.1 < Vector2(-1.0,-1.0):
				mov = Vector2(-1.0,-1.0)
			else:
				mov = (velocity-old_velocity)*0.1
			
		
		
			
		emit_signal("camera_movement",-mov)    