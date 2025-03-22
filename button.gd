extends Button

var counter = -1
var array = []
var columns = 5
var rows = 5


var play_animation = false
var end_position = null
var direction_step = null
var duration = 10
var animation_object = null
var time_iterator = 0

@onready var BorderBottom = $"../../Node3D/AreaObjects/Borders/BorderBottom"

var mynode = preload("res://object_to_instance.tscn")
# Called when the node enters the scene tree for the first time_iterator.
func _ready() -> void:
	var mynode2 = $"../../Node3D/ObjectToInstance"
	var offset = $"../../Node3D/AreaObjects/InstanceEmptyOffset".position
	var scale = 0.44
	
	for column in range(columns):
		for row in range(rows):
			var position_for_array = Vector3(column, 0, row ) * scale + offset
			array.append([position_for_array, null])
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			
			#var position_mouse = get_viewport().get_mouse_position()
			#var position_3d = get_viewport().get_camera_3d().project_position(position_mouse, 0)
			#position_3d.y = 0
			#print("Mouse Click/Unclick at: ", position_3d)
			
			if counter+1<columns*rows and play_animation != true:
				
				counter += 1
			
				var instance = mynode.instantiate()
			
				instance.position = BorderBottom.position
				
				add_child(instance)
				
				play_animation = true
				time_iterator = 0
				end_position = array[counter][0]
				animation_object = instance
				direction_step = (end_position-instance.position)/duration
				array[counter][1] = instance
				
				
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed == true:
			
			if counter >= 0 and play_animation != true:
				
				remove_child(array[counter][1])
				
				counter -= 1
				

# Called every frame. 'delta' is the elapsed time_iterator since the previous frame.
func _process(delta: float) -> void:

	if play_animation:
		
		if time_iterator==duration:
			play_animation = false
		else:
			animation_object.position += direction_step
			
			time_iterator +=1
		 
