extends "res://res/props/Collectible.gd"


func on_touched(body):

    if body.get_name() == "Player":
        body.collect_apple()
        get_parent().remove_child(self)
