extends Node2D
class_name HealthComponent


@export var maxHealth : float = 10
var health : float

func _ready() -> void:
	health = maxHealth;

func take_damage(damage: int):
	health -= damage;
	pass
