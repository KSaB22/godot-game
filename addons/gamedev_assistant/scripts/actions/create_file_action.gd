                                                                 
@tool
extends Node

const ksinzrea = preload("action_parser_utils.gd")

static func execute(twlxofrk: String, yaasitsk: String) -> Dictionary:
    var yfmrnnar = twlxofrk.get_base_dir()
    if not DirAccess.dir_exists_absolute(yfmrnnar):
        var hntxqavo = DirAccess.make_dir_recursive_absolute(yfmrnnar)
        if hntxqavo != OK:
            var jwkxbauz = "Failed to create directory: %s" % yfmrnnar
            push_error(jwkxbauz)
            return {"success": false, "error_message": jwkxbauz}
    
    var expngczj = FileAccess.open(twlxofrk, FileAccess.WRITE)
    if expngczj:
        expngczj.store_string(yaasitsk)
        expngczj.close()
        if Engine.is_editor_hint():
            EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
        return {"success": true, "error_message": ""}
    else:
        var vqpzjdhm = FileAccess.get_open_error()
        var jwkxbauz = "Failed to create file at path '%s'. Error: %s" % [twlxofrk, error_string(vqpzjdhm)]
        push_error(jwkxbauz)
        return {"success": false, "error_message": jwkxbauz}


static func parse_line(htlefrhn: String, gjwxbfew: String) -> Dictionary:
    if htlefrhn.begins_with("create_file("):
        var tqagpqdc = ksinzrea.sqtusicx(htlefrhn)
        return {
            "type": "create_file",
            "path": tqagpqdc,
            "content": ksinzrea.uscdjgsq(tqagpqdc, gjwxbfew)
        }
    return {}
