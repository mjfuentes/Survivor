 
extends Node2D

const UNO = "ONE"
const DOS = "TWO"
const TRES = "THREE"
const CUATRO = "FOUR" 
var game_started = false
var game_ended = false
var screen_size
var escalador_size = Vector2(36,60)
var escalador_speed = 500
var fall_game_key = "TWO"
var fall_game = false
const fall_at = 200
const fall_speed = 500
var current_step = 0
var falling = false
var time_falling
var waiting_spacebar

func _ready():
#	get_node("new_sound_player").play("aire-8-bits.wav")
	set_process(true)
	waiting_spacebar = true

func _process(delta):
	if (!game_ended):
		if (Input.is_action_pressed("SPACE") and !game_started):
			get_node("splash").hide_splash()
		elif ((game_started) and (fall_game)):
			time_falling += delta
			if (time_falling > 0.25):
				if (Input.is_action_pressed(fall_game_key)):
					end_fall_game()
				elif ((Input.is_action_pressed(UNO)) or (Input.is_action_pressed(DOS)) or (Input.is_action_pressed(TRES)) or (Input.is_action_pressed(CUATRO))):
					end_game()
				elif (time_falling > 1.25):
					end_game()
	else:
		if (Input.is_action_pressed("SPACE") and game_ended):
			start_game()
			
	
func start_game():
	get_node("escalador").start()
	game_ended = false
	game_started = true
	time_falling = 0
	
func end_game():
	get_node("new_sound_player").play("click-2-8-bit.wav")
	get_node("escalador").get_node("hud").end_fall_game()
	get_node("escalador").die()
	fall_game = false
	game_ended = true

func start_fall_game(key,letter):
	get_node("escalador").get_node("hud").start_fall_game(letter)
	fall_game= true
	fall_game_key = key
	time_falling = 0


func game_ended():
	game_ended = true

func end_fall_game():
	get_node("escalador").get_node("hud").end_fall_game()
	get_node("escalador").end_fall_game()
	fall_game = false
	time_falling = 0

	
	