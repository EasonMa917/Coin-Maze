extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
var alive = true
var can_move = true

func _physics_process(delta: float) -> void:
	if !alive:
		return
	# Add Animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "walk"
	else:
		animated_sprite_2d.animation = "idle"
	
	var x_dir := Input.get_axis("left", "right")
	var y_dir := Input.get_axis("up", "down")
	
	if x_dir:
		velocity.x = x_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if y_dir:
		velocity.y = y_dir * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
	
	# Add directional changing
	if x_dir == 1.0:
		animated_sprite_2d.flip_h = false
	if x_dir == -1.0:
		animated_sprite_2d.flip_h = true
