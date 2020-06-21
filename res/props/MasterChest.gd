extends "res://res/props/Chest.gd"

onready var player  = get_tree().root.get_node("Game/Items/Player")

func _on_chest_touched(body):
    if body.get_name() == "Player":
        
        if not is_open:
            is_open = body.has_master_key()
        
            if is_open:
                $AudioStreamPlayer.play()
                player.obtain_golden_pineapple()
                $Sprite.texture = load("res://res/props/large_chest_open.png")
