@tool
class_name ActionTexture
extends ImageTexture


const ActionTexturePicker := preload("action_texture_picker.gd")


## Action name from InputMap.
var action_name: StringName = &"":
	set(mod_value):
		if action_name == mod_value:
			return
		
		action_name = mod_value
		refresh()


## Whether a joypad button should be used or keyboard/mouse.
var joypad_mode: ActionTexturePicker.JoypadMode = ActionTexturePicker.JoypadMode.ADAPTIVE:
	set(mod_value):
		if joypad_mode == mod_value:
			return
		
		joypad_mode = mod_value
		if joypad_mode == ActionTexturePicker.JoypadMode.ADAPTIVE:
			if not _action_texture_picker.refresh.is_connected(refresh):
				_action_texture_picker.refresh.connect(refresh)
		else:
			if _action_texture_picker.refresh.is_connected(refresh):
				_action_texture_picker.refresh.disconnect(refresh)

		refresh()


## Controller model for the displayed icon.
var joypad_model: ActionTexturePicker.JoypadModel = ActionTexturePicker.JoypadModel.AUTO:
	set(mod_value):
		if joypad_model == mod_value:
			return
		
		joypad_model = mod_value
		refresh()


## If using keyboard/mouse icon, this makes mouse preferred if available.
var favor_mouse: bool = true:
	set(mod_value):
		if favor_mouse == mod_value:
			return
		
		favor_mouse = mod_value
		refresh()


var _image:Image
var _action_texture_picker:ActionTexturePicker


func _init() -> void:
	var base_path := preload("plugin.gd").base_path
	_set_textures([load(base_path + "/Keyboard/Blank.png") as Texture2D])
	_action_texture_picker = ActionTexturePicker.instance as ActionTexturePicker
	refresh()


func _get_property_list() -> Array[Dictionary]:
	var list_of_actions:String = ""
	for action in InputMap.get_actions():
		if not list_of_actions.is_empty():
			list_of_actions += ","

		list_of_actions += str(action)

	return [
		{
			"name": "action_name",
			"type": TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM_SUGGESTION,
			"hint_string": list_of_actions,
			"usage": PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
		},
		{
			"name": "joypad_mode",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Adaptive:0,Force Keyboard:1,Force Joypad:2",
			"usage": PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
		},
		{
			"name": "joypad_model",
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Auto:0,Xbox:1,Xbox 360:2,Ds 3:3,Ds 4:4,Dual Sense:5,Joy Con:6",
			"usage": PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
		},
		{
			"name": "favor_mouse",
			"type": TYPE_BOOL,
			"hint_string": "bool",
			"usage": PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
		}
	]


func refresh() -> void:
	if is_instance_valid(_action_texture_picker):
		var textures := _action_texture_picker.pick_texture(action_name, joypad_mode, joypad_model, favor_mouse)
		_set_textures(textures)


func _set_textures(textures:Array[Texture2D]) -> void:
	var size := Vector2i.ZERO
	for texture in textures:
		var texture_size := texture.get_size()
		size.x += int(texture_size.x)
		size.y = maxi(size.y, int(texture_size.y))

	if _image == null:
		_image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	elif _image.get_size() != size:
		_image.crop(size.x, size.y)

	var offset := Vector2i.ZERO
	for texture in textures:
		var texture_size := texture.get_size()
		var rect := Rect2i(Vector2i.ZERO, texture_size)
		_image.blit_rect(texture.get_image(), rect, offset)
		offset += Vector2i(int(texture_size.x), 0)

	set_image(_image)
