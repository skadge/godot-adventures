extends Control

signal conversation_finished

var strings_file
var strings = {}

func _init():
    strings_file = File.new()
    
    
func _ready():
    
    strings_file.open("res://chronicles_purdownia_translations.csv", File.READ)
    
    while not strings_file.eof_reached():
        var line = strings_file.get_csv_line()
        if line.size() > 1:
            strings[line[0]] = line[1]

    strings_file.close()
        
    hide_all_buttons()


func hide_all_buttons():
    for b in $Box/Buttons.get_children(): 
        b.hide()



func clear_buttons_signals():
        
    for b in $Box/Buttons.get_children(): 
        for s in b.get_signal_connection_list("pressed"):
            b.disconnect(s["signal"], s["target"], s["method"])
        

func close():
    hide()
    clear_buttons_signals()
       
func say(sprite, text):
    
    show()
    hide_all_buttons()
    
    $Box/CharacterIcon.texture = sprite.texture
    set_text(text)


func say_many(sprite, sentences):
    
    show()
    hide_all_buttons()
    
    var btnContinue = $Box/Buttons/ButtonContinue
    btnContinue.show()
    
    $Box/CharacterIcon.texture = sprite.texture
    
    
    for idx in range(sentences.size()):
        
        set_text(sentences[idx])
        
        if idx < sentences.size() - 1:
            yield(btnContinue, "pressed")
        else:
            btnContinue.hide()
            get_parent().set_process_input(false)
            emit_signal("conversation_finished")


func set_text(text):

    if strings.has(text):
        text = strings[text]
    else:
        print("[MISSING STRING] " + text)
        
    $Box/RichTextLabel.bbcode_text = text
    
func say_yes_no(sprite, text, cb_object, on_yes, on_no):
    
        
    show()
    hide_all_buttons()
    
    $Box/Buttons/ButtonYes.show()
    $Box/Buttons/ButtonNo.show()
    
    $Box/CharacterIcon.texture = sprite.texture
    set_text(text)
        
    $Box/Buttons/ButtonYes.connect("pressed", cb_object, on_yes, [], CONNECT_ONESHOT)
    $Box/Buttons/ButtonNo.connect("pressed", cb_object, on_no, [], CONNECT_ONESHOT)
    
