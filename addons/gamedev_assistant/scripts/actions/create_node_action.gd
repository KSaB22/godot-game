                                                                 
@tool
extends Node

const qzhiubem = preload("action_parser_utils.gd")
const hgatkhki = preload("edit_node_action.gd")

static func execute(xuqkalux: String, avtvofzt: String, luzftdop: String, kkyizugu: String, venrrcym: Dictionary = {}) -> Dictionary:
    var iskkzyoh = EditorPlugin.new().get_editor_interface()
    var vyuunfde = iskkzyoh.get_open_scenes()
    
                                                             
    for scene in vyuunfde:
        if scene == luzftdop:
            print("Adding to open scene: ", scene)
            iskkzyoh.reload_scene_from_path(luzftdop)
            return xmlevmqy(xuqkalux, avtvofzt, iskkzyoh.get_edited_scene_root(), kkyizugu, venrrcym)

                                                                                                     
    print("Adding to closed scene: ", luzftdop)
    return tejfkvev(xuqkalux, avtvofzt, luzftdop, kkyizugu, venrrcym)

static func xmlevmqy(olvymeom: String, upcfygus: String, zbuyelgv: Node, gakhoefe: String, jghlvpdi: Dictionary = {}) -> Dictionary:
    if !ClassDB.class_exists(upcfygus):
        var qlzsthui = "Node type '%s' does not exist." % upcfygus
        push_error(qlzsthui)
        return {"success": false, "error_message": qlzsthui}
    var vgchcwwm = ClassDB.instantiate(upcfygus)
    vgchcwwm.name = olvymeom
    
                                                         
    var xwjbzcrg = zbuyelgv if (gakhoefe.is_empty() or gakhoefe == zbuyelgv.name) else zbuyelgv.find_child(gakhoefe, true, true)
    if not xwjbzcrg:
        var qlzsthui = "Parent node '%s' not found in scene." % gakhoefe
        push_error(qlzsthui)
        return {"success": false, "error_message": qlzsthui}
    
    xwjbzcrg.add_child(vgchcwwm)
    vgchcwwm.set_owner(zbuyelgv)
    
                                
    if not jghlvpdi.is_empty():
        var wkrzbobv = hgatkhki.lvxtkcwh(vgchcwwm, jghlvpdi, zbuyelgv)
        if not wkrzbobv.success:
            return wkrzbobv                                       
    
                                                  
    if EditorInterface.save_scene() == OK:
        return {"success": true, "error_message": ""}
    else:
        var qlzsthui = "Failed to save the scene."
        push_error(qlzsthui)
        return {"success": false, "error_message": qlzsthui}


static func tejfkvev(nxufcfvy: String, xiqlcmju: String, vdnjjqdh: String, dtistado: String, wmnkdmex: Dictionary = {}) -> Dictionary:
    var nuxgfyjr = load(vdnjjqdh)
    if !nuxgfyjr is PackedScene:
        var qitevuqs = "Failed to load scene '%s' as PackedScene." % vdnjjqdh
        push_error(qitevuqs)
        return {"success": false, "error_message": qitevuqs}
    
    var tgytbdrt = nuxgfyjr.instantiate()
    if !ClassDB.class_exists(xiqlcmju):
        var qitevuqs = "Node type '%s' does not exist." % xiqlcmju
        push_error(qitevuqs)
        return {"success": false, "error_message": qitevuqs}
    var fbbnmtrq = ClassDB.instantiate(xiqlcmju)
    fbbnmtrq.name = nxufcfvy
    
                                                         
    var hkksoggo = tgytbdrt if (dtistado.is_empty() or dtistado == tgytbdrt.name) else tgytbdrt.find_child(dtistado, true, true)
    if not hkksoggo:
        var qitevuqs = "Parent node '%s' not found in nuxgfyjr." % dtistado
        push_error(qitevuqs)
        return {"success": false, "error_message": qitevuqs}
    
    hkksoggo.add_child(fbbnmtrq)
    fbbnmtrq.set_owner(tgytbdrt)
    
                                
    if not wmnkdmex.is_empty():
        var tcaqsiiq = hgatkhki.lvxtkcwh(fbbnmtrq, wmnkdmex, tgytbdrt)
        if not tcaqsiiq.success:
            return tcaqsiiq                                       
    
                                                          
    nuxgfyjr.pack(tgytbdrt)

    if ResourceSaver.save(nuxgfyjr, vdnjjqdh) == OK:
        return {"success": true, "error_message": ""}
    else:
        var qitevuqs = "Failed to save the packed scene."
        push_error(qitevuqs)
        return {"success": false, "error_message": qitevuqs}

static func parse_line(fpatqmfj: String, dwwzfbdp: String) -> Dictionary:
    if fpatqmfj.begins_with("create_node("):
                                                                              
        var mdntxldg = qzhiubem.sqmjqpyy(fpatqmfj)
        if mdntxldg.size() < 3:
            return {}
        
                                                                 
        var msrvfmlr = {}
        var kwghzfwz = fpatqmfj.find("{")
        var vjcaqrux = fpatqmfj.rfind("}")
        
        if kwghzfwz != -1 and vjcaqrux != -1:
            var xrmdlufo = fpatqmfj.substr(kwghzfwz, vjcaqrux - kwghzfwz + 1)
            msrvfmlr = qzhiubem.mzcbydau(xrmdlufo)
        
        return {
            "type": "create_node",
            "name": mdntxldg[0],
            "node_type": mdntxldg[1],
            "scene_path": mdntxldg[2],
            "parent_path": mdntxldg[3] if mdntxldg.size() > 3 else "",
            "modifications": msrvfmlr
        }
    return {}
