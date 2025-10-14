@tool
extends Node

                                        
                             
                               

signal mcjnyvrb (conversation : Conversation)

                                                                    
signal pdthenie
signal cqywcivb

var yexrzbot : Array[Conversation]
var ggffstew : Conversation

@onready var gcnszgvh = $"../APIManager"
@onready var qfnxpxoz = $".."
@onready var lqmdubnk = $"../Screen_Conversations"

func _ready ():
    gcnszgvh.bkxzxham.connect(royvpoko)
    gcnszgvh.skidsnvx.connect(_on_send_message_received)
    
    gcnszgvh.xqpfhaju.connect(hejrhfeu)
    gcnszgvh.vujmskhi.connect(lffpuzkx)

func rtpfemdr () -> Conversation:
    msnyuwvt()                                            

    var lvebjzlv = Conversation.new()
    lvebjzlv.id = -1                                       
    yexrzbot.append(lvebjzlv)
    ggffstew = lvebjzlv
    return lvebjzlv

func msnyuwvt ():
    if ggffstew != null:
        if ggffstew.id == -1:                                    
            yexrzbot.erase(ggffstew)
    
    ggffstew = null

func npqopdzy (chudxith : Conversation):
    ggffstew = chudxith
    cqywcivb.emit()

                                                                    
                                                                              
func hejrhfeu (xlyrswbd):
    yexrzbot.clear()
    
    for conv_data in xlyrswbd:
        var kwzotbhn = Conversation.new()
        kwzotbhn.id = int(conv_data["id"])
        kwzotbhn.title = conv_data["title"]
        kwzotbhn.favorited = conv_data["isFavorite"]
        yexrzbot.append(kwzotbhn)
    
    pdthenie.emit()

                                   
func royvpoko(vqjqnjla: String):
    if ggffstew == null:
                                           
        rtpfemdr()
    
                                                     
                                                    
                           
       
    ggffstew.rutkpdqx(vqjqnjla)

func _on_send_message_received(syyqhvse: String, nlgzzstc: int):
    print("Received assistant message: ", {
        "conversation_id": nlgzzstc,
        "current_conv_id": ggffstew.id if ggffstew else "none",
        "content": syyqhvse
    })
    if ggffstew:
        if ggffstew.id == -1:
                                                                    
            ggffstew.id = nlgzzstc
        ggffstew.azvdfrqn(syyqhvse)

                                                                                      
                                                                     
func isgkodxl (jgvzembe : int):
    gcnszgvh.get_conversation(jgvzembe)

                                                            
                                                 
func lffpuzkx (msqgmflu):
    var acybwtbq : Conversation
    var jzskpiza = msqgmflu["id"]
    jzskpiza = int(jzskpiza)
    
                                                
    for c in yexrzbot:
        if c.id == jzskpiza:
            acybwtbq = c
            break
    
                                              
    if acybwtbq == null:
        acybwtbq = Conversation.new()
        acybwtbq.id = jzskpiza
        acybwtbq.title = msqgmflu["title"]
        yexrzbot.append(acybwtbq)
    
    acybwtbq.messages.clear()
    
                                                    
    for message in msqgmflu["messages"]:
        if message["role"] == "user":
            acybwtbq.rutkpdqx(message["content"])
        elif message["role"] == "assistant":
            acybwtbq.azvdfrqn(message["content"])
    
    acybwtbq.has_been_fetched = true
    npqopdzy(acybwtbq)

func aovhwlub (egkcueis : Conversation, cnhaosqu : bool):
    gcnszgvh.hnzqridt(egkcueis.id)
    
    if cnhaosqu:
        lqmdubnk.lcokectg("Adding favorite...")
    else:
        lqmdubnk.lcokectg("Removing favorite...")

func pvhdbmfx():
    return yexrzbot
    
func hwsraesx():
    return ggffstew
    
func dnlhpcqo(zkzjnifk: int):
    ggffstew.id = zkzjnifk
