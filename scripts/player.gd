class_name Player
extends CharacterBody2D

const GRAVITY: float = 4.2

func _physics_process(delta: float) -> void:
	$engine_particles.emitting = velocity.y < 0.0
	
	velocity.y += GRAVITY
	move_and_slide()

func shake() -> void:
	$animation_player.play("jingle")

func time_to_speed(time: int) -> float:
	return 1024 * pow(max(1.0, float(time)), -0.2)
