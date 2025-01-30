extends Camera2D
class_name Cam

var zoomSpeed := Vector2(0.1, 0.1)
var maxZoom : Vector2 = Vector2(0.6, 0.6)
var minZoom : Vector2 = Vector2(9.6, 9.6)

var travado := false

func goTo(pos : Vector2):
	travado = true
	var tween = create_tween()
	await tween.tween_property(self, "global_position", pos, 1)
	travado = false

func _process(delta: float) -> void:
	if travado: return
	
	if Input.is_action_just_released("WheelUp"):
		zoom = clamp(zoom + zoomSpeed, maxZoom, minZoom)
	if Input.is_action_just_released("WheelDown"):
		zoom = clamp(zoom - zoomSpeed, maxZoom, minZoom)
	if Input.is_action_pressed("MouseEsquerdo"):
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_DRAG)
	else:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)

func _input(event: InputEvent) -> void:
	if travado: return
	if event is InputEventMouseMotion and Input.is_action_pressed("MouseEsquerdo"):
		var newPos = global_position - event.relative
		newPos.x = clamp(newPos.x, limit_left, limit_right) #Não funciona da melhor forma, mas pra ser rápido é assim
		newPos.y = clamp(newPos.y, limit_top, limit_bottom)
		global_position = newPos
