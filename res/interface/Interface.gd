extends Control

onready var root = get_tree().root
onready var player  = root.get_node("Game/Items/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
    $Inventory.hide()
    $Inventory/HBox/HotAirBalloonButton.hide()
    $Inventory/HBox/PlayerButton.hide()
    $Inventory/HBox/SwordButton.hide()
    
    $MainMsg.modulate.a = 0
    
    #_on_HotAirBalloonAvailable()
    #_on_SwordAvailable()
    

func resize_inventory_bg():
    $Inventory.rect_size.x = $Inventory/HBox.rect_size.x + 60
    
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
    print("Sword button pressed")

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


