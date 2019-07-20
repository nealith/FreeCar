extends KinematicBody2D

# Member variables
const GRAVITY = 500.0 # pixels/second/second

const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 300

const STOP_FORCE = 500

var velocity = Vector2()

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
		
		var force = Vector2(0,0)
		
		var gravity = Vector2(GRAVITY*2,GRAVITY)*Physics2DServer.area_get_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR)
		
		var stop = true
		
		if left == true:
			if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
				force.x -= WALK_FORCE
				stop = false
		elif right == true:
			if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
				force.x += WALK_FORCE
				stop = false
				
		if stop:
			var vsign = sign(velocity.x)
			var vlen = abs(velocity.x)
			
			vlen -= STOP_FORCE * delta
			if vlen < 0:
				vlen = 0
			
			velocity.x = vlen * vsign
			
		# Integrate forces to velocity
		velocity += (force+gravity) * delta
		# Integrate velocity into motion and move
		print(velocity)
		
		var collision = move_and_collide(velocity) 
		
		if collision:
			is_on_floor = (collision.normal.y < 0)
			is_on_ceil = (collision.normal.y > 0 and collision.normal.x < 0.1 and collision.normal.x > -0.1)
			is_on_wall = (collision.normal.x > 0.9 or collision.normal.x < -0.9 and collision.normal.y < 0.1)
	
			#if is_on_ceil and collision.collider.get_class() == "KinematicBody2D":
			#	hit()
				
			velocity = velocity.slide(collision.normal)
		else:
			is_on_wall = false
			is_on_ceil = false
			is_on_floor = false