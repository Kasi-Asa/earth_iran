extends Node
@onready var timer: Timer = $Timer
@onready var black_screen: ColorRect = $Control/BlackLayer/Blackout
@onready var gunshot_player: AudioStreamPlayer2D = $GunshotPlayer
var slides : Array[Slide]
var gunshot_sounds = [
	preload("res://audio/gunshot_2.ogg"),
	preload("res://audio/gunshot_3.ogg"),
	preload("res://audio/gunshot_5.ogg")
]
func _ready() -> void:
	await get_slide(0)
func get_slide(seq_num):
	if seq_num < slides.size():
		print(seq_num)
		print(slides.size())
		var slide = slides[seq_num]
		slide.visible = true
		
		if slide.need_input:
			print("need input")
			await wait_for_input(slide.next_input)
			print("correct input")
		else:
			print("wait...")
			timer.start(slide.wait_time)
			await timer.timeout
			print("time out")
		if slide.need_gun_shot:
			play_gunshot()
		await blackout(slide.blackout_time)
		slide.visible = false
		get_slide(seq_num + 1)
	else:
		print("End.")
		
func wait_for_input(input):
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed(input):
			return

func blackout(sec):
	black_screen.visible = true
	timer.start(sec)
	await timer.timeout
	black_screen.visible = false
func play_gunshot():
	gunshot_player.stream = gunshot_sounds.pick_random()
	gunshot_player.play()
