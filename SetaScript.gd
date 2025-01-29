extends Sprite2D
class_name SetaScript

var travado = false

func _ready() -> void:
	QuadTreeNode.seta = self as SetaScript

func goTo(pos : Vector2):
	if travado: 
		print("Retornei pq tava travado")
		return
	
	print("Chamei aq")
	travado = true
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "global_position", pos, 0.5)
	travado = false
	
