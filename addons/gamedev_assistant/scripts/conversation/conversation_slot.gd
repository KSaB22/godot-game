@tool
extends Button

@onready var jtasmzvu : Label = $PromptLabel
@onready var vmiuzmsi : TextureButton = $FavouriteButton
@onready var utmkegld : Button = $DeleteButton

@export var non_favourite_color : Color
@export var favourite_color : Color

var zijhxcuk : Conversation
var ebzfneaz

func _ready():
    vmiuzmsi.modulate = non_favourite_color
    
                                
    pressed.connect(gfamevpg)
    utmkegld.pressed.connect(crrxllve)
    vmiuzmsi.pressed.connect(deqqwxdf)

                                                 
func qyrfrxhe (kwkhdztn : Conversation, eqbtybnr):
    zijhxcuk = kwkhdztn
    ebzfneaz = eqbtybnr
    jtasmzvu.text = zijhxcuk.dfkyejxn().replace("\n", "")                    
    vvekjmjt()

                                                
func gfamevpg():
    ebzfneaz.vadjgybc(zijhxcuk)

                              
                                    
func crrxllve():
    $"../../..".nqgfpnfm(self)

func deqqwxdf():
                                                          
    var qhjpfiyf = ebzfneaz.mujofglr()
    qhjpfiyf.aovhwlub(zijhxcuk, not zijhxcuk.favorited)
    vvekjmjt()

func vvekjmjt ():
    if zijhxcuk.favorited:
        vmiuzmsi.modulate = favourite_color
    else:
        vmiuzmsi.modulate = non_favourite_color

func get_conversation():
    return zijhxcuk
