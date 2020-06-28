extends Node2D

# the languages need to appear in the same order as the columns in translations.csv
enum Languages {ENGLISH, FRENCH, NORVEGIAN}

const CURRENT_LANGUAGE = Languages.ENGLISH

var strings_file
var strings = {}

func _init():
    #strings_file = File.new()
    pass
  
  
# Called when the node enters the scene tree for the first time.
func _ready():
    set_camera_limits()
    
    $AudioStreamPlayer.play()
    
    $DialoguesLayer/Dialogues.hide()
    
    $background/DeepForest.connect("body_entered", $Items/Player, "_on_zone_entered", ["Deep forest"])
    
        
    #strings_file.open("res://chronicles_purdownia_translations.csv", File.READ)
    #
    #while not strings_file.eof_reached():
    #    var line = strings_file.get_csv_line()
    #    if line.size() > 1:
    #        strings[line[0]] = Array(line).slice(1, line.size())
    #
    #strings_file.close()
    
func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.scancode == KEY_ESCAPE:
            get_tree().quit()

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
  

func translate(text):
    
    
    if CURRENT_LANGUAGE == Languages.ENGLISH:
        return text
    
    var idx : int = CURRENT_LANGUAGE - 1
    
    if strings.has(text) and strings[text].size() > idx + 1 and strings[text][idx] != "":
        return strings[text][CURRENT_LANGUAGE]
    else:
        #print("[MISSING STRING FOR " + Languages.keys()[CURRENT_LANGUAGE] + "] " + text)
        return text
        
    
func _on_Character_body_entered(_body):
    pass # Replace with function body.


func _on_Character_body_exited(_body):
    pass # Replace with function body.
