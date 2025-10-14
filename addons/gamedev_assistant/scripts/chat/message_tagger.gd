                                                               
@tool
extends RefCounted

const widhrxvg = "@OpenScripts"
const ziuxxorh = "@SceneTree"
const ebbpsdpv = "@OpenScenes"
const khhqmrhk = "@FileTree"
const jfiorkdm = "@Output"
const ypngrcac = "@GitDiff"
const sjaneuyj = "@Docs"
const pucjaxrm = "@ProjectSettings"
const fiuctsou = 10000
const pujrqrqu = 5000
const hlozhdws = 75000

var crwphmrt = {}                                  
var etjmdlsc = []                                     

                              
func zuvupaax() -> void:
    crwphmrt.clear()
    etjmdlsc.clear()

func jbubylrv(sowvzapd: String, duicbahm: EditorInterface) -> String:
                                                         
    if not yzyxmeet(sowvzapd):
        return sowvzapd
        
                            
    var gdkyipoo = sowvzapd
    
    if widhrxvg in sowvzapd:
                                      
        gdkyipoo = dghneelw(gdkyipoo, duicbahm)
        
    if ziuxxorh in sowvzapd:
                                     
        gdkyipoo = vfvumoon(gdkyipoo, duicbahm)

    if ebbpsdpv in sowvzapd:
        gdkyipoo = uchrkaka(gdkyipoo, duicbahm)

    if khhqmrhk in sowvzapd:
                                     
        gdkyipoo = yvraehqz(gdkyipoo, duicbahm)

    if jfiorkdm in sowvzapd:
                                        
        gdkyipoo = mmlchajd(gdkyipoo, duicbahm)
    
    if ypngrcac in sowvzapd:                                                             
        gdkyipoo = noeinmsx(gdkyipoo, duicbahm)      
    
    if pucjaxrm in gdkyipoo:
        gdkyipoo = aknknnmy(gdkyipoo)
    
    return gdkyipoo

func yzyxmeet(ccomvcsh: String) -> bool:
                                  
    return widhrxvg in ccomvcsh or ziuxxorh in ccomvcsh or khhqmrhk in ccomvcsh or jfiorkdm in ccomvcsh or pucjaxrm in ccomvcsh or ebbpsdpv in ccomvcsh

func dghneelw(pkdkoutd: String, stjngcsp: EditorInterface) -> String:
    var ulirzbwn = pkdkoutd.replace(widhrxvg, widhrxvg.substr(1)).strip_edges()
    
    var xoqnjrzz = eyifzxcr(stjngcsp)
    etjmdlsc.clear()
    
                         
    var touxbpfq = "\n[gds_context]\nScripts for context:\n"
    
                                                             
    var hmdopvov = {}
    etjmdlsc = []
    for file_path in xoqnjrzz:
       var udfzxouk = xoqnjrzz[file_path]
       if crwphmrt.has(file_path) and crwphmrt[file_path] == udfzxouk:
          etjmdlsc.append(file_path)
       else:
                                                                      
          hmdopvov[file_path] = udfzxouk

                                                                                             
    var zetdmczh = ""
    if not etjmdlsc.is_empty():
       zetdmczh = "The following scripts remain the same: %s\n" % [etjmdlsc]

                                                                       
    var ufxbbphv = ""
    var apfgqkdt = []
    var ofljgcfb = false

    for file_path in hmdopvov:
       var saixwecf = hmdopvov[file_path]
       var cdjhgmhz = "File: %s\nContent:\n```%s\n```\n" % [file_path, saixwecf]

                                                                   
       if ufxbbphv.length() + cdjhgmhz.length() > hlozhdws:
          ofljgcfb = true
          break                                                                  
       
                                                                                    
       ufxbbphv += cdjhgmhz
       apfgqkdt.append(file_path)
       crwphmrt[file_path] = saixwecf

                                                                                         
    if ofljgcfb:
       var gaanlaen = []
                                                 
       for file_path in hmdopvov.keys():
          if not file_path in apfgqkdt:
             gaanlaen.append(file_path)
       
       push_warning("Character limit reached for @OpenScripts. Not all files could be included in the message.")
       if not gaanlaen.is_empty():
          push_warning("These files were NOT sent to the LLM: %s" % [gaanlaen])

                                                         
    touxbpfq = touxbpfq + zetdmczh + ufxbbphv
        
    return ulirzbwn + touxbpfq + "\n[/gds_context]"

func eyifzxcr(xawniiib: EditorInterface) -> Dictionary:
    var dtlcxqbu = xawniiib.get_script_editor()
    var levuueqr: Array = dtlcxqbu.get_open_scripts()
    
    var matckcsq: Dictionary = {}
    
    for script in levuueqr:
        var gyozmhhy: String = script.get_source_code()
        var mftmipup: String = script.get_path()
                                            
        matckcsq[mftmipup] = gyozmhhy
        
    return matckcsq

func vfvumoon(ygihjpnd: String, dniggnis: EditorInterface) -> String:
                                                                                                                          
    var kvxatoak = ygihjpnd.replace(ziuxxorh, ziuxxorh.substr(1)).strip_edges()
    
                               
    var hkwkgcyo = dniggnis.get_edited_scene_root()
    if not hkwkgcyo:
        return kvxatoak + "\n[gds_context]Node tree: No scene is currently being edited.[/gds_context]"
    
                                
    var plrdsjuf = "\n[gds_context]Node tree:\n"
    plrdsjuf += jxaumnau(hkwkgcyo)
    plrdsjuf += "--\n"

    if plrdsjuf.length() > fiuctsou:                                                            
        plrdsjuf = plrdsjuf.substr(0, fiuctsou) + "..."
        
    plrdsjuf += "\n[/gds_context]"
        
    return kvxatoak + plrdsjuf

func jxaumnau(hjnqlffn: Node, vtgayzpf: String = "") -> String:
    var czthbvwq = vtgayzpf + "- " + hjnqlffn.name
    czthbvwq += " (" + hjnqlffn.get_class() + ")"
    
                                                 
    if hjnqlffn is Node2D:
        czthbvwq += " position " + str(hjnqlffn.position)
    elif hjnqlffn is Control:                      
        czthbvwq += " position " + str(hjnqlffn.position)
    elif hjnqlffn is Node3D:
        czthbvwq += " position " + str(hjnqlffn.position)

                                                                              
    if hjnqlffn.owner and hjnqlffn.owner != hjnqlffn:
        czthbvwq += " [owner: " + hjnqlffn.owner.name + "]"
    
    czthbvwq += "\n"
    var pwcektdl = vtgayzpf + "  "
    
                                                  
    if hjnqlffn is CollisionObject2D or hjnqlffn is CollisionObject3D:
        var zokcnifg = []
        var qezhqtol = []
        
                            
        for i in range(1, 33):                                
            if hjnqlffn.get_collision_layer_value(i):
                zokcnifg.append(str(i))
            if hjnqlffn.get_collision_mask_value(i):
                qezhqtol.append(str(i))
        
        if zokcnifg.size() > 0 or qezhqtol.size() > 0:
            czthbvwq += pwcektdl + "Collision: layer: " + ",".join(zokcnifg)
            czthbvwq += " mask: " + ",".join(qezhqtol) + "\n"
    
                                                                          
                                                                 
    if hjnqlffn.is_inside_tree():
                                
        var bcuxegja = []
        for prop in hjnqlffn.get_property_list():
            var lpcuobqx = prop["name"]
            var nswroxak = hjnqlffn.get(lpcuobqx)
            if nswroxak is Resource and nswroxak != null:
                var foruitob = nswroxak.get_class()
                if nswroxak.resource_name != "":
                    foruitob = nswroxak.resource_name
                bcuxegja.append("%s (%s)" % [lpcuobqx, foruitob])
            
        if not bcuxegja.is_empty():
            czthbvwq += pwcektdl + "Assigned subresources: " + ", ".join(bcuxegja) + "\n"
        
                                       
    if hjnqlffn.get_script():
        czthbvwq += pwcektdl + "Script: " + hjnqlffn.get_script().resource_path + "\n"
    
                            
    if hjnqlffn.unique_name_in_owner:
        czthbvwq += pwcektdl + "Unique name: %" + hjnqlffn.name + "\n"
    
                
    var tlbmpeqk = hjnqlffn.get_groups()
    if not tlbmpeqk.is_empty():
                                                              
        tlbmpeqk = tlbmpeqk.filter(func(group): return not group.begins_with("_"))
        if not tlbmpeqk.is_empty():
            czthbvwq += pwcektdl + "Groups: " + ", ".join(tlbmpeqk) + "\n"
    
                                           
    if hjnqlffn.scene_file_path:
        czthbvwq += pwcektdl + "Instanced from: " + hjnqlffn.scene_file_path + "\n"
    
                      
    for child in hjnqlffn.get_children():
        czthbvwq += jxaumnau(child, pwcektdl)
    return czthbvwq

func uchrkaka(umvuvjrp: String, hrhrbclc: EditorInterface) -> String:
    var aynjzedq = umvuvjrp.replace(ebbpsdpv, ebbpsdpv.substr(1)).strip_edges()

    var vnpetdxd: Array = Array(hrhrbclc.get_open_scenes())
    if vnpetdxd.is_empty():
        return aynjzedq + "\n[gds_context]Node tree:\n No scenes are currently open.[/gds_context]"

    var nejfdzvf = "\n[gds_context]Node tree:\n"
    
    for scene_path in vnpetdxd:
        var ohqxaose: PackedScene = load(scene_path)
        if not ohqxaose:
            nejfdzvf += "Could not load scene: %s\n" % scene_path
            continue

        var uvwmxcwi: Node = ohqxaose.instantiate()
        if not uvwmxcwi:
            continue

        var tfxrpoxm = jxaumnau(uvwmxcwi)

        nejfdzvf += "Scene: %s\n" % scene_path
        nejfdzvf += tfxrpoxm
        nejfdzvf += "--\n"
        
                                
        uvwmxcwi.free()

    if nejfdzvf.length() > fiuctsou:
        nejfdzvf = nejfdzvf.substr(0, fiuctsou) + "..."

    nejfdzvf += "\n[/gds_context]"

    return aynjzedq + nejfdzvf

func yvraehqz(bojlpyba: String, jbhzdcra: EditorInterface) -> String:
                                                                                                                          
    var wetxkqrk = bojlpyba.replace(khhqmrhk, khhqmrhk.substr(1)).strip_edges()

    var zuqitcmj = jbhzdcra.get_resource_filesystem()
    var dzmztblk = "res://"
    
                                
    var nppoxzka = "\n[gds_context]\nFile Tree:\n"
    nppoxzka += ztptgjvr(zuqitcmj.get_filesystem_path(dzmztblk))
    nppoxzka += "--\n"
    
    if nppoxzka.length() > fiuctsou:                                                            
        nppoxzka = nppoxzka.substr(0, fiuctsou) + "..."
            
    nppoxzka += "\n[/gds_context]"
    
    return wetxkqrk + nppoxzka

func ztptgjvr(tgtyxarn: EditorFileSystemDirectory, vpknpfam: String = "") -> String:
    var xlgvaeti = ""
    
                                                          
    var wniqxhip = tgtyxarn.get_path()
    if wniqxhip == "res://addons/gamedev_assistant/":
                                
        var jsaxsiuh = EditorInterface.get_editor_settings()
        var egjtbxbd = jsaxsiuh.has_setting("gamedev_assistant/development_mode") and jsaxsiuh.get_setting("gamedev_assistant/development_mode") == true
        if not egjtbxbd:
            return vpknpfam + "+ gamedev_assistant/\n"                                            
    
                                                   
    if tgtyxarn.get_path() != "res://":
        xlgvaeti += vpknpfam + "+ " + tgtyxarn.get_name() + "/\n"
        vpknpfam += "  "
    
                                      
    for i in tgtyxarn.get_subdir_count():
        var lebyjgho = tgtyxarn.get_subdir(i)
        xlgvaeti += ztptgjvr(lebyjgho, vpknpfam)
    
    for i in tgtyxarn.get_file_count():
        var jqilqdlw = tgtyxarn.get_file(i)
        xlgvaeti += vpknpfam + "- " + jqilqdlw + "\n"
    
    return xlgvaeti

func mmlchajd(osfihmpo: String, mtditotq: EditorInterface) -> String:
                                                                                                                          
    var pgvdmxns = osfihmpo.replace(jfiorkdm, jfiorkdm.substr(1)).strip_edges()

                                                                                                       
    var vahvfvgh: Node = mtditotq.get_base_control()
    var dwsoxxpm: RichTextLabel = xgkcffhy(vahvfvgh)

    if dwsoxxpm:
        var vqhxxmlp = dwsoxxpm.get_parsed_text()
        
        if vqhxxmlp.length() > pujrqrqu:                     
                                                                                            
            vqhxxmlp = vqhxxmlp.substr(-pujrqrqu) + "..."
        
        if vqhxxmlp.length() > 0:
            return pgvdmxns + "\n[gds_context]\nOutput Panel:\n" + vqhxxmlp + "\n[/gds_context]"
        else:
            return pgvdmxns + "\n[gds_context]No contents in the Output Panel.[/gds_context]"
    else:
        print("No RichTextLabel under @EditorLog was found.")
        return pgvdmxns + "\n--\nOutput Panel: Could not find the label.\n--\n"

func xgkcffhy(qlnorxqm: Node) -> RichTextLabel:
                                              
    if qlnorxqm is RichTextLabel:
        var qqvbcdta: Node = qlnorxqm.get_parent()
        if qqvbcdta:
            var eozfgzft: Node = qqvbcdta.get_parent()
                                                           
            if eozfgzft and eozfgzft.name.begins_with("@EditorLog"):
                return qlnorxqm

                              
    for child in qlnorxqm.get_children():
        var hhoifalq: RichTextLabel = xgkcffhy(child)
        if hhoifalq:
            return hhoifalq

    return null

func noeinmsx(axizeyzc: String, ygjeloez: EditorInterface) -> String:         
                                                                                                                          
    var gsgnjiwx = axizeyzc.replace(ypngrcac, ypngrcac.substr(1)).strip_edges()
                                                                                                    
                                                                                                  
    var cbidekcs = []                                                                              
    var yhtagiza = OS.execute("git", ["diff"], cbidekcs, true)                                    
                                                                                                    
    if yhtagiza == 0:                                                                            
        var nfyshpkt = "\n[gds_context]\nGit Diff:\n" + "\n".join(cbidekcs) + "\n"  
        
        if nfyshpkt.length() > fiuctsou:                                                            
            nfyshpkt = nfyshpkt.substr(0, fiuctsou) + "..."
        
        nfyshpkt += "[/gds_context]"
        
        return gsgnjiwx + nfyshpkt                                                
    else:                                                                                         
        return gsgnjiwx + "\n--\nGit Diff: Failed to execute git diff command.\n--\n"

func zyiupluf(plhzebcf: String, uvxstcmm: EditorInterface) -> String:
                                                                                                                          
    var ldadptcr = plhzebcf.replace(sjaneuyj, sjaneuyj.substr(1)).strip_edges()
    return ldadptcr

func aknknnmy(ujwlbvyo: String) -> String:
    var vikmygqa = ujwlbvyo.replace(pucjaxrm, pucjaxrm.substr(1)).strip_edges()
    
    var ahnfltyd = []
    var peozmaex = ProjectSettings.get_property_list()
    
    for prop in peozmaex:
        var zlrfvqoy: String = prop["name"]
        var mcxliypq = ProjectSettings.get(zlrfvqoy)
        
                                             
        if zlrfvqoy.begins_with("input/"):
            if mcxliypq is Dictionary or mcxliypq is Array:
                ahnfltyd.append("%s = %s" % [zlrfvqoy, str(mcxliypq)])
            elif mcxliypq == null or (mcxliypq is String and mcxliypq.is_empty()):
                continue
            else:
                ahnfltyd.append("%s = %s" % [zlrfvqoy, mcxliypq])
            continue
        
                                         
        if mcxliypq is Dictionary or mcxliypq is Array:
            continue
            
                                                      
        if mcxliypq == null or (mcxliypq is String and mcxliypq.is_empty()):
            continue
            
        ahnfltyd.append("%s = %s" % [zlrfvqoy, mcxliypq])
    
    ahnfltyd.sort()
    var iygsvpbf = "Unassigned project settings have been omitted from this list:\n" + "\n".join(ahnfltyd)
    
    vikmygqa = vikmygqa + "\n" + iygsvpbf
    return vikmygqa
