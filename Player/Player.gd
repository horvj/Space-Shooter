extends CharacterBody2D

var speed = 5
var max_speed = 400
var rotate_speed = 0.08
var nose = Vector2(0, -60)
var Bullet = load("res://Player/bullet.tscn")
var Effects = null
var Explosion = load("res://Effects/explosion.tscn")
var health = 10
var target_pos = Vector2.ZERO
var rotation_interpolation_speed = 10.0

func get_input():
	var to_return = Vector2.ZERO
	$Exhaust.hide()
	if Input.is_action_pressed("Forward"):
		to_return += Vector2(0, -1)
		$Exhaust.show()
	if Input.is_action_pressed("Left"):
		rotation -= rotate_speed
	if Input.is_action_pressed("Right"):
		rotation += rotate_speed
	return to_return.rotated(rotation)

func _physics_process(_delta):
	velocity += get_input() * speed
	velocity = velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	move_and_slide()
	position.x = wrapf(position.x, 0.0, Global.VP.x)
	position.y = wrapf(position.y, 0.0, Global.VP.y)
	target_pos = get_viewport().get_mouse_position()
	$Crosshair.global_position = target_pos

	# Calculate the angle between the player and the mouse position
	var direction_to_mouse = (target_pos - global_position).normalized()
	var angle_to_mouse = atan2(direction_to_mouse.y, direction_to_mouse.x)

	# Set the rotation to the angle + 90 degrees (adjust for the sprite's initial orientation)
	rotation = angle_to_mouse + deg_to_rad(90)

	if Input.is_action_just_pressed("Shoot"):
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var bullet = Bullet.instantiate()
			bullet.rotation = rotation
			bullet.global_position = global_position + nose.rotated(rotation)
			Effects.add_child(bullet)

func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instantiate()
			Effects.add_child(explosion)
			explosion.global_position = global_position
			hide()
			await explosion.animation_finished
		Global.update_lives(-1)
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name != "Player":
		damage(100)
