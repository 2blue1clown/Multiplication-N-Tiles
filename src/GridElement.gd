extends Sprite

var black_dot = load("res://assets/BlackDot.png")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():


	print("start")
	yield(get_tree().create_timer(1.0), "timeout")
	texture = black_dot
	print("end")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
