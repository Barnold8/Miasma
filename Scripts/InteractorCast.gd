extends RayCast3D
@onready var interact_text: RichTextLabel = $"../../../../Control/InteractText"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_colliding():
		
		var collider = get_collider()
		
		match collider.name:
			"ReadableBookCollider":
				interact_text.visible = true
				if Input.is_action_just_pressed("interact"):
					print(collider.get_class())
			"":
				print("Two are better than one!")
			_:
				pass
				
	else:
		interact_text.visible = false
	
	pass
