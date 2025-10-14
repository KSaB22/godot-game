                                                                      
@tool
extends Node

const slgwzves = preload("action_parser_utils.gd")
                                                                            
                                                   
const iozzqwhn = preload("add_subresource_action.gd")

static func execute(nxxkgeue: String, ulqvqasl: String, nsebrahl: String, jrszckbi: Dictionary) -> Dictionary:
    var bovkfnpc = EditorPlugin.new().get_editor_interface()
    var bbtjghph = bovkfnpc.get_open_scenes()

                                   
    for scene in bbtjghph:
        if scene == ulqvqasl:
                                                                    
            bovkfnpc.reload_scene_from_path(ulqvqasl)
            return _edit_in_open_scene(nxxkgeue, bovkfnpc.get_edited_scene_root(), nsebrahl, jrszckbi)

                                           
                                                              
    return _edit_in_closed_scene(nxxkgeue, ulqvqasl, nsebrahl, jrszckbi)


static func _edit_in_open_scene(bffszywy: String, ptmtwkhc: Node, oezetwdp: String, nwwnxavw: Dictionary) -> Dictionary:
    var drbmdguz = iozzqwhn.easygmos(bffszywy, ptmtwkhc)               
    if not drbmdguz:
                                              
        return {"success": false, "error_message": "Node '%s' not found." % bffszywy, "node_type": "", "subresource_type": ""}

    var ombsxvjq = drbmdguz.get(oezetwdp)
    if not (ombsxvjq is Resource):
        var efwcniia = "Property '%s' on node '%s' is not a Resource or doesn't exist." % [oezetwdp, bffszywy]
        push_error(efwcniia)
        return {"success": false, "error_message": efwcniia, "node_type": drbmdguz.get_class(), "subresource_type": ""}

    var dfzdyzyl = ryrkfzuy(ombsxvjq, nwwnxavw)
    if not dfzdyzyl.success:
        return {"success": false, "error_message": dfzdyzyl.error_message, "node_type": drbmdguz.get_class(), "subresource_type": ombsxvjq.get_class()}

                         
    EditorInterface.edit_resource(ombsxvjq)                                 
    if EditorInterface.save_scene() == OK:
        return {"success": true, "error_message": "", "node_type": drbmdguz.get_class(), "subresource_type": ombsxvjq.get_class()}
    else:
        var efwcniia = "Failed to save the scene."
        push_error(efwcniia)
        return {"success": false, "error_message": efwcniia, "node_type": drbmdguz.get_class(), "subresource_type": ombsxvjq.get_class()}

static func _edit_in_closed_scene(qiayqjry: String, rkluitsl: String, ptdinnnu: String, qsahqzvg: Dictionary) -> Dictionary:
    var affixeri = load(rkluitsl)
    if !(affixeri is PackedScene):
        var abcukvdr = "Failed to load scene '%s' as PackedScene." % rkluitsl
        push_error(abcukvdr)
        return {"success": false, "error_message": abcukvdr, "node_type": "", "subresource_type": ""}

    var plmikwwv = affixeri.instantiate()
    if not plmikwwv:
        var abcukvdr = "Could not instantiate scene '%s'." % rkluitsl
        push_error(abcukvdr)
        return {"success": false, "error_message": abcukvdr, "node_type": "", "subresource_type": ""}

    var rzbrkkkm = iozzqwhn.easygmos(qiayqjry, plmikwwv)               
    if not rzbrkkkm:
        plmikwwv.free()
        return {"success": false, "error_message": "Node '%s' not found." % qiayqjry, "node_type": "", "subresource_type": ""}

    var bnpjydiw = rzbrkkkm.get(ptdinnnu)
    if not (bnpjydiw is Resource):
        var abcukvdr = "Property '%s' on node '%s' is not a Resource or doesn't exist." % [ptdinnnu, qiayqjry]
        push_error(abcukvdr)
        plmikwwv.free()
        return {"success": false, "error_message": abcukvdr, "node_type": rzbrkkkm.get_class(), "subresource_type": ""}

    var fixmnkpk = ryrkfzuy(bnpjydiw, qsahqzvg)
    if not fixmnkpk.success:
        plmikwwv.free()
        return {"success": false, "error_message": fixmnkpk.error_message, "node_type": rzbrkkkm.get_class(), "subresource_type": bnpjydiw.get_class()}

    affixeri.pack(plmikwwv)
    var ypggzjsc = ResourceSaver.save(affixeri, rkluitsl)
    plmikwwv.free()

    if ypggzjsc == OK:
        return {"success": true, "error_message": "", "node_type": rzbrkkkm.get_class(), "subresource_type": bnpjydiw.get_class()}
    else:
        var abcukvdr = "Failed to save the packed scene."
        push_error(abcukvdr)
        return {"success": false, "error_message": abcukvdr, "node_type": rzbrkkkm.get_class(), "subresource_type": bnpjydiw.get_class()}


                                                                             
         
                                                                             
static func ryrkfzuy(nmdlmopj: Resource, uhplupsv: Dictionary) -> Dictionary:
    for property_name in uhplupsv.keys():
        var dqamjlkc = uhplupsv[property_name]
        var njvcyaxu = iozzqwhn._parse_value(dqamjlkc)
        if njvcyaxu == null and dqamjlkc != null:
            var yylkpnbr = "Failed to parse value '%s' for property '%s'." % [str(dqamjlkc), property_name]
            push_error(yylkpnbr)
            return {"success": false, "error_message": yylkpnbr}

        if not iozzqwhn.stldjbum(nmdlmopj, property_name, njvcyaxu):
                                               
            var yylkpnbr = "Failed to set property '%s' on resource '%s'." % [property_name, nmdlmopj.get_class()]
            return {"success": false, "error_message": yylkpnbr}

    return {"success": true, "error_message": ""}

                                                                             
            
                                                       
                                                                
                                                                                                                     
                                                                             
static func parse_line(tjsinspc: String, herzklbl: String) -> Dictionary:
    if tjsinspc.begins_with("edit_subresource("):
        var gxceaagl = tjsinspc.replace("edit_subresource(", "")
        if gxceaagl.ends_with(")"):
            gxceaagl = gxceaagl.substr(0, gxceaagl.length() - 1)             
        gxceaagl = gxceaagl.strip_edges()

                                                                                                
        var dstjcpim = []
        var npmjuvxw = 0
        var oxnigmdq = 0
        while oxnigmdq < 3:                             
            var ojcimwum = gxceaagl.find('"',npmjuvxw)
            if ojcimwum == -1:
                break                         
            var hbxlbzog = gxceaagl.find('"', ojcimwum + 1)
            if hbxlbzog == -1:
                break                       
            dstjcpim.append(gxceaagl.substr(ojcimwum + 1, hbxlbzog - (ojcimwum + 1)))             
            npmjuvxw = hbxlbzog + 1
            oxnigmdq += 1
                                                                         
            var cycamnqi = gxceaagl.find(",", npmjuvxw)
            if cycamnqi != -1:
                npmjuvxw = cycamnqi + 1
            else:
                                                                                                    
                if oxnigmdq < 3: break                                               

        if dstjcpim.size() < 3:
            push_error("Edit Subresource: Failed to parse required string arguments (node_name, scene_path, subresource_property_name). Line: " + tjsinspc)
            return {}

                                                                        
        var ycegstfb = gxceaagl.find("{", npmjuvxw)                                 
        var maploftu = gxceaagl.rfind("}")
        if ycegstfb == -1 or maploftu == -1 or maploftu < ycegstfb:
            push_error("Edit Subresource: Failed to find or parse properties dictionary. Line: " + tjsinspc)
            return {}

        var kcyxsycb = gxceaagl.substr(ycegstfb, maploftu - ycegstfb + 1)             
                                                                           
        var wvrgtxyd = slgwzves.mzcbydau(kcyxsycb)                                 

                                                                           
                                                                                   

        return {
            "type": "edit_subresource",
            "node_name": dstjcpim[0],
            "scene_path": dstjcpim[1],
            "subresource_property_name": dstjcpim[2],
            "properties": wvrgtxyd                                         
        }

    return {}
