extends Node

var GridElement = load("res://src/GridElement.tscn")

signal display_answer

export var cols = 12
export var rows = 1
export var width = 600
export var height = 600
export var MAX_ROWS = 20
var rect = Rect2(0,0,width,height)

enum opType {NONE, DOUBLE,ADD_ROW, FIVE_ROWS, TEN_ROWS}

var final_ans
var final_rows

var green_dot = load("res://assets/GreenDot.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	make_grid()

# Functions responsible for drawing the grid.
func make_grid():
	# This is the code for the total grid
	for i in range(1,rows+1):
		#i*height/(rows+1) gives an equal spacing between rows
		make_row_at_ypos(rect.position.y - height/2 + i*height/(rows+1))

func make_row_at_ypos(y):
	for i in range(1,cols+1):
		var ele = GridElement.instance() 
		add_child(ele)
		#i*width/(cols+1) gives an equal spacing between cols
		ele.position.x = rect.position.x - width/2 + i*width/(cols+1)
		ele.position.y = y
		while(too_big(ele)):
			ele.scale.x *= 0.95
			ele.scale.y *= 0.95
# returns true iff the grid has too many rows and the GridElemnets overlap.
# Used in make_row_at_ypos(y)
func too_big(ele):
	var ele_rect = ele.get_rect()
	if(ele_rect.size.x* ele.scale.x * cols > width -200 || ele_rect.size.y * ele.scale.y * rows > height - 100):
		return true
	else:
		return false


# Functions responsible for changing the grid
func double():
	if(rows * 2 <= MAX_ROWS):
		rows *= 2
		clear_children()
		make_grid()
	else:
		print("Grid can't go bigger than ",MAX_ROWS," rows")
		
func add_row():
	if(rows + 1 <= MAX_ROWS):
		rows += 1
		clear_children()
		make_grid()
	else:
		print("Grid can't go bigger than ",MAX_ROWS," rows")

func ten_rows():
	rows = 10
	clear_children()
	make_grid()

func five_rows():
	rows = 5
	clear_children()
	make_grid()

func reset():
	rows = 1
	clear_children()
	make_grid()

func clear_children():
	for n in get_children():
		remove_child(n)
		n.queue_free()


#Signal Functions
func _on_HUD_answer_given(operation, answer):
	var correct_ans
	
	if(operation == opType.DOUBLE):
		correct_ans = 2*cols*rows
		if( answer == correct_ans):
			double()
			
	if(operation == opType.ADD_ROW):
		correct_ans = rows*cols + cols #cols is the size of a row
		if( answer == correct_ans):
			add_row()
	
	if(operation == opType.FIVE_ROWS):
		correct_ans = cols*5 #cols is the size of a row
		if( answer == correct_ans):
			five_rows()
			
	if(operation == opType.TEN_ROWS):
		correct_ans = 10*cols #cols is the size of a row
		if( answer == correct_ans):
			ten_rows()
	
	if(answer == final_ans):
		emit_signal("display_answer")
		rows = final_rows
		clear_children()
		make_grid()
		for gridelement in get_children():
			gridelement.texture = green_dot
		



func _on_HUD_reset():
	reset()

func _on_QuestionGen_display_question(i,j,ans):
	cols = j
	final_ans = ans
	final_rows = i
	reset()
