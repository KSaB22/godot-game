                                                              
@tool
class_name MarkdownToBBCode
extends RefCounted

const ytptdquq = [
    "b", "i", "u", "s", "code", "char", "p", "center", "left", "right", "fill",
    "indent", "url", "hint", "img", "font", "font_size", "dropcap",
    "opentype_features", "lang", "color", "bgcolor", "fgcolor", "outline_size",
    "outline_color", "table", "cell", "ul", "ol", "lb", "rb", "lrm", "rlm",
    "lre", "rle", "lro", "rlo", "pdf", "alm", "lri", "rli", "fsi", "pdi",
    "zwj", "zwnj", "wj", "shy"
]


                                                                    
                              
                                                                
                                                                    
static func icodbtmp(bagsrooy: Array, lffmddmz: String) -> String:
    var fqxolobz = ""
    for i in range(bagsrooy.size()):
        if i > 0:
            fqxolobz += lffmddmz
        fqxolobz += str(bagsrooy[i])
    return fqxolobz


                                                                    
                                     
 
                                
                                                              
                                                                         
                                                                    
static func psrmlqvh(hhtjywsv: String) -> String:
    var xxmwwmlj = hhtjywsv.split("\n")
    var algaejcy = []
    var andtqgli = false
    var aouljelk = []
    var fhlrynmd = []

    for line in xxmwwmlj:
        var twhmvydk = line.strip_edges(true, false)                       

        if twhmvydk.begins_with("```"):
            if andtqgli:
                                
                var jmjhwqya = icodbtmp(aouljelk, "\n")
                jmjhwqya = rhzzchtq(jmjhwqya)

                                                       
                if fhlrynmd.size() > 0:
                    var wbafffwa = icodbtmp(fhlrynmd, "\n")
                    wbafffwa = rhzzchtq(wbafffwa)
                    wbafffwa = dfneqola(wbafffwa)
                    algaejcy.append(wbafffwa)
                    fhlrynmd.clear()

                algaejcy.append("\n[table=1]\n[cell bg=#000000]\n[code]" + jmjhwqya + "[/code]\n[/cell]\n[/table]\n")
                aouljelk.clear()
                andtqgli = false
            else:
                                  
                if fhlrynmd.size() > 0:
                    var ffcecntp = icodbtmp(fhlrynmd, "\n")
                    ffcecntp = rhzzchtq(ffcecntp)
                    ffcecntp = dfneqola(ffcecntp)
                    algaejcy.append(ffcecntp)
                    fhlrynmd.clear()
                andtqgli = true
        elif andtqgli:
            aouljelk.append(line)
        else:
            fhlrynmd.append(line)

                                 
    if andtqgli and aouljelk.size() > 0:
                             
        var fdingmpb = icodbtmp(aouljelk, "\n")
        fdingmpb = rhzzchtq(fdingmpb)
        var tnbpbvbj = qphvyxct(fdingmpb)
        algaejcy.append("[p][/p][table=1]\n[cell bg=#000000]\n[code]" + tnbpbvbj + "[/code]\n[/cell]\n[/table]")
    elif fhlrynmd.size() > 0:
        var rqhymfjo = icodbtmp(fhlrynmd, "\n")
        rqhymfjo = rhzzchtq(rqhymfjo)
        rqhymfjo = dfneqola(rqhymfjo)
        algaejcy.append(rqhymfjo)

    return icodbtmp(algaejcy, "\n")


                                                                    
                                         
 
                                                    
                                                                                  
                                                                            
                                                                    
static func uyvgxpne(zhjtllnj: String) -> Array:
    var vhgnsopo = []
    var ikpdplqs = zhjtllnj.split("\n")

    var pkequcof = false
    var nablvnzm = []
    var gvyodznu = []

    for line in ikpdplqs:
        var lkmvxlop = line.strip_edges()

        if lkmvxlop.begins_with("```"):
            if pkequcof:
                                    
                var stpqufqm = icodbtmp(gvyodznu, "\n")
                vhgnsopo.append({ "type": "code", "content": stpqufqm })
                gvyodznu.clear()
                pkequcof = false
            else:
                                    
                if nablvnzm.size() > 0:
                    var luqjlfsf = icodbtmp(nablvnzm, "\n")
                    vhgnsopo.append({ "type": "text", "content": luqjlfsf })
                    nablvnzm.clear()
                pkequcof = true
        elif pkequcof:
            gvyodznu.append(line)
        else:
            nablvnzm.append(line)

                                      
    if nablvnzm.size() > 0:
        var nxzbjnoz = icodbtmp(nablvnzm, "\n")
        vhgnsopo.append({ "type": "text", "content": nxzbjnoz })
    elif pkequcof and gvyodznu.size() > 0:
        var oztkhdrh = icodbtmp(gvyodznu, "\n")
        vhgnsopo.append({ "type": "code", "content": oztkhdrh })

    return vhgnsopo


                             
                           
                             

static func qphvyxct(xtkysjik: String) -> String:
    var wsivxudv = xtkysjik.split("\n")
    var lnryeazh = 0
    
                           
    for line in wsivxudv:
        lnryeazh = max(lnryeazh, line.length())
    
                                    
    for i in range(wsivxudv.size()):
        var btenhdja = "  "
        var mgosykgq = "  "
        wsivxudv[i] = btenhdja + wsivxudv[i] + mgosykgq
    
    return icodbtmp(wsivxudv, "\n") + "\n"


static func dfneqola(fvtsgaqj: String) -> String:
    var ejpjylxl = fvtsgaqj
    var vednciat = ejpjylxl.split("\n")
    var ncqiwgla = []

    for line in vednciat:
                        
        if line.begins_with("## "):
            line = "[font_size=22][b]" + line.substr(3) + "[/b][/font_size]"
        elif line.begins_with("### "):
            line = "[font_size=18][b]" + line.substr(4) + "[/b][/font_size]"
        elif line.begins_with("#### "):
            line = "[font_size=16][b]" + line.substr(4) + "[/b][/font_size]"
        
               
        line = atqnjhka(line)
        ncqiwgla.append(line)

    ejpjylxl = icodbtmp(ncqiwgla, "\n")

                               
    var bxtsuvjz = ejpjylxl.split("***")
    ejpjylxl = ""
    for i in range(bxtsuvjz.size()):
        ejpjylxl += bxtsuvjz[i]
        if i < bxtsuvjz.size() - 1:
            if i % 2 == 0:
                ejpjylxl += "[b][i]"
            else:
                ejpjylxl += "[/i][/b]"

                           
    var itveqzwh = ejpjylxl.split("**")
    var skasxfcj = ""
    for i in range(itveqzwh.size()):
        skasxfcj += itveqzwh[i]
        if i < itveqzwh.size() - 1:
            if i % 2 == 0:
                skasxfcj += "[b]"
            else:
                skasxfcj += "[/b]"
    ejpjylxl = skasxfcj

                           
    var tushepxb = RegEx.new()
    tushepxb.compile("(?<![\\s])(\\*)(?![\\s])([^\\*]+?)(?<![\\s])\\*(?![\\s])")
    ejpjylxl = tushepxb.sub(ejpjylxl, "[i]$2[/i]", true)
    
    return ejpjylxl

static func fvwoztum(bkvxmfyh: String, zqgbsbvx: String, ocvtachw: int) -> bool:
    var tqcogpev = ocvtachw + bkvxmfyh.length()
    while tqcogpev < zqgbsbvx.length():
        var mictljcs = zqgbsbvx[tqcogpev]
        if mictljcs == "(":
            return true
        elif mictljcs == " " or mictljcs == "\t":
            tqcogpev += 1
        else:
            return false
    return false


static func lnrfrasl(licyadul: String, vmkobghr: Color) -> String:
    return "[vmkobghr =#" + vmkobghr.to_html(false) + "]" + licyadul + "[/color]"


static func rhzzchtq(osatwneq: String) -> String:
    var tljajsiy = osatwneq
    var dwcmszkc = RegEx.new()
    dwcmszkc.compile("\\[(/?)(\\w+)((?:[= ])[^\\]]*)?\\]")

    var ytzaoold = dwcmszkc.search_all(tljajsiy)
    ytzaoold.reverse()
    for match in ytzaoold:
        var ozvxysyr = match.get_string()
        var dxfzweal = match.get_string(2).to_lower()
        if dxfzweal in ytptdquq:
            var omvkygtt = match.get_start()
            var cgmrafac = match.get_end()
            var ztlkpeqr = ""
            for c in ozvxysyr:
                if c == "[":
                    ztlkpeqr += "[lb]"
                elif c == "]":
                    ztlkpeqr += "[rb]"
                else:
                    ztlkpeqr += c
            tljajsiy = tljajsiy.substr(0, omvkygtt) + ztlkpeqr + tljajsiy.substr(cgmrafac)

    return tljajsiy


static func atqnjhka(erqaqwvo: String) -> String:
    var hijeykhj = RegEx.new()
                                      
    hijeykhj.compile("\\[(.+?)\\]\\((.+?)\\)")
    var fykqhuam = erqaqwvo
    var vimtvvnj = hijeykhj.search_all(erqaqwvo)
    vimtvvnj.reverse()
    for match in vimtvvnj:
        var gqbhdqji = match.get_string()
        var mipkxsca = match.get_string(1)
        var rqacdnxj = match.get_string(2)
                             
        var oonlduuh = "[url=%s]%s[/url]" % [rqacdnxj, mipkxsca]
        fykqhuam = fykqhuam.substr(0, match.get_start()) + oonlduuh + fykqhuam.substr(match.get_end())
    return fykqhuam
