extends CharacterBody2D

@onready var _sprite_to_hide = $BalaoP
@onready var _sprite_right = $BalaoRC
@onready var _sprite_wrong = $BalaoRE

const MAX_INTERACTION_DISTANCE = 20.0
var playerscore = 0
@onready var global_data = get_node("/root/Global")

@export var npc_references: Array = ["/root/Game/Npc1/Balao", "/root/Game/Npc2/Balao", "/root/Game/Npc3/Balao"]
@export var player: NodePath = "/root/Game/Player"
@export var player_start_position = Vector2(100, 118)

var _timer = null
var _waiting_for_timeline = false

func _ready() -> void:
	_sprite_wrong.visible = false
	_sprite_right.visible = false
	if player == null:
		print("Atenção: Referência ao player não foi definida!")

func _process(delta: float) -> void:
	if _waiting_for_timeline:
		return  # Pausa interação enquanto o diálogo está em andamento
	var player_node = get_node(player)
	if player_node and is_player_close(player_node):
		if Input.is_action_just_pressed("ui_accept"):
			trigger_action()

func is_player_close(player_node: Node) -> bool:
	return position.distance_to(player_node.position) <= MAX_INTERACTION_DISTANCE

func trigger_action() -> void:
	if _sprite_to_hide:
		_sprite_to_hide.visible = false
	func_timeline(global_data.fase)

func func_timeline(fase) -> void:
	playerscore = 0  # Reseta a pontuação ao iniciar a fase
	if fase == 1:
		print("Iniciando fase 1")
		Dialogic.start('player_questionador_f1')
		Dialogic.signal_event.connect(DialogicSignal)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		_waiting_for_timeline = true  # Aguarda o fim do diálogo para continuar
	elif fase == 2:
		print("Iniciando fase 2")
		Dialogic.start('player_questionador_f2')
		Dialogic.signal_event.connect(DialogicSignal)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		_waiting_for_timeline = true
	elif fase == 3:
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
		start_timer_with_balao(_sprite_right)
		teleport_player_to_start()
	else:
		print("Jogador não atingiu a pontuação necessária.")
		start_timer_with_balao(_sprite_wrong)
		if _sprite_to_hide:
			_sprite_to_hide.visible = true

func start_timer_with_balao(balao) -> void:
	balao.visible = true
	if not _timer:
		_timer = Timer.new()
		add_child(_timer)
		_timer.one_shot = true
		_timer.wait_time = 2.0
		_timer.connect("timeout", Callable(self, "_on_timer_timeout").bind(balao))
		_timer.start()

func _on_timer_timeout(balao) -> void:
	if balao:
		balao.visible = false
	if _timer:
		_timer.queue_free()
		_timer = null

func teleport_player_to_start() -> void:
	var player_node = get_node_or_null(player)
	if player_node:
		player_node.global_position = player_start_position
	show_other_npcs_sprites()

func show_other_npcs_sprites() -> void:
	for npc in npc_references:
		var sprite = get_node(npc)
		if sprite:
			sprite.visible = true
