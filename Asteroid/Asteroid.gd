extends CharacterBody2D

var initial_speed = 100.0
var health = 10

func _ready():
	velocity = Vector2(0,initial_speed*randf()).rotated(2*PI*randf())


func _physics_process(_delta):
	move_and_slide()
	position.x = wrapf(position.x,0,1152)
	position.y = wrapf(position.y,0,648)

func damage(d):
	health -= d
	if health <= 0:
		queue_free()
