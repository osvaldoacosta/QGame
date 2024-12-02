extends CharacterBody2D

@onready var _animated_sprite = $Animation
@onready var _sprite_to_hide = $Balao # Substitua pelo caminho correto do nó filho

# Distância máxima para interação
const MAX_INTERACTION_DISTANCE = 20.0

# Referência para o player (certifique-se de atribuí-lo corretamente no editor ou na cena)
@export var player: NodePath

# Variável global (use um Autoload para gerenciar variáveis globais)
@onready var global_data = get_node("/root/Global")

func _ready() -> void:
	if player == null:
		print("Atenção: Referência ao player não foi definida!")
	pass

func _process(delta: float) -> void:
	# Reproduz animação idle do NPC
	_animated_sprite.play("npc_3_idle")

	# Verifica se o player está dentro da distância máxima
	var player_node = get_node("/root/Game/Player")
	if player_node and is_player_close(player_node):
		if Input.is_action_just_pressed("ui_accept"): # Verifica se Enter foi pressionado
			func_timeline(global_data.fase)
	pass

func is_player_close(player_node: Node) -> bool:
	# Calcula a distância entre o NPC e o player
	var distance = position.distance_to(player_node.position)
	return distance <= MAX_INTERACTION_DISTANCE

func func_timeline(fase) -> void:
	if _sprite_to_hide:
		_sprite_to_hide.visible = false
	if fase == 1:
		print("fase1") # coloca dialogo da fase 1 aqui
		Dialogic.start('player_npc3_f1')
	if fase == 2:
		print("fase2") # coloca dilogo da fase 2 aqui
		Dialogic.start('player_npc3_f2')
	if fase == 3:
		print("fase3") # coloca dialogo da fase 3 aqui 
		Dialogic.start('player_npc3_f3')
