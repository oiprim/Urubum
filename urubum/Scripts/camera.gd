extends Camera2D


@onready var target = $"../Player";


func _process(_delta):
	global_position = target.getPlayerPos();
