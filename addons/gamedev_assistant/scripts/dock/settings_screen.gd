                                  
@tool
extends GDAScreenBase

var ajfvoegd : Label
var aezmpbti : LineEdit
var lwcwyivw : CheckButton
var nuzvwezg : Button
var pgtvdovl : RichTextLabel
var khngrqgl : RichTextLabel
var bwsylemg : RichTextLabel
var zugtnzbg : Button
var slgucnkz : LineEdit
var llessyxw : Button
var gqxvtipo : Button
var oqvwbuud : String

const yedsqtfh : String = "gamedev_assistant/hide_token"
const xojbuxlx : String = "gamedev_assistant/validated"
const youuygjx : String = "gamedev_assistant/custom_instructions"

@onready var vkdtjpvz = $".."
@onready var frivrpmb = $"../APIManager"
@onready var jiziqurs = $"VBoxContainer/CustomInput"

var hrwyxxys : bool

func _ready ():
    frivrpmb.pyeocobp.connect(_on_validate_token_received)
    frivrpmb.flnzxrxk.connect(_on_check_updates_received)
    frivrpmb.neuvrjjn.connect(nmqikaqp)
    
    bavhtjer()
    
                                             
    lwcwyivw.toggled.connect(qiqeoyab)
    nuzvwezg.pressed.connect(vtbcrcap)
    llessyxw.pressed.connect(tzainyjk)
    gqxvtipo.pressed.connect(nadymccs)
    aezmpbti.text_changed.connect(sxcqrvsx)
    
    pgtvdovl.visible = false
    khngrqgl.visible = false
    bwsylemg.visible = false
    
    var nbrjejnv = EditorInterface.get_editor_settings()       
    
    nbrjejnv.set_setting("gamedev_assistant/version_identifier", "L93HS7Dvba")
    
    hrwyxxys = nbrjejnv.has_setting("gamedev_assistant/development_mode") and nbrjejnv.get_setting('gamedev_assistant/development_mode') == true    
    if not hrwyxxys:
        nbrjejnv.set_setting("gamedev_assistant/endpoint", "https://app.gamedevassistant.com")
        oqvwbuud = "gamedev_assistant/token"
    else:
        nbrjejnv.set_setting("gamedev_assistant/endpoint", "http://localhost:3000")
        oqvwbuud = "gamedev_assistant/token_dev"
        print("Development mode")
        
    frivrpmb.ajjyajpt()
    
                                                                         
                                                  
func bavhtjer ():
    ajfvoegd = $VBoxContainer/EnterTokenPrompt
    aezmpbti = $VBoxContainer/Token_Input
    lwcwyivw = $VBoxContainer/HideToken
    nuzvwezg = $VBoxContainer/ValidateButton
    pgtvdovl = $VBoxContainer/TokenValidationSuccess
    khngrqgl = $VBoxContainer/TokenValidationError
    bwsylemg = $VBoxContainer/TokenValidationProgress
    llessyxw = $VBoxContainer/AccountButton
    gqxvtipo = $VBoxContainer/UpdatesButton

func qiqeoyab (dxbgkxvb):
    aezmpbti.secret = dxbgkxvb
    
    var pvkxwiai = EditorInterface.get_editor_settings()
    pvkxwiai.set_setting(yedsqtfh, lwcwyivw.button_pressed)

func sxcqrvsx (xsmgmiza):
    if len(aezmpbti.text) == 0:
        ajfvoegd.visible = true
    else:
        ajfvoegd.visible = false
    
    vkdtjpvz.ckueknhh(false)
    
    pgtvdovl.visible = false
    khngrqgl.visible = false
    bwsylemg.visible = false
    
    var azfozkfb = EditorInterface.get_editor_settings()
    azfozkfb.set_setting(oqvwbuud, aezmpbti.text)

func vtbcrcap ():
    nuzvwezg.disabled = true
    pgtvdovl.visible = false
    khngrqgl.visible = false
    bwsylemg.visible = true
    frivrpmb.xxlvjnoz()

                                                        
func _on_validate_token_received (andenzol : bool, whcoryto : String):
    bwsylemg.visible = false
    nuzvwezg.disabled = false
    
    if andenzol:
        pgtvdovl.visible = true
        pgtvdovl.text = "Token has been validated!"
        
        var nlipetxb = EditorInterface.get_editor_settings()
        nlipetxb.set_setting(xojbuxlx, true)
        
        vkdtjpvz.ckueknhh(true)
    else:
        khngrqgl.visible = true
        khngrqgl.text = whcoryto

                                                  
                                                  
func _on_open ():
    bavhtjer()
    var dragdcur = EditorInterface.get_editor_settings()
    
    if dragdcur.has_setting(oqvwbuud):
        aezmpbti.text = dragdcur.get_setting(oqvwbuud)
    
    if dragdcur.has_setting(yedsqtfh):
        lwcwyivw.button_pressed = dragdcur.get_setting(yedsqtfh)
    
    aezmpbti.secret = lwcwyivw.button_pressed
    
    if len(aezmpbti.text) == 0:
        ajfvoegd.visible = true
    else:
        ajfvoegd.visible = false
        
    if dragdcur.has_setting(youuygjx):
        jiziqurs.text = dragdcur.get_setting(youuygjx)

func tzainyjk():
    OS.shell_open("https://app.gamedevassistant.com/profile")
    
func nadymccs():
    pgtvdovl.visible = false
    khngrqgl.visible = false
    bwsylemg.visible = true
    
    frivrpmb.xuctghjw()

func _on_check_updates_received(iklfyqlc: bool, pwlmwfsi: String):
    bwsylemg.visible = false
    
    if iklfyqlc:
        pgtvdovl.visible = true
        pgtvdovl.text = "An update is available! Latest version: " + pwlmwfsi + ". Click 'Manage Account' to download it."
    else:
        pgtvdovl.visible = true
        pgtvdovl.text = "You are already in the latest version"

func nmqikaqp(yijkwugt: String):
    bwsylemg.visible = false
    khngrqgl.visible = true
    khngrqgl.text = yijkwugt
    
