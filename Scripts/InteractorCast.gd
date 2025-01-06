extends RayCast3D


@onready var player: CharacterBody3D = $"../../.."
@onready var bloodiedpaper: Sprite2D = $"../../../../UI/Bloodiedpaper"
@onready var book_contents: RichTextLabel = $"../../../../UI/Bloodiedpaper/BookContents"
@onready var interact_text: RichTextLabel = $"../../../../UI/InteractText"


var just_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	just_pressed = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_colliding():
		
		var collider = get_collider()
		
		match collider.name:
			"ReadableBookCollider":
				interact_text.visible = true
				
				if Input.is_action_just_pressed("interact") && !just_pressed:
					just_pressed = true
					bloodiedpaper.visible = true
					book_contents.clear()
					book_contents.add_text(collider.get_indexed("bookContent").contents)
					player.user_control = false
					
				elif Input.is_action_just_pressed("interact") && just_pressed:
					bloodiedpaper.visible = false
					player.user_control = true
					just_pressed = false
				
				
	else:
		interact_text.visible = false
		if Input.is_action_just_pressed("interact") && just_pressed:
			print("HEREE")
			bloodiedpaper.visible = false
			player.user_control = true
