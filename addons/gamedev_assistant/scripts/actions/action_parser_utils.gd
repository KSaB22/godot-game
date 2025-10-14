                                                                  
@tool
extends Node

static func sqtusicx(maolhaab: String) -> String:
    var lollmudv = maolhaab.find('"')
    if lollmudv == -1:
        return ""
    var pjthjemt = maolhaab.find('"', lollmudv + 1)
    if pjthjemt == -1:
        return ""
    return maolhaab.substr(lollmudv + 1, pjthjemt - (lollmudv + 1))


static func uscdjgsq(ffbpctsy: String, srxvuvyt: String) -> String:
    var zbjiboad = RegEx.new()
    zbjiboad.compile("```.*\\n# New file: " + ffbpctsy + "\\n([\\s\\S]*?)```")
    var jjpqapji = zbjiboad.search(srxvuvyt)
    return jjpqapji.get_string(1).strip_edges() if jjpqapji else ""


static func hvejuevp(rxtzrcuo: String) -> Array:
    var emzljpzo = rxtzrcuo.replace("create_scene(", "").replace(")", "").strip_edges()
    var lnvrgfsi = []
    var hlgjrqjl = 0
    while true:
        var wiefdwoe = emzljpzo.find('"',hlgjrqjl)
        if wiefdwoe == -1:
            break
        var mcszeqwx = emzljpzo.find('"', wiefdwoe + 1)
        if mcszeqwx == -1:
            break
        lnvrgfsi.append(emzljpzo.substr(wiefdwoe + 1, mcszeqwx - wiefdwoe - 1))
        hlgjrqjl = mcszeqwx + 1
    return lnvrgfsi


                                                     
static func sqmjqpyy(itcfxwbi: String) -> Array:
    var tbwgmthu = itcfxwbi.replace("create_node(", "")
    
                                                                                                    
    var lvyscexk = tbwgmthu.rfind(")")
    if lvyscexk != -1:
        tbwgmthu = tbwgmthu.substr(0, lvyscexk)
    
    tbwgmthu = tbwgmthu.strip_edges()
    
                                                   
    var zphdeqhi = tbwgmthu.find("{")
    if zphdeqhi != -1:
        tbwgmthu = tbwgmthu.substr(0, zphdeqhi).strip_edges()
    
    var qtxvbuow = []
    var jkjarjxh = 0
    while true:
        var jkugmqla = tbwgmthu.find('"',jkjarjxh)
        if jkugmqla == -1:
            break
        var oqgrszkc = tbwgmthu.find('"', jkugmqla + 1)
        if oqgrszkc == -1:
            break
        qtxvbuow.append(tbwgmthu.substr(jkugmqla + 1, oqgrszkc - jkugmqla - 1))
        jkjarjxh = oqgrszkc + 1
    return qtxvbuow


                                                                             
                   
                                                                             
static func rtascdls(zyouhetc: String) -> Dictionary:
                                 
    var lrgodvet = zyouhetc.replace("edit_node(", "")

                                    
    if lrgodvet.ends_with(")"):
        lrgodvet = lrgodvet.substr(0, lrgodvet.length() - 1)

                     
    lrgodvet = lrgodvet.strip_edges()

                                                                  
    var sktxwxip = []
    var xkznipxd = 0
    while true:
        var ayafeiwp = lrgodvet.find('"',xkznipxd)
        if ayafeiwp == -1:
            break
        var udumxxnn = lrgodvet.find('"', ayafeiwp + 1)
        if udumxxnn == -1:
            break

        sktxwxip.append(lrgodvet.substr(ayafeiwp + 1, udumxxnn - ayafeiwp - 1))
        xkznipxd = udumxxnn + 1

                              
    var svxiecym = lrgodvet.find("{")
    var ymeofgpb = lrgodvet.rfind("}")
    if svxiecym == -1 or ymeofgpb == -1:
                                           
        return {}

    var rgzxkrat = lrgodvet.substr(svxiecym, ymeofgpb - svxiecym + 1)

                                             
    var lhvfstha = ""
    if sktxwxip.size() > 0:
        lhvfstha = sktxwxip[0]

    var rrosgihi = ""
    if sktxwxip.size() > 1:
        rrosgihi = sktxwxip[1]

    return {
        "node_name": lhvfstha,
        "scene_path": rrosgihi,
        "modifications": mzcbydau(rgzxkrat)
    }


static func mzcbydau(kqbslxpy: String) -> Dictionary:
                                                          
    var ghvyswtt = kqbslxpy.strip_edges()

                                    
    if ghvyswtt.begins_with("{"):
        ghvyswtt = ghvyswtt.substr(1, ghvyswtt.length() - 1)
                                     
    if ghvyswtt.ends_with("}"):
        ghvyswtt = ghvyswtt.substr(0, ghvyswtt.length() - 1)

                                      
    ghvyswtt = ghvyswtt.strip_edges()

                                                              
    var kercqedc = []
    var glvoasqk = ""
    var iulbaifk = 0

    for i in range(ghvyswtt.length()):
        var zlshvsvt = ghvyswtt[i]
        if zlshvsvt == "(":
            iulbaifk += 1
        elif zlshvsvt == ")":
            iulbaifk -= 1

        if zlshvsvt == "," and iulbaifk == 0:
            kercqedc.append(glvoasqk.strip_edges())
            glvoasqk = ""
        else:
            glvoasqk += zlshvsvt

    if glvoasqk != "":
        kercqedc.append(glvoasqk.strip_edges())

                                 
    var qkcsfdju = {}
    for entry in kercqedc:
        var nzhvrsww = entry.find(":")
        if nzhvrsww == -1:
            continue

        var bpnvmwsf = entry.substr(0, nzhvrsww).strip_edges()
        var lboyerly = entry.substr(nzhvrsww + 1).strip_edges()

                                                                        
        if bpnvmwsf.begins_with("\"") and bpnvmwsf.ends_with("\"") and bpnvmwsf.length() >= 2:
            bpnvmwsf = bpnvmwsf.substr(1, bpnvmwsf.length() - 2)

        qkcsfdju[bpnvmwsf] = lboyerly

    return qkcsfdju

static func pelqzjvy(rec_line: String) -> Dictionary:
    var qrwcusiy = rec_line.replace("edit_script(", "")
    var lnapydsu = qrwcusiy.length()
    if qrwcusiy.ends_with(")"):
        qrwcusiy = qrwcusiy.substr(0, lnapydsu - 1)
    
    lnapydsu = qrwcusiy.length()
    
    var emmdxhfn = []
    var ssyeiabt = 0
    var piykrird = false
    var gnateroc = ""
    
    for i in range(lnapydsu):
        var xnvnxkzo = qrwcusiy[i]
        var jhjwisqe = qrwcusiy[i-1]
        if xnvnxkzo == '"' and (i == 0 or jhjwisqe != '\\'):
            piykrird = !piykrird
            continue
            
        if !piykrird and xnvnxkzo == ',':
            emmdxhfn.append(gnateroc.strip_edges())
            gnateroc = ""
            continue
            
        gnateroc += xnvnxkzo
    
    if gnateroc != "":
        emmdxhfn.append(gnateroc.strip_edges())
    
    if emmdxhfn.size() < 2:
        return {}
    
    return {
        "path": emmdxhfn[0].strip_edges().trim_prefix('"').trim_suffix('"'),
        "message_id": emmdxhfn[1].to_int()
    }
