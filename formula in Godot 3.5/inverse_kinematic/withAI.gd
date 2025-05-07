
extends Node2D

# R1 - R2
var L1 = 300
var L2 = 200

# Posisi awal (shoulder)
var x0 = 0.0
var y0 = 0.0

# Target awal
var tx = 4.0
var ty = 2.0

# Knee dan end-effector
var x1 = 0.0
var y1 = 0.0
var x2 = 0.0
var y2 = 0.0
#var scale = 1
var flip = false

func _ready():
	
	OS.set_window_title("IK math")

	var pos_target=$point.get_position()
	tx = pos_target.x
	ty = pos_target.y
	
	var pos_shoulder=$point2.get_position()
	x0 = pos_shoulder.x
	y0 = pos_shoulder.y
	
	
	update_ik(tx, ty)
	set_process_input(true)

func update_ik(tx: float, ty: float) -> void:
	var dx = tx - x0
	var dy = ty - y0
	var dist = sqrt(dx * dx + dy * dy)
	dist = min(dist, L1 + L2)

	var cos_theta2 = (pow(dist, 2) - pow(L1, 2) - pow(L2, 2)) / (2 * L1 * L2)
	cos_theta2 = clamp(cos_theta2, -1, 1)
	var theta2 = acos(cos_theta2)

	var angle_to_target = atan2(dy, dx)
	var cos_alpha = (pow(dist, 2) + pow(L1, 2) - pow(L2, 2)) / (2 * dist * L1)
	cos_alpha = clamp(cos_alpha, -1, 1)
	var alpha = acos(cos_alpha)
	
	var neg = 1
	
	if flip:
		neg = 1
		theta2 = -theta2
	else: 
		neg = -1
		
	var theta1 = angle_to_target + (alpha*neg)
	
	x1 = x0 + L1 * cos(theta1)
	y1 = y0 + L1 * sin(theta1)
	
	 
		
	x2 = x1 + L2 * cos(theta1 + theta2)
	y2 = y1 + L2 * sin(theta1 + theta2)

	update() 

func _draw():
	$point3.set_position(Vector2(x1,y1))

	draw_line(Vector2(x0, y0) , Vector2(x1, y1) , Color.white, 4)
	draw_line(Vector2(x1, y1) , Vector2(x2, y2) , Color.yellow, 4)
	#draw_circle(Vector2(tx, ty) , 5, Color.red)

func _input(event): # not used
	if event is InputEventMouseButton and event.pressed:
		var pos = event.position
		tx = pos.x
		ty = pos.y
		#update_ik(tx, ty)

func baru(): # get posision of target or shoulder
	var pos_target=$point.get_position()
	tx = pos_target.x
	ty = pos_target.y
	
	var pos_shoulder=$point2.get_position()
	x0 = pos_shoulder.x
	y0 = pos_shoulder.y
	update_ik(tx, ty) # update posisition knee

func _on_Button_pressed(): # to other IK  formula

	get_tree().change_scene("res://main.tscn")


func _on_Button2_toggled(button_pressed):
	flip = button_pressed
	baru()
