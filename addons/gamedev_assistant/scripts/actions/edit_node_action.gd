                                                               
@tool
extends Node

const jxzoxokf = preload("action_parser_utils.gd")

static func execute(mdeyjsgy: String, qvxsmhll: String, kozabkys: Dictionary) -> Dictionary:
    var jwltrmxh = EditorPlugin.new().get_editor_interface()
    var iougskbj = jwltrmxh.get_open_scenes()

                                   
    for scene in iougskbj:
        if scene == qvxsmhll:
                                                     
            jwltrmxh.reload_scene_from_path(qvxsmhll)
                                                             
            return ptraorhn(mdeyjsgy, jwltrmxh.get_edited_scene_root(), kozabkys)

                                                        
                                               
    return ryrlzske(mdeyjsgy, qvxsmhll, kozabkys)


static func ptraorhn(kjjfnnej: String, qchyfpng: Node, pppvdjrp: Dictionary) -> Dictionary:
    var aphbxegz = qchyfpng.find_child(kjjfnnej, true, true)
    
    if not aphbxegz and kjjfnnej == qchyfpng.name:
        aphbxegz = qchyfpng

    if not aphbxegz:
        var ydmmvjmx = "Node '%s' not found in open scene root '%s'." % [kjjfnnej, qchyfpng.name]
        push_error(ydmmvjmx)
        return {"success": false, "error_message": ydmmvjmx, "node_type": ""}

                                                 
    var ahkzafes = lvxtkcwh(aphbxegz, pppvdjrp, qchyfpng)
    if not ahkzafes.success:
        return {"success": false, "error_message": ahkzafes.error_message, "node_type": aphbxegz.get_class()}
        
                                                  
    if EditorInterface.save_scene() == OK:
        return {"success": true, "error_message": "", "node_type": aphbxegz.get_class()}
    else:
        var ydmmvjmx = "Failed to save the scene."
        push_error(ydmmvjmx)
        return {"success": false, "error_message": ydmmvjmx, "node_type": aphbxegz.get_class()}


static func ryrlzske(fwuvchgd: String, rhrhautd: String, pprhvnwv: Dictionary) -> Dictionary:
    var lnxwmtgc = load(rhrhautd)
    if !(lnxwmtgc is PackedScene):
        var gsqqmsvw = "Failed to load scene '%s' as PackedScene." % rhrhautd
        push_error(gsqqmsvw)
        return {"success": false, "error_message": gsqqmsvw, "node_type": ""}

    var xjrdrpyf = lnxwmtgc.instantiate()
    if not xjrdrpyf:
        var gsqqmsvw = "Could not instantiate scene '%s'." % rhrhautd
        push_error(gsqqmsvw)
        return {"success": false, "error_message": gsqqmsvw, "node_type": ""}

    var fwrvcypx = xjrdrpyf.find_child(fwuvchgd, true, true)
    
    if not fwrvcypx and fwuvchgd == xjrdrpyf.name:
        fwrvcypx = xjrdrpyf

    if not fwrvcypx:
        var gsqqmsvw = "Node '%s' not found in scene instance root '%s'." % [fwuvchgd, xjrdrpyf.name]
        push_error(gsqqmsvw)
        return {"success": false, "error_message": gsqqmsvw, "node_type": ""}

                                                        
    var tnsguumy = lvxtkcwh(fwrvcypx, pprhvnwv, xjrdrpyf)
    if not tnsguumy.success:
        return {"success": false, "error_message": tnsguumy.error_message, "node_type": fwrvcypx.get_class()}

                                
    lnxwmtgc.pack(xjrdrpyf)
    if ResourceSaver.save(lnxwmtgc, rhrhautd) == OK:
        return {"success": true, "error_message": "", "node_type": fwrvcypx.get_class()}
    else:
        var gsqqmsvw = "Failed to save the packed scene."
        push_error(gsqqmsvw)
        return {"success": false, "error_message": gsqqmsvw, "node_type": fwrvcypx.get_class()}


static func lvxtkcwh(gcxiutiq: Node, gyqtuhaw: Dictionary, dkaefvir: Node = null) -> Dictionary:
    for property_name in gyqtuhaw.keys():
        var ovmlizih = gyqtuhaw[property_name]
        var sgtgrrvx = _parse_value(ovmlizih)
        if sgtgrrvx == null and ovmlizih != null:
            var szjmylxo = "Failed to parse value '%s' for property '%s'." % [str(ovmlizih), property_name]
            push_error(szjmylxo)
            return {"success": false, "error_message": szjmylxo}
            
                                     
                                                                                                           
                                                             
        var wvlkpmme = _try_set_property(gcxiutiq, property_name, sgtgrrvx, dkaefvir)
        if not wvlkpmme:
                                                                       
            var szjmylxo = "Failed to set property '%s' on node '%s'." % [property_name, gcxiutiq.name]
            return {"success": false, "error_message": szjmylxo}

    return {"success": true, "error_message": ""}

static func _parse_value(rwwyinra) -> Variant:
                                                                                            
    if rwwyinra is String:
        var hbqdtkig = rwwyinra.strip_edges()
        
                                                        
        if hbqdtkig.length() >= 2 and hbqdtkig.begins_with('"') and hbqdtkig.ends_with('"'):
            hbqdtkig = hbqdtkig.substr(1, hbqdtkig.length() - 2)
        elif hbqdtkig.length() >= 2 and hbqdtkig.begins_with("'") and hbqdtkig.ends_with("'"):
            hbqdtkig = hbqdtkig.substr(1, hbqdtkig.length() - 2)
        
        if hbqdtkig.begins_with("(") and hbqdtkig.ends_with(")"):
            var abqlhusc = hbqdtkig.substr(1, hbqdtkig.length() - 2)
            var uwlxhgll = abqlhusc.split(",", false)
                                                  
            if uwlxhgll.size() == 2:
                var efedkhhv = float(uwlxhgll[0].strip_edges())
                var ovqnuyfr = float(uwlxhgll[1].strip_edges())
                return Vector2(efedkhhv, ovqnuyfr)
                                                  
            if uwlxhgll.size() == 3:
                var lefnbtct = float(uwlxhgll[0].strip_edges())
                var fblrlimv = float(uwlxhgll[1].strip_edges())
                var jkgjeqec = float(uwlxhgll[2].strip_edges())
                return Vector3(lefnbtct, fblrlimv, jkgjeqec)
                                                  
            if uwlxhgll.size() == 4:
                var fdnxkggx = float(uwlxhgll[0].strip_edges())
                var cqecbzdl = float(uwlxhgll[1].strip_edges())
                var jvrsgnyv = float(uwlxhgll[2].strip_edges())
                var shlodfeo = float(uwlxhgll[3].strip_edges())
                return Vector4(fdnxkggx, cqecbzdl, jvrsgnyv, shlodfeo)
                               
        if hbqdtkig.to_lower() == "true":
            return true
        if hbqdtkig.to_lower() == "false":
            return false
                                
        if hbqdtkig.is_valid_float():
            return float(hbqdtkig)
                                                
        return hbqdtkig

                                                             
    return rwwyinra

static func hhubvunp(vvjdooyb: String, mnabgcdg: String) -> String:
    var riisjlbv = ""
    var vjiohvhg = vvjdooyb.length()
    var atphrsls = mnabgcdg.length()
    var cwnlciiu = min(vjiohvhg, atphrsls)

    for i in range(cwnlciiu):
        if vvjdooyb[i] != mnabgcdg[i]:
            riisjlbv += "Difference at index: " + str(i) + ", String1: " + vvjdooyb[i] + ", String2: " + mnabgcdg[i]
            break

    return riisjlbv


static func _try_set_property(ifhrynma: Node, mrkpyqru: String, gkqoodgw: Variant, yhhdvfmt: Node = null) -> bool:  
                                      
    if mrkpyqru == "parent":
        if not gkqoodgw is String:
            push_error("Parent value must be a string (name of the new parent)")
            return false

        if yhhdvfmt == null:
            push_error("Cannot re-parent without a valid scene root.")
            return false

        var pxvgostj = gkqoodgw.strip_edges()
        var agctgjvy: Node

                                                 
                                                                          
        if pxvgostj == "" or pxvgostj == yhhdvfmt.name:
            agctgjvy = yhhdvfmt
        else:
            agctgjvy = yhhdvfmt.find_child(pxvgostj, true, true)
            if not agctgjvy:
                push_error("Failed to find parent node with name: %s" % pxvgostj)
                return false
        
                   
        if ifhrynma.get_parent():
            ifhrynma.get_parent().remove_child(ifhrynma)
        agctgjvy.add_child(ifhrynma)

                                                                          
        ifhrynma.set_owner(yhhdvfmt)

        return true

                                      
    var dujmxflr = ifhrynma.get_property_list()
    for prop in dujmxflr:
        if prop.name == mrkpyqru:
                        
            if prop.type == TYPE_COLOR:
                match typeof(gkqoodgw):
                    TYPE_VECTOR2:
                                                            
                        gkqoodgw = Color(gkqoodgw.x, gkqoodgw.y, 0, 1.0)
                    TYPE_VECTOR3:
                                                                
                        gkqoodgw = Color(gkqoodgw.x, gkqoodgw.y, gkqoodgw.z, 1.0)
                    TYPE_VECTOR4:
                        gkqoodgw = Color(gkqoodgw.x, gkqoodgw.y, gkqoodgw.z, gkqoodgw.w)
                    TYPE_ARRAY:
                                                                                                  
                        if gkqoodgw.size() == 3:
                            gkqoodgw = Color(gkqoodgw[0], gkqoodgw[1], gkqoodgw[2], 1.0)
                        elif gkqoodgw.size() == 4:
                            gkqoodgw = Color(gkqoodgw[0], gkqoodgw[1], gkqoodgw[2], gkqoodgw[3])

                                                                       
            elif prop.type == TYPE_OBJECT and prop.hint == PROPERTY_HINT_RESOURCE_TYPE:
                var vlplxhor = prop.hint_string
                
                                           
                if vlplxhor == "Texture2D" or vlplxhor.contains("Texture2D"):
                    var bfmxrrdq = load(gkqoodgw)

                                                                                        
                    if "_" in mrkpyqru:
                        var djimkvoj = mrkpyqru.split("_")
                        if djimkvoj.size() > 1:
                            var cobruwkx = djimkvoj[1]
                            var rnmjkkgp = "set_texture_" + cobruwkx
                            if ifhrynma.has_method(rnmjkkgp):
                                ifhrynma.call(rnmjkkgp, bfmxrrdq)
                                return true

                                                                           
                    if ifhrynma.has_method("set_texture"):
                        ifhrynma.set_texture(bfmxrrdq)
                        return true
                        
                                             
                elif vlplxhor == "Mesh" or vlplxhor.contains("Mesh"):
                    var rkoohnul = load(gkqoodgw)
                    if not rkoohnul:
                        push_error("Failed to load mesh at path: %s" % gkqoodgw)
                        return false
                    
                    if "_" in mrkpyqru:
                        var djimkvoj = mrkpyqru.split("_")
                        if djimkvoj.size() > 1:
                            var cobruwkx = djimkvoj[1]
                            var rnmjkkgp = "set_mesh_" + cobruwkx
                            if ifhrynma.has_method(rnmjkkgp):
                                ifhrynma.call(rnmjkkgp, rkoohnul)
                                return true
                    
                    ifhrynma.set(mrkpyqru, rkoohnul)
                    return true
                
                                                
                elif vlplxhor == "AudioStream" or vlplxhor.contains("AudioStream"):
                    var mvfgbmyr = load(gkqoodgw)
                    if not mvfgbmyr:
                        push_error("Failed to load audio stream at path: %s" % gkqoodgw)
                        return false
                    ifhrynma.set(mrkpyqru, mvfgbmyr)
                    return true



                                                                 
    if not ifhrynma.has_method("get") or ifhrynma.get(mrkpyqru) == null:
        push_error("Property '%s' doesn't exist on node '%s'." % [mrkpyqru, ifhrynma.name])
        return false

                                    
    ifhrynma.set(mrkpyqru, gkqoodgw)

                                                               
                                                          
    return true


                                                                             
                 
                                                                      
                                                                             
static func parse_line(ghehgmtp: String, ivbrystz: String) -> Dictionary:
                                                     
    if ghehgmtp.begins_with("edit_node("):
        var cdjepmvu = jxzoxokf.rtascdls(ghehgmtp)
                                                            
        if cdjepmvu.size() == 0:
            return {}
        if not cdjepmvu.has("node_name") \
            or not cdjepmvu.has("scene_path") \
            or not cdjepmvu.has("modifications"):
            return {}

        return {
            "type": "edit_node",
            "node_name": cdjepmvu.node_name,
            "scene_path": cdjepmvu.scene_path,
            "modifications": cdjepmvu.modifications
        }

    return {}
