                                         
@tool
extends Control

@onready var jpzqbzxo = $Screen_Conversations
@onready var qogymlpp = $Screen_Chat
@onready var dwjlbfwa = $Screen_Settings

@onready var pyztansa = $Header/HBoxContainer/ConversationsButton
@onready var gduqiwjt = $Header/ChatButton
@onready var sxkaylqi = $Header/HBoxContainer/SettingsButton
@onready var mhspzyuq = $Header/ScreenText

@onready var jfavtnfn = $ConversationManager
@onready var wbmlbwvp = $APIManager

                                          
var mvdugmog : bool = false

                                                    
var npnvmbuf : bool = false

func _ready():
    ckueknhh(false)
    
                                       
    wbmlbwvp.flnzxrxk.connect(usidmavq)
    wbmlbwvp.neuvrjjn.connect(usidmavq)
    
                                   
    gduqiwjt.pressed.connect(jdtvpbvv)
    sxkaylqi.pressed.connect(qlqauthc)
    pyztansa.pressed.connect(rvyfanzc)
    
    var ryotsoyg = EditorInterface.get_editor_settings()
    
                                        
    var wlgblzgc = ryotsoyg.has_setting("gamedev_assistant/development_mode") and ryotsoyg.get_setting('gamedev_assistant/development_mode') == true    
    if wlgblzgc:
        shuizbah()
    
    if ryotsoyg.has_setting("gamedev_assistant/validated"):
        if ryotsoyg.get_setting("gamedev_assistant/validated") == true:
            jdtvpbvv()
            ckueknhh(true)
                        
                                                             
            wbmlbwvp.xuctghjw(true)
            return
                                          
    elif !ryotsoyg.has_setting("gamedev_assistant/onboarding_shown"):
        shuizbah()
        ryotsoyg.set_setting("gamedev_assistant/onboarding_shown", true)
        
    wnblhngt(dwjlbfwa, "Settings")

func wnblhngt (asilzfvt, opxtojtq):
    jpzqbzxo.visible = false
    qogymlpp.visible = false
    dwjlbfwa.visible = false
    
                                                 
    asilzfvt.visible = true
    asilzfvt._on_open()
    
    mhspzyuq.text = opxtojtq
    
    npnvmbuf = asilzfvt == qogymlpp
    
                       
    wbmlbwvp.uiyurcqx.emit()
    
                                                                
                                                           
                                       

func rvyfanzc():
    wnblhngt(jpzqbzxo, "Conversations")

func jdtvpbvv():
    jfavtnfn.msnyuwvt()
    wnblhngt(qogymlpp, "New Conversation")
    qogymlpp.swpajpeb()
    wbmlbwvp.uiyurcqx.emit()

func qlqauthc():
    if dwjlbfwa.visible:
        return
    
    wnblhngt(dwjlbfwa, "Settings")

func vadjgybc (zeoqngop : Conversation):
    jfavtnfn.isgkodxl(zeoqngop.id)
    wnblhngt(qogymlpp, "Chat")

func ckueknhh (wbffzgfz : bool):
    mvdugmog = wbffzgfz
    gduqiwjt.disabled = !wbffzgfz
    pyztansa.disabled = !wbffzgfz
    
                                                               
func usidmavq(rrlqmoqd, param2 = ""):
                                                                                       
                                                            
    
    var ufcgikpz = AcceptDialog.new()
    ufcgikpz.get_ok_button().text = "Close"
    
                                                                                 
    if rrlqmoqd is bool:
                                                             
        var wwwodfrj = rrlqmoqd
        var lfukenvs = param2
        
                                                   
        if wwwodfrj:
            ufcgikpz.title = "GameDev Assistant Update"
            ufcgikpz.dialog_text = "An update is available! Latest version: " + lfukenvs + ". Go to https://app.gamedevassistant.com to download it."
            add_child(ufcgikpz)
            ufcgikpz.popup_centered()
    else:
                                                           
        var nbzggtwr = rrlqmoqd
        ufcgikpz.title = "GameDev Assistant Update"
        ufcgikpz.dialog_text = nbzggtwr
        add_child(ufcgikpz)
        ufcgikpz.popup_centered()

func shuizbah():
    var jbjbzmdy = AcceptDialog.new()
    jbjbzmdy.title = "Welcome Aboard! 🚀"
    jbjbzmdy.dialog_text = "Welcome to GameDev Assistant by Zenva!\n\n🌟 To get started:\n1. Find the Assistant tab (next to Inspector, Node, etc, use arrows < > to find it)\n2. Enter your token in Settings\n3. Start a chat with the + button\n4. Switch between Chat and Agent mode to find your perfect workflow\n\n\nHappy gamedev! 🎮"
    jbjbzmdy.ok_button_text = "Close"
    jbjbzmdy.dialog_hide_on_ok = true
    add_child(jbjbzmdy)
    jbjbzmdy.popup_centered()

func mujofglr():
    return jfavtnfn
