
extends Node2D

const max_val = 100
var medidor_max_size
var step_size
var medidor_max
var medidor_min

func _ready():
	get_node("alerts").show()
	var medidor_size = get_node("medidor").get_texture().get_size()
	step_size = medidor_size.y / max_val
	medidor_max = get_node("medidor").get_pos().y - (medidor_size.y / 2)
	medidor_min = get_node("medidor").get_pos().y + (medidor_size.y / 2) - 15
	var current_pos = get_node("indicador").get_pos()
	current_pos.y = medidor_min
	get_node("indicador").set_pos(current_pos)

func increase():
	var current_pos = get_node("indicador").get_pos()
	if (current_pos.y >= medidor_max):
		current_pos.y -= step_size
		get_node("indicador").set_pos(current_pos)
	
func decrease():
	var current_pos = get_node("indicador").get_pos()
	if (current_pos.y <= medidor_min):
		current_pos.y += step_size
		get_node("indicador").set_pos(current_pos)
		
func start_fall_game(letter):
	get_node("alerts").show()
	get_node("alerts").get_node("player").play(letter)

func end_fall_game():
	get_node("alerts").hide()
	get_node("alerts").get_node("player").stop_all()
	


