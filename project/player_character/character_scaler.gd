class_name CharacterScaler
extends Node2D

@export var scale_target: Node2D
@export var scale_levels: Array[float] = [0.25, 0.5, 1.0, 2.0, 4.0]
@export var scale_up_sound: AudioStream
@export var scale_down_sound: AudioStream
@export var fail_scale_up_sound: AudioStream
@export var scale_delay: float = 0.25
@export var can_grow: bool = false
@export var can_shrink: bool = false
@export var scale_checker: ScaleChecker


@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var scale_audio_stream_player: AudioStreamPlayer = %ScaleAudioStreamPlayer

func activate():
	can_shrink = true
	can_grow = true

func deactivate():
	can_shrink = false
	can_grow = false

var is_max_scale: bool:
	get: return current_scale_index == scale_levels.size() - 1

var is_min_scale: bool:
	get: return current_scale_index == 0

var is_on_cooldown: bool = false

signal scaled(amount: float)

var current_scale_index: int = 2:
	set = set_scale_index
func set_scale_index(val: int):
	current_scale_index = val
	scale_target.scale_amount = current_scale
	scaled.emit(current_scale)

var current_scale: float:
	get: return scale_levels[current_scale_index]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func scale_up():
	current_scale_index = min(current_scale_index + 1, scale_levels[scale_levels.size() - 1])
	if scale_up_sound:
		scale_audio_stream_player.stream = scale_up_sound
		scale_audio_stream_player.play()
	animation_player.play("grow")
	
func scale_down():
	current_scale_index = max(current_scale_index - 1, 0)
	if scale_down_sound:
		scale_audio_stream_player.stream = scale_down_sound
		scale_audio_stream_player.play()
	animation_player.play("shrink")

func set_cooldown():
	is_on_cooldown = true
	await get_tree().create_timer(scale_delay).timeout
	is_on_cooldown = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("scale_player_up"):
		if !can_grow:
			return
		if is_on_cooldown:
			return
		if is_max_scale:
			return
		if scale_checker != null and !scale_checker.has_room_to_grow:
			scale_audio_stream_player.stream = fail_scale_up_sound
			scale_audio_stream_player.play()
			set_cooldown()
			return
		scale_up()
		set_cooldown()
	elif event.is_action_pressed("scale_player_down"):
		if !can_shrink:
			return
		if is_on_cooldown:
			return
		if is_min_scale:
			return
		scale_down()
		set_cooldown()
	
