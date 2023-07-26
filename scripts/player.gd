class_name Player
extends CharacterBody2D

const GRAVITY: float = 4.2


func _physics_process(delta: float) -> void:
	$engine_particles.emitting = velocity.y < 0
	
	$rocket_player.volume_db += delta * 128 * (-1 if velocity.y >= 0 else 1)
	$rocket_player.volume_db = clamp($rocket_player.volume_db, -64, -12)
	
	velocity.y += GRAVITY
	
	var was_on_floor: bool = is_on_floor()
	
	move_and_slide()
	
	if not was_on_floor and is_on_floor():
		$thud_sound_spawner.play_sound()

func shake() -> void:
	$animation_player.play("jingle")

func time_to_speed(time: int) -> float:
	return 1024 * pow(max(1.0, float(time)), -0.2)
