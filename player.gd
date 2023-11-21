extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var near_edge = false
@onready var weapon = $Weapon/CollisionShape2D
@onready var facing_shape = $Weapon
var state = "idle"
var animation_locked = false
var was_jumping = false

#TODO: mark animation locked on animations until they are finished. add update animations 

	



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5



func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
		
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or near_edge):
		velocity.y = JUMP_VELOCITY
		state = "jump"
		animation_locked = true
		
	if Input.is_action_just_pressed("mouse_left"):
		state = "attack"	
		animation_locked = true
		
	# Check if character should move or not
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if not animation_locked:
		if not is_on_floor() and was_jumping:
			state = "falling"
				
		if direction != 0:
			if is_on_floor():
				state = "run"
			
		elif is_on_floor():
			state = "idle"
			was_jumping = false

	
	move_and_slide()
	update_facing_direction(direction)
	update_state(state)
	
	
func update_facing_direction(direction):
	if direction:
		$Sprite2D.scale.x = -1 if direction < 0 else 1 #flip sprite based on direction
		if direction < 0:
			weapon.position.x = facing_shape.face_left
		else:
			weapon.position.x = facing_shape.face_right
	pass
	
func update_state(state):
	if state == "run":
		$AnimationPlayer.play("run")
	elif state == "jump":
		$AnimationPlayer.play("jump")
	elif state == "idle":
		$AnimationPlayer.play("idle")
	elif state == "falling":
		$AnimationPlayer.play("falling")
	elif state == "attack":
		$AnimationPlayer.play("attack")	

func _on_area_2d_body_entered(body):
	if body == self:
		near_edge = true
		print("near true")

func _on_area_2d_body_exited(body):
	if body == self:
		near_edge = false
		print("near false")



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "jump":
		animation_locked = false
		was_jumping = true
	if anim_name == "attack":
		animation_locked = false
		print(anim_name)
