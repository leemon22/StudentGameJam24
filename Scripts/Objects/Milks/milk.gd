extends Area2D

enum MilkState {WAITING, COLLECTED}

@export var price: int = 10

var current_state = MilkState.WAITING

func _physics_process(delta):
	if current_state == MilkState.WAITING:
		_check_cursor_collision()
	else:
		# TODO: Mover a la tienda e intercambiar por dinero.
		pass

func _check_cursor_collision():
	var is_collecting = %CollisionBox.get_overlapping_bodies().size() > 0
	if is_collecting:
		current_state = MilkState.COLLECTED
