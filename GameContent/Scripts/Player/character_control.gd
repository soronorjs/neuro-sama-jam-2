extends CharacterBody2D

# Project Variables
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Character Variables
@onready var player = $"."
@onready var player_sprite = $".".get_node("PlayerSprite")
@onready var animation_player = player.get_node("MainAnimation")
@onready var animation_control = animation_player.get_node("AnimationRoot")
@onready var state_machine = animation_control.get("parameters/playback")


# Metadata
@onready var speed = player.get_meta("walk_speed")
@onready var jump_velocity = player.get_meta("jump_velocity")
	
var last_direction = 1

func _physics_process(delta: float) -> void:
# Jumping Logic
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	while Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		break
		
	if Input.is_action_just_released("ui_accept"):
		velocity.y = lerp(velocity.y, gravity*delta, 0.75)
		
		
	var direction = Input.get_axis("ui_left", "ui_right")
	while direction != 0:
		last_direction = direction
		break

# Movement Logic
	if direction:
		velocity.x = direction * speed
		state_machine.travel("End")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		state_machine.travel("Idle")
		
	move_and_slide()
	
# Attack
	if Input.is_action_just_pressed("attack"):
		var bullet = load("res://GameContent/Scenes/Subscene_Objects/bullet.tscn")
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = player.position + Vector2(100*last_direction, 0)
		bullet_instance.linear_velocity.x = player.get_meta("railgun_speed") * last_direction
		
		var bullet_holder = $BulletHolder
		bullet_holder.add_child(bullet_instance)
