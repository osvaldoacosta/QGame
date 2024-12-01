extends CharacterBody2D

@onready var _sprite_to_hide = $BalaoP # Substitua pelo caminho do sprite de pergunta
@onready var _sprite_right = $BalaoRC # Substitua pelo caminho do sprite de resposta certa
@onready var _sprite_wrong = $BalaoRE # Substitua pelo caminho do sprite de resposta errada

# Distância máxima para interação
const MAX_INTERACTION_DISTANCE = 20.0

# Variável global (use um Autoload para gerenciar variáveis globais)
@onready var global_data = get_node("/root/Global")

@export var npc_references: Array = ["/root/Game/Npc1/Balao", "/root/Game/Npc2/Balao", "/root/Game/Npc3/Balao"]

var _answer: bool

# Referência para o player
@export var player: NodePath = "/root/Game/Player"

# Timer para controle do tempo de exibição
var _timer = null

# Posição inicial do player
@export var player_start_position = Vector2(100, 118)

func _ready() -> void:
	_sprite_wrong.visible = false
	if player == null:
		print("Atenção: Referência ao player não foi definida!")
	# Certifique-se de que o sprite a ser exibido inicialmente está oculto
	if _sprite_right:
		_sprite_right.visible = false

func _process(delta: float) -> void:
	# Verifica se o player está dentro da distância máxima
	var player_node = get_node(player)
	if player_node and is_player_close(player_node):
		if Input.is_action_just_pressed("ui_accept"): # Verifica se Enter foi pressionado
			trigger_action()

func is_player_close(player_node: Node) -> bool:
	# Calcula a distância entre o NPC e o player
	var distance = position.distance_to(player_node.position)
	return distance <= MAX_INTERACTION_DISTANCE

func trigger_action() -> void:
	# Esconde o primeiro sprite
	if _sprite_to_hide:
		_sprite_to_hide.visible = false
		
	_answer = func_timeline(global_data.fase)
	
	if _answer:
		# Incrementa a variável global
		global_data.fase += 1
		# balao de acerto
		start_timer_with_balao(_sprite_right)
		# Teleporta o player para a posição inicial
		teleport_player_to_start()
		
	
	else:
		# balao de erros
		start_timer_with_balao(_sprite_wrong)
		_sprite_to_hide.visible = true
		
func start_timer_with_balao(balao) -> void:
	balao.visible = true
	# Configura um timer para ocultar o segundo sprite após 2 segundos
	if not _timer:
		_timer = Timer.new()
		add_child(_timer)
		_timer.one_shot = true
		_timer.wait_time = 2.0
		_timer.connect("timeout", Callable(self, "_on_timer_timeout").bind(balao))
	_timer.start()	

func _on_timer_timeout(balao) -> void:
	# Esconde o sprite de resposta errada quando o timer expira
	if balao:
		balao.visible = false
	if _timer:
		_timer.queue_free()
		_timer = null

func func_timeline(fase) -> bool:
	if fase == 1:
		print("fase1")
		return true # coloca dialogo da fase 1 aqui podendo retornar true ou false
	if fase == 2:
		print("fase2")
		return true # coloca dilogo da fase 2 aqui podendo retornar true ou false
	if fase == 3:
		print("fase3")
		return false # coloca dialogo da fase 3 aqui podendo retornar true ou false
	return true
				
func teleport_player_to_start() -> void:
	var player_node = get_node_or_null(player)
	if player_node:
		player_node.global_position = player_start_position
	show_other_npcs_sprites()
	
func show_other_npcs_sprites() -> void:
	for npc in npc_references:
		if npc:
			var sprite = get_node(npc) # Substitua pelo caminho do sprite no NPC
			if sprite:
				sprite.visible = true
