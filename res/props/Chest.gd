extends Area2D


onready var interface  = get_tree().root.get_node("Game/GUILayer/Interface")

export(bool) var is_open = false

signal chest_opened

var content_gold = 5

var rng = RandomNumberGenerator.new()

func _ready():
    rng.randomize()
    content_gold = rng.randi_range(3,10)
    
    connect("chest_opened", interface, "on_msg")
    
func _on_chest_touched(body):
    if body.get_name() == "Player":
        
        if not is_open:
            is_open = body.use_key()
        
            if is_open:
                emit_signal("chest_opened", "You open the chest:\n[center][wave amp=50 freq=2]It contains " + str(content_gold) + " gold coins![/wave][/center]")
                body.collect_gold(content_gold)
                $Sprite.texture = load("res://res/props/chest_open.png")
