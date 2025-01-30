extends Node2D
class_name QuadTreeNode

static var seta : SetaScript
static var colors : Array[Color] = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.ORANGE,
	Color.DEEP_PINK,
]
var colorIndex := 0
var filhos : Array[QuadTreeNode] = [null, null, null, null]
@onready var timer: Timer = $Timer
var camera : Cam
var pos: Vector2
var selected = false:
	set(value):
		selected = value
		if selected and seta:
			seta.goTo(global_position)
		queue_redraw()
var instanciado = false

@export var pai : QuadTreeNode = null:
	set(value):
		set_process(true)
		pai = value
		if not pai:
			return
		
		var tween = create_tween()
		tween.set_parallel(true)
		
		if pai:
			colorIndex = (pai.colorIndex + 1)%colors.size()
		
		var lMax : Vector2
		var lMin : Vector2
		
		if pai.global_position.x > global_position.x:
			lMax.x = pai.global_position.x
			lMin.x = pai.limitMin.x
		else:
			lMin.x = pai.global_position.x
			lMax.x = pai.limitMax.x
		if pai.global_position.y > global_position.y:
			lMax.y = pai.global_position.y
			lMin.y = pai.limitMin.y
		else:
			lMin.y = pai.global_position.y
			lMax.y = pai.limitMax.y
		
		limitMax = to_global(Vector2.ZERO)
		limitMin = to_global(Vector2.ZERO)
		tween.tween_property(self, "limitMax", lMax, 1)
		tween.tween_property(self, "limitMin", lMin, 1)
		await tween.finished
		set_process(false)

var limitMax : Vector2 = Vector2(1000, 1000)
var limitMin : Vector2 = Vector2(-1000, -1000)

enum Direcao {
	NE = 0,
	NW = 1,
	SW = 2,
	SE = 3
}

func addChild(child : QuadTreeNode) -> bool:
	if not child:
		return false
	
	selected = true
	var direcao : Direcao
	if child.pos.x >= global_position.x:
		if child.pos.y <= global_position.y:
			direcao = Direcao.NE
		else:
			direcao = Direcao.SE
	else:
		if child.pos.y <= global_position.y:
			direcao = Direcao.NW
		else:
			direcao = Direcao.SW
	
	timer.start(1.5)
	await timer.timeout
	selected = false
	
	if not filhos[direcao]:
		seta.goTo(child.pos)
		
		timer.start(1)
		await timer.timeout
		
		if !child.instanciado: #Se não estiver na cena, colocamos, setamos como instanciado e colocamos a global position
			get_tree().current_scene.call_deferred("add_child", child)
			child.instanciado = true
			child.global_position = child.pos
		filhos[direcao] = child
		child.pai = self as QuadTreeNode
		seta.visible = false
		return true
	else:
		return await filhos[direcao].addChild(child)

func auxRemove(x : float, y : float):
	if pos.x == x and pos.y == y:
		pai.filhos.erase(self)
		visible = false
		for f in filhos:
			await pai.addChild(f)
		queue_free()
		return
	
	var direcao : Direcao
	if x >= pos.x:
		if y <= pos.y:
			direcao = Direcao.NE
		else:
			direcao = Direcao.SE
	else:
		if y <= pos.y:
			direcao = Direcao.NW
		else:
			direcao = Direcao.SW
	
	if not filhos[direcao]:
		printerr("Valor não encontrado")
		return
	else:
		filhos[direcao].auxRemove(x, y)

func _ready() -> void:
	camera = get_viewport().get_camera_2d() as Cam

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var cor = colors[colorIndex]
	draw_circle(Vector2.ZERO, 15, cor)
	
	var lMin = to_local(limitMin)
	var lMax = to_local(limitMax)
	
	draw_line(Vector2(0, 0), Vector2(lMax.x, 0), cor, 6)
	draw_line(Vector2(0, 0), Vector2(lMin.x, 0), cor, 6)
	draw_line(Vector2(0, 0), Vector2(0, lMax.y), cor, 6)
	draw_line(Vector2(0, 0), Vector2(0, lMin.y), cor, 6)
	
	if selected:
		draw_circle(Vector2.ZERO, 7, Color.WHITE)
