extends RayCast3D

@onready var interact_text: RichTextLabel = $"../../../../Control/InteractText"
@onready var bloodiedpaper: Sprite2D = $"../../../../Control/Bloodiedpaper"
@onready var player: CharacterBody3D = $"../../.."
@onready var book_contents: RichTextLabel = $"../../../../Control/Bloodiedpaper/BookContents"


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
					bloodiedpaper.visible = true
					book_contents.clear()
					book_contents.add_text(collider.get_indexed("bookContent").contents)
					player.user_control = false
			_:
				pass
				
	else:
		interact_text.visible = false
