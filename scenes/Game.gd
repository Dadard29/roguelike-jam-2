extends Node2D

export (Vector2) var initial_perso_position = Vector2(0, 0)

onready var _perso = $Perso
onready var _levels_node = $Levels
onready var _gui = $Gui

const LOBBY_SIZE = 10
const LEVEL_SIZE = 20
const TUNNEL_SIZE = 10
const CELL_SIZE = 64

export (int) var MAX_HEALTH = 100
export (int) var ATTACK_DMG = 10
export (int) var ARMOR_BASE = 1

export (int) var LEVEL_COUNT_MAX = 10
export (int) var LEVEL_COUNT = 3

export (bool) var DEBUG_ALL_LEVELS = false

var _tunnel_scene = preload("res://scenes/levels/Tunnel.tscn")
var _win_scene = preload("res://scenes/levels/Win.tscn")

var _rng = RandomNumberGenerator.new()
var _levels = []

var _enemy_basic_scene = preload("res://scenes/entities/EnemyBasic.tscn")
var _enemy_inter_scene = preload("res://scenes/entities/EnemyInter.tscn")
var _enemy_hard_scene = preload("res://scenes/entities/EnemyHard.tscn")
var _enemies_scenes = [
	_enemy_basic_scene, _enemy_inter_scene, _enemy_hard_scene
]

var _bonus_types = ["DAMAGE", "ARMOR"]
var _bonus_amount_max = 10

func init_levels():
	for i in range(1, LEVEL_COUNT_MAX + 1):
		var level_path = "res://scenes/levels/Level%d.tscn" % i
		var level = load(level_path)
		_levels.append(level)
	
func get_random_levels() -> Array:
	var levels_selected = []
	var levels_index = []
	for _i in range(LEVEL_COUNT):
		var index = -1
		while index == -1 or levels_index.has(index):
			index = _rng.randi_range(0, _levels.size() - 1)
		
		levels_index.append(index)
		levels_selected.append(_levels[index])
	
	return levels_selected
	
func get_random_enemies_instance(count: int) -> Array:
	var enemies_list = []
	for _i in range(0, count):
		var random_index = _rng.randi_range(0, _enemies_scenes.size() - 1)
		enemies_list.append(_enemies_scenes[random_index].instance())
	
	return enemies_list

func get_random_bonus_type() -> String:
	var random_index = _rng.randi_range(0, _bonus_types.size() - 1)
	return _bonus_types[random_index]

func get_random_bonus_amount() -> int :
	return _rng.randi_range(0, _bonus_amount_max)


func instanciate_levels(levels_selected: Array) -> void:
	var index = 0
	for level in levels_selected:
		var tunnel = _tunnel_scene.instance()
		
		var tunnel_offset = LOBBY_SIZE + (index * TUNNEL_SIZE) + (index * LEVEL_SIZE)
		var tunnel_x = tunnel_offset * CELL_SIZE
		tunnel.set_position(Vector2(tunnel_x, 0))
		_levels_node.add_child(tunnel)
		
		# set level position
		var level_instance = level.instance()
		var level_offset = LOBBY_SIZE + ((index + 1) * TUNNEL_SIZE) + (index * LEVEL_SIZE)
		var level_x = level_offset * CELL_SIZE
		level_instance.set_position(Vector2(level_x, 0))
		
		# set level enemies
		var slot_count = level_instance.get_slot_count()
		var enemies_list = get_random_enemies_instance(slot_count)
		level_instance.spawn_enemies(enemies_list)
		
		# set level bonus
		var bonus_type = get_random_bonus_type()
		var bonus_amount = get_random_bonus_amount()
		level_instance.set_bonus(bonus_type, bonus_amount)
		
		_levels_node.add_child(level_instance)
		
		index += 1
	
	var tunnel = _tunnel_scene.instance()
	var tunnel_offset = LOBBY_SIZE + (index * TUNNEL_SIZE) + (index * LEVEL_SIZE)
	var tunnel_x = tunnel_offset * CELL_SIZE
	tunnel.set_position(Vector2(tunnel_x, 0))
	_levels_node.add_child(tunnel)
	
	var win_instance = _win_scene.instance()
	var win_offset = LOBBY_SIZE + ((index + 1) * TUNNEL_SIZE) + (index * LEVEL_SIZE)
	var win_x = win_offset * CELL_SIZE
	win_instance.set_position(Vector2(win_x, 0))
	_levels_node.add_child(win_instance)
	

func reset_game():
	_rng.randomize()
	
	for child in _levels_node.get_children():
		_levels_node.remove_child(child)
	
	if DEBUG_ALL_LEVELS:
		instanciate_levels(_levels)
	else:
		var levels_selected = get_random_levels()
		instanciate_levels(levels_selected)
	
	# when done
	# reset player position and state
	_perso.set_global_position(initial_perso_position)
	_perso.spawn(MAX_HEALTH, ATTACK_DMG, ARMOR_BASE)
	
	_gui.set_seed(_rng.get_seed())
	
	

func _ready():
	init_levels()
	reset_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
