extends Area2D

@export var face_right = 8
@export var face_left = -8
@export var damage = 10


func _on_body_entered(body):
	for child in body.get_children():
		if child.name == "Damageable":
			child.hit(damage)
