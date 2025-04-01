extends Control

@onready var c = $".."

func ai():
	
	c.add_unit_left("top")
	c.add_unit_left("top")
	c.damage_from_top_to_bottom("left")
	c.damage_from_top_to_bottom("left")





# Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
