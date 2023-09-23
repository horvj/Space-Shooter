extends Node2D

var Player = load("res://Player/bullet.tscn")

func _physics_process(_delta):
	if get_child_count() == 0:
		var player = Player.instance()
		player.position = Vector2(576,324)
		add_child(player)
