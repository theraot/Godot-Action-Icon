@tool
class_name ActionTexture
extends ImageTexture


const ActionTexturePicker := preload("action_texture_picker.gd")


## Action name from InputMap.
@export var action_name: StringName = &"":
	set(mod_value):
		if action_name == mod_value:
			return
		
		action_name = mod_value
		refresh()



## Whether a joypad button should be used or keyboard/mouse.
@export var joypad_mode: ActionTexturePicker.JoypadMode = ActionTexturePicker.JoypadMode.ADAPTIVE:
	set(mod_value):
		if joypad_mode == mod_value:
			return
		
		joypad_mode = mod_value
		refresh()


## Controller model for the displayed icon.
@export var joypad_model: ActionTexturePicker.JoypadModel = ActionTexturePicker.JoypadModel.AUTO:
	set(mod_value):
		if joypad_model == mod_value:
			return
		
		joypad_model = mod_value
		refresh()


## If using keyboard/mouse icon, this makes mouse preferred if available.
@export var favor_mouse: bool = true:
	set(mod_value):
		if favor_mouse == mod_value:
			return
		
		favor_mouse = mod_value
		refresh()


var _image:Image
var _texture:Texture2D:
	set(mod_value):
		if _texture == mod_value:
			return

		_texture = mod_value
		var size := Vector2i(_texture.get_size())
		if _image == null:
			_image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
		elif _image.get_size() != size:
			_image.resize(size.x, size.y, Image.INTERPOLATE_NEAREST)

		var rect := Rect2i(Vector2.ZERO, size)
		_image.blit_rect(_texture.get_image(), rect, Vector2i.ZERO)
		set_image(_image)


var _action_texture_picker:ActionTexturePicker


func _init() -> void:
	var base_path := preload("plugin.gd").base_path
	_texture = load(base_path + "/Keyboard/Blank.png") as Texture2D
	_action_texture_picker = ActionTexturePicker.instance as ActionTexturePicker
	refresh()


func refresh() -> void:
	if is_instance_valid(_action_texture_picker):
		_texture = _action_texture_picker.pick_texture(action_name, joypad_mode, joypad_model, favor_mouse)
		if joypad_mode == ActionTexturePicker.JoypadMode.ADAPTIVE:
			if not _action_texture_picker.refresh.is_connected(refresh):
				_action_texture_picker.refresh.connect(refresh)
		else:
			if _action_texture_picker.refresh.is_connected(refresh):
				_action_texture_picker.refresh.disconnect(refresh)
