@tool
class_name Conversation
extends Node

                                                                             

var messages : Array[Message] = []
var title : String
var id : int = -1
var favorited : bool = false
var has_been_fetched : bool = false

class Message:
    var role : String
    var content : String

                                           
                                                                    
func dfkyejxn () -> String:
    if len(title) > 0:
        return title
    
    if len(messages) == 0:
        return "Empty chat..."
    
    return messages[0].content

func rutkpdqx (lclsviaa : String):
    var tawcresc = Message.new()
    tawcresc.role = "user"
    tawcresc.content = lclsviaa
    messages.append(tawcresc)

func azvdfrqn (qtfrxvnp : String):
    var jwajrsly = Message.new()
    jwajrsly.role = "assistant"
    jwajrsly.content = qtfrxvnp
    messages.append(jwajrsly)
