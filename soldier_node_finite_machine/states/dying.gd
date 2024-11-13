extends SoldierState

func enter(previus_state_path)->void:
	soldier.show_state("dying")
	soldier.collision_layer = 0
	soldier.play_animation(SoldierFiniteMachineScripted.States.DYING)
