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
        $DirectionButtons/LeftBtn.connect("button_down", self, "_on_btn_left")
        $DirectionButtons/LeftBtn.connect("button_up", self, "_on_btn_released")
        $DirectionButtons/RightBtn.connect("button_down", self, "_on_btn_right")
        $DirectionButtons/RightBtn.connect("button_up", self, "_on_btn_released")
        $DirectionButtons/UpBtn.connect("button_down", self, "_on_btn_up")
        $DirectionButtons/UpBtn.connect("button_up", self, "_on_btn_released")
        $DirectionButtons/DownBtn.connect("button_down", self, "_on_btn_down")
        $DirectionButtons/DownBtn.connect("button_up", self, "_on_btn_released")
    else:
        $DirectionButtons.hide()
        
    $Inventory.hide()
    $Inventory/HBox/HotAirBalloonButton.hide()
    $Inventory/HBox/PlayerButton.hide()
    $Inventory/HBox/MasterKeyIcon.hide()
    $Inventory/HBox/GoldenPineappleIcon.hide()
    $SwordPanel.hide()
    
    $MainMsg.modulate.a = 0
    
    #_on_HotAirBalloonAvailable()
    #_on_SwordAvailable()
    #_on_fluteGiven()
    

func resize_inventory_bg():
    $Inventory.rect_size.x = $Inventory/HBox.rect_size.x + 60

func _on_Player_keys_tally_updated(keys):
    $KeyCounter/Label.text = str(keys)
    
func _on_Player_gold_increased(gold):
    $GoldCounter/Label.text = str(gold)


func _on_Player_apple_collected(apple):
    $AppleCounter/Label.text = str(apple)


func _on_Player_health_changed(health):
    $HealthCounter/Label.text = str(health)
    
func _on_HotAirBalloonAvailable():
    
    if not $Inventory.visible:
        $Inventory.show()
    
    $Inventory/HBox/HotAirBalloonButton.show()
    
    resize_inventory_bg()

func _on_SwordAvailable():
    
    $SwordPanel.show()


func _on_fluteGiven():
    
    on_msg("\n[center][color=blue][wave amp=50 freq=2]You receive a flute![/wave][/color]\n\nPress the icon to play a tune[/center]")
    if not $Inventory.visible:
        $Inventory.show()
        
    $Inventory/HBox/FluteButton.show()
    
    resize_inventory_bg()

func _on_masterKeyObtained():
    
    on_msg("\n[center][color=yellow][wave amp=50 freq=2]You obtain the master key![/wave][/color]\n[img]res://res/props/master_key.png[/img][/center]", 2)
    if not $Inventory.visible:
        $Inventory.show()
        
    $Inventory/HBox/MasterKeyIcon.show()
    
    resize_inventory_bg()

func _on_pineappleObtained():
    
    on_msg("\n[center][color=blue][wave amp=50 freq=2]The chest contains a golden pineapple![/wave][/color]\n[img]res://res/props/pineapple.png[/img][/center]", 3)
    if not $Inventory.visible:
        $Inventory.show()
        
    $Inventory/HBox/GoldenPineappleIcon.show()
    
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
        $MainMsg/Label.bbcode_text = "\n[center][color=red][wave amp=50 freq=2]You fainted![/wave][/color][/center]\nThe Village elder took you back to the village, but you've lost some gold."
        $AnimationPlayer.playback_speed = 0.5
        $AnimationPlayer.play("DisplayMainMsg")

func on_msg(msg, display_duration=1):
        $MainMsg/Label.bbcode_text = msg
        $AnimationPlayer.playback_speed = 1.0/display_duration
        $AnimationPlayer.play("DisplayMainMsg")




func _on_FluteButton_pressed():
    player.play_flute()

