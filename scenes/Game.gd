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

export (int) var LEVEL_COUNT_MAX = 11
export (int) var LEVEL_COUNT = 3

var _tunnel_scene = preload("res://scenes/levels/Tunnel.tscn")
var _rng = RandomNumberGenerator.new()
var _levels = []

func init_levels():
	for i in range(1, LEVEL_COUNT_MAX):
		var level_path = "res://scenes/levels/Level%d.tscn" % i
		var level = load(level_path).instance()
		_levels.append(level)
	
func get_random_levels() -> Array:
	_rng.randomize()
	var levels_selected = []
	var levels_index = []
	for _i in range(LEVEL_COUNT):
		var index = -1
		while index == -1 or levels_index.has(index):
			index = _rng.randi_range(0, _levels.size() - 1)
		
		levels_index.append(index)
		levels_selected.append(_levels[index])
	
	return levels_selected


func instanciate_levels(levels_selected: Array) -> void:
	var index = 0
	for level in levels_selected:
		var tunnel = _tunnel_scene.instance()
		
		var tunnel_offset = LOBBY_SIZE + (index * TUNNEL_SIZE) + (index * LEVEL_SIZE)
		var tunnel_x = tunnel_offset * CELL_SIZE
		tunnel.set_position(Vector2(tunnel_x, 0))
		_levels_node.add_child(tunnel)
		
		var level_offset = LOBBY_SIZE + ((index + 1) * TUNNEL_SIZE) + (index * LEVEL_SIZE)
		var level_x = level_offset * CELL_SIZE
		level.set_position(Vector2(level_x, 0))
		_levels_node.add_child(level)
		
		index += 1
	

func reset_game():
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
