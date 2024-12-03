extends Button
@onready var click_sound = $ClickSound

var original_position: Vector2
@export var hover_offset: float = 10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))
	if not click_sound:
		print("Warning: ClickSound node not found!")
	original_position = position




# Called every frame. 'delta' is the elapsed time since the previous frame.


@export var hover_scale_factor: float = 50


func _process(delta: float) -> void:
	if is_hovered():
		position = lerp(position, original_position - Vector2(0, hover_offset), delta * 10)
	else:
		position = lerp(position, original_position, delta * 10)
		
func _on_play_pressed() -> void:
	if click_sound and click_sound.stream:
		click_sound.play()
	
	await click_sound.finished
	get_tree().change_scene_to_file("res://game.tscn")
	
