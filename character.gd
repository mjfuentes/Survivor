
extends KinematicBody2D

var max_score_life = 0
var actual_game_score
const GRAVITY = 200.0
const CLIMB_SPEED = 2000
var FALL_SPEED = 600
var velocity = Vector2()
const size_reduce = Vector2(26,20)
const darkness_move = Vector2(103,81)
var vals = []
var game_won = false
const UNO = "ONE"
const DOS = "TWO"
const TRES = "THREE"
const CUATRO = "FOUR" 
var total_fall_max = 1.5
var falling = false
var dying = false
var dead = false
var falling_dead = false
var total_fall = 0
var expected_next
var steps = 0
var max_steps
var show_tuto = true
var original_size
var original_pos
var camera_pos
var letters = ["A","S","K","L"]
var inputs = ["ONE","TWO","THREE","FOUR"]
var play_tuto
var original_camera_pos
var original_character_pos

func _ready():
	original_camera_pos = get_node("camera").get_pos()
	original_character_pos = get_pos()
	load_score_images()
	
func _fixed_process(delta):
#    velocity.y += delta * GRAVITY
	if (falling):
		velocity.y = FALL_SPEED
		var motion = velocity * delta
		move(motion)
		update_score()
		get_node("hud").decrease()
#		if (get_pos().y > 1400):
#			dead()
		if (falling_dead):
			total_fall += delta
			if (total_fall >= total_fall_max):
				camera_pos = get_node("camera").get_pos()
				dead = true
				FALL_SPEED += 300
				total_fall = 0
				falling_dead = false
		if (dead):
			total_fall += delta
			if (total_fall >= 1.5):
				falling = false
				dead = false
				show_end_game()
			var camera_pos = get_node("camera").get_pos()
			camera_pos.y = camera_pos.y - 15
			get_node("camera").set_pos(camera_pos)
			
	elif (is_colliding() and !game_won):
		game_won()

	else:
		if (Input.is_action_pressed(expected_next)):
			velocity.y = -CLIMB_SPEED
			steps += 1
			set_next(expected_next)
			get_node("hud").increase()
			if ((steps >= 8) and (play_tuto)):
				play_tuto = false
				get_node("hud").get_node("alerts").hide()
			elif (steps >= max_steps):
				falling = true
				randomize()
				var num = randi() % 3
				get_node("escalador_sprite").get_node("player").play("caida")
				get_parent().start_fall_game(inputs[num], letters[num])
		else: 
			velocity.y = 0
		var motion = velocity * delta
		move( motion )  
#		

func start():
	get_node("camera").make_current()
	randomize()
	actual_game_score = 0
	get_node("hud").get_node("alerts").show()
	play_tuto = true
	max_steps = get_random()
	set_fixed_process(true)
	steps = 0
	falling = false
	game_won = false
	dead = false
	max_score_life = 0
	falling_dead = false
	get_node("escalador_sprite").get_node("player").play("still")
	get_node("hud").get_node("alerts").get_node("player").play("A")
	get_node("camera").set_pos(original_camera_pos)
	set_pos(original_character_pos)
	expected_next = UNO
	FALL_SPEED = 600
#	original_size = get_node("darkness_sprite_two").get_texture().size
	original_pos = get_pos()
	update_score()
	
#func set_next_letter():
#	var num = randi() % 3
#	get_node("hud").get_node("alerts").get_node("player").play(letters[num])
#	expected_next = inputs[num]
	
func game_won():
	get_parent().get_node("new_sound_player").stop_all()
	get_parent().get_node("new_sound_player").play("achievement-8 bit")
	get_parent().get_node("game_won").get_node("win_camera").make_current()
	game_won = true
	get_parent().game_ended()
	
func end_fall_game():
	get_parent().get_node("new_sound_player").play("pico-8-bit.wav")
	get_node("escalador_sprite").get_node("player").play("colgado")
	total_fall_max += -0.2
	falling = false
	#get_node("hud").get_node("alerts").get_node("player").play("A")
	expected_next = UNO
	randomize()
	max_steps = get_random()
	steps = 0
	FALL_SPEED += 25
	
func die():
	total_fall = 0
	falling = true
	falling_dead = true
	
func show_end_game():
	get_parent().get_node("new_sound_player").play("death 8 bit")
	get_parent().get_node("die_screen").get_node("end_camera").make_current()
	show_max_score()
	get_parent().game_ended()
	
func get_random():
	randomize()
	var num = randi() % 25
	var smallest = 1
	if (play_tuto):
		smallest = 9
	while (num < smallest):
	#	randomize()
		num = randi() % 25
	return num

#func dead():
#	if (falling == true):
#		falling = false
#		var steps = 0
#		expected_next = UNO

func update_score():
	var actual_game_score = original_pos.y - get_pos().y
	if (actual_game_score >= 0):
		if (actual_game_score > max_score_life):
			max_score_life = actual_game_score
	else:
		actual_game_score = 0
	var first = floor(int(actual_game_score) / 1000)
	var second = floor(int(actual_game_score) % 1000 / 100)
	var third = floor(int(actual_game_score) % 100 / 10)
	var fourth = int(actual_game_score) % 10
#	var texture = load(vals[fourth])
	get_node("hud").get_node("score").get_node("first").set_texture(load(vals[first]))
	get_node("hud").get_node("score").get_node("second").set_texture(load(vals[second]))
	get_node("hud").get_node("score").get_node("third").set_texture(load(vals[third]))
	get_node("hud").get_node("score").get_node("fourth").set_texture(load(vals[fourth]))
	#	second = actual_game_score 
	
func show_max_score():
	var first = floor(int(max_score_life) / 1000)
	var second = floor(int(max_score_life) % 1000 / 100)
	var third = floor(int(max_score_life) % 100 / 10)
	var fourth = int(max_score_life) % 10
#	var texture = load(vals[fourth])
	get_parent().get_node("die_screen").get_node("score").get_node("first").set_texture(load(vals[first]))
	get_parent().get_node("die_screen").get_node("score").get_node("second").set_texture(load(vals[second]))
	get_parent().get_node("die_screen").get_node("score").get_node("third").set_texture(load(vals[third]))
	get_parent().get_node("die_screen").get_node("score").get_node("fourth").set_texture(load(vals[fourth]))
#	second = actual_game_score 


func load_score_images():
	vals.resize(10)
	for i in range(10):
		vals[i] = "res://sprites/hud/numeros/" + str(i) + ".png"
	
func set_next(last):
	get_node("hud").get_node("alerts").get_node("player").stop_all()
	if (last == UNO):
		if (play_tuto):
			get_node("hud").get_node("alerts").get_node("player").play("S")
		get_node("escalador_sprite").get_node("player").play("left")
		expected_next = DOS
	if (last == DOS):
		if (play_tuto):
			get_node("hud").get_node("alerts").get_node("player").play("K")
		get_node("escalador_sprite").get_node("player").play("right")
		expected_next = TRES
	if (last == TRES):
		if (play_tuto):
			get_node("hud").get_node("alerts").get_node("player").play("L")
		get_node("escalador_sprite").get_node("player").play("left")
		expected_next = CUATRO
	if (last == CUATRO):
		if (play_tuto):
			get_node("hud").get_node("alerts").get_node("player").play("A")
		get_node("escalador_sprite").get_node("player").play("right")
		expected_next = UNO
	update_score()
	get_parent().get_node("new_sound_player").play("pico-8-bit.wav")
