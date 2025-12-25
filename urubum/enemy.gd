extends RigidBody2D

var speed = 100
var searchSide
@onready var spriteRend = $enemySprite
@onready var spritePerState = [
preload("res://Sprites/Urubao.png"), ##IDLE -> 0
];

@onready var leftWall := $RayCast2DL;
@onready var rightWall := $RayCast2DR;

var maxTimeToFlip : int = 120;
var timeToFlip : int = maxTimeToFlip;


enum STATES { IDLE, SEARCH }

var state: STATES = STATES.IDLE

func _physics_process(_delta):
	spriteRend.scale = Vector2(0.1, 0.1);
	match state:
		STATES.IDLE:
			idle();
			
			if Input.is_key_pressed(KEY_K):
				state = STATES.SEARCH
			
		STATES.SEARCH:
			searching();
			
			

#region StatesFunction #definindo cada função do inimigo

func idle():
	spriteRend.texture = spritePerState.get(0);
	timeToFlip -= 1;
	
	self.linear_velocity = Vector2(0, 0)

func searching():
	if(spriteRend.flip_h == false): searchSide = 1
	else: searchSide = -1
	
	if rightWall.is_colliding() and spriteRend.flip_h == false:
		spriteRend.flip_h = !spriteRend.flip_h;
	elif leftWall.is_colliding() and spriteRend.flip_h == true:
		spriteRend.flip_h = !spriteRend.flip_h;
	
	
	#if Input.is_key_pressed(KEY_K):
	#	spriteRend.flip_h = !spriteRend.flip_h
	
	
	self.linear_velocity = Vector2(speed * searchSide, 0);
#endregion
