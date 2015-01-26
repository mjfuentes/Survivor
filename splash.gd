
extends Sprite

var total_to_move
const speed = 420
var total_moved = 0
func _ready():
	total_to_move = get_texture().get_size().y
	
func hide_splash():
	set_process(true)

func _process(delta):
	var current_pos = get_pos()
	current_pos.y = current_pos.y + (speed * delta)
	set_pos(current_pos)
	total_moved += speed * delta
	if (total_moved >= total_to_move):
		set_process(false)
		kill()


func kill():
	hide()
	get_parent().start_game()
	


