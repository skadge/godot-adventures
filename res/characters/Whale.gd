extends "res://res/characters/Character.gd"

onready var sprite = $PathIdle/PathFollow2D/Area2D/Sprite
onready var path_follower = $PathIdle/PathFollow2D

var last_x

var idling = true

var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    $PathMermaid/PathFollow2D/Sprite.hide()
    last_x = path_follower.position.x
    
    #going_to_village()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    if idling:
        $PathIdle/PathFollow2D.unit_offset += delta * 0.05
    else:
        $PathMermaid/PathFollow2D.unit_offset += delta * 0.1 * direction
        
        if direction == 1:
            player.position = position + path_follower.position
        
        if $PathMermaid/PathFollow2D.unit_offset >= 0.98:
            sprite.texture = load("res://res/characters/whale_small.png")   
            player.show()
            direction = -1
        
        if $PathMermaid/PathFollow2D.unit_offset <= 0.02 and direction == -1:
            sprite.texture = load("res://res/characters/whale_small_character.png")
            idling()
            direction = 1
        
        
    
    if path_follower.position.x > last_x:
        sprite.set_flip_h(true)
    if path_follower.position.x < last_x:
        sprite.set_flip_h(false)
    
    last_x = path_follower.position.x

func going_to_mermaid():
    
    player.hide()
    
    path_follower = $PathMermaid/PathFollow2D
    path_follower.position = Vector2(0,0)
    
    $PathIdle/PathFollow2D/Area2D.hide()
    idling = false
    sprite = $PathMermaid/PathFollow2D/Sprite
    sprite.show()


func idling():
    idling = true
    $PathMermaid/PathFollow2D/Sprite.hide()
    sprite = $PathIdle/PathFollow2D/Area2D/Sprite
    path_follower = $PathIdle/PathFollow2D
    
    path_follower.position = Vector2(0,0)
    
    $PathIdle/PathFollow2D/Area2D.show()

