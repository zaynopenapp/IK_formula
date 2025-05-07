extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var klik=false
var lokalpos=Vector2()
export(String) var nama="point"
export(bool) var parent=false
export(NodePath) var node=null
var showpos= false
var showname= true
var panel=false
var parentnya = null
# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/LineEdit.text=get_name()
	$name.text=nama
	
	
	$pos.text="("+str(rect_position.x)+","+str(rect_position.y)+")"
	if parent:
		get_parent().object_parent=self
	#if node!=null:
		#var node_path=NodePath(str(node))
		#var node=get_node(node_path)
		#get_parent().get_node("draw").points.append(node)
		#var posself=get_position()
		#get_parent().get_node("draw").points.append(self)
	


		#var p=node("position")
		#var pos = p.get_as_property_path()
		#var posself=get_position()
		#
		#
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_point_button_down():
	klik=true
	lokalpos=get_local_mouse_position()
	if panel:
		$Panel.hide()
		panel=false
	
	
func set_nama(nn):
	$name.text = nn
	
func _on_point_button_up():
	klik=false


func _on_point_gui_input(ev):
	#var p=Input.get_mouse_button_mask()
	if Input.is_mouse_button_pressed(2):
		if not panel:
			$Panel.show()
			panel=true
		#else:
			#$Panel.show()
			#panel=true
	
	if klik:
		if ev is InputEventMouseMotion:
			var pos=ev.global_position-lokalpos
			set_position(pos)
			#if get_name()=="point3":
				#var obj_parent=get_parent().object_parent
				#get_parent().v2= pos-obj_parent.get_position()
			
			
				
			get_parent().baru()
			
				
			if showpos:
				$pos.text="("+str(pos.x)+","+str(pos.y)+")"


func _on_CheckBox2_toggled(button_pressed):
	showpos=button_pressed
	if showpos:
		$pos.show()
	else:
		$pos.hide()

func _on_CheckBox_toggled(pressed):
	showname=pressed
	if showname:
		$name.show()
	else:
		$name.hide()


func _on_LineEdit_text_changed(new_text):
	$name.text=new_text


func _on_Button_pressed():
	$Panel.hide()
	panel=false
