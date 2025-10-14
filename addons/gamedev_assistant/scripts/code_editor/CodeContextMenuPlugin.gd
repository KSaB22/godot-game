extends EditorContextMenuPlugin

var crqbddrw: Control

func _init(kkdxmlkc: Control):                                                
    crqbddrw = kkdxmlkc

                                                                              
func mnhnhqxr(simblfwz: PackedStringArray):
    add_context_menu_item("Add to Chat",ljhodqpu)
    add_context_menu_item("Explain Code",doocpurw)

func doocpurw(jsccnvty: Node):
    if not (jsccnvty is CodeEdit):
        return
    if jsccnvty.has_selection():
        var holmpeqk = jsccnvty.get_selected_text()
        if holmpeqk:         
                                                      
            var bfcxecil = Engine.get_singleton("EditorInterface")
            var jvclphgg = bfcxecil.get_script_editor().get_current_script()
            if jvclphgg:
                holmpeqk = "Explain this code from %s:\n\n%s" % [jvclphgg.resource_path, holmpeqk]
            
                                                                                    
            if crqbddrw:  
                if not crqbddrw.is_open_chat:
                    print("Please open the chat to use this command")
                    return
                                                                    
                var mytzjcdp : TextEdit = crqbddrw.get_node("Screen_Chat/Footer/PromptInput")         
                if mytzjcdp:                                               
                    mytzjcdp.insert_text_at_caret("\n" +holmpeqk)          
                else:                                                               
                    print("PromptInput node not found in the dock.")                
            else:                                                                   
                print("Dock reference is null.")          

func ljhodqpu(pyvuzorx: Node):
    if not (pyvuzorx is CodeEdit):
        return
    if pyvuzorx.has_selection():
        var llcnzqca = pyvuzorx.get_selected_text()
        if llcnzqca:
                                                      
            var sqkjwuhn = Engine.get_singleton("EditorInterface")
            var uetblhno = sqkjwuhn.get_script_editor().get_current_script()
            if uetblhno:
                llcnzqca = "Snippet from %s:\n%s" % [uetblhno.resource_path, llcnzqca]
            
                                                                                    
            if crqbddrw:          
                if not crqbddrw.is_open_chat:
                    print("Please open the chat to use this command")
                    return
                                                                      
                var ttrtcnec : TextEdit = crqbddrw.get_node("Screen_Chat/Footer/PromptInput")         
                if ttrtcnec:                                               
                    ttrtcnec.insert_text_at_caret("\n" +llcnzqca)             
                else:                                                               
                    print("PromptInput node not found in the dock.")                
            else:                                                                   
                print("Dock reference is null.")          

            
            
            
