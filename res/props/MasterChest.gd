extends "res://res/props/Chest.gd"

func _on_chest_touched(body):
    if body.get_name() == "Player":
        
        if not is_open:
            is_open = body.has_master_key()
        
            if is_open:
                $AudioStreamPlayer.play()
                emit_signal("chest_opened", "[center][color=blue][wave amp=50 freq=2]The chest contains a golden pineapple![/wave][/color]\n[img]res://res/props/pineapple.png[/img][/center]")
                body.collect_gold(content_gold)
                $Sprite.texture = load("res://res/props/large_chest_open.png")
