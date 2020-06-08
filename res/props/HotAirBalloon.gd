extends KinematicBody2D

onready var root = get_tree().root
onready var hotAirBalloonButton  = root.get_node("Game/GUILayer/Interface/Inventory/HBox/HotAirBalloonButton")
onready var playerButton  = root.get_node("Game/GUILayer/Interface/Inventory/HBox/PlayerButton")


export (int) var base_speed = 500

var speed = base_speed

var velocity = Vector2()


var active = false
var idling = true

# Called when the node enters the scene tree for the first time.
func _ready():
    hotAirBalloonButton.connect("pressed", self, "_activate")
    playerButton.connect("pressed", self, "_deactivate")
    

func _activate():
    
    position = root.get_node("Game/Items/Player").position + Vector2(0, 64)
    active = true
    
    self.show()
    $Camera2D.make_current()

    var tween = root.get_node("Game/Tween")
    tween.interpolate_property(self, "modulate:a",
    0, 1, 1,
    Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()
    
    
func _deactivate():
    
    active = false
    
    var tween = root.get_node("Game/Tween")
    tween.interpolate_property(self, "modulate:a",
    1, 0, 1,
    Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()
    
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    if modulate.a == 0:
        hide()
        
    if idling:
        $Path2D/PathFollow2D.unit_offset += delta/10


    
func get_input():
    velocity = Vector2()
    if Input.is_action_pressed('right'):
        velocity.x += 1
    if Input.is_action_pressed('left'):
        velocity.x -= 1
    if Input.is_action_pressed('down'):
        velocity.y += 1
    if Input.is_action_pressed('up'):
        velocity.y -= 1
    velocity = velocity.normalized() * speed


func _physics_process(delta):
    
    if not active:
        return
        
    get_input()

    velocity = move_and_slide(velocity)

