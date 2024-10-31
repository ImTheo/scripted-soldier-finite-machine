class_name SoldierFiniteMachineScripted
extends Node3D

enum States{STANDING,FALING,WALKING, SHOOTING, DYING}
var gravity = 0
var rotation_direction: float
var state: States = States.STANDING: set = set_state
var text: String
var movement_velocity: Vector3
@onready var soldier: Soldier = $Shooting_standing_up as Soldier
@onready var label_3d: Label3D = %Label3D
@export var velocity : int = 5
@export var controls:Array[InputEventAction]
enum Controls{UP,DOWN,LEFT,RIGHT} 


func _process(delta: float) -> void:
	#Update Soldier Labels
	text = "State: %s ,
	health: %s" 
	label_3d.text = text%[[States.keys()[state]],soldier.health]
	
	_handle_controls(delta)
	#Update State
	match state:
		States.STANDING:
			if not soldier.is_on_floor():
				state = States.FALING
			elif _is_control_pressed():
				state = States.WALKING
			elif soldier.has_collisions():
				state = States.SHOOTING
			elif soldier.health < 0:
				state = States.DYING
		States.WALKING:
			if not _is_control_pressed():
				state = States.STANDING
			elif not soldier.is_on_floor():
				state = States.FALING
			elif soldier.has_collisions():
				state = States.SHOOTING
			elif soldier.health < 0:
				state = States.DYING
		States.FALING:
			if soldier.is_on_floor():
				state = States.STANDING
		States.SHOOTING:
			if not soldier.has_collisions():
				state = States.STANDING
			elif soldier.health < 0:
				state = States.DYING
	if state == States.SHOOTING:
		var target:Soldier = soldier.get_collision()
		var target_position = target.global_position
		var direction = (target_position - soldier.global_position).normalized()
		var target_angle = atan2(direction.x, direction.z)
		var angle_diff = target_angle - soldier.rotation.y
		angle_diff = wrapf(angle_diff, -PI, PI)
		soldier.rotate_y(angle_diff)
	soldier.move_and_slide()
	_handle_gravity(delta)
	
func _is_control_pressed()->bool:
	for i in controls:
		if Input.is_action_pressed(i.action):
			return true
	return false

#Handle State Transition
func set_state(new_state:States):
	var prev_state := state
	state = new_state
	if (prev_state == States.STANDING or prev_state == States.WALKING) and new_state == States.FALING:
		soldier.velocity = Vector3(0,-20,0)
	if prev_state == States.STANDING and new_state == States.WALKING:
		soldier.velocity = movement_velocity
	if prev_state == States.WALKING and new_state == States.STANDING:
		soldier.velocity = Vector3(0,0,0)
	if new_state == States.SHOOTING: 
		soldier.velocity = Vector3.ZERO
	if new_state == States.DYING:
		soldier.collision_layer = 0
	soldier.play_animation(state)
	
	
func _handle_controls(delta):
	if controls.is_empty():
		return
	var input := Vector3.ZERO
	input.x = Input.get_axis(controls[Controls.DOWN].action,controls[Controls.UP].action)
	input.z = Input.get_axis(controls[Controls.LEFT].action,controls[Controls.RIGHT].action)
	if input.length() > 1:
		input = input.normalized()

	movement_velocity = input * velocity * delta

	if state == States.WALKING:
		soldier.velocity = movement_velocity
		rotation_direction = Vector2(movement_velocity.z, movement_velocity.x).angle()
		soldier.rotation.y = lerp_angle(soldier.rotation.y, rotation_direction, delta*10)
	
func _handle_gravity(delta):
	if state != States.FALING:
		gravity = 0
		soldier.velocity.y = 0
		return
	gravity += 50 * delta
	soldier.velocity.y = -gravity
