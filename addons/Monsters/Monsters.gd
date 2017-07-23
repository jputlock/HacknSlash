tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Zombie", "RigidBody2D", preload("Zombie.gd"), preload("Zombie.png"))

func _exit_tree():
	remove_custom_type("Zombie")