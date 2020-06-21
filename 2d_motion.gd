extends KinematicBody2D

onready var root = get_tree().root
onready var interface = root.get_node("Game/GUILayer/Interface")
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

signal apple_collected
export(int) var apple = 0
var first_apple = true

signal gold_increased
export(int) var gold = 0

signal keys_tally_updated
signal missing_key
export(int) var keys = 0
signal master_key_obtained
export(bool) var master_key_available = false

export(int) var sword_damage_per_hit = 2

signal calling_whale
var is_on_beach = false

signal golden_pineapple_obtained
export(bool) var golden_pineapple_available = false

# Called when the node enters the scene tree for the first time.
func _ready():
    
    start_position = position
    
    emit_signal("keys_tally_updated", keys)
    emit_signal("gold_increased", gold)
    emit_signal("health_changed", health)
    emit_signal("apple_collected", apple)
    
    # for debugging only
    if master_key_available:
        obtain_master_key()
    if golden_pineapple_available:
        obtain_golden_pineapple()
    
    hotAirBalloonButton.connect("pressed", self, "_deactivate")
    playerButton.connect("pressed", self, "_activate")
    
    # the sword target is initially hidden, only revealed when the sword is
    # available and used.
    $Sprite/SwordTargetAxis.modulate.a = 0
    
    interface.connect("sword_pressed", self, "attack")
    
func _process(_delta):
    if modulate.a == 0:
        hide()

func play_flute():
    
    $Sprite.animation = "play_flute"
    
    active = false
    
    if is_on_beach:
        emit_signal("calling_whale")
        
    var prev_stream = $SoundEffects.stream
    $SoundEffects.stream = load("res://res/sounds/flute_theme.ogg")
    $SoundEffects.play()
    yield($SoundEffects, "finished")
    $SoundEffects.stream = prev_stream
    
    active = true
    
    
func attack():
    $Sprite/SwordTargetAxis.show()
    
    $Sprite/SwordTargetAxis/SwordTarget/AudioStreamPlayer.play()
    $SwordTween.interpolate_property($Sprite/SwordTargetAxis, "modulate:a", 1, 0, 1)
    $SwordTween.start()
    
    var hits = $Sprite/SwordTargetAxis/SwordTarget.get_overlapping_areas()

    for hit in hits:
        
        var node = hit.owner
        if node.get_parent().get_name() == "Monsters":
            # we've hit a monster!
            node.hit(sword_damage_per_hit)


        #emit_signal("sword_hit", body)
             
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
    
    if velocity == Vector2(0,0):
        $SoundEffects.stop()
        moving = false
        $Sprite.stop()
        $Sprite.frame = 1 # the second frame always correspond to the 'neutral' pose
        return

               
    moving = true
     
    if velocity.x > 0:
        $Sprite.animation = "walking_right"
        $Sprite/SwordTargetAxis.rotation = PI/2
    if velocity.x < 0:
        $Sprite.animation = "walking_left"
        $Sprite/SwordTargetAxis.rotation =  -PI/2
    if velocity.y < 0:
        $Sprite.animation = "walking_back"
        $Sprite/SwordTargetAxis.rotation = 0
    if velocity.y > 0:
        $Sprite.animation = "walking_face"
        $Sprite/SwordTargetAxis.rotation = PI

    $Sprite.play()
    if not $SoundEffects.playing:
        $SoundEffects.play()
        


    move_and_slide(velocity * speed * delta * 50)
    


func collect_key():
    keys += 1
    emit_signal("keys_tally_updated", keys)

func use_key():
    if keys >= 1:
        keys -= 1
        emit_signal("keys_tally_updated", keys)
        return true
    else:
        emit_signal("missing_key", "[center]You need a key to open this chest![/center]")
        return false

func has_master_key():
    if master_key_available:
        return true
    else:
        emit_signal("missing_key", "[center]This looks like an uncommonly large chest...\nYou need a special key to open it[/center]")
        return false

func obtain_master_key():
    master_key_available = true
    emit_signal("master_key_obtained")

func obtain_golden_pineapple():
    golden_pineapple_available = true
    emit_signal("golden_pineapple_obtained")

func collect_gold(nb_gold=1):
    gold += nb_gold
    emit_signal("gold_increased", gold)

func pay_out(cost):
    gold -= cost
    emit_signal("gold_increased", gold)

func apple_changed(nb_apple=1):
    apple += nb_apple
    if apple < 0:
        apple = 0
        
    if first_apple:
        first_apple = false
        interface.on_msg("[center] You've picked up an apple!\nClick on the icon to eat it and regain some energy.[/center]",2)
    emit_signal("apple_collected", apple)



func health_change(delta):
    
    if not visible:
        return
        
    health += delta
    
    if health <= 0:
        moving = false # important to make sure the 'death' msg is not overwritten by 'you are entering Pine Village'
        position = start_position
        yield(root.get_node("Game/background/PineVillage"), "body_entered")
        health = 75
        pay_out(15)
        emit_signal("dead")
    
    if health > 100:
        health = 100
        
    emit_signal("health_changed", health)

func _on_path_entered(_body):
    speed = base_speed * 1.5
    $SoundEffects.stream = load("res://res/sounds/steps-dirt.ogg")


func _on_path_exited(_body):
    speed = base_speed
    $SoundEffects.stream = load("res://res/sounds/steps-grass.ogg")

func _on_zone_entered(body, zone):
    if body.get_name() == "Player":
        print("Player enters " + zone)
        if zone == "Deep forest":
            $BackgroundMusic.stream = load("res://res/sounds/bird-singing3.ogg")
            $BackgroundMusic.play()

func _on_zone_exited(_body, _zone):
    $BackgroundMusic.stop()




func _on_Beach_body_entered(_body):
    is_on_beach = true


func _on_Beach_body_exited(_body):
    is_on_beach = false
