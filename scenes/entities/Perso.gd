class_name Player
extends KinematicBody2D

export  (int) var GRAVITY = 2000
export (int) var JUMP_SPEED = 1000
export (int) var MOVE_SPEED = 700

var velocity: Vector2
var health: int
var attack_damage: int
var armor: int

var _recover: bool = false

onready var animation = $Animation/Sprite
onready var player = $Animation/Player

const ENEMY_DAMAGE = {
	"enemy_basic": 10,
	"enemy_inter": 10,
	"enemy_inter_projectile": 20
}
const FLASH_ANIM = "flash"
const TILE_KILL_GROUP = "tile_kill"

onready var _infos = $Infos
onready var _state_machine = $StateMachine
onready var _attack_state = $StateMachine/Attack
var is_flipped_horizontal = false

signal died
signal damaged(damage_taken)

func _ready() -> void:
	pass
	
func is_moving():
	return Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")

func is_jumping():
	return Input.is_action_pressed("ui_up")
	
func is_attacking():
	return Input.is_action_just_pressed("attack")

func jump():
	velocity.y = -JUMP_SPEED

func spawn(max_health: int, attack_damage_default: int, armor_default: int):
	_state_machine.transition_to("Idle")
	health = max_health
	attack_damage = attack_damage_default
	armor = armor_default

func die():
	_state_machine.transition_to("Dying")
	yield(animation, "animation_finished")
	emit_signal("died")

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
		_attack_state.flip_horizontal(current_flip)

func take_damage(dmg_taken: int) -> void:
	if _recover:
		# still recovering..
		return
	
	#fixme: add sound
	player.play(FLASH_ANIM)
	health -= dmg_taken
	if health <= 0:
		die()
		return
		
	emit_signal("damaged", dmg_taken, health)

# took damage
func _on_CollisionDamage_area_entered(area: Area2D) -> void:
	var groups = area.get_groups()
	if groups.size() < 1:
		return

	var group = groups[0]
	var dmg_taken = ENEMY_DAMAGE.get(group)
	if dmg_taken == null:
		return
	
	take_damage(dmg_taken)
	
# start flashing
func _on_Player_animation_started(anim_name: String) -> void:
	if anim_name != FLASH_ANIM:
		return
	
	_recover = true

# end flashing
func _on_Player_animation_finished(anim_name: String) -> void:
	if anim_name != FLASH_ANIM:
		return
	
	_recover = false

func is_on_tile_kill():
	for i in get_slide_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group(TILE_KILL_GROUP):
			take_damage(collider.damage)


func _physics_process(_delta: float) -> void:
	update_flip_horizontal()
	
	_infos.update_debug(velocity, _state_machine.state.name, health)

