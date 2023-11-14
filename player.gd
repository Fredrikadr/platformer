extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var near_edge = false
@onready var sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.3


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or near_edge):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("default")
	if direction != 0:
		sprite.flip_h = (direction == -1)
	
	move_and_slide()
	
	


func _on_area_2d_body_entered(body):
	if body == self:
		near_edge = true
		print("near true")

func _on_area_2d_body_exited(body):
	if body == self:
		near_edge = false
		print("near false")


