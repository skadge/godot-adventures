extends Area2D


func _ready():
    pass # Replace with function body.



func _on_coin_touched(body):
    if body.get_name() == "Player":
        body.collect_gold()
        get_parent().remove_child(self)
