extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Alterar a variável global do Dialogic
	Dialogic.set_variable("player_name", "Lucas")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
