                                                                  
@tool
extends Node

signal atctvhdo(action_type: String, success: bool, error_message: String, node_name: String, subresource_name: String, button: Button)
signal cqbbfiup(action_type: String, disable: bool)

                                     
const svluaeci = preload("res://addons/gamedev_assistant/scripts/actions/action_parser_utils.gd")
const cyurjcld = preload("res://addons/gamedev_assistant/scripts/actions/create_file_action.gd")
const cijxqjlc = preload("res://addons/gamedev_assistant/scripts/actions/create_scene_action.gd")
const bmmblzig = preload("res://addons/gamedev_assistant/scripts/actions/create_node_action.gd")
const wvxmenyk = preload("res://addons/gamedev_assistant/scripts/actions/edit_node_action.gd")
const cqgjukcl = preload("res://addons/gamedev_assistant/scripts/actions/add_subresource_action.gd")
const hhmtharp = preload("res://addons/gamedev_assistant/scripts/actions/edit_subresource_action.gd")
const ueqbkrtr = preload("res://addons/gamedev_assistant/scripts/actions/assign_script_action.gd")
const lvucakgn = preload("res://addons/gamedev_assistant/scripts/actions/add_existing_scene_action.gd")
const inkthbos = preload("res://addons/gamedev_assistant/scripts/actions/edit_script_action.gd")

const edulyxxv = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ActionButton.tscn")
const feiblyia = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ApplyAllButton.tscn")
const ozyfkkos = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ActionsContainer.tscn")
const zevcfymu = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_Spacing.tscn")

var cbocfqio: Control
var stffjjht : VBoxContainer
var dzoioyed: Array = []
var vuyutpqz : Button
var fduvoobs : bool
var rasdmeeg : bool
var yjjouzbt = 0

                             
var bqenpkss: Timer

func _ready():
    
    var ljflkirq = EditorInterface.get_editor_settings()       
    rasdmeeg = ljflkirq.has_setting("gamedev_assistant/development_mode") and ljflkirq.get_setting('gamedev_assistant/development_mode') == true    

                                                           
    atctvhdo.connect(fqgzmwed)
    cqbbfiup.connect(hswbgqfv)

                                    
    bqenpkss = Timer.new()
    bqenpkss.wait_time = 0.2
    bqenpkss.one_shot = true
    add_child(bqenpkss)
    bqenpkss.timeout.connect(mimnwghm)

                            
func kkstndjd(cblwaoea: String, izdeelln: int) -> Array:
    var uxfrcbqy = []

    var sjudqajo = "[gds_actions]"
    var ciclvxaq = "[/gds_actions]"

    var dxlllvdn = cblwaoea.find(sjudqajo)
    var nflyfsni = cblwaoea.find(ciclvxaq)

    if dxlllvdn == -1 or nflyfsni == -1:
        return uxfrcbqy                                       

                                                                
    var bmekuoad = dxlllvdn + sjudqajo.length()
    var oqpwvsxm = nflyfsni - bmekuoad
    var sgtbacxx = cblwaoea.substr(bmekuoad, oqpwvsxm).strip_edges()
    
    if rasdmeeg:
        print(sgtbacxx)

                                        
    var xfnpgqnw = sgtbacxx.split("\n")
    for line in xfnpgqnw:
        line = line.strip_edges()
        if line == "":
            continue

        var uaaqrkhb = wufophhq(line, cblwaoea)
        if uaaqrkhb:
            uaaqrkhb["message_id"] = izdeelln
            uxfrcbqy.append(uaaqrkhb)

    return uxfrcbqy


                    
func mkikibaw(xqeozsqc: String, lgyoxerc: String, szhzyjpv: Button) -> bool:
    var vuftzcyq = cyurjcld.execute(xqeozsqc, lgyoxerc)
    atctvhdo.emit("create_file", vuftzcyq.success, vuftzcyq.error_message, "", "", szhzyjpv)
    return vuftzcyq.success

                     
func pzqowmcn(gxppetjm: String, dyogqioz: String, kxdqjwdp: String, wfhpnsye: Button) -> bool:
    var yglnhlre = cijxqjlc.execute(gxppetjm, dyogqioz, kxdqjwdp)
    atctvhdo.emit("create_scene", yglnhlre.success, yglnhlre.error_message, "", "", wfhpnsye)
    return yglnhlre.success

                    
func thriecer(tnaluzmj: String, afxdpgtb: String, wyhkrjtx: String, cfvixmvb: String, jhhvvhsu: Dictionary, ystzepls: Button) -> bool:
    var iffajyzc = bmmblzig.execute(tnaluzmj, afxdpgtb, wyhkrjtx, cfvixmvb, jhhvvhsu)
    atctvhdo.emit("create_node", iffajyzc.success, iffajyzc.error_message, afxdpgtb, "", ystzepls)
    return iffajyzc.success
    
                  
func mlzvcwcg(fbfvktwc: String, evdgbscx: String, gkovuqfr: Dictionary, tpsnhzcf: Button) -> bool:
    var okghqpgx = wvxmenyk.execute(fbfvktwc, evdgbscx, gkovuqfr)
    atctvhdo.emit("edit_node", okghqpgx.success, okghqpgx.error_message, okghqpgx.node_type, "", tpsnhzcf)
    return okghqpgx.success
    
func fryrgyxc(lctwouug: String, bcmktrkk: String, zqibdynq: String, jlkombfz: Dictionary, ewrfjpwy: Button) -> bool:
    var deitbozu = cqgjukcl.execute(lctwouug, bcmktrkk, zqibdynq, jlkombfz)
    atctvhdo.emit("add_subresource", deitbozu.success, deitbozu.error_message, deitbozu.node_type, zqibdynq, ewrfjpwy)
    return deitbozu.success

                         
func eovlhxna(uezbnbbt: String, xnqrjfim: String, cggzgyid: String, ggmtpama: Dictionary, xxyfwnvn: Button) -> bool:
    var tujplmec = hhmtharp.execute(uezbnbbt, xnqrjfim, cggzgyid, ggmtpama)
                                                                              
    atctvhdo.emit("edit_subresource", tujplmec.success, tujplmec.error_message, tujplmec.node_type, tujplmec.subresource_type, xxyfwnvn)
    return tujplmec.success

func uhnoqmhi(ufxziqsv: String, pymhywir: String, mkufxhyn: String, bvcownkh: Button) -> bool:  
      var pcvtmjip = ueqbkrtr.execute(ufxziqsv, pymhywir, mkufxhyn)  
      atctvhdo.emit("assign_script", pcvtmjip.success, pcvtmjip.error_message, "", "", bvcownkh)  
      return pcvtmjip.success  

func qijnhucm(zdwkanmj: String, hlyumxnd: String, kuluhbpz: String, qybuvsgo: String, tscjwvjz: Dictionary, aqljynki: Button) -> bool:
    var ohuvruoe = lvucakgn.execute(zdwkanmj, hlyumxnd, kuluhbpz, qybuvsgo, tscjwvjz)
    atctvhdo.emit("add_existing_scene", ohuvruoe.success, ohuvruoe.error_message, "", "", aqljynki)
    return ohuvruoe.success  
    
func objdfpck(pdfodvye: String, kinzjtkn: int, rudaevnl: Button) -> void:
    var ijminxdh = $"../APIManager"
    var yhlwjvnc = inkthbos.execute(pdfodvye, kinzjtkn, rudaevnl, ijminxdh)
    
                                                                                                     
                                                                                   
    if yhlwjvnc is Dictionary:
        atctvhdo.emit("edit_script", yhlwjvnc.success, yhlwjvnc.error_message, "", "", rudaevnl)
    
                                                                                  
                                                                           


                                 
func fejmsafd(nwnmdzcj: Array, zabefwia: Control) -> void:
    
    cbocfqio = zabefwia    
    sosjbsev()
    
    stffjjht = ozyfkkos.instantiate()
    var ngtqmioy = zevcfymu.instantiate()
    stffjjht.add_child(ngtqmioy)
    cbocfqio.add_child(stffjjht)
    
                                                        
    if nwnmdzcj.size() > 1:
        vuyutpqz = feiblyia.instantiate()
        vuyutpqz.text = "Apply All"
        vuyutpqz.disabled = false
        vuyutpqz.pressed.connect(uhylaqen)
        vuyutpqz.tooltip_text = "Apply the actions listed below from top to bottom"
        stffjjht.add_child(vuyutpqz)

    for action in nwnmdzcj:
        var suitbtzx = edulyxxv.instantiate()

        var wyhircen = ""
        var glaveshh = []
        
        match action.type:
            "create_file":
                wyhircen = "Create {path}".format({"path": action.path})
                glaveshh.append("Create file")
            "create_scene":
                wyhircen = "Create {path}".format({
                    "path": action.path,
                })
                glaveshh.append("Create scene")
            "create_node":
                var xynaillx = action.scene_path.get_file()
                var cdsuacls = action.parent_path if action.parent_path != "" else "root"
                wyhircen = "Create {type} \"{node_name}\"".format({
                    "type": action.node_type,
                    "node_name": action.name
                })
                glaveshh.append("Create node")
                glaveshh.append("Scene: %s" % xynaillx)                
            "edit_node":
                var xynaillx = action.scene_path.get_file()
                wyhircen = "Edit %s" % [action.node_name]
                
                glaveshh.append("Edit node")
                glaveshh.append("Scene: %s" % xynaillx)
            "add_subresource":
                var xynaillx = action.scene_path.get_file()
                wyhircen = "Add %s to %s" % [
                    action.subresource_type,
                    action.node_name
                ]                
                glaveshh.append("Add subresource")
                glaveshh.append("Scene: %s" % xynaillx)
            "edit_subresource":
                var xynaillx = action.scene_path.get_file()
                wyhircen = "Edit %s on %s" % [
                    action.subresource_property_name,                                       
                    action.node_name                                                
                ]
                glaveshh.append("Edit subresource")
                glaveshh.append("Scene: %s" % xynaillx)
                glaveshh.append("Property: %s" % action.subresource_property_name)                
            "assign_script":  
                var xynaillx = action.scene_path.get_file()  
                var kuzadeiw = action.script_path.get_file()
                wyhircen = "Attach %s to %s" % [  
                    kuzadeiw,  
                    action.node_name  
                ]
                glaveshh.append("Attach script")
                glaveshh.append("File: %s" % kuzadeiw)
                glaveshh.append("Scene: %s" % xynaillx)                
            "add_existing_scene":
                var jwyrksjs = action.existing_scene_path.get_file()
                var rkzzqjiq = action.target_scene_path.get_file()
                wyhircen = "Add %s to %s" % [jwyrksjs, rkzzqjiq]
                
                glaveshh.append("Add existing scene")
                glaveshh.append("Source: %s" % jwyrksjs)
                glaveshh.append("Target: %s" % rkzzqjiq)  
            "edit_script":
                wyhircen = "Edit {path}".format({"path": action.path})
                glaveshh.append("Edit script")
                glaveshh.append("Path: %s" % action.path)
                                
                              
        if action.has("path"):
            glaveshh.append("Path: %s" % action.path)
        
        if action.has("scene_name"):
            glaveshh.append("Scene: %s" % action.scene_name)
        
        if action.has("node_type"):
            glaveshh.append("Node type: %s" % action.node_type)
        
        if action.has("root_type"):
            glaveshh.append("Root type: %s" % action.root_type)
            
        if action.has("subresource_type"):
            glaveshh.append("Subresource type: %s" % action.subresource_type)
        
        if action.has("name"):
            glaveshh.append("Name: %s" % action.name)
        
        if action.has("node_name"):
            glaveshh.append("Node name: %s" % action.node_name)
       
        if action.has("parent_path"):      
            glaveshh.append("Parent: %s" % (action.parent_path if action.parent_path else "root"))
            
        if action.has("modifications") or action.has("properties"):
            var bgcvcind = action.get("modifications", action.get("properties", {}))
            if bgcvcind.size() > 0:
                glaveshh.append("\nProperties to apply:")
                for key in bgcvcind:
                    glaveshh.append("• %s = %s" % [key, str(bgcvcind[key])])
                
        suitbtzx.tooltip_text = "\n".join(glaveshh)

        suitbtzx.text = wyhircen
        suitbtzx.set_meta("action", action)
        suitbtzx.pressed.connect(xrfjavym.bind(suitbtzx))

        stffjjht.add_child(suitbtzx)
        dzoioyed.append(suitbtzx)


                          
func sosjbsev() -> void:
    if cbocfqio == null:
        return
        
                                                                     
    if is_instance_valid(stffjjht) and stffjjht.is_inside_tree():
                                                                     
        if cbocfqio.has_node(stffjjht.get_path()):
                                                                  
            cbocfqio.remove_child(stffjjht)
    
                                    
    dzoioyed.clear()

                                                  
func xrfjavym(vocpkpln: Button) -> void:
        fduvoobs = false
        whyilesh(vocpkpln)

                                                  
func whyilesh(tugtjltg: Button) -> void:
    var oghfcump = tugtjltg.get_meta("action") if tugtjltg.has_meta("action") else {}
    
    tugtjltg.disabled = true

    match oghfcump.type:
        "create_file":
            mkikibaw(oghfcump.path, oghfcump.content, tugtjltg)
        "create_scene":
            pzqowmcn(oghfcump.path, oghfcump.root_name, oghfcump.root_type, tugtjltg)
        "create_node":
            var zlwgkqjh = oghfcump.modifications if oghfcump.has("modifications") else {}
            thriecer(oghfcump.name, oghfcump.node_type, oghfcump.scene_path, oghfcump.parent_path, zlwgkqjh, tugtjltg)
        "edit_node":
            mlzvcwcg(oghfcump.node_name, oghfcump.scene_path, oghfcump.modifications, tugtjltg)
        "add_subresource":
            fryrgyxc(
                oghfcump.node_name,
                oghfcump.scene_path,
                oghfcump.subresource_type,
                oghfcump.properties,
                tugtjltg
            )
        "edit_subresource":
             eovlhxna(
                oghfcump.node_name,
                oghfcump.scene_path,
                oghfcump.subresource_property_name,
                oghfcump.properties,                                                    
                tugtjltg
             )
        "assign_script":  
              uhnoqmhi(oghfcump.node_name, oghfcump.scene_path, oghfcump.script_path, tugtjltg)  
        "add_existing_scene":
            qijnhucm(
                oghfcump.node_name,
                oghfcump.existing_scene_path,
                oghfcump.target_scene_path,
                oghfcump.parent_path,
                oghfcump.modifications,
                tugtjltg
            )
        "edit_script":
            objdfpck(oghfcump.path, oghfcump.message_id, tugtjltg)
        _:
            push_warning("Unrecognized action type: %s" % oghfcump.type)


                                             
func fqgzmwed(xsrwpign: String, bnxtsnwn: bool, qildteqn: String, vhcaubvb: String, ozjwwrwc: String, wzbucowq: Button) -> void:
    if not is_instance_valid(wzbucowq):
        return

                                                                         
    var suleaptv = wzbucowq.text
    var qgefeqld = wzbucowq.tooltip_text
    
                                                         
    if is_instance_valid(vuyutpqz):
        vuyutpqz.disabled = true

    var ymhmvisy = wzbucowq.get_meta("action")
    var rxzxruej = ymhmvisy.get("message_id", -1)

    if rxzxruej != -1:
        $"../APIManager".quxzgytl(rxzxruej, bnxtsnwn, xsrwpign, vhcaubvb, ozjwwrwc, qildteqn)

                                                                             
    if xsrwpign == ymhmvisy.type:
        var vqkykkan = "✓ " if bnxtsnwn else "✗ "
        var uwestsmb = "\n\nACTION COMPLETED" if bnxtsnwn else "\n\nACTION FAILED:\n%s\nClick to retry." % qildteqn
        var frdnjqyq = ""                               

                                                                   
        match xsrwpign:
            "create_file":
                frdnjqyq = ("Created file {path}" if bnxtsnwn else "Failed: file creation {path}").format({"path": ymhmvisy.path})
            "create_scene":
                frdnjqyq = ("Created scene {path}, root: {root_type}" if bnxtsnwn else "Failed: scene creation {path}, root: {root_type}").format({
                    "path": ymhmvisy.path,
                    "root_type": ymhmvisy.root_type
                })
            "create_node":
                var aceezzgc = ymhmvisy.scene_path.get_file()
                var qijutggn = ymhmvisy.parent_path if ymhmvisy.parent_path != "" else "root"
                var cowyoder = ""
                if ymhmvisy.has("modifications") and ymhmvisy.modifications.size() > 0:
                    cowyoder = " with %s props" % ymhmvisy.modifications.size()
                frdnjqyq = ("Created node {name}, type {type}, parent {parent} in scene {scene}{props}" if bnxtsnwn
                                else "Failed: creating node {name}, type {type}, parent {parent} in scene {scene}{props}"
                                ).format({
                                    "name": ymhmvisy.name,
                                    "type": ymhmvisy.node_type,
                                    "scene": aceezzgc,
                                    "parent": qijutggn,
                                    "props": cowyoder
                                })
            "edit_node":
                frdnjqyq = ("Edited node \"%s\" in scene %s" if bnxtsnwn
                                else "Failed: editing node \"%s\", scene: %s"
                                ) % [ymhmvisy.node_name, ymhmvisy.scene_path.get_file()]

            "add_subresource":
                var aceezzgc = ymhmvisy.scene_path.get_file()
                var kqesfzrq = str(ymhmvisy.properties.size())
                frdnjqyq = ("Added subresource %s to node %s in scene %s (%s properties)" if bnxtsnwn
                                else "Failed: adding subresource %s to node %s, scene: %s (%s properties)"
                                ) % [ymhmvisy.subresource_type, ymhmvisy.node_name, aceezzgc, kqesfzrq]
                                
            "edit_subresource":
                 var aceezzgc = ymhmvisy.scene_path.get_file()
                 var kqesfzrq = str(ymhmvisy.properties.size())
                 frdnjqyq = ("Edited subresource property '%s' on node '%s' in scene %s (%s properties changed)" if bnxtsnwn
                                 else "Failed: editing subresource property '%s' on node '%s', scene: %s (%s properties attempted)"
                                 ) % [ymhmvisy.subresource_property_name, ymhmvisy.node_name, aceezzgc, kqesfzrq]

            "assign_script":
                frdnjqyq = ("Assigned script to node \"%s\" in scene %s" if bnxtsnwn
                                else "Failed: assigning script to node \"%s\", scene: %s"
                                ) % [ymhmvisy.node_name, ymhmvisy.scene_path.get_file()]

            "add_existing_scene":
                var dvinjneb = ymhmvisy.target_scene_path.get_file()
                var aceezzgc = ymhmvisy.existing_scene_path.get_file()
                var kqesfzrq = str(ymhmvisy.modifications.size())
                frdnjqyq = ("Added %s to %s" if bnxtsnwn
                              else "Failed: adding %s to %s"
                              ) % [aceezzgc, dvinjneb]
                if ymhmvisy.modifications.size() > 0:
                    frdnjqyq += " (%s props)" % kqesfzrq
            "edit_script":
                frdnjqyq = ("Edited script %s" if bnxtsnwn else "Failed: editing script %s") % [ymhmvisy.path]

                                                         
        wzbucowq.text = vqkykkan + suleaptv

                                                             
        wzbucowq.tooltip_text = qgefeqld + uwestsmb

                                               
                                                             
        print('[GameDev Assistant] ' + vqkykkan + frdnjqyq) 

        if not bnxtsnwn:
            wzbucowq.self_modulate = Color(1, 0, 0)                               
            
                                  
        wzbucowq.set_meta("completed", true)
        
                               
        if xsrwpign == "edit_script":
            hswbgqfv(xsrwpign, false)
            
                                          
        if bnxtsnwn:
            wzbucowq.disabled = true
        
                              
func wufophhq(nnfyhcki: String, egondbws: String) -> Dictionary:
    var shvghnei = [cyurjcld, cijxqjlc, bmmblzig, wvxmenyk, cqgjukcl, hhmtharp, ueqbkrtr, lvucakgn, inkthbos]
    for parser in shvghnei:
        var zvtpudco = parser.parse_line(nnfyhcki, egondbws)
        if not zvtpudco.is_empty():
            return zvtpudco
    return {}
    
func uhylaqen() -> void:
    if fduvoobs:
        return                                                   
        
    fduvoobs = true
    vuyutpqz.disabled = true
    yjjouzbt = 0
    
                                                               
    for button in dzoioyed:
                                                              
        if not button.get_meta("completed", false):
            button.disabled = true
    
                                                                   
    atctvhdo.connect(luczggfm)
    
                                                      
    qfhqzaga()

func luczggfm(jobmfkac, dmbyjscm, zbmrwkim, qowfbavv, yqcavuxd, xdkihqga: Button):
                                                                           
    if not fduvoobs:
        return

                                                                                  
    if dzoioyed.size() > yjjouzbt and xdkihqga == dzoioyed[yjjouzbt]:
        yjjouzbt += 1
                                                                                        
        bqenpkss.start()

func qfhqzaga():
                                                        
    if yjjouzbt >= dzoioyed.size():
        fduvoobs = false
        atctvhdo.disconnect(luczggfm)                                     
        print("[GameDev Assistant] Apply All sequence completed.")
        return

                                            
    var xirzvqjj = dzoioyed[yjjouzbt]
    if is_instance_valid(xirzvqjj):
                                                                
        if xirzvqjj.get_meta("completed", false):
            yjjouzbt += 1
            qfhqzaga()
            return
            
        whyilesh(xirzvqjj)
    else:
                                                                            
        yjjouzbt += 1
        qfhqzaga()

func mimnwghm():
                                                                                    
    call_deferred("qfhqzaga")

func hswbgqfv(ohgbkkms: String, wprkwglc: bool) -> void:

    if fduvoobs:
        return
    
    for button in dzoioyed:
        var echghzyu = button.get_meta("action") if button.has_meta("action") else {}
        if echghzyu.get("type", "") == ohgbkkms:
                                                
            if not button.get_meta("completed", false):
                button.disabled = wprkwglc
