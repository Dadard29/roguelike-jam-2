extends Control

onready var velocity_label = $Container/Velocity
onready var state_label = $Container/State
onready var health_label = $Container/Health
onready var attack_label = $Container/Attack
onready var armor_label = $Container/Armor

func update_debug(velocity: Vector2, state_name: String, health: int,
					attack_damage: int, armor: int):
	velocity_label.set_text("Velocity: {0}".format([velocity]))
	state_label.set_text("State: {0}".format([state_name]))
	health_label.set_text("Health: {0}".format([health]))
	attack_label.set_text("Attack: {0}".format([attack_damage]))
	armor_label.set_text("Armor: {0}".format([armor]))

