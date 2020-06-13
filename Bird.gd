extends "res://bunnies.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    speed_factor = 0.2
    spawn_rect_top_left = Vector2(380,760)
    spawn_rect_bottom_right = Vector2(2000, 880)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
