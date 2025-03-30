extends Control

var counter_bottom_left = -1
var counter_bottom_right = -1
var lattice_array_left = []
var lattice_array_right = []
var columns_in_lattice = 5
var rows_in_lattice = 5


var counter_top_left = -1
var counter_top_right = -1


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
var duration_2 = 15


var joystick = false
var start_mouse_position
var end_mouse_position
var joystick_angle

var move_counter = 0
var actions_in_one_move = 4
var move_name = 'add'


@export var health_top : int = 100 
@export var health_bottom : int = 100 


var vector_to_hide = Vector3(0, -2, 0)


@export var BaseBottom : Node3D

@export var offset_object_left : Node3D
@export var offset_object_right : Node3D

@export var active_selection_object : Node3D
@export var active_selection_object_left_bottom: Node3D
@export var active_selection_object_left_top: Node3D
@export var active_selection_object_right_bottom: Node3D
@export var active_selection_object_right_top: Node3D


var mynode = preload("res://object_to_instance.tscn")

@onready var colour_changer_node = $"../Node3D/ActiveSelection/ColourChanger"

var colour_red = Color.from_hsv(0, 1, 1, 1)
var colour_white = Color.from_hsv(0, 0, 1, 1)


func _ready() -> void:
	var scale = 0.44
	
	for column in range(columns_in_lattice):
		for row in range(rows_in_lattice):
			lattice_array_left.append([   Vector3(column, 0, row ) * scale + offset_object_left.position,     null])
			lattice_array_right.append([  Vector3(-column, 0, row ) * scale + offset_object_right.position,    null])

func _input(event):

	if event is InputEventKey and event.pressed == true:

		match event.keycode:
			KEY_BACKSPACE:
				print("Shift")
			KEY_A:
				add_unit_left()
			KEY_D:
				add_unit_right()
			KEY_W:
				del_unit_right()
			KEY_S:
				del_unit_left()
				
				
func end_move(result_of_move):
	
	move_counter += result_of_move
	
	active_selection_object.position = vector_to_hide
	
	
				
func _on_button_2_pressed() -> void:
	
	move_counter += actions_in_one_move - move_counter%actions_in_one_move

func _on_button_down() -> void:
	
	start_mouse_position = get_global_mouse_position()
	joystick = true

	colour_changer_node.material_override.emission = colour_white

	if move_counter%actions_in_one_move >= 2:
		move_name = "attack"
	else:
		move_name = "add"
		

func _on_button_up() -> void:
	
	joystick = false

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
				end_move(del_unit_right())

			elif 180 > joystick_angle and joystick_angle > 90:
				end_move(del_unit_left())

	check_winner()

	



func _process(delta: float) -> void:
	
	if joystick:
		joystick_angle = start_mouse_position.angle_to_point(get_global_mouse_position())
		joystick_angle = rad_to_deg(joystick_angle) * -1

		# var mouse_pos = get_viewport().get_mouse_position()
		# var cursor_pos_g = camera.project_position(mouse_pos, 10)

		# print(cursor_pos_g)

		match move_name:

			"add":

				if 90 > joystick_angle and joystick_angle > 0:
					active_selection_object.position = active_selection_object_right_bottom.global_position

				elif 180 > joystick_angle and joystick_angle > 90:
					active_selection_object.position = active_selection_object_left_bottom.global_position
					
				else:
					active_selection_object.position = vector_to_hide
					
			
			"attack":

				if 90 > joystick_angle and joystick_angle > 0:
					active_selection_object.position = active_selection_object_right_top.global_position

					colour_changer_node.material_override.emission = colour_red if counter_bottom_right < 0 else colour_white


				elif 180 > joystick_angle and joystick_angle > 90:
					active_selection_object.position = active_selection_object_left_top.global_position

					colour_changer_node.material_override.emission = colour_red if counter_bottom_left < 0 else colour_white

				else:
					active_selection_object.position = vector_to_hide



		
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
		pass
	elif health_bottom == 0:
		pass


func add_unit_left():
	
	if counter_bottom_left+1<columns_in_lattice*rows_in_lattice and play_animation != true and play_animation_multiple != true:
				
		counter_bottom_left += 1
	
		var instance = mynode.instantiate()
	
		instance.position = BaseBottom.position
		
		add_child(instance)
		
		play_animation = true
		time_iterator = 0
		end_position = lattice_array_left[counter_bottom_left][0]
		animation_object = instance
		direction_step = (end_position-instance.position)/duration
		lattice_array_left[counter_bottom_left][1] = instance

func del_unit_left():

	var start_range
	
	if counter_bottom_left >= 0 and play_animation != true and play_animation_multiple != true:

		var end_range = (counter_bottom_left+1)%rows_in_lattice

		if end_range > 0:
			start_range = counter_bottom_left - end_range + 1
		else:
			start_range = counter_bottom_left - rows_in_lattice + 1

		play_animation_multiple = true

		var direction_step_3 = ( Vector3(0,0,-5) - lattice_array_left[start_range][0] )/duration_2

		objects_animation_multiple.append( [lattice_array_left[start_range][1], direction_step_3, 0, "remove" ] ) 
		 
		for i in range(start_range, counter_bottom_left):

			lattice_array_left[i][1] = lattice_array_left[i+1][1]

			var direction_step_2 = (lattice_array_left[i][0] - lattice_array_left[i][1].position)/duration_2

			objects_animation_multiple.append( [lattice_array_left[i][1], direction_step_2, 0, "stay" ] ) 

		counter_bottom_left -= 1

		return 1

	else:

		return 0




func add_unit_right():
	
	if counter_bottom_right+1<columns_in_lattice*rows_in_lattice and play_animation != true and play_animation_multiple != true:
				
		counter_bottom_right += 1
	
		var instance = mynode.instantiate()
	
		instance.position = BaseBottom.position
		
		add_child(instance)
		
		play_animation = true
		time_iterator = 0
		end_position = lattice_array_right[counter_bottom_right][0]
		animation_object = instance
		direction_step = (end_position-instance.position)/duration
		lattice_array_right[counter_bottom_right][1] = instance
	

func del_unit_right():
	
	var start_range
	
	if counter_bottom_right >= 0 and play_animation != true and play_animation_multiple != true:

		var end_range = (counter_bottom_right+1)%rows_in_lattice

		if end_range > 0:
			start_range = counter_bottom_right - end_range + 1
		else:
			start_range = counter_bottom_right - rows_in_lattice + 1

		play_animation_multiple = true

		var direction_step_3 = ( Vector3(0,0,-5) - lattice_array_right[start_range][0] )/duration_2

		objects_animation_multiple.append( [lattice_array_right[start_range][1], direction_step_3, 0, "remove" ] ) 
		 
		for i in range(start_range, counter_bottom_right):

			lattice_array_right[i][1] = lattice_array_right[i+1][1]

			var direction_step_2 = (lattice_array_right[i][0] - lattice_array_right[i][1].position)/duration_2

			objects_animation_multiple.append( [lattice_array_right[i][1], direction_step_2, 0, "stay" ] ) 

		counter_bottom_right -= 1

		return 1

	else:

		return 0
	


 #Replace with function body.
