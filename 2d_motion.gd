extends KinematicBody2D

onready var root = get_tree().root
onready var hotAirBalloonButton  = root.get_node("Game/GUILayer/Interface/Inventory/HBox/HotAirBalloonButton")
onready var playerButton  = root.get_node("Game/GUILayer/Interface/Inventory/HBox/PlayerButton")

var start_position

export (int) var base_speed = 200
var speed = base_speed

var velocity = Vector2()

var active = true
var moving = false

signal health_changed
signal dead
export(int) var health = 100

signal gold_increased
export(int) var gold = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    
    start_position = position
    
    emit_signal("gold_increased", gold)
    emit_signal("health_changed", health)
    
    hotAirBalloonButton.connect("pressed", self, "_deactivate")
    playerButton.connect("pressed", self, "_activate")
    
func _process(delta):
    if modulate.a == 0:
        hide()
        
func _activate():
    
    
    position = root.get_node("Game/Items/HotAirBalloon").position - Vector2(0,64)
    
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
    
    if velocity == Vector2(0,0):
        moving = false
        return
    
    moving = true
        
    var sprite = $Sprite
    if velocity.x > 0:
        sprite.texture = load("res://res/characters/character1_maud_small_right.png")
    if velocity.x < 0:
        sprite.texture = load("res://res/characters/character1_maud_small_left.png")
    if velocity.y < 0:
        sprite.texture = load("res://res/characters/character1_maud_small_back.png")
    if velocity.y > 0:
        sprite.texture = load("res://res/characters/character1_maud_small_face.png")

    velocity = move_and_slide(velocity)


func collect_gold():
    gold += 1
    emit_signal("gold_increased", gold)

func pay_out(cost):
    gold -= cost
    emit_signal("gold_increased", gold)

func health_change(delta):
    
    if not visible:
        return
        
    health += delta
    
    if health <= 0:
        moving = false # important to make sure the 'death' msg is not overwritten by 'you are entering Pine Village'
        position = start_position
        health = 75
        pay_out(gold)
        emit_signal("dead")
    
    if health > 100:
        health = 100
        
    emit_signal("health_changed", health)

func _on_path_entered(body):
    speed = base_speed * 1.5


func _on_path_exited(body):
    speed = base_speed
