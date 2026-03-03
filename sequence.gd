extends CanvasLayer
@onready var main: Node = $"../.."

func _ready() -> void:
	for child in get_children():
		if child is Slide:
			main.slides.append(child)
	#for s in slides:
		#print(s.name)
