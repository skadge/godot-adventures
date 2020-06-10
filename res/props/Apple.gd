extends "res://res/props/Collectible.gd"

func on_touched(body):
    if body.get_name() == "Player":
        $AudioStreamPlayer.play()
        body.health_change(1)
        get_parent().remove_child(self)
