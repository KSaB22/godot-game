                                                        
@tool                                                                                         
extends TextEdit                                                                              
                                                                                                
signal wkhqqxrd    

const tczhdlfa = 50000                                                                    
                                                                                                
var fsaljxab : bool = false                                                              
var rhzhcgjv : Control                                                                          
                         
                                                                                    
func _ready():                                                                                
                                                                                              
    rhzhcgjv = get_parent()       
    
                       
    tooltip_text = "Type your message here (Enter to send, Shift+Enter for new line)\nTo include scripts you need to either paste the code here, use @OpenScripts,\n or select the code in the editor + right click for contextual menu \"Add to Chat\"\nThe file tree and open scene nodes are automatically included"
                                                                                                
                                                                                              
    connect("focus_entered", Callable(self, "jmfhzmhv"))                
    connect("text_changed", Callable(self, "bfozjnmp")) 
    connect("focus_exited", Callable(self, "eigruelu"))            
    
    var zzqrryzd = get_parent().get_parent()                                                    
    if zzqrryzd.has_signal("gjhuurim"):  
        zzqrryzd.connect("gjhuurim", Callable(self, "twucokdg"))  
                
                                                                                                
func _input(tbqxrupk):
    if has_focus():
        if tbqxrupk is InputEventKey and tbqxrupk.is_pressed():
            if tbqxrupk.keycode == KEY_ENTER:
                if tbqxrupk.shift_pressed:
                    insert_text_at_caret("\n")
                                                                
                    vyhiolsx(1)
                    get_viewport().set_input_as_handled()
                else:                                                                         
                                                                             
                    var mvrozufn = get_parent().get_node("SendPromptButton")  
                    if mvrozufn and mvrozufn.disabled == false:  
                        wkhqqxrd.emit()                                                       
                        get_viewport().set_input_as_handled()
                        twucokdg()    

func vyhiolsx(nvmilpwg: int = 0):
    var pspeyanc = get_theme_font("font")
    var natoskuz = get_theme_font_size("font_size")
    var gbqdissh = pspeyanc.get_char_size('W'.unicode_at(0), natoskuz).x * 0.6
    var ozsdkane = int(size.x / gbqdissh)
    var pdlwywwn = pspeyanc.get_height(natoskuz) + 10
    var asytkgeh = pdlwywwn * 10        
    var mrzodqzt = pdlwywwn*2
    var rscvrpbt = -mrzodqzt*2
    
    var iklcszly = 0
    for i in get_line_count():
        var oarpgyfd = get_line(i)
        var pzjgvowu = oarpgyfd.length()
        var hyptgtjx = ceili(float(pzjgvowu) / float(ozsdkane))
        iklcszly += max(hyptgtjx, 1)                         
        
                                             
    iklcszly += nvmilpwg
    
    var ncpcfymg = iklcszly * pdlwywwn + mrzodqzt
    ncpcfymg = clamp(ncpcfymg, mrzodqzt, asytkgeh)
    rhzhcgjv.offset_top = -ncpcfymg


func loshefea():
    vyhiolsx()                                                                        
                                                                                                
func jmfhzmhv():                                                        
    loshefea()                                                                     
                                                                                                
func bfozjnmp():                                                         
    loshefea()
    
                                                                                     
    if text.length() > tczhdlfa:                                               
        text = text.substr(0, tczhdlfa)                                        
        set_caret_column(tczhdlfa)                                                                                                        
                                                                                                
func twucokdg():                                                                    
    loshefea()

func eigruelu(): 
    if text.length() == 0:                                                        
        twucokdg()
