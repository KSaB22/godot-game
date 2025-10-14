                                                                    
@tool
extends TextEdit

@export var max_length = 1000                                        
const qschnnsq = "gamedev_assistant/custom_instructions"

func _ready():
    text_changed.connect(wgjwblby)

func wgjwblby():
                             
    if text.length() > max_length:
        var pbhuhlfn = get_caret_column()
        text = text.substr(0, max_length)
        set_caret_column(min(pbhuhlfn, max_length))
    
                        
    var cykbzset = EditorInterface.get_editor_settings()
    cykbzset.set_setting(qschnnsq, text)
