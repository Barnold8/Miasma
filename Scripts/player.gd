extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var standing_collider: CollisionShape3D = $Standing_collider
@onready var crouching_collider: CollisionShape3D = $Crouching_collider
@onready var standing_ray: RayCast3D = $StandingRay

## Const variables - Read only
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.8

## Editable variables - Read and write
var current_speed = 0.0
var direction = Vector3(0.0,0.0,0.0)
var head_height = 0.0

## Exported variables for editing in godot editor
@export var MAX_SPEED = 10.0
@export var walking_speed = 5.0
@export var sprinting_speed = 8.0
@export var crouching_speed = 1.0
@export var crouching_depth = 0.5
@export var smoothing_factor = 12

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hide mouse
	head_height = head.position.y
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: # When the input event for a mouse movement is triggered...
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY)) # Rotate the y axis to look left and right ("-" sign to stop inversion)
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY)) # Rotate the x axis to look up and down ("-" sign to stop inversion )
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89)) # clamp to stop rolling effect when looking

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("pause"):
		get_tree().quit()

	if Input.is_action_pressed("crouch"):
		
		head.position.y = lerp(head.position.y, crouching_depth, delta * smoothing_factor)
		standing_collider.disabled = true
		crouching_collider.disabled = false
		current_speed = crouching_speed
	else:
		if Input.is_action_pressed("sprint"):
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed
		
		if not standing_ray.is_colliding():
			standing_collider.disabled = false
			crouching_collider.disabled = true
			head.position.y = lerp(head.position.y, head_height, delta * smoothing_factor)


	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*MAX_SPEED)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
