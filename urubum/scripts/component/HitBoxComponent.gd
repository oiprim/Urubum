extends Area2D

var health_component = "res://scripts/component/HealthComponent.gd"

func _ready() -> void:
	body_entered.connect(entity_deteceted);
	pass;

func _process(delta: float) -> void:
	
	pass;

func entity_deteceted():
	health_component.take_damage(1);
	
