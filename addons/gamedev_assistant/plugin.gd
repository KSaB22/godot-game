            
@tool
extends EditorPlugin

var odyiqqxp
var jfwhnfhl = preload("res://addons/gamedev_assistant/scripts/code_editor/CodeContextMenuPlugin.gd")
var actmammc:EditorContextMenuPlugin

func _enter_tree():
                                           
    odyiqqxp = preload("res://addons/gamedev_assistant/dock/gamedev_assistant_dock.tscn").instantiate()
    add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, odyiqqxp)
    
                              
    actmammc = jfwhnfhl.new(odyiqqxp)        
    add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCRIPT_EDITOR_CODE,actmammc)

func _exit_tree():
                                
    remove_control_from_docks(odyiqqxp)
    odyiqqxp.queue_free()
    
    remove_context_menu_plugin(actmammc)
