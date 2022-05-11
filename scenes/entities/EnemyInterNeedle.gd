extends AnimatedSprite

const ATTACK_ANIM = "attack"
const IDLE_ANIM = "idle"

onready var _timer = $Timer

export (float) var round_value = 0.01

var _perso_body: Area2D = null
var _shoot_orientation = Vector2.UP
var projectile_scene = preload("res://scenes/entities/EnemyInterProjectile.tscn")
var _attack_enabled = true

func _update_rotation():
	var enemy_position = get_global_position()
	var perso_position = _perso_body.get_global_position()
	_shoot_orientation = enemy_position.direction_to(perso_position)
	
	var angle = stepify(_shoot_orientation.angle() + PI/2, 0.01)
	var needle_rotation = stepify(rotation, 0.01)
	
	if needle_rotation != angle:
		self.set_rotation(angle)
		

func _on_EnemyInter_dying():
	# remove the needle
	self.set_visible(false)
	_attack_enabled = false

func _on_Detection_area_entered(area: Area2D):
	# perso detected
	if area.is_in_group("perso_body"):
		_perso_body = area
		_timer.start()


func _on_Detection_area_exited(area: Area2D):
	# perso left detection area
	if area.is_in_group("perso_body"):
		# stop attack behavior
		_perso_body = null
		_timer.stop()
	
func _on_Timer_timeout():
	# when CD done, play the attack animation
	play(ATTACK_ANIM)
	yield(self, "animation_finished")
	play(IDLE_ANIM)
	
func _on_Needle_frame_changed():
	if not _attack_enabled:
		return
	
	if animation == ATTACK_ANIM:
		if frame == 20:
			# fire at the specific frame
			# print("firing " + String(_shoot_orientation))
			var projectile = projectile_scene.instance()
			get_parent().add_child(projectile)
			projectile.set_position(Vector2.UP)
			projectile.fire(_shoot_orientation)

func _physics_process(_delta: float):
	if _perso_body == null:
		return
	
	_update_rotation()
