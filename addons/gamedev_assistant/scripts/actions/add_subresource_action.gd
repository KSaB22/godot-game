                                                                     
@tool
extends Node

const kcrdycja = preload("action_parser_utils.gd")

static func execute(xosurqhj: String, cufaxteh: String, spkwakxv: String, bppkqcrb: Dictionary) -> Dictionary:
    var khactyts = EditorPlugin.new().get_editor_interface()
    var bfzviumz = khactyts.get_open_scenes()

                                   
    for scene in bfzviumz:
        if scene == cufaxteh:
                                                                   
            khactyts.reload_scene_from_path(cufaxteh)
            return _add_to_open_scene(xosurqhj, khactyts.get_edited_scene_root(), spkwakxv, bppkqcrb)

                                           
                                                             
    return _add_to_closed_scene(xosurqhj, cufaxteh, spkwakxv, bppkqcrb)


static func _add_to_open_scene(zofhncyv: String, ytlrdhid: Node, budiugwj: String, nnupsaws: Dictionary) -> Dictionary:
    var zijrlwza = easygmos(zofhncyv, ytlrdhid)
    if not zijrlwza:
        return {"success": false, "error_message": "Node '%s' not found." % zofhncyv, "node_type": ""}

    var ytrbuvcf = vsbkysnp(budiugwj, nnupsaws)
    if not ytrbuvcf:
                                       
        return {"success": false, "error_message": "Could not create or configure resource '%s'." % budiugwj, "node_type": zijrlwza.get_class()}

    if not nnupsaws.has("assign_to_property"):
        var jytlhvmx = "No 'assign_to_property' field in nnupsaws dictionary."
        push_error(jytlhvmx)
        return {"success": false, "error_message": jytlhvmx, "node_type": zijrlwza.get_class()}

    var yqjupncj = String(nnupsaws["assign_to_property"])
    if not lkwhjycv(zijrlwza, yqjupncj, ytrbuvcf):
                                       
        var jytlhvmx = "Failed to assign new resource to property '%s'." % yqjupncj
        return {"success": false, "error_message": jytlhvmx, "node_type": zijrlwza.get_class()}

    if EditorInterface.save_scene() == OK:
        return {"success": true, "error_message": "", "node_type": zijrlwza.get_class()}
    else:
        var jytlhvmx = "Failed to save the scene."
        push_error(jytlhvmx)
        return {"success": false, "error_message": jytlhvmx, "node_type": zijrlwza.get_class()}

static func _add_to_closed_scene(tfudqxrf: String, elmhrgrr: String, ngskmgns: String, tgafcjud: Dictionary) -> Dictionary:
    var tnbyskyu = load(elmhrgrr)
    if !(tnbyskyu is PackedScene):
        var pmuzvuhr = "Failed to load scene '%s' as PackedScene." % elmhrgrr
        push_error(pmuzvuhr)
        return {"success": false, "error_message": pmuzvuhr, "node_type": ""}

    var vntovczw = tnbyskyu.instantiate()
    if not vntovczw:
        var pmuzvuhr = "Could not instantiate scene '%s'." % elmhrgrr
        push_error(pmuzvuhr)
        return {"success": false, "error_message": pmuzvuhr, "node_type": ""}

    var xawmgkzy = easygmos(tfudqxrf, vntovczw)
    if not xawmgkzy:
        return {"success": false, "error_message": "Node '%s' not found." % tfudqxrf, "node_type": ""}

    var llhkpgpl = vsbkysnp(ngskmgns, tgafcjud)
    if not llhkpgpl:
        return {"success": false, "error_message": "Could not create or configure resource '%s'." % ngskmgns, "node_type": xawmgkzy.get_class()}

    if not tgafcjud.has("assign_to_property"):
        var pmuzvuhr = "No 'assign_to_property' field in tgafcjud dictionary."
        push_error(pmuzvuhr)
        return {"success": false, "error_message": pmuzvuhr, "node_type": xawmgkzy.get_class()}

    var qysaunxm = String(tgafcjud["assign_to_property"])
    if not lkwhjycv(xawmgkzy, qysaunxm, llhkpgpl):
        var pmuzvuhr = "Failed to assign new resource to property '%s'." % qysaunxm
        return {"success": false, "error_message": pmuzvuhr, "node_type": xawmgkzy.get_class()}

    tnbyskyu.pack(vntovczw)
    if ResourceSaver.save(tnbyskyu, elmhrgrr) == OK:
        return {"success": true, "error_message": "", "node_type": xawmgkzy.get_class()}
    else:
        var pmuzvuhr = "Failed to save the packed scene."
        push_error(pmuzvuhr)
        return {"success": false, "error_message": pmuzvuhr, "node_type": xawmgkzy.get_class()}

                                                                             
         
                                                                             
static func easygmos(leayzjmi: String, gditjtse: Node) -> Node:
    var ozssdllc = gditjtse.find_child(leayzjmi, true, true)
    if not ozssdllc and leayzjmi == gditjtse.name:
        ozssdllc = gditjtse

    if not ozssdllc:
        push_error("Node '%s' not found in the scene." % leayzjmi)
        return null

    return ozssdllc


static func vsbkysnp(ywjxqmin: String, dmmrwewt: Dictionary) -> Resource:
    if not ClassDB.class_exists(ywjxqmin):
        push_error("Resource type '%s' does not exist." % ywjxqmin)
        return null

    var idugouge = ClassDB.instantiate(ywjxqmin)
    if not idugouge:
        push_error("Could not instantiate resource of type '%s'." % ywjxqmin)
        return null

                                                                  
    for property_name in dmmrwewt.keys():
        if property_name == "assign_to_property":
            continue

        var vypuhuuj = dmmrwewt[property_name]
        var hbybhbxe = _parse_value(vypuhuuj)
        if hbybhbxe == null and vypuhuuj != null:
            push_error("Failed to parse value '%s' for property '%s'." % [str(vypuhuuj), property_name])
            return null

        if not stldjbum(idugouge, property_name, hbybhbxe):
            return null

    return idugouge


static func _parse_value(twihpsog) -> Variant:
                                                             
    if twihpsog is String:
        var zbvkopcz = twihpsog.strip_edges()
                                                 
        if zbvkopcz.begins_with("(") and zbvkopcz.ends_with(")"):
            var jfsnpxwt = zbvkopcz.substr(1, zbvkopcz.length() - 2)
            var qikytknk = jfsnpxwt.split(",", false)
            if qikytknk.size() == 2:
                return Vector2(float(qikytknk[0].strip_edges()), float(qikytknk[1].strip_edges()))
            elif qikytknk.size() == 3:
                return Vector3(float(qikytknk[0].strip_edges()), float(qikytknk[1].strip_edges()), float(qikytknk[2].strip_edges()))
            elif qikytknk.size() == 4:
                return Vector4(float(qikytknk[0].strip_edges()), float(qikytknk[1].strip_edges()), float(qikytknk[2].strip_edges()), float(qikytknk[3].strip_edges()))
        if zbvkopcz.to_lower() == "true":
            return true
        if zbvkopcz.to_lower() == "false":
            return false
        if zbvkopcz.is_valid_float():
            return float(zbvkopcz)
                                       
        return zbvkopcz

                                                                  
    return twihpsog


static func lkwhjycv(uzxaaskn: Node, ybihsxch: String, cjkxbpca: Variant) -> bool:
    var zrwrpytk = uzxaaskn.get(ybihsxch)
    var gpxoddmf = true
                                                                                          
                                                                                                        
                                         
      
                                                                                                            
                                                                 

                    
    uzxaaskn.set(ybihsxch, cjkxbpca)
                                               
    if uzxaaskn.get(ybihsxch) != cjkxbpca:
        push_error("Failed to set property '%s' on node '%s' value: %s." % [ybihsxch, uzxaaskn.name, cjkxbpca])
        gpxoddmf = false
                          
    return gpxoddmf


static func stldjbum(eutbwznw: Resource, dtrwenis: String, fphcgnda: Variant) -> bool:
                                                    
    var cudzogdp = eutbwznw.get_property_list()
    var gxnginxq = null

                                           
    for prop_info in cudzogdp:
        if prop_info.name == dtrwenis:
            gxnginxq = prop_info.type
            break

                                              
    if gxnginxq == null:
        push_error("Property '%s' doesn't exist on resource '%s'." % [dtrwenis, eutbwznw.get_class()])
        return true                                                              

                                                                                 
                                         
    if gxnginxq == TYPE_COLOR:
        match typeof(fphcgnda):
            TYPE_VECTOR2:
                                                    
                fphcgnda = Color(fphcgnda.x, fphcgnda.y, 0, 1.0)
            TYPE_VECTOR3:
                                                        
                fphcgnda = Color(fphcgnda.x, fphcgnda.y, fphcgnda.z, 1.0)
            TYPE_VECTOR4:
                                                        
                fphcgnda = Color(fphcgnda.x, fphcgnda.y, fphcgnda.z, fphcgnda.w)
            TYPE_ARRAY:
                                                                                         
                if fphcgnda.size() == 3:
                    fphcgnda = Color(fphcgnda[0], fphcgnda[1], fphcgnda[2], 1.0)
                elif fphcgnda.size() == 4:
                    fphcgnda = Color(fphcgnda[0], fphcgnda[1], fphcgnda[2], fphcgnda[3])
                                                                       
                                           
            
                                                                    
    elif gxnginxq == TYPE_VECTOR3 and typeof(fphcgnda):
        fphcgnda = Vector3(fphcgnda.x, fphcgnda.y, 0)

                    
    eutbwznw.set(dtrwenis, fphcgnda)

                                                   
    var zgksoivk = eutbwznw.get(dtrwenis)
    
    var kqclsnqa : bool
    
    if typeof(fphcgnda) in [TYPE_VECTOR2, TYPE_VECTOR3, TYPE_VECTOR4]:
        if typeof(zgksoivk) == typeof(fphcgnda):
            kqclsnqa = zgksoivk.is_equal_approx(fphcgnda)
        else:
            push_error("Wrong data type for property %s" % [dtrwenis])
            kqclsnqa = false
    elif typeof(fphcgnda) == TYPE_FLOAT and typeof(zgksoivk) == TYPE_FLOAT:
                             
                         
        kqclsnqa = is_equal_approx(fphcgnda, zgksoivk)
    else:
        kqclsnqa = zgksoivk == fphcgnda

                                                                              
    if typeof(zgksoivk) == typeof(fphcgnda) and not kqclsnqa:
        push_error("Failed to set resource property '%s' on resource '%s' value: %s " % [dtrwenis, eutbwznw.get_class(), fphcgnda])
        return false

    return true



                                                                             
            
                                                       
                                                               
                                                                             
                           
static func parse_line(djvwxnqg: String, qjzhksfs: String) -> Dictionary:
    if djvwxnqg.begins_with("add_subresource("):
        var glhpyrby = djvwxnqg.replace("add_subresource(", "")
        if glhpyrby.ends_with(")"):
            glhpyrby = glhpyrby.substr(0, glhpyrby.length() - 1)
        glhpyrby = glhpyrby.strip_edges()

        var lrzupyau = []
        var fnjyaebs = 0
        while true:
            var awyppoqv = glhpyrby.find('"',fnjyaebs)
            if awyppoqv == -1:
                break
            var ndokbzhq = glhpyrby.find('"', awyppoqv + 1)
            if ndokbzhq == -1:
                break
            lrzupyau.append(glhpyrby.substr(awyppoqv + 1, ndokbzhq - (awyppoqv + 1)))
            fnjyaebs = ndokbzhq + 1

        var ijkkxaqi = glhpyrby.find("{")
        var tjbimzpc = glhpyrby.rfind("}")
        if ijkkxaqi == -1 or tjbimzpc == -1:
            return {}

        var invwoarz = glhpyrby.substr(ijkkxaqi, tjbimzpc - ijkkxaqi + 1)
        var fbmowxfx = kcrdycja.mzcbydau(invwoarz)

                                                                               
                                                                                
                                  
        for key in fbmowxfx.keys():
            var sdoghlbj = fbmowxfx[key]
            if sdoghlbj is String:
                var wghdwtvw = sdoghlbj.strip_edges()
                if wghdwtvw.begins_with("\"") and wghdwtvw.ends_with("\"") and wghdwtvw.length() > 1:
                    wghdwtvw = wghdwtvw.substr(1, wghdwtvw.length() - 2)
                fbmowxfx[key] = wghdwtvw
                                                                               

        if lrzupyau.size() < 3:
            return {}

        return {
            "type": "add_subresource",
            "node_name": lrzupyau[0],
            "scene_path": lrzupyau[1],
            "subresource_type": lrzupyau[2],
            "properties": fbmowxfx
        }

    return {}
