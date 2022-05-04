class_name Player
extends KinematicBody2D

export  (int) var GRAVITY = 2000
export (int) var JUMP_SPEED = 1000
export (int) var MOVE_SPEED = 1000

var velocity: Vector2
onready var animation = $AnimatedSprite

onready var _debug_label = $Debug
onready var _state_machine = $StateMachine
var is_flipped_horizontal = false

signal flipped_horizontal(is_flipped)

func _ready() -> void:
	pass
	
func _debug():
	_debug_label.set_text(
		"Velocity: {vel}\nState: {state}\n".format(
			{"vel": velocity, "state": _state_machine.state.name}
		))
	
func is_moving():
	return Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")

func is_jumping():
	return Input.is_action_pressed("ui_up")
	
func is_attacking():
	return Input.is_action_just_pressed("attack")

func jump():
	velocity.y = -JUMP_SPEED

func update_velocity(delta: float):
	var move_direction: float = (
		Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left")
	)
	velocity.x = MOVE_SPEED * move_direction
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func update_animation(animation_name: String):
	if animation.get_animation() == animation_name:
		return
	
	animation.play(animation_name)

func update_flip_horizontal():
	if velocity.x == 0:
		return
		
	var current_flip: bool = false
	if velocity.x < 0:
		current_flip = true
	
	if is_flipped_horizontal != current_flip:
		is_flipped_horizontal = current_flip
		animation.flip_h = current_flip
		emit_signal("flipped_horizontal", current_flip)
	

func _physics_process(_delta: float) -> void:
	update_flip_horizontal()
	
	_debug()
