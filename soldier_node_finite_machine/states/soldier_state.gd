class_name SoldierState
extends State

enum States{STANDING, FALING,WALKING, SHOOTING, DYING}
const states :=["Standing","Faling","Walking","Shooting","Dying"]

@export var soldier:Soldier

func _ready() -> void:
	assert(soldier != null,"Add soldier")
