extends Control

var Indicator = load("res://UI/indicator.tscn")
var lives_pos = Vector2(20, Global.VP.y - 20)
var lives_index = 30

func _ready():
	update_score()
	update_time()
	update_lives()

func update_score():
	$Score.text = "Score: " + str(Global.score)

func update_time():
	$Time.text = "Time: " + str(Global.time)

func update_lives():
	lives_pos = Vector2(20, Global.VP.y - 20)
	for child in $Indicator_Container.get_children():
		child.queue_free()
	for i in range(Global.lives):
		var indicator = Indicator.instantiate()
		indicator.position = lives_pos + Vector2(lives_index*i, 0)
		$Indicator_Container.add_child(indicator)


func _on_timer_timeout():
	Global.update_time(-1)
	update_time()
	if Global.time <= 0:
		get_tree().change_scene_to_file("res://UI/end_game.tscn")
