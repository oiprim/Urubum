extends Node
class_name HealthComponent

@export var maxHealth : float = 10
var health : float

func _physics_process(delta: float) -> void:
	if (health <= 0):
		die();

func _ready() -> void:
	health = maxHealth;

func take_damage(damage: float) -> void:
	health -= damage;

func heal(heal_amount: float) -> void:
	health += heal_amount;
	
func die():
	print("Eu to morto");
	
func current_health():
	return health;
	
	

	
