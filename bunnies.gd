extends Node2D

export (float) var speed_factor = 0.6

var rng = RandomNumberGenerator.new()

export(Vector2) var spawn_rect_top_left = Vector2(250, 50)
export(Vector2) var spawn_rect_bottom_right = Vector2(1000, 600)

func _ready():
    rng.randomize()
    $Path2D/PathFollow2D.unit_offset = rng.randf()
    
func _process(delta):
    $Path2D/PathFollow2D.unit_offset =  $Path2D/PathFollow2D.unit_offset + delta * speed_factor
   
    if $Path2D/PathFollow2D.unit_offset > 0.98:
        var spawn_x = rng.randi_range(spawn_rect_top_left.x, spawn_rect_bottom_right.x)
        var spawn_y = rng.randi_range(spawn_rect_top_left.y, spawn_rect_bottom_right.y )
        position = Vector2 (spawn_x, spawn_y)
        $Path2D/PathFollow2D.unit_offset = 0
    


