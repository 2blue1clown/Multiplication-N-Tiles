extends CanvasLayer

signal answer_given(operation, answer)
signal change_questions(add_or_remove,mult)
signal reset
signal starting_questions(multlst)

# Declare member variables here.
# These enums NEED to match those in the HUD
enum buttonType {NONE,DOUBLE,ADD_ROW, FIVE_ROWS, TEN_ROWS}
var buttonPressed
enum Mult {ADD,REMOVE,SAME}

var q_str
var q_ans

var starting_multlst = []

func _ready():
	var tmp : String
	for button in get_node("VBoxContainer2").get_children():
		if(button.pressed == true):
			tmp = button.text
			tmp = tmp.replace('x','')
			starting_multlst.append(int(tmp))
	
	emit_signal("starting_questions",starting_multlst)
		


func _on_DoubleButton_pressed():
	buttonPressed = buttonType.DOUBLE
	get_node("VBoxContainer/AnswerBox").grab_focus()

func _on_AddRowButton_pressed():
	buttonPressed = buttonType.ADD_ROW
	get_node("VBoxContainer/AnswerBox").grab_focus()

func _on_FiveRowsButton_pressed():
	buttonPressed = buttonType.FIVE_ROWS
	get_node("VBoxContainer/AnswerBox").grab_focus()

func _on_TenRowsButton_pressed():
	buttonPressed = buttonType.TEN_ROWS
	get_node("VBoxContainer/AnswerBox").grab_focus()

func _on_ResetButton_pressed():
	emit_signal("reset")
	buttons_up()
	
func buttons_up():
	#this is just some code to make it so that after the answer is entered
	#the buttons are all false again. 
	for op_button in get_tree().get_nodes_in_group("operation_buttongroup"):
		op_button.pressed = false
	
	
func _on_AnswerBox_text_entered(new_text):
	
	var answer = int(new_text)
	emit_signal("answer_given",buttonPressed,answer)
	get_node("VBoxContainer/AnswerBox").clear()
	get_node("VBoxContainer/AnswerBox").release_focus()
	buttons_up()
	

func _on_QuestionGen_display_question(i ,j , ans):
	q_str = "" + str(i) + " x " + str(j)
	q_ans = ans
	get_node("Message").text = q_str
	get_node("NextQuestionButton").visible = false
	get_node("VBoxContainer").visible = true

func send_toggle_signal(button_pressed, mult):
	if(button_pressed == true):
		emit_signal("change_questions",Mult.ADD,mult)
	if(button_pressed == false):
		emit_signal("change_questions",Mult.REMOVE,mult)
		

func _on_x1CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,1)

func _on_x2CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed, 2)

func _on_x3CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,3)

func _on_x4CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,4)

func _on_x5CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,5)

func _on_x6CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,6)

func _on_x7CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,7)

func _on_x8CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,8)

func _on_x9CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,9)

func _on_x10CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,10)

func _on_x11CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,11)

func _on_x12CheckBox_toggled(button_pressed):
	send_toggle_signal(button_pressed,12)



#Occurs when there is only one box checked and a remove is attemped
func _on_QuestionGen_cannot_remove(mult):
	var node_path = "VBoxContainer2/x" + str(mult) +"CheckBox"
	get_node(node_path).pressed = true
	send_toggle_signal(false,mult)


func _on_NextQuestionButton_pressed():
	emit_signal("change_questions",Mult.SAME,0)


func _on_Grid_display_answer():
	get_node("Message").text = q_str + " = " + str(q_ans)
	get_node("NextQuestionButton").visible = true
	get_node("VBoxContainer").visible = false
	
