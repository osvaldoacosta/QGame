extends CharacterBody2D

@onready var _animated_sprite = $Animation
const SPEED = 80.0
@onready var label = $Camera2D/Fase  # Substitua pelo caminho do nó Label

@onready var global_data = get_node("/root/Global")

var closest_interactable_npc = null

func _ready() -> void:
	if label:
		label.text = "Fase 1"  # Define o texto

# Dialogic
func _input(event: InputEvent):
	# check if a dialog is already running
	
	if Dialogic.current_timeline != null:
		return

	if event.is_action_pressed("ui_accept"):
		if closest_interactable_npc:
			print("interagiu")
			closest_interactable_npc.interact()



# Processamento de animacoes/interacao
func _process(delta: float) -> void:
	label.text = "Fase "+str(global_data.fase)  # Define o texto
	if(Input.is_action_pressed("ui_right")):
		_animated_sprite.play("mc_forward_walk")
	elif(Input.is_action_pressed("ui_left")):
		_animated_sprite.play("mc_backward_walk")
	else:
		_animated_sprite.play("mc_idle")

#Coisas relacionadas a fisica do jogo/input-output, possivelmente nao vai mudar mais
func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)



	move_and_slide()








func _on_interaction_area_body_entered(body: Node) -> void:
	print(body)
	
	if body.has_method("interact"):
		closest_interactable_npc = body
		
		

# Detect when leaving an NPC's interaction area
func _on_interaction_area_body_exited(body: Node) -> void:
	print("Exited Area")
	if body == closest_interactable_npc:
		closest_interactable_npc = null
