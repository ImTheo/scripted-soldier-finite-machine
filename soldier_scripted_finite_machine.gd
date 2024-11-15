class_name SoldierFiniteMachineScripted
extends Node3D

var gravity = 0
var rotation_direction: float
var movement_velocity: Vector3
@onready var soldier: Soldier = %Soldier as Soldier

var state: States = States.STANDING: set = _set_state
enum States{STANDING,FALLING,WALKING, SHOOTING, DYING}

func _process(delta: float) -> void:
	soldier.update_state_label(States.keys()[state])
	
	_handle_state_transitions(delta)
	_handle_current_state(delta)

func _handle_state_transitions(_delta):
	match state:
		States.STANDING:
			if not soldier.is_on_floor():
				state = States.FALLING
			elif soldier.is_control_pressed():
				state = States.WALKING
			elif soldier.has_collisions():
				state = States.SHOOTING
			elif soldier.health < 0:
				state = States.DYING
		States.WALKING:
			if not soldier.is_control_pressed():
				state = States.STANDING
			elif not soldier.is_on_floor():
				state = States.FALLING
			elif soldier.has_collisions():
				state = States.SHOOTING
			elif soldier.health < 0:
				state = States.DYING
		States.FALLING:
			if soldier.is_on_floor():
				state = States.STANDING
		States.SHOOTING:
			if not soldier.has_collisions():
				state = States.STANDING
			elif soldier.health < 0:
				state = States.DYING

func _handle_current_state(delta):
	if state == States.FALLING:
		_handle_gravity(delta)
	if state == States.WALKING:
		_handle_controls(delta)
	if state == States.SHOOTING:
		_handle_shooting(delta)

	soldier.move_and_slide()

func _set_state(new_state:States):
	var prev_state := state
	state = new_state
	if 	(	
			prev_state == States.WALKING 
			and new_state == States.STANDING
		):
		soldier.velocity = Vector3.ZERO
	if new_state == States.SHOOTING: 
		soldier.velocity = Vector3.ZERO
	if new_state == States.DYING:
		soldier.collision_layer = 0
	soldier.play_animation(state)
	
func _handle_controls(delta):
	if soldier.controls.is_empty():
		printerr("agrega controles a ",soldier)
	var input := Vector3.ZERO
	input.x = Input.get_axis(soldier.controls[soldier.Controls.DOWN].action,soldier.controls[soldier.Controls.UP].action)
	input.z = Input.get_axis(soldier.controls[soldier.Controls.LEFT].action,soldier.controls[soldier.Controls.RIGHT].action)
	if input.length() > 1:
		input = input.normalized()
	movement_velocity = input * 1000 * delta
	if state == States.WALKING:
		soldier.velocity = movement_velocity
		rotation_direction = Vector2(movement_velocity.z, movement_velocity.x).angle()
		soldier.rotation.y = lerp_angle(soldier.rotation.y, rotation_direction, delta*10)
	
func _handle_gravity(delta):
	if state != States.FALLING:
		gravity = 0
		soldier.velocity.y = 0
		return
	gravity += 50 * delta
	soldier.velocity.y = -gravity
	
func _handle_shooting(delta):
	var target:Soldier = soldier.get_collision()
	var target_position = target.global_position
	var direction = (target_position - soldier.global_position).normalized()
	var target_angle = atan2(direction.x, direction.z)
	var angle_diff = target_angle - soldier.rotation.y
	angle_diff = wrapf(angle_diff, -PI, PI)
	soldier.rotate_y(angle_diff)
