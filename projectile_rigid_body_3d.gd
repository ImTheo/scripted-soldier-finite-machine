class_name Bullet
extends RigidBody3D

@export var speed:float = 5.0
@export var damage:float = 10.0

func _physics_process(delta):
	move_and_collide(-transform.basis.z * delta * speed)

func _on_hit_area_3d_body_entered(body):
	if body is Soldier:
		body.shooted.emit()
		queue_free()

func _on_timer_timeout():
	queue_free()
