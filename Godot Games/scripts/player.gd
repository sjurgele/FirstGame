extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_rolling = false  # Flag to track rolling state

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations and handle rolling
	if is_on_floor():
		is_rolling = Input.is_action_pressed("roll")  # Track rolling state based on button press
		if is_rolling:
			animated_sprite.play("roll")  # Play roll animation only when rolling
		else:
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if Input.is_action_pressed("attack"):
		animated_sprite.play("attack")

	# Apply movement (modify for rolling)
	if direction:  # Apply movement based on input direction
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)  # Slow down gradually when not moving

	move_and_slide()
