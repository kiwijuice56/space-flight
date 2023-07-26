class_name SoundSpawner
extends Node

@export var sounds: Array[Resource]
@export var base_db: float = 0.0

# Play a random sound with a little pitch for less repetition
func play_sound() -> void:
	var new_player: AudioStreamPlayer = AudioStreamPlayer.new()
	new_player.stream = sounds.pick_random()
	new_player.volume_db = base_db
	new_player.pitch_scale = randf_range(0.8, 1.2)
	add_child(new_player)
	new_player.play()
	await new_player.finished
	new_player.queue_free()
