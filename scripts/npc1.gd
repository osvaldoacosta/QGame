extends CharacterBody2D

@onready var _animated_sprite = $Animation
@onready var _sprite_to_hide = $Balao # Substitua pelo caminho correto do nó filho


@onready var global_data = get_node("/root/Global")

func _process(delta: float) -> void:
	# Reproduz animação idle do NPC
	_animated_sprite.play("npc_1_idle")


func interact() -> void:
	if _sprite_to_hide:
		_sprite_to_hide.visible = false
	if global_data.fase == 1:
		Dialogic.start('player_npc1_f1')
		print("fase1") # coloca dialogo da fase 1 aqui
	if global_data.fase == 2:
		print("fase2") # coloca dilogo da fase 2 aqui
		Dialogic.start('player_npc1_f2')
	if global_data.fase == 3:
		print("fase3") # coloca dialogo da fase 3 aqui 
		Dialogic.start('player_npc1_f2')
