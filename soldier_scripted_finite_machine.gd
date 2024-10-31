class_name Soldier

extends CharacterBody3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var shape_cast_3d: ShapeCast3D = %ShapeCast3D
@onready var shape_cast_capsule_3d: ShapeCast3D = %ShapeCastCapsule3D
@onready var fire_arm: Node3D = %FireArm
@export var bullet: PackedScene
@export var health: int = 100
@onready var label_3d: Label3D = %Label3D

var text

signal shooted

func play_animation(state:SoldierFiniteMachineScripted.States):
	match state:
		SoldierFiniteMachineScripted.States.STANDING:
			animation_player.play("idle_standing_up")
		SoldierFiniteMachineScripted.States.WALKING:
			animation_player.play("walking_standing_up")
		SoldierFiniteMachineScripted.States.SHOOTING:
			animation_player.play("shooting_standing_up")
		SoldierFiniteMachineScripted.States.DYING:
			rotation.x = 0
			animation_player.play("death")

func has_collisions():
	if shape_cast_3d.is_colliding() or shape_cast_capsule_3d.is_colliding():
		return true
	else:
		return false

func get_collision()->Soldier:
	if shape_cast_3d.is_colliding():
		return shape_cast_3d.get_collider(0) as Soldier
	else:
		return shape_cast_capsule_3d.get_collider(0) as Soldier

func shoot():
	var b:Bullet = bullet.instantiate() as Bullet
	b.transform = fire_arm.global_transform
	owner.add_sibling(b)
	
func _on_shooted() -> void:
	health -= 20
