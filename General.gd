extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_camera_limits():

    var size = $background.get_rect().end * scale
    
    $Items/Player/Camera2D.limit_left = 0
    $Items/Player/Camera2D.limit_right = size.x
    $Items/Player/Camera2D.limit_top = 0
    $Items/Player/Camera2D.limit_bottom = size.y
    
    $Items/HotAirBalloon/Camera2D.limit_left = 0
    $Items/HotAirBalloon/Camera2D.limit_right = size.x
    $Items/HotAirBalloon/Camera2D.limit_top = 0
    $Items/HotAirBalloon/Camera2D.limit_bottom = size.y
    
    # start with the Player's camera
    $Items/Player/Camera2D.make_current()
    
  
# Called when the node enters the scene tree for the first time.
func _ready():
    set_camera_limits()
    
    $DialoguesLayer/Dialogues.hide()
    
    $background/DeepForest.connect("body_entered", $Items/Player, "_on_zone_entered", ["Deep forest"])
    
func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.scancode == KEY_ESCAPE:
            get_tree().quit()

func _on_Character_body_entered(body):
    pass # Replace with function body.


func _on_Character_body_exited(body):
    pass # Replace with function body.
