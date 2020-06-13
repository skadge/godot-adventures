extends Control

onready var root = get_tree().root
onready var player  = root.get_node("Game/Items/Player")

signal up
signal down
signal left
signal right
signal direction_btns_released

signal sword_pressed

func _on_btn_up():
    emit_signal("up")
func _on_btn_down():
    emit_signal("down")
func _on_btn_right():
    emit_signal("right")
func _on_btn_left():
    emit_signal("left")
func _on_btn_released():
    emit_signal("direction_btns_released")
    
# Called when the node enters the scene tree for the first time.
func _ready():
    
    if OS.get_name() == "Android":
        $DirectionButtons.show()
        
        # Forwarding of the direction buttons signals
        $DirectionButtons/VBoxContainer/LeftBtn.connect("button_down", self, "_on_btn_left")
        $DirectionButtons/VBoxContainer/LeftBtn.connect("button_up", self, "_on_btn_released")
        $DirectionButtons/VBoxContainer3/RightBtn.connect("button_down", self, "_on_btn_right")
        $DirectionButtons/VBoxContainer3/RightBtn.connect("button_up", self, "_on_btn_released")
        $DirectionButtons/VBoxContainer2/UpBtn.connect("button_down", self, "_on_btn_up")
        $DirectionButtons/VBoxContainer2/UpBtn.connect("button_up", self, "_on_btn_released")
        $DirectionButtons/VBoxContainer2/DownBtn.connect("button_down", self, "_on_btn_down")
        $DirectionButtons/VBoxContainer2/DownBtn.connect("button_up", self, "_on_btn_released")
    else:
        $DirectionButtons.hide()
        
    $Inventory.hide()
    $Inventory/HBox/HotAirBalloonButton.hide()
    $Inventory/HBox/PlayerButton.hide()
    $Inventory/HBox/SwordButton.hide()
    
    $MainMsg.modulate.a = 0
    
    #_on_HotAirBalloonAvailable()
    _on_SwordAvailable()
    

func resize_inventory_bg():
    $Inventory.rect_size.x = $Inventory/HBox.rect_size.x + 60

func _on_Player_keys_tally_updated(keys):
    $KeyCounter/Label.text = str(keys)
    
func _on_Player_gold_increased(gold):
    $GoldCounter/Label.text = str(gold)

func _on_Player_health_changed(health):
    $HealthCounter/Label.text = str(health)
    
func _on_HotAirBalloonAvailable():
    
    if not $Inventory.visible:
        $Inventory.show()
    
    $Inventory/HBox/HotAirBalloonButton.show()
    
    resize_inventory_bg()

func _on_SwordAvailable():
    
    if not $Inventory.visible:
        $Inventory.show()
    
    $Inventory/HBox/SwordButton.show()

    resize_inventory_bg()


func _on_PlayerButton_pressed():
    $Inventory/HBox/PlayerButton.hide()
    $Inventory/HBox/HotAirBalloonButton.show()


func _on_HotAirBalloonButton_pressed():
    $Inventory/HBox/HotAirBalloonButton.hide()
    $Inventory/HBox/PlayerButton.show()

func _on_SwordButton_pressed():
    emit_signal("sword_pressed")

func _on_zone_exited(body, zone):
    if body.get_name() == "Player" and player.moving:
        $MainMsg/Label.bbcode_text = "\n[center]You are leaving " + zone +  "[/center]"
        $AnimationPlayer.playback_speed = 1
        $AnimationPlayer.play("DisplayMainMsg")
        
func _on_zone_entered(body, zone):
    if body.get_name() == "Player" and player.moving:
        $MainMsg/Label.bbcode_text = "\n[center]You are entering " + zone +  "[/center]"
        $AnimationPlayer.playback_speed = 1
        $AnimationPlayer.play("DisplayMainMsg")

func _on_death():
        $MainMsg/Label.bbcode_text = "[center][color=red][wave amp=50 freq=2]You fainted![/wave][/color][/center]\nThe Village elder took you back to the village, but you've lost your gold."
        $AnimationPlayer.playback_speed = 0.5
        $AnimationPlayer.play("DisplayMainMsg")

func on_msg(msg):
        $MainMsg/Label.bbcode_text = msg
        $AnimationPlayer.playback_speed = 1
        $AnimationPlayer.play("DisplayMainMsg")

