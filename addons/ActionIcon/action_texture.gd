@tool
class_name ActionTexture
extends ImageTexture


const ActionTexturePicker := preload("action_texture_picker.gd")


enum JoypadMode { ADAPTIVE, FORCE_KEYBOARD, FORCE_JOYPAD }
enum JoypadModel { AUTO, XBOX, XBOX360, DS3, DS4, DUAL_SENSE, JOY_CON }


## Action name from InputMap.
var action_name: StringName = &"":
	set(mod_value):
		if action_name == mod_value:
			return
		
		action_name = mod_value
		refresh()


## Whether a joypad button should be used or keyboard/mouse.
var joypad_mode: JoypadMode = JoypadMode.ADAPTIVE:
	set(mod_value):
		if joypad_mode == mod_value:
			return
		
		joypad_mode = mod_value
		_update_adaptive_connection()
		refresh()


## Controller model for the displayed icon.
var joypad_model: JoypadModel = JoypadModel.AUTO:
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


var size:Vector2i:
	set(mod_value):
		if size == mod_value:
			return

		size = mod_value
		refresh()


var _action_texture_picker:ActionTexturePicker


func _init() -> void:
	var base_path := preload("plugin.gd").base_path
	_set_textures([load(base_path + "/Keyboard/Blank.png") as Texture2D], false)
	_action_texture_picker = ActionTexturePicker.instance as ActionTexturePicker
	_update_adaptive_connection()
	refresh()


func _get_property_list() -> Array[Dictionary]:
	var list_of_actions:String = ""
	InputMap.load_from_project_settings()
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
			"usage": PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
		},
		{
			"name": "size",
			"type": TYPE_VECTOR2I,
			"usage": PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
		}
	]


func refresh() -> void:
	if is_instance_valid(_action_texture_picker):
		var textures := _action_texture_picker.pick_texture(action_name, joypad_mode, joypad_model, favor_mouse)
		_set_textures(textures, false)


func refresh_keep_aspect() -> void:
	if is_instance_valid(_action_texture_picker):
		var textures := _action_texture_picker.pick_texture(action_name, joypad_mode, joypad_model, favor_mouse)
		_set_textures(textures, true)


func _set_textures(textures:Array[Texture2D], keep_aspect:bool) -> void:
	var render_size := Vector2i.ZERO
	for texture in textures:
		var texture_size := texture.get_size()
		render_size.x += int(texture_size.x)
		render_size.y = maxi(render_size.y, int(texture_size.y))

	var valign := 0
	if keep_aspect:
		var target_aspect := get_size().aspect()
		var new_x := int(target_aspect * render_size.y)
		if new_x < render_size.x:
			var scale_factor := render_size.x / float(new_x)
			valign = int(render_size.y * (scale_factor - 1.0) * 0.5)
			render_size.y = int(render_size.y * scale_factor)
		else:
			render_size.x = new_x

	var image := Image.create(render_size.x, render_size.y, false, Image.FORMAT_RGBA8)
	var offset := Vector2i(0, valign)
	for texture in textures:
		var texture_size := texture.get_size()
		var rect := Rect2i(Vector2i.ZERO, texture_size)
		image.blit_rect(texture.get_image(), rect, offset)
		offset += Vector2i(int(texture_size.x), 0)

	if size.x != 0 and size.y != 0 and size != render_size:
		image.resize(size.x, size.y)
	elif size.x == 0 and size.y != 0 and size.y != render_size.y:
		var size_x := ceili(render_size.x * float(size.y) / float(render_size.y))
		image.resize(size_x, size.y)
	elif size.y == 0 and size.x != 0 and size.x != render_size.x:
		var size_y := ceili(render_size.y * float(size.x) / float(render_size.x))
		image.resize(size.x, size_y)

	set_image(image)


func _update_adaptive_connection() -> void:
	if joypad_mode == JoypadMode.ADAPTIVE:
		if not _action_texture_picker.refresh.is_connected(refresh_keep_aspect):
			_action_texture_picker.refresh.connect(refresh_keep_aspect)
	else:
		if _action_texture_picker.refresh.is_connected(refresh_keep_aspect):
			_action_texture_picker.refresh.disconnect(refresh_keep_aspect)
