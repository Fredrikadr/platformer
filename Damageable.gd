extends Node

@export var health = 20

func hit(damage):
	health -= damage
	
	if health <= 0:
		get_parent().queue_free()
