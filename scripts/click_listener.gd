# Listens for input and runs challenges.
class_name ClickListener
extends Node

# The label that shows what letter to press.
const LETTER_LABEL: PackedScene = preload("res://scenes/letter.scn")

# Animation constants.
const CENTER: Vector2 = Vector2(193, 200)
const LETTER_LENGTH: int = 21
const ANIM_LENGTH: float = 0.05

# The string of letters to be typed by the player.
var to_type: String
var seconds_elapsed: int = 0

signal challenge_complete

func _ready() -> void:
	$error_delay.timeout.connect(_on_error_ended)
	$second_clock.timeout.connect(_on_second_passed)
	
	set_process_input(false)

func _input(event: InputEvent) -> void:
	# Prevent long presses from being picked up as another input.
	if not (event.is_pressed() and not event.is_echo()):
		return
	
	# Detect letter presses.
	if "unicode" in event:
		# A small delay prevents letter mashing.
		$clicky_sound_spawner.play_sound()
		
		if not $error_delay.is_stopped():
			return
		
		if char(event.unicode) == to_type.substr(0, 1):
			# Chop off the first letter.
			to_type = to_type.substr(1)
			shift_letters()
		else:
			error()

func _on_error_ended() -> void:
	%letter_holder.modulate = Color(1.0, 1.0, 1.0)

func _on_second_passed() -> void:
	seconds_elapsed += 1
	%time_label.text = str(min(99, seconds_elapsed))
	$clock_sound_spawner.play_sound()

func run_challenge(sentence: String) -> int:
	%time_label.text = "0"
	$second_clock.start()
	
	seconds_elapsed = 0
	to_type = sentence
	set_up_letters()
	set_process_input(true)
	
	await challenge_complete
	
	set_process_input(false)
	
	$second_clock.stop()
	
	return seconds_elapsed

func set_up_letters() -> void:
	for i in range(len(to_type)):
		var new_letter: Label = LETTER_LABEL.instantiate()
		new_letter.modulate.a = max(1.0 - i/3.0, 0.0)
		%letter_holder.add_child(new_letter)
		new_letter.position = CENTER + Vector2(i * LETTER_LENGTH, 0)
		new_letter.text = to_type.substr(i, 1)

# Move all letters to the left one position and delete the front-most letter.
func shift_letters() -> void:
	# Move the first label to be a child of the tree so that it is no longer detected
	# by this script.
	var letter_to_remove: Label = %letter_holder.get_child(0)
	letter_to_remove.get_parent().remove_child(letter_to_remove)
	get_tree().get_root().add_child(letter_to_remove)
	letter_to_remove.position = CENTER
	
	# Move the first letter down to the rocket
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(letter_to_remove, "position:y", 350, ANIM_LENGTH)
	tween.parallel().tween_property(letter_to_remove, "scale", Vector2(), ANIM_LENGTH)
	
	# Shift all letters to the left.
	for i in range(len(to_type)):
		tween.parallel().tween_property(%letter_holder.get_child(i), "position:x", 
		CENTER.x + LETTER_LENGTH * i, ANIM_LENGTH)
		tween.parallel().tween_property(%letter_holder.get_child(i), "modulate:a", 
		max(1.0 - i/3.0, 0.0), ANIM_LENGTH)
	
	await tween.finished
	%player.shake()
	$fuel_sound_spawner.play_sound()
	
	letter_to_remove.queue_free()
	
	if len(to_type) == 0:
		challenge_complete.emit()

func error() -> void:
	%letter_holder.modulate = Color(1.0, 0.5, 0.5, 0.8)
	$error_sound_spawner.play_sound()
	$error_delay.start(0.5)
