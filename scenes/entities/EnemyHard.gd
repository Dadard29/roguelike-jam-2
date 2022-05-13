extends Enemy

var _perso_body: Area2D = null

export (int) var speed = 3

const PERSO_GROUP = "perso_body"

onready var _sprite_body = $Animation/SpriteBody

func _ready():
	_health = 30
	

func _physics_process(_delta: float):
	if _perso_body != null:
		
		var enemy_position = get_global_position()
		var perso_position = _perso_body.get_global_position()
		var orientation = enemy_position.direction_to(perso_position)
		
		self.global_translate(orientation * speed)
		_sprite_body.rotate(PI/12)
		

func _on_Detection_area_entered(area):
	if area.is_in_group(PERSO_GROUP):
		_perso_body = area


func _on_Detection_area_exited(area):
	if area.is_in_group(PERSO_GROUP):
		_perso_body = null


func _on_EnemyHard_dying():
	_sprite_body.set_visible(false)
