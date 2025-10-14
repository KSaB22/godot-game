                                                       
@tool
extends Node

                                                 
                                      
                                   

signal pyeocobp (validated : bool, error : String)

signal flnzxrxk(update_available: bool, latest_version: String)
signal neuvrjjn(error: String)

signal skidsnvx (message : String, conv_id : int)
signal uhdmmyul (error : String)
signal bkxzxham (message : String)

signal xqpfhaju (data)
signal gvaakbif (error : String)

signal vujmskhi (data)
signal lkxhsgmo (error : String)

signal efsqzmsi ()
signal mftxywjz (error : String)

signal mmxlbrin ()
signal ssvbabvx (error : String)

signal uiyurcqx

const vsqbqosd = 30
const tbwqzffy = 120
const rdgycfuq = 60

var qrlifbkg : bool 

              
signal cackpbrl(content: String, conv_id: int, message_id: int)
signal datqgqyk(conv_id: int, message_id: int)
signal sqxyeklx(conv_id: int, message_id: int)
signal pclndlng(error: String)
var jhbowgzt : HTTPClient
var gfqmhfzc = false
var wokjxisc = ""
var ywbgasvk = false

var kpgnlsfk : String
var urgkbqbz : String
var epmqffqv : String
var jqvwdzgd : String
var eetrmabq : String
var nekwyejp : String
var huhqtcfa : String
var nbwjrshn : String

var zcrzewaa : String:
    get:
        var yrllvykv = EditorInterface.get_editor_settings()
        var lgzdqmrr = "null"
        qrlifbkg = yrllvykv.has_setting("gamedev_assistant/development_mode") and yrllvykv.get_setting('gamedev_assistant/development_mode') == true
        
        if not qrlifbkg and yrllvykv.has_setting("gamedev_assistant/token"):
            return yrllvykv.get_setting("gamedev_assistant/token")
        elif qrlifbkg and yrllvykv.has_setting("gamedev_assistant/token_dev"):        
            return yrllvykv.get_setting("gamedev_assistant/token_dev")
                    
        return lgzdqmrr

var yqrkfhov = ["Content-type: application/json", "Authorization: Bearer " + zcrzewaa]

@onready var glgjmfmt = $"../ConversationManager"

@onready var dbiexzsb : HTTPRequest = $ValidateToken
@onready var bplfzkhj : HTTPRequest = $SendMessage
@onready var osqzhiab : HTTPRequest = $GetConversationsList
@onready var stlwvier : HTTPRequest = $GetConversation
@onready var jvrbfnrk : HTTPRequest = $DeleteConversation
@onready var nubnscoo : HTTPRequest = $ToggleFavorite
@onready var jvwkdutq : HTTPRequest = $CheckUpdates
@onready var blimldic : HTTPRequest = $TrackAction
@onready var xllxqbqg : HTTPRequest = $RatingAction
@onready var kahfaeyx : HTTPRequest = $EditScript

var renqbaiv = []

var fzeisjer : Button = null

func _ready ():
                                      
    jhbowgzt = HTTPClient.new()
    
    dbiexzsb.timeout = vsqbqosd                                         
    bplfzkhj.timeout = tbwqzffy                                           
    osqzhiab.timeout = vsqbqosd                                 
    stlwvier.timeout = vsqbqosd                                       
    jvrbfnrk.timeout = vsqbqosd                                    
    nubnscoo.timeout = vsqbqosd
    jvwkdutq.timeout = vsqbqosd
    kahfaeyx.timeout = rdgycfuq
    
    dbiexzsb.request_completed.connect(zigyxhsi)
    bplfzkhj.request_completed.connect(zciwdiur)
    osqzhiab.request_completed.connect(lalldsxl)
    stlwvier.request_completed.connect(zhawhkni)
    jvrbfnrk.request_completed.connect(xcmtdnko)
    nubnscoo.request_completed.connect(sllgqqbx)
    jvwkdutq.request_completed.connect(iostkdag)
    kahfaeyx.request_completed.connect(txcdgdjm)
    
    uiyurcqx.connect(nqogyaej)  
    
    ajjyajpt ()
    

func ajjyajpt ():
    var lymnzqgw = EditorInterface.get_editor_settings()            
    if lymnzqgw.has_setting("gamedev_assistant/endpoint"):          
        kpgnlsfk = lymnzqgw.get_setting("gamedev_assistant/endpoint")    
        urgkbqbz = kpgnlsfk + "/token/validate"                
        epmqffqv = kpgnlsfk + "/chat/message"                         
        jqvwdzgd = kpgnlsfk + "/chat/conversations"        
        eetrmabq = kpgnlsfk + "/chat/conversation/"
        nekwyejp = kpgnlsfk + "/chat/checkForUpdates"
        huhqtcfa = kpgnlsfk + "/chat/track-action"
        nbwjrshn = kpgnlsfk + "/chat/track-rating"

func zasvmgfq ():
    return ["Content-type: application/json", "Authorization: Bearer " + zcrzewaa]

func xxlvjnoz ():
    var fvhybpik = dbiexzsb.request(urgkbqbz, zasvmgfq(), HTTPClient.METHOD_GET)

func fstoqbvo(msikpccq: String, wljeudie: bool, runmalau: String) -> void:
    
    bplfzkhj.timeout = vsqbqosd
    
                           
    gfqmhfzc = false
    ywbgasvk = false
    wokjxisc = ""
    
                                
    var bqiyjjrk = kpgnlsfk.begins_with("https://")
    var megttgqn = kpgnlsfk.replace("http://", "").replace("https://", "")
    
                                       
    var gmfxgvdg = -1
    if megttgqn.begins_with("localhost:"):
        var oqvkfghl = megttgqn.split(":")
        megttgqn = oqvkfghl[0]
        gmfxgvdg = int(oqvkfghl[1])
        
    var pzpfsggy: Error
    if bqiyjjrk:
        pzpfsggy = jhbowgzt.connect_to_host(megttgqn, gmfxgvdg, TLSOptions.client())
    else:
        pzpfsggy = jhbowgzt.connect_to_host(megttgqn, gmfxgvdg)
        
    if pzpfsggy != OK:
        pclndlng.emit("Failed to connect: " + str(pzpfsggy))
        return

    gfqmhfzc = true
    
                             
    var jigtbfxn = EditorInterface.get_editor_settings()
    var mdzgbkbk = jigtbfxn.get_setting("gamedev_assistant/version_identifier")
    
    var fuihcpuk = Engine.get_version_info()
    var kjxcpioz = "%d.%d" % [fuihcpuk.major, fuihcpuk.minor]
    
                                           
    var hbkfdnaa = ""
    if jigtbfxn.has_setting("gamedev_assistant/custom_instructions"):
        hbkfdnaa = jigtbfxn.get_setting("gamedev_assistant/custom_instructions")
    
    
                              
    var jyzqxgrq = { 
        "content": msikpccq, 
        "useThinking": wljeudie,
        "releaseUniqueIdentifier": mdzgbkbk,
        "godotVersion": kjxcpioz,
        "mode": runmalau,
        "customInstructions": hbkfdnaa
    }
    
    var uvqflpgq = glgjmfmt.hwsraesx()
    
    if uvqflpgq and uvqflpgq.id > 0:
        jyzqxgrq["conversationId"] = uvqflpgq.id
        
                                                            
    
                                                
    figdrpwb(jyzqxgrq)
    
    bkxzxham.emit(msikpccq)

func enpbtfrn ():
    var hwaqvkmx = osqzhiab.request(jqvwdzgd, zasvmgfq(), HTTPClient.METHOD_GET)

func get_conversation (gztfanye : int):
    var jiftzizx = eetrmabq + str(gztfanye)
    var ikmollwr = stlwvier.request(jiftzizx, zasvmgfq(), HTTPClient.METHOD_GET)

func hauyjpeu (dvitofrc : int):
    var zvamzhgj = eetrmabq + str(dvitofrc)
    var hxzsixbg = jvrbfnrk.request(zvamzhgj, zasvmgfq(), HTTPClient.METHOD_DELETE)

func hnzqridt (rwskjvnf : int):
    var aggrrdjl = eetrmabq + str(rwskjvnf) + "/toggle-favorite"
    var akkjmsnt = nubnscoo.request(aggrrdjl, zasvmgfq(), HTTPClient.METHOD_POST)

func zigyxhsi(ijmubkwi: int, zdolmqah: int, rsbuvhhg: PackedStringArray, ldrewpmn: PackedByteArray):
                                
    if ijmubkwi != HTTPRequest.RESULT_SUCCESS:
        pyeocobp.emit(false, "Network error (Code: " + str(ijmubkwi) + ")")
        return
        
    var tkfxgyct = yabhuvee(ldrewpmn)
    if not tkfxgyct is Dictionary:
        pyeocobp.emit(false, "Response error (Code: " + str(zdolmqah) + ")")
        return
        
    var pegefpfj = tkfxgyct.get("success", false)
    var mglddzkx = tkfxgyct.get("error", "Response code: " + str(zdolmqah))
    
    pyeocobp.emit(pegefpfj, mglddzkx)

                                                     
func zciwdiur(xehwqcts, wxxaohxt, qbqaborv, teogkhoa):
    
    if xehwqcts != HTTPRequest.RESULT_SUCCESS:
        uhdmmyul.emit("Network error (Code: " + str(xehwqcts) + ")")
        return
        
    var zscaawqo = yabhuvee(teogkhoa)
    if not zscaawqo is Dictionary:
        uhdmmyul.emit("Response error (Code: " + str(wxxaohxt) + ")")
        return
    
    if wxxaohxt == 201:
        var acuuujuo = zscaawqo.get("content", "")
        var bigykprp = int(zscaawqo.get("conversationId", -1))
        skidsnvx.emit(acuuujuo, bigykprp)
    else:
        uhdmmyul.emit(zscaawqo.get("error", "Response code: " + str(wxxaohxt)))

                                                                    
func lalldsxl(vggxsocw, izozimzm, xbdukdep, ndxympoe):
    if vggxsocw != HTTPRequest.RESULT_SUCCESS:
        gvaakbif.emit("Network error (Code: " + str(vggxsocw) + ")")
        return
        
    var mkvnjkvf = yabhuvee(ndxympoe)
    
    if izozimzm == 200:
        xqpfhaju.emit(mkvnjkvf)
    else:
        if mkvnjkvf is Dictionary:
            gvaakbif.emit(mkvnjkvf.get("error", "Response code: " + str(izozimzm)))
        else:
            gvaakbif.emit("Response error (Code: " + str(izozimzm) + ")")

                                                                
func zhawhkni(skiiyvoj, jsybjnuk, dudaatov, wqsqjmhk):
    if skiiyvoj != HTTPRequest.RESULT_SUCCESS:
                                                              
        printerr("[GameDev Assistant] Get conversation network error (Code: " + str(skiiyvoj) + ")")
        return
        
    var rbfddeyo = yabhuvee(wqsqjmhk)
    if not rbfddeyo is Dictionary:
        printerr("[GameDev Assistant] Get conversation response error (Code: " + str(jsybjnuk) + ")")
        return
        
    vujmskhi.emit(rbfddeyo)

                                                                                         
func xcmtdnko(plfkdady, tgjzjcny, aldwilgk, rnviawaw):
    if plfkdady != HTTPRequest.RESULT_SUCCESS:
                                                                          
        printerr("[GameDev Assistant] Delete conversation network error (Code: " + str(plfkdady) + ")")
        return
        
    if tgjzjcny == 204:
        efsqzmsi.emit()
    else:
        var sbxvxmzx = yabhuvee(rnviawaw)
        var agwrxkfu = "[GameDev Assistant] Response code: " + str(tgjzjcny)
        if sbxvxmzx is Dictionary:
            agwrxkfu = sbxvxmzx.get("error", agwrxkfu)
        mftxywjz.emit(agwrxkfu)

                                                                                                       
func sllgqqbx(eaagbmsf, vrbfkuoy, ykskbyyc, behrlwwp):
    if eaagbmsf != HTTPRequest.RESULT_SUCCESS:
                                                                      
        printerr("[GameDev Assistant] Toggle favorite network error (Code: " + str(eaagbmsf) + ")")
        return
        
    if vrbfkuoy == 200:
        mmxlbrin.emit()
    else:
        var xxgqiedt = yabhuvee(behrlwwp)
        var qotwgdtx = "[GameDev Assistant] Response code: " + str(vrbfkuoy)
        if xxgqiedt is Dictionary:
            qotwgdtx = xxgqiedt.get("error", qotwgdtx)
        ssvbabvx.emit(qotwgdtx)

func yabhuvee (qrrqjdxh):
    var drawqhdl = JSON.new()
    var zlsfohlw = drawqhdl.parse(qrrqjdxh.get_string_from_utf8())
    if zlsfohlw != OK:
        return null
    return drawqhdl.get_data()

func figdrpwb(mkefmaeu: Dictionary) -> void:
    while gfqmhfzc:
        jhbowgzt.poll()
        
        match jhbowgzt.get_status():
            HTTPClient.STATUS_CONNECTION_ERROR:
                pclndlng.emit("Connection error")
                nqogyaej()
                return
            HTTPClient.STATUS_DISCONNECTED:
                pclndlng.emit("Disconnected")
                nqogyaej()
                return
            
            HTTPClient.STATUS_CONNECTED:
                if not ywbgasvk:
                    ilqjgeks(mkefmaeu)
                
            HTTPClient.STATUS_BODY:
                facbcjlo()
        
        await get_tree().process_frame

func ilqjgeks(eaaqlufz: Dictionary) -> void:
    if ywbgasvk:
        return
    ywbgasvk = true
    
    var tdainxox = JSON.new()
    var jpxtjuop = tdainxox.stringify(eaaqlufz)
    var jovtnjda = PackedStringArray([
        "Content-Type: application/json",
        "Authorization: Bearer " + zcrzewaa
    ])
    
    var mmjopesf = jhbowgzt.request(
        HTTPClient.METHOD_POST,
        epmqffqv.replace(kpgnlsfk, ""),                                        
        jovtnjda,
        jpxtjuop
    )
    
    if mmjopesf != OK:
        pclndlng.emit("Failed to send request: " + str(mmjopesf))
        gfqmhfzc = false
        ywbgasvk = false

func facbcjlo() -> void:
    while jhbowgzt.get_status() == HTTPClient.STATUS_BODY:
        var gzadsuof = jhbowgzt.read_response_body_chunk()
        if gzadsuof.size() == 0:
            break
            
        wokjxisc += gzadsuof.get_string_from_utf8()
        
        uzftffre()

func uzftffre() -> void:
    
    var pvyhsccp
    var adejehdf
    var xkdqxjrl
    
    if jhbowgzt.get_response_code() != 200:
        gfqmhfzc = false
        
        pvyhsccp = JSON.new()
        adejehdf = pvyhsccp.parse(wokjxisc)
        
        if adejehdf == OK:
            xkdqxjrl = pvyhsccp.get_data()
            if xkdqxjrl.has("error"):                
                pclndlng.emit(xkdqxjrl["error"])
            elif xkdqxjrl.has("message"):                
                pclndlng.emit(xkdqxjrl["message"])
            else:
                pclndlng.emit("Unknown server error, please try again later")
        else: 
            pclndlng.emit("Could not parse server response. Received from server: " + wokjxisc)
    
    var sosdkqql = wokjxisc.split("\n\n")
    
                                                                                 
    for i in range(sosdkqql.size() - 1):
        var xtwbpale: String = sosdkqql[i]
        if xtwbpale.find("data:") != -1:
            var pcousttu = xtwbpale.split("\n")
            for line in pcousttu:
                if line.begins_with("data:"):
                    var rsjxolzw = line.substr(5).strip_edges()
                                                               
                    
                    pvyhsccp = JSON.new()
                    adejehdf = pvyhsccp.parse(rsjxolzw)
                    
                    if adejehdf == OK:
                        xkdqxjrl = pvyhsccp.get_data()
                        
                        if xkdqxjrl is Dictionary:
                            if xkdqxjrl.has("error"):
                                printerr("Server error: ", xkdqxjrl["error"])
                                pclndlng.emit(xkdqxjrl["error"])
                                nqogyaej()
                                return
                            
                            if xkdqxjrl.has("done") and xkdqxjrl["done"] == true:
                                gfqmhfzc = false
                                                                
                                datqgqyk.emit(
                                    int(xkdqxjrl.get("conversationId", -1)),
                                    int(xkdqxjrl.get("messageId", -1))
                                )
                                nqogyaej()
                                
                            elif xkdqxjrl.has("beforeActions"):
                                sqxyeklx.emit(
                                    int(xkdqxjrl.get("conversationId", -1)),
                                    int(xkdqxjrl.get("messageId", -1))
                                )
                                
                            elif xkdqxjrl.has("content"):
                                
                                if (typeof(xkdqxjrl.get("messageId")) != TYPE_INT and typeof(xkdqxjrl.get("messageId")) != TYPE_FLOAT) or (typeof(xkdqxjrl.get("conversationId")) != TYPE_INT and typeof(xkdqxjrl.get("conversationId")) != TYPE_FLOAT):
                                    pclndlng.emit("Invalid data coming from the server")
                                    nqogyaej()
                                    return                                   
                            
                                cackpbrl.emit(
                                    str(xkdqxjrl["content"]),
                                    int(xkdqxjrl.get("conversationId", -1)),
                                    int(xkdqxjrl.get("messageId", -1))
                                )
                        
                                               
    wokjxisc = sosdkqql[sosdkqql.size() - 1]
    
func nqogyaej():  
    gfqmhfzc = false  
    jhbowgzt.close()            

                                                                  
func xuctghjw(jlwuisrw: bool = false):
    var vgowgswb = EditorInterface.get_editor_settings()       
    var bidrvgcv = vgowgswb.get_setting("gamedev_assistant/version_identifier")
    
    var eithboco = {
        "releaseUniqueIdentifier": bidrvgcv,
        "isInit": jlwuisrw
    }
    var vsycmbjp = JSON.new()
    var weibdzhz = vsycmbjp.stringify(eithboco)
    var vuaqxjcv = jvwkdutq.request(nekwyejp, zasvmgfq(), HTTPClient.METHOD_POST, weibdzhz)

                                            
func iostkdag(gopiyafz, nntjpluv, ugkeibzm, ytttjosn):
    if gopiyafz != HTTPRequest.RESULT_SUCCESS:
        neuvrjjn.emit("[GameDev Assistant] Network error when checking for updates (Code: " + str(gopiyafz) + ")")
        return
        
    var jodxetod = yabhuvee(ytttjosn)
    if not jodxetod is Dictionary:
        neuvrjjn.emit("[GameDev Assistant] Response error when checking for updates (Code: " + str(nntjpluv) + ")")
        return
    
    if nntjpluv == 200:
        var xctknjad = jodxetod.get("updateAvailable", false)
        var gnseyywr = jodxetod.get("latestVersion", "")
        
        flnzxrxk.emit(xctknjad, gnseyywr)
    else:
        neuvrjjn.emit(jodxetod.get("error", "Response code: " + str(nntjpluv)))

func quxzgytl(gztgmrdv: int, usvurfon: bool, qotnlwud: String, foujwybw: String, ihotwnjh: String, xxpjfgrt: String):
    var wsfsfewd = {
        "messageId": gztgmrdv,
        "success": usvurfon,
        "action_type": qotnlwud,
        "node_type": foujwybw,
        "subresource_type": ihotwnjh,
        "error_message": xxpjfgrt
    }
    renqbaiv.append(wsfsfewd)
    zohawzbt()

                             
func zohawzbt():
    var client_status = blimldic.get_http_client_status()
                                                                                      
    if (client_status == HTTPClient.STATUS_DISCONNECTED or 
        client_status == HTTPClient.STATUS_CANT_RESOLVE or 
        client_status == HTTPClient.STATUS_CANT_CONNECT or 
        client_status == HTTPClient.STATUS_CONNECTION_ERROR or 
        client_status == HTTPClient.STATUS_TLS_HANDSHAKE_ERROR) and renqbaiv.size() > 0:
        
        var rkcoygjw = renqbaiv.pop_front()
        var sfeeelty = JSON.new()
        var wlbvtdiy = sfeeelty.stringify(rkcoygjw)
        var qkmlpjgd = zasvmgfq()
        var kwcasxqr = blimldic.request(huhqtcfa, qkmlpjgd, HTTPClient.METHOD_POST, wlbvtdiy)
        if kwcasxqr != OK:
            printerr("Failed to start track action request:", kwcasxqr)
            zohawzbt()                                  

func hcmrwhsa(dgkjoxay, iyyprfqv, usogylar, njdskbbf):
    zohawzbt()                                      
    if dgkjoxay != HTTPRequest.RESULT_SUCCESS:
        printerr("[GameDev Assistant] Track action failed:", dgkjoxay)
        return
        
    var uhmaqwmy = yabhuvee(njdskbbf)
    if not uhmaqwmy is Dictionary:
        printerr("[GameDev Assistant] Invalid track action response")

func zquxxxqr(zjnznebw: int, gdvwlhtv: int) -> void:
    var juxzhkjs = {
        "messageId": zjnznebw,
        "rating": gdvwlhtv
    }
    var tqnbfwai = JSON.new()
    var mhbzrzmw = tqnbfwai.stringify(juxzhkjs)
    var hjgizylu = zasvmgfq()
    var xxnrqrqi = xllxqbqg.request(nbwjrshn, hjgizylu, HTTPClient.METHOD_POST, mhbzrzmw)
    if xxnrqrqi != OK:
        printerr("[GameDev Assistant] Failed to track rating:", xxnrqrqi)

                                          
func cnbqwmlg(gudygpkt, rbnfmtvn, bqfpomfl, zzayxqeq):
    if gudygpkt != HTTPRequest.RESULT_SUCCESS:
        printerr("[GameDev Assistant] Rating action failed:", gudygpkt)
        return
        
    var fvdejehb = yabhuvee(zzayxqeq)
    if not fvdejehb is Dictionary:
        printerr("[GameDev Assistant] Invalid rating response")
        return

func bctnbiyj():
    return gfqmhfzc
func gijuktjr(ndhpypqw: Object) -> void:
    print("=== Methods ===")
    for method in ndhpypqw.get_method_list():
        print(method["name"])
    
    print("\n=== Properties ===")
    for property in ndhpypqw.get_property_list():
        print(property["name"])
    
    print("\n=== Signals ===")
    for signal_info in ndhpypqw.get_signal_list():
        print(signal_info["name"])
        
func tpujdvrs(diyjcajw: String, lklyzawq: int, pbptpmgu: String, jkekiivt: Button) -> void:
                                         
    fzeisjer = jkekiivt
    
                                                                  
    var fkbkeanz = $"../ActionManager"
    fkbkeanz.cqbbfiup.emit("edit_script", true)
    jkekiivt.text = "⌛Editing file %s" % diyjcajw

    var qqyqrwek = {
        "path": diyjcajw,
        "message_id": lklyzawq,
        "content": pbptpmgu
    }
    
    var ngcrhjbx = JSON.new()
    var jefkruuf = ngcrhjbx.stringify(qqyqrwek)
    var oilgtxwu = zasvmgfq()
                                                     
    
    var jcmsgimx = kpgnlsfk + "/editScript"
    var kltlpkli = kahfaeyx.request(jcmsgimx, oilgtxwu, HTTPClient.METHOD_POST, jefkruuf)
    
    if kltlpkli != OK:
        var rqirmecm = "Failed to start edit_script request: " + str(kltlpkli)
        push_error(rqirmecm)
                                   
                                                      
        fkbkeanz.atctvhdo.emit("edit_script", false,rqirmecm, "", "", jkekiivt)
        
func txcdgdjm(igsvaskm: int, qmgeupto: int, tamqsqqb: PackedStringArray, yfnvppyg: PackedByteArray) -> void:
    var ovgzzppa = $"../ActionManager"
    var ysuhijfg = fzeisjer

                                                                
    if igsvaskm != HTTPRequest.RESULT_SUCCESS:
        var koexoldy = "EditScript network request failed. Code: " + str(igsvaskm)
        push_error(koexoldy)
        ovgzzppa.atctvhdo.emit("edit_script", false, koexoldy, "", "", ysuhijfg)
        return

                                                      
    var totpmtfk = yabhuvee(yfnvppyg)
    if not totpmtfk is Dictionary:
        var koexoldy = "Invalid response from server (not valid JSON)."
        push_error(koexoldy)
        ovgzzppa.atctvhdo.emit("edit_script", false, koexoldy, "", "", ysuhijfg)
        return

                                                         
    if totpmtfk.has("error"):
        var koexoldy = "Server returned an error: " + str(totpmtfk["error"])
        push_error(koexoldy)
        ovgzzppa.atctvhdo.emit("edit_script", false, koexoldy, "", "", ysuhijfg)
        return

    var rrnwprnd = totpmtfk.get("path", "")
    var ccicnakx = totpmtfk.get("content", "")

                                                  
    if rrnwprnd.is_empty():
        var koexoldy = "Incomplete data in EditScript response (path or content missing)."
        push_error(koexoldy)
        ovgzzppa.atctvhdo.emit("edit_script", false, koexoldy, "", "", ysuhijfg)
        return

                                                         
    var fkbrfanu = FileAccess.open(rrnwprnd, FileAccess.WRITE)
    if fkbrfanu:
        fkbrfanu.store_string(ccicnakx)
        fkbrfanu.close()

                                                        
        var yqucblrd = ResourceLoader.load(rrnwprnd, "Script", ResourceLoader.CACHE_MODE_IGNORE)
        await get_tree().process_frame
        
                                                                          
                                                                                 
        var hftclbje = ysuhijfg.get_meta("action")
        ysuhijfg.text = "Edit {path}".format({"path": hftclbje.path})

        var esliuuke = Engine.get_singleton("EditorInterface")
        var vkhkzfzd = esliuuke.get_script_editor()
        var pdsdojas = false
        for i in range(vkhkzfzd.get_open_scripts().size()):
            var vqnlamca = vkhkzfzd.get_open_scripts()[i]
            if vqnlamca.resource_path == rrnwprnd:
                vkhkzfzd.get_open_script_editors()[i].get_base_editor().set_text(ccicnakx)
                push_warning("[GameDev Assistant] File updated: " + rrnwprnd + " (due to a Godot API limitation, it will appear as unsaved, but it has been saved to disk!)")
                pdsdojas = true
                break

        if not pdsdojas:
            print("[GameDev Assistant] File updated: " + rrnwprnd)

        esliuuke.get_resource_filesystem().scan()
        await get_tree().process_frame
        esliuuke.edit_script(yqucblrd)                           

                                 
        ovgzzppa.atctvhdo.emit("edit_script", true, "", "", "", ysuhijfg)
    else:
                                                         
        var xyudwand = FileAccess.get_open_error()
        var koexoldy = "Failed to write to script '%s'. Error: %s" % [rrnwprnd, error_string(xyudwand)]
        push_error("[GameDev Assistant] " + koexoldy)
        ovgzzppa.atctvhdo.emit("edit_script", false, koexoldy, "", "", ysuhijfg)
