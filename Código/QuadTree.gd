extends Node2D
class_name QuadTree

var raiz : QuadTreeNode = null
const NODE = preload("res://Código/quad_tree_node.tscn")
@onready var timer: Timer = $Timer
@onready var textX: TextEdit = $"../UI/TextEdit"
@onready var textY: TextEdit = $"../UI/TextEdit2"

func adicionarPonto(x : float, y : float):
	if abs(x) > 10 or abs(y) > 10:
		printerr("VALORES IMPOSSÍVEIS")
		return
	x = x * 100
	y = -y * 100
	var novo = NODE.instantiate()
	novo.pos = Vector2(x, y)
	if not raiz:
		get_tree().current_scene.call_deferred("add_child", novo)
		novo.global_position = novo.pos
		raiz = novo
	else:
		QuadTreeNode.seta.global_position = raiz.global_position 
		raiz.addChild(novo)

func removerPonto(x : float, y : float):
	if abs(x) > 10 or abs(y) > 10:
		printerr("VALORES IMPOSSÍVEIS")
		return
	
	x = x * 100
	y = -y * 100
	if raiz:
		raiz.auxRemove(x, y)


func _ready() -> void:
	adicionarPonto(1, 1)

func _draw() -> void:
	for i in range(-1000, 1001, 100):
		draw_line(Vector2(-1000, i), Vector2(1000, i), Color.GRAY, 2, true)
		draw_line(Vector2(i, -1000), Vector2(i, 1000), Color.GRAY, 2, true)
	draw_line(Vector2(-1000, 0), Vector2(1000, 0), Color.BLACK, 3, true)
	draw_line(Vector2(0, -1000), Vector2(0, 1000), Color.BLACK, 3, true)


func _on_button_pressed() -> void:
	var x = float(textX.text)
	var y = float(textY.text)
	textX.text = ""
	textY.text = ""
	adicionarPonto(x, y)


func _on_button_2_pressed() -> void:
	var x = float(textX.text)
	var y = float(textY.text)
	textX.text = ""
	textY.text = ""
	removerPonto(x, y)
