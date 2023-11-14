extends CharacterBody2D


const SPEED = 20.0
const JUMP_VELOCITY = -400.0
@onready var roam_timer = $roam_timer
@onready var wait_timer = $wait_timer
var roam = true
var direction = "right"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !roam:
		velocity.x = 0
	if roam and direction == "right":
		velocity.x = 1 * SPEED
	elif roam and direction == "left":
		velocity.x = -1 * SPEED
	
		
	move_and_slide()


func _on_roam_timer_timeout():
	roam = false
	wait_timer.start(2)
	
	
	

func change_direction():
	if direction == "right":
		direction = "left"
	elif direction == "left":
		direction = "right"
	print(direction)



func _on_wait_timer_timeout():
	change_direction()
	roam_timer.start(4)
	roam = true
