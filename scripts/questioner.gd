extends CharacterBody2D

@onready var _sprite_to_hide = $BalaoP
@onready var _sprite_right = $BalaoRC
@onready var _sprite_wrong = $BalaoRE
@onready var _animated_sprite = $Animation

const MAX_INTERACTION_DISTANCE = 20.0
var playerscore = 0
@onready var global_data = get_node("/root/Global")

@export var npc_references: Array = ["/root/Game/Npc1/Balao", "/root/Game/Npc2/Balao", "/root/Game/Npc3/Balao"]
@export var player: NodePath = "/root/Game/Player"
@export var player_start_position = Vector2(100, 118)


var _waiting_for_timeline = false

func _ready() -> void:
	_sprite_wrong.visible = false
	_sprite_right.visible = false
	
	if player == null:
		print("Atenção: Referência ao player não foi definida!")

func _process(delta: float) -> void:
	_animated_sprite.play("q_idle")


func interact() -> void:
	playerscore = 0  # Reseta a pontuação ao iniciar a fase
	if global_data.fase == 1:
		print("Iniciando fase 1")
		Dialogic.start('player_questionador_f1')
		Dialogic.signal_event.connect(DialogicSignal)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		_waiting_for_timeline = true  # Aguarda o fim do diálogo para continuar
	elif global_data.fase == 2:
		print("Iniciando fase 2")
		Dialogic.start('player_questionador_f2')
		Dialogic.signal_event.connect(DialogicSignal)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		_waiting_for_timeline = true
	elif global_data.fase == 3:
		print("Iniciando fase 3")
		Dialogic.start('player_questionador_f3')
		Dialogic.signal_event.connect(DialogicSignal)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		_waiting_for_timeline = true

func DialogicSignal(argument: String) -> void:
	if argument in ['acertou1', 'acertou2']:
		playerscore += 1
		print("Pontuação atual:", playerscore)

func _on_timeline_ended() -> void:
	print("Diálogo encerrado. Pontuação:", playerscore)
	_waiting_for_timeline = false  # Permite novas interações
	if playerscore == 2:
		print("Jogador passou de fase!")
		global_data.fase += 1
	else:
		print("Jogador não atingiu a pontuação necessária.")
		if _sprite_to_hide:
			_sprite_to_hide.visible = true
