extends "res://res/props/Collectible.gd"


func on_touched(body):

    if body.get_name() == "Player":
        body.apple_changed(1)
        get_parent().remove_child(self)
