# Runs the control flow of the entire game
class_name Main
extends Node2D

func _ready() -> void:
	var time: int = await %click_listener.run_challenge("thedogsitsthemogmits")
	var speed: float = %player.time_to_speed(time)
	
	%player.velocity.y -= speed
