                                                       
@tool
extends GDAScreenBase

signal gjhuurim

var isexlpzy : RichTextLabel = null

@onready var wgwlfzry : TextEdit = $Footer/PromptInput
@onready var vqegkhau : Button = $Footer/SendPromptButton
@onready var ybcxdwbo : Control = $Footer
@onready var hggzmoyu : Control = $Body

@onready var dzimgjhy = $"../APIManager"
@onready var arnhiauq = $"../ActionManager"

var gyfvlbjf = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_UserPrompt.tscn")
var msnewcbz = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ServerResponse.tscn")
var fwaghbed = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ErrorMessage.tscn")
const onuavvgm = preload("res://addons/gamedev_assistant/scripts/chat/markdown_to_bbcode.gd")
var xbrhflmu = preload("res://addons/gamedev_assistant/scripts/chat/message_tagger.gd").new()
var mcrnrtrt = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_CodeBlockResponse.tscn")
var jlmlgizl = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_CodeBlockUser.tscn")
var ltainshd = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_Spacing.tscn")

var bbgitbjd := false
var yrxetlaf: String = ""

                                                   
var ibggfdle : String = ""
var hwmbnwol : String = ""
var zwvlipzj  : String = ""
var atgzywjf : String = ""
var qmacwfnd  : String = ""

var eqddsvmp : int = -1

@onready var urwxjsji = $Body/MessagesContainer
@onready var wobbclky = $Body/MessagesContainer/ThinkingLabel
@onready var qvgbaqtl = $Bottom/AddContext
@onready var vhdpgavk : CheckButton = $Bottom/ReasoningToggle
@onready var xovoveis = $Body/MessagesContainer/RatingContainer
@onready var lxrjulkz = $Bottom/Mode

@onready var shlkendn = preload("res://addons/gamedev_assistant/dock/icons/stop.png")  
@onready var mmcvhyuu = preload("res://addons/gamedev_assistant/dock/icons/arrowUp.png")  

var xnpirzsw = [
    "",
    " @OpenScripts ",
    " @Output ",
    " @Docs ",
    " @GitDiff ",
    " @ProjectSettings"
]

@onready var vogbgpwb = $"../ConversationManager"

var waiting_nonthinking = "Thinking ⚡"
var waiting_thinking = "Reasoning ⌛ This could take multiple minutes"

var notice_actions_nonthinking = "Generating one-click actions ⌛ To skip, press ■"
var notice_actions_thinking = "Generating one-click actions ⌛ To skip, press ■"


func _ready ():
    dzimgjhy.skidsnvx.connect(suqqrdbl)
    dzimgjhy.uhdmmyul.connect(hepeigrk)
    
    vogbgpwb.cqywcivb.connect(ygfnuzmj)
    wgwlfzry.wkhqqxrd.connect(kyfbemzm)
    
                       
    dzimgjhy.cackpbrl.connect(jcovacdk)
    dzimgjhy.datqgqyk.connect(ryhahkwa)
    dzimgjhy.sqxyeklx.connect(cjuxkvwa)
    dzimgjhy.pclndlng.connect(wejvazpb)

    qvgbaqtl.item_selected.connect(mcixjbfm)    
    vqegkhau.pressed.connect(symujsbz)   
    
    xovoveis.get_node("UpButton").pressed.connect(qtpwfesv)
    xovoveis.get_node("DownButton").pressed.connect(nxtznyed)
    xovoveis.visible = false 

func _on_open ():
    wgwlfzry.text = ""
    wobbclky.visible = false
    xovoveis.visible = false 
    ojissdqw(false)
    pzbqrzlt()
    qvgbaqtl.selected = 0
    yrxetlaf = ''
    

                                                            
func swpajpeb ():
    bbgitbjd = true
    ojissdqw(true)
    eqddsvmp = -1
    xovoveis.visible = false
    xbrhflmu.zuvupaax()
    
                    
    hwmbnwol = ""
    zwvlipzj  = ""
    atgzywjf = ""
    qmacwfnd  = ""
    ibggfdle = ""

func jcovacdk(yosvborb: String, wbcybxgs: int, wpwczjsz: int) -> void:
    if isexlpzy == null:
        isexlpzy = msnewcbz.instantiate()
        isexlpzy.bbcode_enabled = true
        urwxjsji.add_child(isexlpzy)
        var vrjrqnfd = ltainshd.instantiate()
        urwxjsji.add_child(vrjrqnfd)
        wobbclky.visible = false
        yrxetlaf = yosvborb
        
        if wpwczjsz != -1:
            eqddsvmp = wpwczjsz
    else:
        yrxetlaf += yosvborb
        
                                                  
    isexlpzy.text = onuavvgm.psrmlqvh(yrxetlaf)
    
                                                                     
    if not isexlpzy.meta_clicked.is_connected(fgpcfrcl):  
        isexlpzy.meta_clicked.connect(fgpcfrcl)  
    
    if wbcybxgs > 0:
        vogbgpwb.dnlhpcqo(wbcybxgs)

func cjuxkvwa(rrywpsxz: int, zssouswq: int) -> void:
    if isexlpzy:
        isexlpzy.visible = false

                                                                
    frywqmsn(yrxetlaf, msnewcbz, urwxjsji, mcrnrtrt)
    
                              
    urwxjsji.move_child(wobbclky, urwxjsji.get_child_count() - 1)
    wobbclky.visible = true
    wobbclky.text = notice_actions_nonthinking

func ryhahkwa(kqbvtvki: int, mfjnplsu: int) -> void:
                                         
    if isexlpzy:
        isexlpzy.queue_free()
        isexlpzy = null
        
    wobbclky.visible = false
    
                                                    
    urwxjsji.move_child(xovoveis, urwxjsji.get_child_count() - 1)
    xovoveis.visible = mfjnplsu > 0
    
                          
    var yzxyiyad = arnhiauq.kkstndjd(yrxetlaf, mfjnplsu)
    arnhiauq.fejmsafd(yzxyiyad, urwxjsji)

    yrxetlaf = ""
    ojissdqw(true)
    wobbclky.visible = false
    vqegkhau.icon = mmcvhyuu

func wejvazpb(pwvfibbl: String):
    ayqhenaa(pwvfibbl)
    ojissdqw(true)
    wobbclky.visible = false
    isexlpzy = null
    vqegkhau.icon = mmcvhyuu

func symujsbz():  
    if dzimgjhy.bctnbiyj():  
                                         
        dzimgjhy.uiyurcqx.emit()  
        
                                             
        if isexlpzy:
            isexlpzy.queue_free()
            isexlpzy = null
        
        ojissdqw(true)  
        vqegkhau.icon = mmcvhyuu  
        
        if not wobbclky.visible:
                                                                        
            frywqmsn(yrxetlaf, msnewcbz, urwxjsji, mcrnrtrt)
        
        wobbclky.visible = false  
        
                                                   
        urwxjsji.move_child(xovoveis, urwxjsji.get_child_count() - 1)
        xovoveis.visible = eqddsvmp > 0

    else:  
                                             
        hwwphnge()  

func hwwphnge():
                                                        
    arnhiauq.sosjbsev()
    
    xovoveis.visible = false
    
    eqddsvmp = -1
    
    if len(wgwlfzry.text) < 1:
        return
    
    var ftmnaadp = wgwlfzry.text

                                                        
    var sqgpdkjc := false
    if bbgitbjd:
        var carufvdq = Engine.get_singleton("EditorInterface") if Engine.is_editor_hint() else null
        atgzywjf = xbrhflmu.uchrkaka("", carufvdq)
        qmacwfnd  = xbrhflmu.yvraehqz("", carufvdq)
        ibggfdle = "[gds_context]Current project context:[/gds_context]\n" \
            + atgzywjf + "\n" + qmacwfnd
        sqgpdkjc = true
    else:
        sqgpdkjc = szzmmdvc()

    if sqgpdkjc and ibggfdle != "":
        ftmnaadp += ibggfdle
                          
        hwmbnwol = atgzywjf
        zwvlipzj  = qmacwfnd

    bbgitbjd = false

    if Engine.is_editor_hint():
        var carufvdq = Engine.get_singleton("EditorInterface")
        ftmnaadp = xbrhflmu.jbubylrv(ftmnaadp, carufvdq)
        
    var ojxmdece = vhdpgavk.button_pressed
    var sgowcypt : int = lxrjulkz.selected
    var xnnlirbd : String
    
    if sgowcypt == 0:
        xnnlirbd = "CHAT"
    else:
        xnnlirbd = "AGENT"        
    
    dzimgjhy.fstoqbvo(ftmnaadp, ojxmdece, xnnlirbd)
    azllavpr(wgwlfzry.text)                               
    ojissdqw(false)
    wgwlfzry.text = ""
    
    if ojxmdece:
        wobbclky.text = waiting_thinking
    else:
        wobbclky.text = waiting_nonthinking
        
    wobbclky.visible = true
    urwxjsji.move_child(wobbclky, urwxjsji.get_child_count() - 1)
    
                                               
    gjhuurim.emit()
    
func ojissdqw (nhkwbepz : bool):
    if nhkwbepz:  
        vqegkhau.icon = mmcvhyuu  
    else:  
        vqegkhau.icon = shlkendn  

func suqqrdbl (fuhmlech : String, qhdnqxse : int):
    gsfepwlw(fuhmlech)
    ojissdqw(true)
    wobbclky.visible = false

func hepeigrk (ecimxvet : String):
    ayqhenaa(ecimxvet)
    ojissdqw(true)
    wobbclky.visible = false

func azllavpr(bdarjtxq: String):
                                                                               
    frywqmsn(bdarjtxq, gyfvlbjf, urwxjsji, jlmlgizl)
    
    var qibbebca = ltainshd.instantiate()
    urwxjsji.add_child(qibbebca)


func gsfepwlw(fvqavkbr: String):
                                                                                
    frywqmsn(fvqavkbr, msnewcbz, urwxjsji, mcrnrtrt)
    
    var wlvcwudl = ltainshd.instantiate()
    urwxjsji.add_child(wlvcwudl)

func ayqhenaa (szmpglmk : String):
    var albhmnnb = fwaghbed.instantiate()
    urwxjsji.add_child(albhmnnb)
    albhmnnb.text = szmpglmk

func pzbqrzlt ():
    for node in urwxjsji.get_children():
        if node == wobbclky or node == xovoveis:
            continue
        node.queue_free()
    urwxjsji.custom_minimum_size = Vector2.ZERO
    
    gjhuurim.emit()
    
                  
    xbrhflmu.zuvupaax()
    
                            
    hwmbnwol = ""
    zwvlipzj  = ""
    atgzywjf = ""
    qmacwfnd  = ""
    ibggfdle = ""

func ygfnuzmj ():
    var nfaavqiq = vogbgpwb.hwsraesx()
    pzbqrzlt()
    
    for msg in nfaavqiq.messages:
        if msg.role == "user":
            azllavpr(msg.content)
        elif msg.role == "assistant":
            gsfepwlw(msg.content)
    
    ojissdqw(true)

func mcixjbfm(oepuequr: int):
    if oepuequr >= 0 and oepuequr < xnpirzsw.size():
        wgwlfzry.text += " " + xnpirzsw[oepuequr]
        qvgbaqtl.select(0)

func fgpcfrcl(rnlsxwvb):
    OS.shell_open(str(rnlsxwvb))

                                                
func gubkyjws(suriyxhe: String) -> String:
    
    var oyaajfen = RegEx.new()
                                 
    oyaajfen.compile("\\[gds_context\\](.|\\n)*?\\[/gds_context\\]")
    suriyxhe = oyaajfen.sub(suriyxhe, "", true)
    
                                       
    oyaajfen.compile("<internal_tool_use>(.|\\n)*?</internal_tool_use>")
    return oyaajfen.sub(suriyxhe, "", true)
    
                                                
func hjlnfwkq(uicwhkcs: String) -> String:
        
    var xnjnxczm = RegEx.new()
    xnjnxczm.compile("\\[gds_actions\\](.|\\n)*?\\[/gds_actions\\]")
    return xnjnxczm.sub(uicwhkcs, "", true)

func ghxcqeyf(ywospvtp: String):
    ywospvtp = ywospvtp.replace(notice_actions_nonthinking, '').replace(notice_actions_thinking, '').strip_edges()
    return ywospvtp
    
func frywqmsn(qxhfvijw: String, exsapuqj: PackedScene, qccqaaxi: Node, anzhkxit: PackedScene) -> void:
    
    qxhfvijw = qxhfvijw.strip_edges()
    qxhfvijw = gubkyjws(qxhfvijw)
    
                       
    var odcvqfec = onuavvgm.uyvgxpne(qxhfvijw)

    for block in odcvqfec:
        if block["type"] == "text":
            var qxcyqhvd = exsapuqj.instantiate()
            qxcyqhvd.bbcode_enabled = true
            qccqaaxi.add_child(qxcyqhvd)
            
            var jotwsgdx = block["content"]
            
                                                      
            jotwsgdx = onuavvgm.rhzzchtq(jotwsgdx)
            jotwsgdx = onuavvgm.dfneqola(jotwsgdx)
            jotwsgdx = jotwsgdx.strip_edges()
            
            qxcyqhvd.text = jotwsgdx

                                 
            if not qxcyqhvd.meta_clicked.is_connected(fgpcfrcl):
                qxcyqhvd.meta_clicked.connect(fgpcfrcl)

        elif block["type"] == "code":
            var cpzbhcdg = anzhkxit.instantiate()
            qccqaaxi.add_child(cpzbhcdg)
            cpzbhcdg.text = block["content"]

                           
func szzmmdvc() -> bool:
    var ypgenebo = Engine.get_singleton("EditorInterface") if Engine.is_editor_hint() else null
    atgzywjf = xbrhflmu.uchrkaka("", ypgenebo)
    qmacwfnd  = xbrhflmu.yvraehqz("", ypgenebo)

    var ykhcgdft = atgzywjf != hwmbnwol
    var ftycyvnu  = qmacwfnd  != zwvlipzj

    var ffrzajxy = []
    if ykhcgdft:
        ffrzajxy.append(atgzywjf)
    if ftycyvnu:
        ffrzajxy.append(qmacwfnd)

    ibggfdle = ""
    if ffrzajxy.size() > 0:
        ibggfdle = "[gds_context]Current project context:[/gds_context]\n" + "\n".join(ffrzajxy)

    return ykhcgdft or ftycyvnu

                               
func kyfbemzm() -> void:
    var oyadwgrp = not dzimgjhy.bctnbiyj()
    if oyadwgrp:
        hwwphnge()
        
func qtpwfesv():
    if eqddsvmp > 0:
        dzimgjhy.zquxxxqr(eqddsvmp, 5)
        xovoveis.visible = false                     

func nxtznyed():
    if eqddsvmp > 0:
        dzimgjhy.zquxxxqr(eqddsvmp, 1)
        xovoveis.visible = false
