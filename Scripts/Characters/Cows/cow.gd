extends CharacterBody2D

enum CowState {WALKING, MEWING, MILKING, SCARED, CONFUSED}

const SCARE_MIN = 2.0
const SCARE_MAX = 5.0

@export var mewing_cooldown = 0.5
@export var milking_cooldown = 3.0
@export var walk_speed = 5.0
@export var run_speed = 9.0
@export var price: int = 1
@export var random_mewing = 0.05
@export var milk_path: NodePath = "res://Scenes/Objects/Milks/milk.tscn"

var current_state = CowState.WALKING
var has_milk = false
var wandering_dir = Vector2(randf(),randf()).normalized()


func _ready():
	%MewingTimer.wait_time = mewing_cooldown
	%MilkingTimer.wait_time = milking_cooldown


func _physics_process(_delta):
	upadate_state()
	move()


func colliding(area) -> bool:
	var overlapping_mobs = area.get_overlapping_bodies()
	return overlapping_mobs.size() > 0


func random_small_angle():
	const SMALLANGLE = 0.2
	return randf_range(-SMALLANGLE, SMALLANGLE)


func upadate_state():
	# Cuando pasa a ordeñada
	if colliding(%MilkZone) and current_state == CowState.WALKING and has_milk:
		current_state = CowState.MILKING
		%MilkingTimer.start()
	# Cuando la abducimos
	elif (colliding(%UFOZone) and colliding(%GrassZone) and
	( current_state == CowState.WALKING or current_state == CowState.MEWING or current_state == CowState.SCARED)):
		if current_state == CowState.MEWING:
			%MewingTimer.stop()
		elif current_state == CowState.SCARED:
			%ScaredTimer.stop()
		# No conectamos al ovni
		current_state = CowState.CONFUSED
		%UFOZone.get_overlapping_bodies()[0].catch_cow(self)	# Espero que no pete
	# Cuando la asustamos con el ratón
	elif (colliding(%ScaredZone) and 
	( current_state == CowState.WALKING or current_state == CowState.MEWING or current_state == CowState.SCARED or current_state == CowState.CONFUSED)):
		if current_state == CowState.MEWING:
			%MewingTimer.stop()
		current_state = CowState.SCARED
		wandering_dir = (global_position - get_global_mouse_position()).normalized()
	# Meter cooldown de susto cuando alejamos el ratón
	elif (!colliding(%ScaredZone) and current_state == CowState.SCARED and !%ScaredTimer.is_timer_active()):
		%ScaredTimer.wait_time(randf_range(SCARE_MIN, SCARE_MAX))
		%ScaredTimer.start()
	# Pastado aleatorio
	elif (colliding(%GrassZone) and current_state == CowState.WALKING):
		if randf() < random_mewing:
			current_state = CowState.MEWING
			%MewingTimer.start()


func move():
	# Calculamos una dirección de movimiento
	wandering_dir.rotated(random_small_angle()).normalized()
	
	# Si está andando o asustado:
	if current_state == CowState.WALKING:
		velocity = wandering_dir * walk_speed
		move_and_slide()
	elif current_state == CowState.SCARED:
		velocity = wandering_dir * run_speed
		move_and_slide()


func _on_milking_timeout():
	# Actualizar estado
	has_milk = false
	current_state = CowState.WALKING
	
	# Instanciar leche
	var milk = load(milk_path).instantiate()
	milk.global_position = global_position + Vector2(randf(), randf())
	get_parent().add_child(milk)


func _on_mewing_timeout():
	has_milk = true
	current_state = CowState.WALKING


func _on_scared_timeout():
	current_state = CowState.WALKING

func abducted():
	queue_free()
