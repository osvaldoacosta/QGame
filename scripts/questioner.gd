extends CharacterBody2D

@onready var _sprite_to_hide = $BalaoP

@onready var _animated_sprite = $Animation

const MAX_INTERACTION_DISTANCE = 20.0
var playerscore = 0
@onready var global_data = get_node("/root/Global")
@onready var current_ballon = $BalaoP
@export var npc_references: Array = ["/root/Game/Npc1/Balao", "/root/Game/Npc2/Balao", "/root/Game/Npc3/Balao"]
@export var player: NodePath = "/root/Game/Player"
@export var player_start_position = Vector2(100, 118)


var _waiting_for_timeline = false
var is_endgame = false
func _ready() -> void:
	$BalaoRC.visible = false
	$BalaoRE.visible = false
	
	if player == null:
		print("Atenção: Referência ao player não foi definida!")

func _process(delta: float) -> void:
	current_ballon.visible = true
	if(is_endgame):
		_animated_sprite.play("q_walk")
		
	else:
		_animated_sprite.play("q_idle")

func _physics_process(delta):
	if is_endgame:
		move_and_slide()
	
func delete_questioner():
	queue_free()
	
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
	if argument in ['acertou1', 'acertou2', 'acertou3']:
		playerscore += 1
		print("Pontuação atual:", playerscore)
	
		

func exhibit_dialog_boxes():
	$"../Npc2"._sprite_to_hide.visible = true
	$"../Npc1"._sprite_to_hide.visible = true
	$"../Npc3"._sprite_to_hide.visible = true

func ballon_default():
	current_ballon = $BalaoP
	$BalaoRC.visible = false
	$BalaoRE.visible = false
func _on_timeline_ended() -> void:
	print("Diálogo encerrado. Pontuação:", playerscore)
	_waiting_for_timeline = false 
	if playerscore == 3:
		print("Jogador passou de fase!")
		current_ballon = $BalaoRC
		$BalaoP.visible = false
		$EndgameTimer.start(2)
		$EndgameTimer.timeout.connect(ballon_default)
		global_data.fase += 1
		exhibit_dialog_boxes()
	
		if(global_data.fase == 4):
			is_endgame = true
			velocity.x = 120
			$EndgameTimer.start(2)
			$EndgameTimer.timeout.connect(delete_questioner)
			move_and_slide()
		$EndgameTimer.start(2)
		$BalaoRC.visible = false
	else:
		print("Jogador não atingiu a pontuação necessária.")
		current_ballon = $BalaoRE
		$BalaoP.visible = false
		$EndgameTimer.start(2)
		$EndgameTimer.timeout.connect(ballon_default)
	
