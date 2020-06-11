extends Node2D

onready var root = get_tree().root

onready var player  = root.get_node("Game/Items/Player")

var speed_factor = 0.6
var direction = 1

var rng = RandomNumberGenerator.new()

export(int) var damage = 20

func _ready():
    rng.randomize()
    $Path2D/PathFollow2D.unit_offset = rng.randf()
    
    speed_factor = rng.randf_range(speed_factor * 0.5, speed_factor * 1.5)
    


func _process(delta):   
    
    if $Path2D/PathFollow2D.unit_offset > 0.99:
        $Path2D/PathFollow2D.unit_offset = 0.99
        direction = -1
        $Path2D/PathFollow2D/Area2D.scale.x *= -1
        
    if $Path2D/PathFollow2D.unit_offset < 0.01:
        $Path2D/PathFollow2D.unit_offset = 0.01
        direction = 1
        $Path2D/PathFollow2D/Area2D.scale.x *= -1
    
    $Path2D/PathFollow2D.unit_offset += direction * delta * speed_factor
    
func _on_touch_player(body):
    if body.get_name() == "Player":
        player.health_change(-damage)
