extends Control

@onready var m = $Code
#var Ai = AiAi.new()

var counter_bottom_left = -1
var counter_bottom_right = -1
var counter_top_left = -1
var counter_top_right = -1


var counter_top_left_removed = 0
var counter_top_right_removed = 0


var one_unit_damage = 1


var array_lattice_bottom_left = []
var array_lattice_bottom_right = []
var columns_in_lattice = 5
var rows_in_lattice = 5



var play_animation = false
var end_position = null
var direction_step = null
var duration = 5
var animation_object = null
var time_iterator = 0


var play_animation_multiple = false
var objects_animation_multiple = []
var end_position_2
var start_position_2
var duration_2 = 17


var joystick = false
var start_mouse_position
var end_mouse_position
var joystick_angle
@onready var line = $"../Node2D/Line2D"


var who_move = "player"
var move_counter = -2
var actions_in_one_move = 4
var move_name = 'add'


@export var health_top : int = 100 
@export var health_bottom : int = 100
@onready var health_top_label = $"../Node3D/AreaObjects/BaseTop/HealthLabel"
@onready var health_bottom_label = $"../Node3D/AreaObjects/BaseBottom/HealthLabel"



@export var BaseTop : Node3D
@export var BaseBottom : Node3D


@export var offset_instance_left : Node3D
@export var offset_instance_right : Node3D



@export var active_selection_top_left: Node
@export var active_selection_top_right: Node
@export var active_selection_bottom_left: Node
@export var active_selection_bottom_right: Node
@onready var active_selection = active_selection_top_left



var mynode = preload("res://object_to_instance.tscn")
var mate = preload("res://Themes and Styles/actice_selection.tres")

#@onready var colour_changer_node = $"../Node3D/ActiveSelection/ColourChanger"

@export var colour_active : Color = Color("00e2db")
@export var colour_error : Color = Color("e65f51")

func update_labels(type):

	match type:
		"bottom":
			$"../Node3D/AreaObjects/MiddleLine/UnitsCounterBottomRight".text = str(counter_bottom_right + 1)
			$"../Node3D/AreaObjects/BaseTopUI/UnitsCounterAll/UnitsCounterLeftRemoved".text = str(counter_top_left_removed)
			$"../Node3D/AreaObjects/BaseTopUI/UnitsCounterAll/UnitsCounterRightRemoved".text = str(counter_top_right_removed)
		"top":
			$"../Node3D/AreaObjects/BaseTopUI/UnitsCounterAll".text = str(counter_top_right + counter_top_left + 2)
			$"../Node3D/AreaObjects/BaseTopUI/UnitsCounterLeft".text = str(counter_top_left + 1)
			$"../Node3D/AreaObjects/BaseTopUI/UnitsCounterLeft/UnitsCounterRight".text = str(counter_top_right + 1)	


func _ready() -> void:

	active_selection_bottom_left.hide()
	active_selection_bottom_right.hide()
	active_selection_top_left.hide()
	active_selection_top_right.hide()

	update_labels("top")
	update_labels("bottom")

	line.hide()
	health_top_label.text = str(health_top)
	
	var scale = 0.44
	
	for column in range(columns_in_lattice):
		for row in range(rows_in_lattice):
			array_lattice_bottom_left.append([   Vector3(column, 0, row ) * scale + offset_instance_left.position,     null])
			array_lattice_bottom_right.append([  Vector3(-column, 0, row ) * scale + offset_instance_right.position,    null])


func _input(event):

	if event is InputEventKey and event.pressed == true:

		match event.keycode:
			KEY_BACKSPACE:
				print("Shift")
			KEY_A:
				add_unit_left()
				end_move(1)
				update_labels("bottom")
			KEY_D:
				add_unit_right()
				end_move(1)
				update_labels("bottom")
			KEY_W:
				damage_bottom_right()
				end_move(damage_bottom_right())
				update_labels("bottom")
			KEY_S:
				damage_bottom_left()
				end_move(damage_bottom_right())
				update_labels("bottom")
				
				
func end_move(result_of_move):
	
	move_counter += result_of_move

	if (move_counter%actions_in_one_move) == 0:
		
		m.ai()

		update_labels("top")
		update_labels("bottom")
		 
				
func _on_button_2_pressed() -> void:

	end_move(actions_in_one_move - move_counter%actions_in_one_move)
	

func _on_button_down() -> void:
	
	start_mouse_position = get_global_mouse_position()
	line.points[0] = start_mouse_position
	line.show()
	joystick = true

	mate.border_color = colour_active

	if move_counter%actions_in_one_move <= 1:
		move_name = "add"
	else:
		move_name = "attack"
		


func _on_button_up() -> void:
	
	joystick = false
	line.hide()
	active_selection.hide()

	match move_name:

		"add":
			if 90 > joystick_angle and joystick_angle > 0:
				add_unit_right()
				end_move(1)
				
			elif 180 > joystick_angle and joystick_angle > 90:
				add_unit_left()
				end_move(1)

		"attack":

			if 90 > joystick_angle and joystick_angle > 0:
				end_move(damage_bottom_right())

			elif 180 > joystick_angle and joystick_angle > 90:
				end_move(damage_bottom_left())

	update_labels("top")
	update_labels("bottom")

	check_winner()
	
	



func _process(delta: float) -> void:
	
	if joystick:
		joystick_angle = start_mouse_position.angle_to_point(get_global_mouse_position())
		joystick_angle = rad_to_deg(joystick_angle) * -1

		line.points[1] = get_global_mouse_position()

		# var mouse_pos = get_viewport().get_mouse_position()
		# var cursor_pos_g = camera.project_position(mouse_pos, 10)

		# print(cursor_pos_g)

		match move_name:

			"add":

				if 90 > joystick_angle and joystick_angle > 0:
					active_selection.hide()
					active_selection_bottom_right.show()
					active_selection = active_selection_bottom_right

				elif 180 > joystick_angle and joystick_angle > 90:
					active_selection.hide()
					active_selection_bottom_left.show()
					active_selection = active_selection_bottom_left
					
				else:
					active_selection.hide()
					
			
			"attack":

				if 90 > joystick_angle and joystick_angle > 0:
					active_selection.hide()
					active_selection_top_right.show()
					active_selection = active_selection_top_right

					mate.border_color = colour_error if counter_bottom_right < 0 else colour_active

					# colour_changer_node.material_override.emission = colour_error if counter_bottom_right < 0 else colour_active
					# active_selection


				elif 180 > joystick_angle and joystick_angle > 90:
					active_selection.hide()
					active_selection_top_left.show()
					active_selection = active_selection_top_left
					
					mate.border_color = colour_error if counter_bottom_left < 0 else colour_active

					# colour_changer_node.material_override.emission = colour_error if counter_bottom_left < 0 else colour_active

				else:
					active_selection.hide()



		
	if play_animation:
		
		if time_iterator==duration:
			play_animation = false
		else:
			animation_object.position += direction_step
			time_iterator +=1

	if play_animation_multiple:

		var objects_to_erase = []

		for object in objects_animation_multiple:

			if object[2] == duration_2:
				objects_to_erase.append(object)
			else:
				object[0].position += object[1]
				object[2] += 1

		for object_to_erase in objects_to_erase:

			objects_animation_multiple.erase( object_to_erase )

			if object_to_erase[3] == "remove":
				remove_child(object_to_erase[0])
			
			if len(objects_animation_multiple) == 0:
				play_animation_multiple = false
			
	
			

func check_winner():
	
	if health_top == 0:
		print("You Win")
	elif health_bottom == 0:
		pass


func damage_from_bottom_to_top(side):

	match side:
		"left":
			if counter_top_left == -1:
				health_top -= one_unit_damage
				health_top_label.text = str(health_top)
			

		"left":
			if counter_top_right == -1:
				health_top -= one_unit_damage
				health_top_label.text = str(health_top)
			


func damage_from_top_to_bottom(side):

	if (counter_top_left == -1 and side == "left") or (counter_top_right == -1 and side == "right"):
		$"../AcceptDialog".popup_centered()
		return

	match side:
		"left":
			if counter_bottom_left == -1:
				health_bottom -= one_unit_damage
				health_bottom_label.text = str(health_bottom)
			else:
				remove_child(array_lattice_bottom_left[counter_bottom_left][1])
				counter_bottom_left -= 1
			
			counter_top_left -= 1

		"right":
			if counter_bottom_left == -1:
				health_bottom -= one_unit_damage
				health_bottom_label.text = str(health_bottom)
			else:
				remove_child(array_lattice_bottom_right[counter_bottom_right][1])
				counter_bottom_right -= 1

			counter_top_right -= 1


func add_unit_left(side = "bottom"):

	match side:
		"top":
			counter_top_left += 1
			counter_top_left_removed += 1
			
		"bottom":
	
			if counter_bottom_left+1<columns_in_lattice*rows_in_lattice and play_animation != true and play_animation_multiple != true:
						
				counter_bottom_left += 1
			
				var instance = mynode.instantiate()
			
				instance.position = BaseBottom.position
				
				add_child(instance)
				
				play_animation = true
				time_iterator = 0
				end_position = array_lattice_bottom_left[counter_bottom_left][0]
				animation_object = instance
				direction_step = (end_position-instance.position)/duration
				array_lattice_bottom_left[counter_bottom_left][1] = instance

func damage_bottom_left():

	var start_range
	
	if counter_bottom_left >= 0 and play_animation != true and play_animation_multiple != true:

		var end_range = (counter_bottom_left+1)%rows_in_lattice

		if end_range > 0:
			start_range = counter_bottom_left - end_range + 1
		else:
			start_range = counter_bottom_left - rows_in_lattice + 1

		play_animation_multiple = true

		var direction_step_3 = ( Vector3(array_lattice_bottom_left[start_range][0].x,  0, -10) - array_lattice_bottom_left[start_range][0] )/duration_2

		objects_animation_multiple.append( [array_lattice_bottom_left[start_range][1], direction_step_3, 0, "remove" ] ) 
		 
		for i in range(start_range, counter_bottom_left):

			array_lattice_bottom_left[i][1] = array_lattice_bottom_left[i+1][1]

			var direction_step_2 = (array_lattice_bottom_left[i][0] - array_lattice_bottom_left[i][1].position)/duration_2

			objects_animation_multiple.append( [array_lattice_bottom_left[i][1], direction_step_2, 0, "stay" ] ) 

		counter_bottom_left -= 1

		damage_from_bottom_to_top("left")

		return 1

	else:

		return 0




func add_unit_right(side = "bottom"):

	match side:
		"top":
			counter_top_right += 1
			counter_top_right_removed += 1

		"bottom":
	
			if counter_bottom_right+1<columns_in_lattice*rows_in_lattice and play_animation != true and play_animation_multiple != true:
						
				counter_bottom_right += 1
			
				var instance = mynode.instantiate()
			
				instance.position = BaseBottom.position
				
				add_child(instance)
				
				play_animation = true
				time_iterator = 0
				end_position = array_lattice_bottom_right[counter_bottom_right][0]
				animation_object = instance
				direction_step = (end_position-instance.position)/duration
				array_lattice_bottom_right[counter_bottom_right][1] = instance
		
		
	

func damage_bottom_right():
	
	var start_range
	
	if counter_bottom_right >= 0 and play_animation != true and play_animation_multiple != true:

		var end_range = (counter_bottom_right+1)%rows_in_lattice

		if end_range > 0:
			start_range = counter_bottom_right - end_range + 1
		else:
			start_range = counter_bottom_right - rows_in_lattice + 1

		play_animation_multiple = true

		var direction_step_3 = ( Vector3(array_lattice_bottom_right[start_range][0].x,  0, -10) - array_lattice_bottom_right[start_range][0] )/duration_2

		objects_animation_multiple.append( [array_lattice_bottom_right[start_range][1], direction_step_3, 0, "remove" ] ) 
		 
		for i in range(start_range, counter_bottom_right):

			array_lattice_bottom_right[i][1] = array_lattice_bottom_right[i+1][1]

			var direction_step_2 = (array_lattice_bottom_right[i][0] - array_lattice_bottom_right[i][1].position)/duration_2

			objects_animation_multiple.append( [array_lattice_bottom_right[i][1], direction_step_2, 0, "stay" ] ) 

		counter_bottom_right -= 1

		damage_from_bottom_to_top("left")

		return 1

	else:

		return 0
	


 #Replace with function body.
