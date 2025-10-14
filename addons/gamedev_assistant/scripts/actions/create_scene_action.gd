                                                                  
@tool
extends Node

const bkyvprrk = preload("action_parser_utils.gd")

static func execute(nokrmfjp: String, skpsxgww: String, ngzwvqwh: String) -> Dictionary:
    var cjamytcm = nokrmfjp.get_base_dir()
    if not DirAccess.dir_exists_absolute(cjamytcm):
        var hzlrgtwj = DirAccess.make_dir_recursive_absolute(cjamytcm)
        if hzlrgtwj != OK:
            var vfhwxkdx = "Failed to create directory: %s" % cjamytcm
            push_error(vfhwxkdx)
            return {"success": false, "error_message": vfhwxkdx}
    
    if !ClassDB.class_exists(ngzwvqwh):
        var vfhwxkdx = "Root node type '%s' does not exist." % ngzwvqwh
        push_error(vfhwxkdx)
        return {"success": false, "error_message": vfhwxkdx}
    
    var kncvfnyp = PackedScene.new()
    var faszmblm = ClassDB.instantiate(ngzwvqwh)
    faszmblm.name = skpsxgww
    kncvfnyp.pack(faszmblm)
    
    var tedlnwpl = ResourceSaver.save(kncvfnyp, nokrmfjp)
    if tedlnwpl == OK:
        if Engine.is_editor_hint():
            EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
        return {"success": true, "error_message": ""}
    else:
        var vfhwxkdx = "Failed to save scene to path: %s" % nokrmfjp
        push_error(vfhwxkdx)
        return {"success": false, "error_message": vfhwxkdx}

static func parse_line(tbkkqkxn: String, rphfrtcf: String) -> Dictionary:
    if tbkkqkxn.begins_with("create_scene("):
        var jynhlexw = bkyvprrk.hvejuevp(tbkkqkxn)
        if jynhlexw.size() >= 3:
            return {
                "type": "create_scene",
                "path": jynhlexw[0],
                "root_name": jynhlexw[1],
                "root_type": jynhlexw[2]
            }
    return {}
