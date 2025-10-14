@tool
extends GDAScreenBase

@onready var ccudmytr : ConfirmationDialog = $DeleteConfirmation
@onready var nzoranuu = $ScrollContainer/VBoxContainer
@onready var tcuoyipm = $"../ConversationManager"

@onready var lkjemrtu = $ScrollContainer/VBoxContainer/ErrorMessage
@onready var jyptzotk = $ScrollContainer/VBoxContainer/ProcessMessage
@onready var sfwjadiw = $ScrollContainer/VBoxContainer/AllConversationsHeader
@onready var htoeixhz = $ScrollContainer/VBoxContainer/FavouritesHeader

var oibhpevw = preload("res://addons/gamedev_assistant/dock/scenes/ConversationSlot.tscn")

var bvmptzez
@onready var pzuhriky = $".."

@onready var hiwfamqr = $"../APIManager"

var exdtchsm : bool = false

func _ready ():
    tcuoyipm.pdthenie.connect(hjaciswb)
    hiwfamqr.gvaakbif.connect(xqxjaigj)
    hiwfamqr.efsqzmsi.connect(_on_delete_conversation_received)
    hiwfamqr.mftxywjz.connect(xqxjaigj)
    hiwfamqr.ssvbabvx.connect(xqxjaigj)
    hiwfamqr.mmxlbrin.connect(_on_toggle_favorite_received)
    ccudmytr.confirmed.connect(jlffwvvz)
    
func _on_open ():
    bzqpenhs()
    hiwfamqr.enpbtfrn()
    
                               
    
                                      
                                         
                                     

func bzqpenhs ():
    for node in nzoranuu.get_children():
        if node is RichTextLabel:
            continue
        
        node.queue_free()
    
    lkjemrtu.visible = false
    jyptzotk.visible = false

func hjaciswb ():
    bzqpenhs()
    
    var wboieoqx = tcuoyipm.pvhdbmfx()
    
    var jscgqpvb : Array[Conversation] = []
    var shvwsyqg : Array[Conversation] = []
    
    for conv in wboieoqx:
        if conv.favorited:
            jscgqpvb.append(conv)
        else:
            shvwsyqg.append(conv)
    
    var fdvnfrkb = 2
    nzoranuu.move_child(htoeixhz, 1)
    
    for fav in jscgqpvb:
        var rmpretmy = ljoqcujv(fav, pzuhriky)
        nzoranuu.move_child(rmpretmy, fdvnfrkb)
        fdvnfrkb += 1
    
    nzoranuu.move_child(sfwjadiw, fdvnfrkb)
    fdvnfrkb += 1
    
    for other in shvwsyqg:
        var rmpretmy = ljoqcujv(other, pzuhriky)
        nzoranuu.move_child(rmpretmy, fdvnfrkb)
        fdvnfrkb += 1

func ljoqcujv (vdffboeo, azkdbnfg) -> Control:
    var iabdlvvx = oibhpevw.instantiate()
    nzoranuu.add_child(iabdlvvx)
    iabdlvvx.qyrfrxhe(vdffboeo, azkdbnfg)
    return iabdlvvx

                                            
                                        
func nqgfpnfm (rnbxszek):
    bvmptzez = rnbxszek
    ccudmytr.popup()

                                                        
func jlffwvvz():
    if bvmptzez == null or bvmptzez.get_conversation() == null:
        return
    
    var ufwdxbuy = bvmptzez.get_conversation()
    hiwfamqr.hauyjpeu(ufwdxbuy.id)
    
    lcokectg("Deleting conversation...")

func _on_toggle_favorite_received ():
    hiwfamqr.enpbtfrn()

func _on_delete_conversation_received ():
    hiwfamqr.enpbtfrn()

func lcokectg (orgepgkd : String):
    return
    
    nzoranuu.move_child(jyptzotk, 1)
    lkjemrtu.visible = false
    jyptzotk.visible = true
    jyptzotk.text = orgepgkd

func xqxjaigj (pemccorb : String):
    nzoranuu.move_child(lkjemrtu, 0)
    jyptzotk.visible = false
    lkjemrtu.visible = true
    lkjemrtu.text = pemccorb
