extends SoldierState

func enter(_previus_state_path)->void:
	soldier.show_state("shooting")
	soldier.play_animation(SoldierFiniteMachineScripted.States.SHOOTING)
	soldier.velocity = Vector3.ZERO

func physics_update(delta:float)->void:
	if not soldier.has_collisions():
		finished.emit(states[States.STANDING])
		return
	elif not soldier.is_on_floor():
		finished.emit(states[States.FALING])
		return
	elif soldier.health < 0:
		finished.emit(states[States.DYING])
		return
		
	var target:Soldier = soldier.get_collision()
	var target_position = target.global_position
	var direction = (target_position - soldier.global_position).normalized()
	var target_angle = atan2(direction.x, direction.z)
	var angle_diff = target_angle - soldier.rotation.y
	angle_diff = wrapf(angle_diff, -PI, PI)
	soldier.rotate_y(angle_diff)
