tool
extends "res://Scripts/Entity.gd"

var animator
var radius = 8
var height = 6

func _ready():
	self.add_to_group("Enemy")
		
	var sprite = Sprite.new()
	sprite.set_name("Sprite")
	sprite.set_texture(preload("res://Textures/characters/Zombie.png"))
	sprite.set_vframes(8)
	sprite.set_hframes(36)
	sprite.set_frame(180)
	sprite.set_frame(253)
	sprite.scale(Vector2(0.75, 0.75))
	self.add_child(sprite)
	sprite.set_owner(self.get_tree().get_current_scene())
	
	#collisionBox
	var collisionBox = CollisionShape2D.new()
	var collisionShape = CapsuleShape2D.new()
	collisionShape.set_radius(radius)
	collisionShape.set_height(height)
	collisionBox.set_shape(collisionShape)
	add_child(collisionBox)
	add_shape(collisionShape)

	
	if self.get_tree().is_editor_hint():
		sprite.show()
	else:
		init(20)
		
		#animations
		animator = AnimationPlayer.new()
		animator.add_animation("deathbot", preload("res://Animations/Zombie/deathbot.tres"))
		animator.add_animation("idlebot", preload("res://Animations/Zombie/idlebot.tres"))
		animator.add_animation("idlebotleft", preload("res://Animations/Zombie/idlebotleft.tres"))
		animator.add_animation("idlebotright", preload("res://Animations/Zombie/idlebotright.tres"))
		animator.add_animation("idleleft", preload("res://Animations/Zombie/idleleft.tres"))
		animator.add_animation("idleright", preload("res://Animations/Zombie/idleright.tres"))
		animator.add_animation("idletop", preload("res://Animations/Zombie/idletop.tres"))
		animator.add_animation("idletopleft", preload("res://Animations/Zombie/idletopleft.tres"))
		animator.add_animation("idletopright", preload("res://Animations/Zombie/idletopright.tres"))
		animator.set_active(true)
		self.add_child(animator)
		animator.set_owner(self.get_tree().get_current_scene())
		
		self.set_gravity_scale(0)
		animator.play("idlebot")
		print(animator.is_active())


func death_protocol():
	if animator.get_current_animation() != "deathbot":
		animator.set_current_animation("deathbot")
		remove_shape(0)
	elif animator.get_current_animation() == "deathbot":
		if not animator.is_playing():
			queue_free()
		else:
			pass
	else:
		print("Zombie animation error")
