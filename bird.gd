
extends AnimatedSprite

var direction = 1
var velocity = Vector2()
const FLY_SPEED = 200

func _ready():
	set_fixed_process(true)
	get_node("player").play("vuelo")

func _fixed_process(delta):
	var pos = self.get_pos()
	if (((pos.x < -40) and direction == -1) or ((pos.x > 680) and direction == 1)):
		direction = direction * -1 
	pos.x += direction * delta * FLY_SPEED
	self.set_pos(pos)
	
	
