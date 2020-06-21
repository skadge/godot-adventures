extends "res://res/characters/Character.gd"

onready var whale = $PathIdle/PathFollow2D/Area2D

onready var sprite = $PathIdle/PathFollow2D/Area2D/Sprite
onready var path_follower = $PathIdle/PathFollow2D

onready var game_scale = root.get_node("Game").scale

onready var nav2d = root.get_node("Game/WhaleNavigation2D")

onready var mermaid = root.get_node("Game/Items/Mermaid")

var speed : int = 150

enum State {IDLING, GOING_TO_PLAYER, GOING_TO_MERMAID, BRINGING_PLAYER_BACK, BACK_TO_IDLING}

var state = State.IDLING

var path = PoolVector2Array() setget set_path

var last_x

var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():

    last_x = path_follower.position.x
    
    #going_to_player()

func connect_signals():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    var original_position = whale.global_position
    
    var move_distance : float = delta * speed
    
    if state == State.IDLING:
        $PathIdle/PathFollow2D.offset += move_distance
        
        if path_follower.position.x > last_x:
            sprite.set_flip_h(true)
        if path_follower.position.x < last_x:
            sprite.set_flip_h(false)
        
        last_x = path_follower.position.x
    
    elif state == State.GOING_TO_PLAYER:
        move_along_path(move_distance)
        
        # not moving anymore? we are at the beach!
        if whale.global_position - original_position == Vector2(0,0):
            sprite.texture = load("res://res/characters/whale_small_character.png")
            player.hide()
            go_to($MermaidTarget)
            state = State.GOING_TO_MERMAID
    
    elif state == State.GOING_TO_MERMAID:
        sprite.set_flip_h(false)
        move_along_path(move_distance)
        
        player.global_position = whale.global_position
        
        # not moving anymore? we are at the mermaid!
        if whale.global_position - original_position == Vector2(0,0):
            
            if not mermaid.talking:
                if not mermaid.key_given:
                    mermaid.dialogue_stages()
                else:
                    go_to($BeachLanding)
                    state = State.BRINGING_PLAYER_BACK
    
    elif state == State.BRINGING_PLAYER_BACK:
        sprite.set_flip_h(true)
        move_along_path(move_distance)
        
        player.global_position = whale.global_position
        
        # not moving anymore? we are at the beach!
        if whale.global_position - original_position == Vector2(0,0):
            sprite.texture = load("res://res/characters/whale_small.png")
            player.show()
            
            var pos = whale.global_position
            $PathIdle/PathFollow2D.offset = 0
            whale.global_position = pos
            
            go_to(self)
            state = State.BACK_TO_IDLING
            
    elif state == State.BACK_TO_IDLING:
        sprite.set_flip_h(false)
        move_along_path(move_distance)
        
        # not moving anymore? we are at the start point of idling!
        if whale.global_position - original_position == Vector2(0,0):
            state = State.IDLING
            
    else:
        print("SHOULD NOT HAPPEN!")
        
        
    


func going_to_player():
    
    go_to(player)
    
    state = State.GOING_TO_PLAYER

func go_to(object):
    set_path(nav2d.get_simple_path(whale.global_position/game_scale, object.global_position/game_scale))
    
func set_path(value : PoolVector2Array) -> void:
    #print(whale.global_position)
    print(whale.global_position)
    print(whale.global_position/game_scale)
    print(whale.global_scale)
    print(whale.global_transform)
    print(whale.position)
    #print(value)
    path = value
    
    get_tree().root.get_node("Game/WhalePath").points = value
    #get_tree().root.get_node("Game/WhalePath").points = [whale.global_position, player.global_position]
    
       
func move_along_path(distance : float) -> void:
    
    var start_point = whale.global_position
    
    for _i in range(path.size()):
        var distance_to_next = start_point.distance_to(path[0] * game_scale)
                    
        if distance_to_next > 0.0 and distance <= distance_to_next and distance >= 0.0:
            #print(whale.global_position)
            whale.global_position = start_point.linear_interpolate(path[0] * game_scale, distance / distance_to_next)
            #print(whale.global_position)
            break
        elif distance < 0.0:
            whale.global_position = path[0] * game_scale
            
            break
            
        distance -= distance_to_next
        start_point = path[0] * game_scale
        path.remove(0)
        


