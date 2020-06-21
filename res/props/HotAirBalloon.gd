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
    
    var interface = root.get_node("Game/GUILayer/Interface")
    
    interface.connect("up", self, "_on_up")
    interface.connect("down", self, "_on_down")
    interface.connect("left", self, "_on_left")
    interface.connect("right", self, "_on_right")
    interface.connect("direction_btns_released", self, "_on_release_direction_btns")
    
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
    velocity = velocity.normalized()

func _on_right():
    velocity.x = 1
    velocity = velocity.normalized()

func _on_left():
    velocity.x = -1
    velocity = velocity.normalized()

func _on_up():
    velocity.y = -1
    velocity = velocity.normalized()

func _on_down():
    velocity.y = 1
    velocity = velocity.normalized()

func _on_release_direction_btns():
    velocity = Vector2()
    
    
func _physics_process(delta):
    
    if not active:
        return
    
    if OS.get_name() != "Android":
        get_input()
    

    move_and_slide(velocity * speed * delta * 50)

