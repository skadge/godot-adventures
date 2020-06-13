extends Node2D

onready var root = get_tree().root

onready var player  = root.get_node("Game/Items/Player")
onready var energy_bar = $Path2D/PathFollow2D/Area2D/Energy_bar/Energy_level

export(float) var speed_factor = 0.6
export(int) var life = 10

var current_life

var direction = 1

var rng = RandomNumberGenerator.new()

export(int) var damage = 20

func _ready():
    
    current_life = life
    energy_bar.scale.x = 1
    
    rng.randomize()
    $Path2D/PathFollow2D.unit_offset = rng.randf()
    
    speed_factor = rng.randf_range(speed_factor * 0.5, speed_factor * 1.5)
    
    player.connect("sword_hit", self, "hit")
    $Path2D/PathFollow2D/Area2D/Hit.modulate.a = 0

func hit(damage):
    
    print("Monster hit!")
    current_life -= damage
    energy_bar.scale.x = float(current_life) / life
    $Tween.interpolate_property($Path2D/PathFollow2D/Area2D/Hit, "modulate:a", 1, 0, 0.5)
    $Tween.start()
    if current_life <= 0:
        get_parent().remove_child(self)     
    
func path_following(delta):
    
    if $Path2D/PathFollow2D.unit_offset > 0.99:
        $Path2D/PathFollow2D.unit_offset = 0.99
        direction = -1
        $Path2D/PathFollow2D/Area2D.scale.x *= -1
        
    if $Path2D/PathFollow2D.unit_offset < 0.01:
        $Path2D/PathFollow2D.unit_offset = 0.01
        direction = 1
        $Path2D/PathFollow2D/Area2D.scale.x *= -1
    
    $Path2D/PathFollow2D.unit_offset += direction * delta * speed_factor
    
func _process(delta):   
    path_following(delta)
    
func _on_touch_player(body):
    if body.get_name() == "Player":
        player.health_change(-damage)
