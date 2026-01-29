extends Area2D
class_name HitBoxComponent

@export var health : HealthComponent

func _ready() -> void:
	area_entered.connect(attack_deteceted);

func attack_deteceted(area: Area2D):
	if(!area.is_in_group("attackCollision")):
		return
	
	if(area.is_in_group("attackCollision")):
		health.take_damage(3);
		print("Tomou um dano");
