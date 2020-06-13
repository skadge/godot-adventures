extends "res://res/monsters/Monster.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    damage = 10
    speed_factor = 0.05


# Called every frame. 'delta' is the elapsed time since the previous frame.
func path_following(delta):
    $Path2D/PathFollow2D.unit_offset += direction * delta * speed_factor
