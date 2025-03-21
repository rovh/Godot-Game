extends CSGSphere3D

#@export var unit: Node

#var mynode = preload("res://node_3d_2.tscn")

#func _input(event):
   ## Mouse in viewport coordinates.
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			#print("Mouse Click/Unclick at: ", event.position.normalized())


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	#for i in range(10):
	#
		#var instance = mynode.instantiate()
		#
		#instance.position = Vector3(i,0,i) * 0.2
		#
		#print(instance.position)
		#
		#add_child(instance)
		
		pass # Replace with function body.
		

#func _on_button_pressed(event) -> void:
	#var ButtonIsPressed = true
	#
	#pass # Replace with function body.


 #Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#var viewport := get_viewport()
		#var mouse_position := viewport.get_mouse_position()
		##var camera := viewport.get_camera_3d()
		#print(get_viewport().get_mouse_position().normalized())
	#pass
	#if Input.is_action_pressed("clicker"):
		
#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed('mb'):
		#print(get_viewport().get_global_mouse_position())
	#pass
	
	
	
