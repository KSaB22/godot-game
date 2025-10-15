extends HBoxContainer

signal joinGame(ip)

func _ready() -> void:
	pass
func _process(delta: float) -> void:
	pass


func _on_join_btn_pressed() -> void:
	joinGame.emit($IPLbl.text)
