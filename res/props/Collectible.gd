extends Area2D


func _ready():
    connect("body_entered", self, "on_touched")
    $AudioStreamPlayer.stream.set_loop(false)


func on_touched(body):
    if body.get_name() == "Player":
        # do smthg!
        get_parent().remove_child(self)
