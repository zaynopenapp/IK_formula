extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var v2=Vector2()
var over = false
var object_parent=null
var point = 0
var v_CD = Vector2()
var diameterB = 100
var diameterA = 100
var diameterC = 100
var kurangin = 0.5
var tracktor = false
var jarakDC = 100
var T3_bones = false
var R_virtual = 0.0
var pos_keni = Vector2(0,0)

var a=Vector2(0,0)
var m=Vector2(0,0)
var b=Vector2(0,0)
var c=Vector2(0,0)
var d=Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	a=$point.get_position()
	m=$point.get_rect().size/2
	b=$point2.get_position()
	c=$point3.get_position()
	d=$point4.get_position()
	
	
	OS.set_window_title("IK interception two circle")
	
	if not T3_bones:
		$point2.set_nama("target")
		$point3.hide()
	
	
func get_intersections(x0,y0,r0,x1,y1,r1):

	var xs=x1-x0
	var ys=y1-y0
	var d=sqrt(pow(xs,2)+pow(ys,2))
	over = false
	if d >= r0+r1:
		over = true
	
		return null
	if d <= abs(r0-r1):
		over = false
		return null
	if d==0 and r0 == r1:
		over = false	
		return null
	else:

		var rx2 = pow(r0,2)
		var a = (rx2-pow(r1,2)+pow(d,2))/(2*d) # GET x
		var h = sqrt(rx2-pow(a,2)) # GET y

		var xsd=xs*1/d
		var ysd=ys*1/d
		
		var xl=x0+a*xsd
		var yl=y0+a*ysd
	
		var x3=xl+h*ysd
		var y3=yl-h*xsd
		
		var x4=xl-h*ysd
		var y4=yl+h*xsd
		
		var val=[Vector2(x3,y3),Vector2(x4,y4)] # RETURN 2 POINT
		
		return val
	
func _draw():
	var a=$point.get_position()
	var m=$point.get_rect().size/2
	var b=$point2.get_position()
	var c=$point3.get_position()
	var d=$point4.get_position()
	
	var totalABC = diameterA+diameterA+diameterC
	
	var distand_AC =a.distance_to(c)
	
	var x = (diameterC-(diameterA+diameterB))*1.0/(0-(diameterA+diameterB+diameterC))  # work
	var p = (19.7-(diameterA+diameterB))*1.0/(101.2-(diameterA+diameterB+diameterC))
	var add = (diameterA+diameterB)-(p*(diameterA+diameterB+diameterC))
	
	if tracktor: # for  animal leg / animal spider leg
		R_virtual = (distand_AC*x)+diameterC  # this is virtual circle only for 3 bones
	else:
		R_virtual = ((diameterA+diameterB)*1.0/totalABC)*distand_AC  # this is virtual circle only for 3 bones
	
	if T3_bones:
		var pos2=get_intersections(a.x,a.y,R_virtual,c.x,c.y,diameterC)
	
		if not pos2 == null:
			var flip = 1
			if tracktor:
				if point == 1:
					flip = 1
				else:
					flip = 0
					
			else:
				if point == 1:
					flip = 1
				else:
					flip =0
			
			var sud = c.angle_to_point(a)
			var sud2 = c.angle_to_point(pos2[flip])
			
			$point2.set_position(pos2[flip]) #asli
			$LineEdit5.text  =var2str(rad2deg(sud-sud2))
		
		var vc = b.direction_to(c)
		var vac = a.direction_to(c)
		var over2= false
		
		if over:
			var vector_ab=c-b
			var distand_AC_t =a.distance_to(b)
			over2 = true
			var pos_b=a+(vac*distand_AC_t)
			var pos_c=pos_b+(vc*diameterC)
			var v =a.direction_to(c)
			var arah=a+(v*diameterA)
			var arah2 = arah+(v*diameterB)
			var arah3 = arah2 +(vac*diameterC)
			$point2.set_position(arah2)
			draw_line(arah2+m,arah3+m,Color(0.5,0.5,0,1),3)
			
		else:
	
			draw_line(b+m,c+m,Color(1,0,0,1),3) #red
			draw_line(a+m,c+m,Color(1,1,1,1),1) #white line
	else:
		draw_line(a+m,b+m,Color(1,1,1,1),1) #white line
		
		
		
	var pos=get_intersections(a.x,a.y,diameterA,b.x,b.y,diameterB)
	if over:
		
		var v =a.direction_to(b)
		var arah=a+(v*diameterA)
		
		var arah2 = arah+(v*diameterB)
		draw_line(a+m,arah+m,Color(1,1,0,1),3)
		draw_line(arah+m,arah2+m,Color(0,0,1,1),3)
		
	else:
		var flip = 1
		if tracktor:
			
			if point == 1:
				flip = 1
			else:
				flip = 0
				
		else:
			
			if point == 1:
				flip = 0
			else:
				flip = 1
				
		draw_line(a+m,pos[flip]+m,Color(1,1,0,1),3)
		draw_line(pos[flip]+m,b+m,Color(0,0,1,1),3)
		
	if not pos == null:	
		pos_keni =pos[1]
		
func baru():
	a=$point.get_position()
	m=$point.get_rect().size/2
	b=$point2.get_position()
	c=$point3.get_position()
	d=$point4.get_position()
	update()

func _on_CheckBox_toggled(v):
	
	if v:
		point = 1
	else:
		point = 0
	
	baru()

func _on_LineEdit_text_changed(v):
	
	diameterA = str2var(v)
	update()

func _on_LineEdit2_text_changed(v):
	diameterB = str2var(v)
	update()

func _on_LineEdit3_text_changed(v):
	diameterC = str2var(v)
	update()

func _on_LineEdit4_text_changed(v):
	kurangin =str2var(v)
	update()

func _on_HSlider_value_changed(value):
	kurangin = value/100
	update()

func _on_CheckBox2_pressed():
	pass # Replace with function body.

func _on_CheckBox2_toggled(button_pressed):
	tracktor = button_pressed
	update()

func _on_CheckBox3_toggled(v):
	$CheckBox2.disabled
	if v:
		$CheckBox2.disabled = false
		$point2.set_nama("knee2")
		$point3.show()
	else:
		$CheckBox2.disabled = true
		
		$point2.set_nama("target")
	
		$point3.hide()
	T3_bones = v
	update()


func _on_Button_pressed():
	get_tree().change_scene("res://IK_2.tscn")


func _on_Button2_toggled(button_pressed):
	if button_pressed:
		
		point = 1
	else:
		point = 0
		
	baru()
	
