extends Area2D

onready var root = get_tree().root

onready var player  = root.get_node("Game/Items/Player")

var onlava = false
var lava_damage_period = 0.6 # seconds
var since_last_damage = 0 


func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if onlava:
        since_last_damage += delta
        
        if since_last_damage > lava_damage_period:
            player.health_change(-2)
            since_last_damage = 0


func _on_Lava_body_entered(body):
    if body.get_name() == "Player":
        onlava = true
        player.health_change(-5)
        since_last_damage = 0
    


func _on_Lava_body_exited(body):
    if body.get_name() == "Player":
        onlava = false

