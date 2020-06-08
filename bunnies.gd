extends Node2D

export (float) var speed = 1.0

var rng = RandomNumberGenerator.new()


func _ready():
    rng.randomize()
    $Path2D/PathFollow2D.unit_offset = rng.randf()
    
func _process(delta):
    $Path2D/PathFollow2D.unit_offset =  $Path2D/PathFollow2D.unit_offset + 0.01
   
    if $Path2D/PathFollow2D.unit_offset > 0.98:
        var spawn_x = rng.randi_range(250, 1000)
        var spawn_y = rng.randi_range(50,600 )
        position = Vector2 (spawn_x, spawn_y)
        $Path2D/PathFollow2D.unit_offset = 0
    


