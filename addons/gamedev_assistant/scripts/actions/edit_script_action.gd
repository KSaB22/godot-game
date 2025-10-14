                                                                      
@tool
extends Node

const eirguyjb = preload("action_parser_utils.gd")

static func execute(jmqrayrp: String, cpqgirse: int, apwruvlm: Button, smqgtngd: Node) -> Variant:
                                      
    var bacsdmqb = FileAccess.open(jmqrayrp, FileAccess.READ)
    if not bacsdmqb:
        var wxygflfo = FileAccess.get_open_error()
        var yqiaxror = "Failed to load script: " + jmqrayrp + " (Error: " + error_string(wxygflfo) + ")"
        push_error(yqiaxror)
        return {"success": false, "error_message": yqiaxror}
    
                                
    var mvcmilsb = bacsdmqb.get_as_text()
    bacsdmqb.close()
        
                                                                                        
    smqgtngd.tpujdvrs(jmqrayrp, cpqgirse, mvcmilsb, apwruvlm)
    
                                                                                       
    return null

static func parse_line(xmjhkrdg: String, fqajvolp: String) -> Dictionary:
    if xmjhkrdg.begins_with("edit_script("):
        var eergjgrd = eirguyjb.pelqzjvy(xmjhkrdg)
        if not eergjgrd.is_empty():
            return {
                "type": "edit_script",
                "path": eergjgrd.get("path", ""),
                "message_id": eergjgrd.get("message_id", -1)
            }
    return {}
