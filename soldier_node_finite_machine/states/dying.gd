extends SoldierState

func enter(previus_state_path)->void:
	soldier.show_state("dying")
	soldier.play_animation(SoldierFiniteMachineScripted.States.DYING)
	soldier.collision_layer = 0
