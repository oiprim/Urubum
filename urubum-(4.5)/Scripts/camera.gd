extends Camera2D


var inicialDisplaySize;
var actualDisplaySize;
@onready var target = $"../Player";


func _ready():
	inicialDisplaySize = DisplayServer.window_get_size(0)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	pass

func _process(_delta):
	global_position = target.getPlayerPos();
	#actualDisplaySize = DisplayServer.window_get_size(0);
	#self.offset = Vector2(inicialDisplaySize - actualDisplaySize) / 1.5;
	
