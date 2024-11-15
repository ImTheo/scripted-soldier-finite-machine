extends SoldierState

func enter(previus_state_path)->void:
	soldier.update_state_label("dying")
	soldier.play_animation(States.DYING)
	soldier.collision_layer = 0
