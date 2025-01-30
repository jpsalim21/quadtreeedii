extends Node2D
class_name SelecaoArea

@export var cor : Color


func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var mousePos = get_local_mouse_position()
	var vetores : PackedVector2Array = []
	vetores.append(Vector2.ZERO)
	vetores.append(Vector2(0, mousePos.y))
	vetores.append(mousePos)
	vetores.append(Vector2(mousePos.x,  0))
	draw_polygon(vetores, [cor])
