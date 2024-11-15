extends SoldierState
var gravity = 0

func enter(previus_state_path)->void:
	soldier.update_state_label("Falling")
	soldier.play_animation(States.STANDING)

func physics_update(delta:float)->void:
	if soldier.is_on_floor():
		finished.emit(states[States.STANDING])
	_handle_gravity(delta)
	soldier.move_and_slide()

func _handle_gravity(delta):
	gravity += 50 * delta
	soldier.velocity.y = -gravity
