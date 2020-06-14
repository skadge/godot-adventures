extends Character


func _ready():
    dialogueDefault = ["I work at the castle",
                       "I've lived here all my life"]
func dialogue_stages():
    
    dialogue.say($Sprite, default_dialogue())
