                                                                 
@tool
extends Node

const golexchw = preload("res://addons/gamedev_assistant/scripts/actions/action_parser_utils.gd")

static func execute(ixkkgind: String, fzjgqsup: String, mexocbko: String) -> Dictionary:
    var miuribxv = EditorPlugin.new().get_editor_interface()
    var bdghzvsd = miuribxv.get_open_scenes()

                                   
    for scene in bdghzvsd:
        if scene == fzjgqsup:
                                                                         
            miuribxv.reload_scene_from_path(fzjgqsup)
            return jktddahc(ixkkgind, miuribxv.get_edited_scene_root(), mexocbko)

                                                        
                                                                   
    return nnewirsm(ixkkgind, fzjgqsup, mexocbko)

static func jktddahc(zairhrkr: String, kbwgmdtj: Node, idyybwnj: String) -> Dictionary:
    var ihmrlqpa = kbwgmdtj.find_child(zairhrkr, true, true)
    
    if not ihmrlqpa and zairhrkr == kbwgmdtj.name:
        ihmrlqpa = kbwgmdtj

    if not ihmrlqpa:
        var hiagobia = "Node '%s' not found in open scene root '%s'." % [zairhrkr, kbwgmdtj.name]
        push_error(hiagobia)
        return {"success": false, "error_message": hiagobia}

                       
    var gmqcnubj = load(idyybwnj)
    if not gmqcnubj:
        var hiagobia = "Failed to load script at path: %s" % idyybwnj
        push_error(hiagobia)
        return {"success": false, "error_message": hiagobia}

    ihmrlqpa.set_script(gmqcnubj)
    
                                                       
    if EditorInterface.save_scene() == OK:
        return {"success": true, "error_message": ""}
    else:
        var hiagobia = "Failed to save the scene."
        push_error(hiagobia)
        return {"success": false, "error_message": hiagobia}


static func nnewirsm(etfucbnj: String, mbqknwgi: String, dwtpeqvb: String) -> Dictionary:
    var khxpcejj = load(mbqknwgi)
    if not (khxpcejj is PackedScene):
        var lcqdogaq = "Failed to load scene '%s' as PackedScene." % mbqknwgi
        push_error(lcqdogaq)
        return {"success": false, "error_message": lcqdogaq}

    var tvfentig = khxpcejj.instantiate()
    if not tvfentig:
        var lcqdogaq = "Could not instantiate scene '%s'." % mbqknwgi
        push_error(lcqdogaq)
        return {"success": false, "error_message": lcqdogaq}

    var iwycinmf = tvfentig.find_child(etfucbnj, true, true)
    
    if not iwycinmf and etfucbnj == tvfentig.name:
        iwycinmf = tvfentig

    if not iwycinmf:
        var lcqdogaq = "Node '%s' not found in scene instance root '%s'." % [etfucbnj, tvfentig.name]
        push_error(lcqdogaq)
        return {"success": false, "error_message": lcqdogaq}

                       
    var sloqpokp = load(dwtpeqvb)
    if not sloqpokp:
        var lcqdogaq = "Failed to load script at path: %s" % dwtpeqvb
        push_error(lcqdogaq)
        return {"success": false, "error_message": lcqdogaq}

    iwycinmf.set_script(sloqpokp)

                                
    khxpcejj.pack(tvfentig)
    if ResourceSaver.save(khxpcejj, mbqknwgi) == OK:
        return {"success": true, "error_message": ""}
    else:
        var lcqdogaq = "Failed to save the packed scene."
        push_error(lcqdogaq)
        return {"success": false, "error_message": lcqdogaq}


                                                                             
                 
                                                                      
                                                                             
static func parse_line(epyoorsi: String, ptdxngts: String) -> Dictionary:
                                                         
    if epyoorsi.begins_with("assign_script("):
        var rgubfbli = epyoorsi.replace("assign_script(", "").replace(")", "").strip_edges()
        var vxhyijkt = []
        var qpqrczbg = 0
        while true:
            var owcxshez = rgubfbli.find('"',qpqrczbg)
            if owcxshez == -1:
                break
            var rwcvhkcq = rgubfbli.find('"', owcxshez + 1)
            if rwcvhkcq == -1:
                break
            vxhyijkt.append(rgubfbli.substr(owcxshez + 1, rwcvhkcq - owcxshez - 1))
            qpqrczbg = rwcvhkcq + 1

                                                                                
        if vxhyijkt.size() != 3:
            return {}

        return {
            "type": "assign_script",
            "node_name": vxhyijkt[0],
            "scene_path": vxhyijkt[1],
            "script_path": vxhyijkt[2]
        }

    return {}
