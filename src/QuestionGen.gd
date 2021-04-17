extends Node

signal display_question(mult1, mult2, ans)
signal cannot_remove(mult)

# Declare member variables here. Examples:
enum Mult {ADD,REMOVE,SAME}

var rng = RandomNumberGenerator.new()
var multlst1 = []
var multlst2 = [1,2,3,4,5,6,7,8,9,10,11,12]

# Called when the node enters the scene tree for the first time.
func _ready():
	new_question()

func new_question():
	rng.randomize()
	var index1 = rng.randi_range(0,multlst1.size()-1)
	var index2 = rng.randi_range(0,12-1) #randi_range is inclusive
	send_out(multlst1[index1],multlst2[index2])

func send_out( multiplicand1:int, multiplicand2:int):
	var ans = multiplicand1 * multiplicand2
	emit_signal("display_question",multiplicand1,multiplicand2,ans)

func remove_mult(n):
	if(multlst1.size() == 1):
		emit_signal("cannot_remove",n)
	else:
		var index = multlst1.find(n)
		multlst1.remove(index)

func add_mult(n):
	multlst1.append(n)

func _on_HUD_change_questions(add_or_remove, mult):
	if (add_or_remove == Mult.REMOVE):
		remove_mult(mult)
	elif(add_or_remove == Mult.ADD):
		add_mult(mult)
	new_question()



func _on_HUD_starting_questions(multlst):
	multlst1 = multlst
