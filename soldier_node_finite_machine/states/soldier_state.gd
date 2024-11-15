#Boilerplate class for 
class_name SoldierState extends State

enum States{STANDING, FALLING,WALKING, SHOOTING, DYING}
const states :=["Standing","Falling","Walking","Shooting","Dying"]

@export var soldier:Soldier

func _ready() -> void:
	assert(soldier != null,"Add soldier")
