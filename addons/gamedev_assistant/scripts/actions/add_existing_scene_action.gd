                                                                 
@tool
extends Node

const bscgqzoe = preload("action_parser_utils.gd")
const eyjkrzbt = preload("edit_node_action.gd")

static func execute(hbkcpslc: String, lqbzwlml: String, wmjqnptv: String, iiuclslj: String, pxhqfoys: Dictionary) -> Dictionary:
    var muakdmss = EditorPlugin.new().get_editor_interface()
    var bpspjexi = muakdmss.get_open_scenes()
    
    var lepmbjee = load(lqbzwlml)
    if not lepmbjee is PackedScene:
        var vtobbviv = "Invalid or non-existent scene file: " + lqbzwlml
        push_error(vtobbviv)
        return {"success": false, "error_message": vtobbviv}
    
    if wmjqnptv in bpspjexi:
        return jqzoofbi(hbkcpslc, lepmbjee, wmjqnptv, iiuclslj, pxhqfoys)
    else:
        return hupfhzui(hbkcpslc, lepmbjee, wmjqnptv, iiuclslj, pxhqfoys)

static func jqzoofbi(ukmvgeox: String, efaotdwz: PackedScene, askoqudc: String, qubjpckr: String, twhqehxe: Dictionary) -> Dictionary:
    var csyqylbv = EditorPlugin.new().get_editor_interface()
    csyqylbv.reload_scene_from_path(askoqudc)
    var lbxjbgmh = csyqylbv.get_edited_scene_root()
    
    var jpdmtjus = lbxjbgmh if (qubjpckr.is_empty() or qubjpckr == lbxjbgmh.name) else lbxjbgmh.find_child(qubjpckr, true, true)
    if not jpdmtjus:
        var cjuajyrd = "Parent node '%s' not found in scene '%s'." % [qubjpckr, askoqudc]
        push_error(cjuajyrd)
        return {"success": false, "error_message": cjuajyrd}
    
    var xprpoaib = efaotdwz.instantiate()
    xprpoaib.name = ukmvgeox
    jpdmtjus.add_child(xprpoaib)
    xprpoaib.set_owner(lbxjbgmh)
    
    if not twhqehxe.is_empty():
        var xjdmsnnj = eyjkrzbt.lvxtkcwh(xprpoaib, twhqehxe, lbxjbgmh)
        if not xjdmsnnj.success:
            return xjdmsnnj                                       
    
    if EditorPlugin.new().get_editor_interface().save_scene() == OK:
        return {"success": true, "error_message": ""}
    else:
        var cjuajyrd = "Failed to save scene '%s'." % askoqudc
        push_error(cjuajyrd)
        return {"success": false, "error_message": cjuajyrd}


static func hupfhzui(zjjsxppq: String, ksztjwoj: PackedScene, nrhnprgo: String, gqwkhngm: String, iqtcsxij: Dictionary) -> Dictionary:
    var rfkcdkwp = load(nrhnprgo)
    if not rfkcdkwp is PackedScene:
        var slbfgrkt = "Invalid or non-existent target scene: " + nrhnprgo
        push_error(slbfgrkt)
        return {"success": false, "error_message": slbfgrkt}
    
    var qabkvubu = rfkcdkwp.instantiate()
    var rtwfrizn = qabkvubu if (gqwkhngm.is_empty() or gqwkhngm == qabkvubu.name) else qabkvubu.find_child(gqwkhngm, true, true)
    if not rtwfrizn:
        var slbfgrkt = "Parent node '%s' not found in scene '%s'." % [gqwkhngm, nrhnprgo]
        push_error(slbfgrkt)
        return {"success": false, "error_message": slbfgrkt}
    
    var egkhcmet = ksztjwoj.instantiate()
    egkhcmet.name = zjjsxppq
    rtwfrizn.add_child(egkhcmet)
    egkhcmet.set_owner(qabkvubu)
    
    if not iqtcsxij.is_empty():
        var iiavrjnl = eyjkrzbt.lvxtkcwh(egkhcmet, iqtcsxij, qabkvubu)
        if not iiavrjnl.success:
            return iiavrjnl                                       
    
    rfkcdkwp.pack(qabkvubu)
    if ResourceSaver.save(rfkcdkwp, nrhnprgo) == OK:
        return {"success": true, "error_message": ""}
    else:
        var slbfgrkt = "Failed to save packed scene '%s'." % nrhnprgo
        push_error(slbfgrkt)
        return {"success": false, "error_message": slbfgrkt}

static func parse_line(igaojdue: String, qsrqapkz: String) -> Dictionary:
    if igaojdue.begins_with("add_existing_scene("):
        var youhxirg = igaojdue.replace("add_existing_scene(", "").strip_edges()
        if youhxirg.ends_with(")"):
            youhxirg = youhxirg.substr(0, youhxirg.length() - 1).strip_edges()
        
        var iusjpxkl = []
        var vlgvwdep = 0
                                             
        for _i in range(4):
            var cgwnmdxi = youhxirg.find('"',vlgvwdep)
            if cgwnmdxi == -1: return {}
            var ukqcttlh = youhxirg.find('"', cgwnmdxi + 1)
            if ukqcttlh == -1: return {}
            iusjpxkl.append(youhxirg.substr(cgwnmdxi + 1, ukqcttlh - cgwnmdxi - 1))
            vlgvwdep = ukqcttlh + 1
        
                                        
        var rudgebmc = {}
        var zgbesbta = youhxirg.substr(vlgvwdep).strip_edges()
        if zgbesbta.begins_with("{"):
            rudgebmc = bscgqzoe.mzcbydau(zgbesbta)
        
        return {
            "type": "add_existing_scene",
            "node_name": iusjpxkl[0],
            "existing_scene_path": iusjpxkl[1],
            "target_scene_path": iusjpxkl[2],
            "parent_path": iusjpxkl[3],
            "modifications": rudgebmc
        }
    return {}
