# Runs the control flow of the entire game
class_name Main
extends Node2D

func _ready() -> void:
	while true:
		var time: int = await %click_listener.run_challenge(get_random_letters())
		var speed: float = %player.time_to_speed(time)
		
		%player.takeoff(speed)
		await %player.landed

func get_random_letters() -> String:
	var str: String = ""
	for i in range(25):
		# Pick a random letter with ASCII
		str += char(97 + randi() % 26)
	return str
