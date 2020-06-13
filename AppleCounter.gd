extends NinePatchRect

onready var player  = get_tree().root.get_node("Game/Items/Player")

var health_per_apple = 2

func _ready():
    $Label.text = "0"
    $AudioStreamPlayer.stream.set_loop(false)
    
    $TextureButton.connect("pressed", self, "eat_apple")

func eat_apple():
    if int($Label.text) > 0:
        $Label.text = str(int($Label.text) - 1)
        $AudioStreamPlayer.play()
        player.health_change(health_per_apple)
