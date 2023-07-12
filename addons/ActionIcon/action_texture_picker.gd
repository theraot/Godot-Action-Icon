@tool
extends Node


signal refresh()


## Use for special actions outside of InputMap. Format is keyboard icon|mouse icon|joypad icon.
const CUSTOM_ACTIONS = {
	"move": "WSAD||LeftStick"
}


const MODEL_MAP = {
	JoypadModel.XBOX: "Xbox",
	JoypadModel.XBOX360: "Xbox360",
	JoypadModel.DS3: "DS3",
	JoypadModel.DS4: "DS4",
	JoypadModel.DUAL_SENSE: "DualSense",
	JoypadModel.JOY_CON: "JoyCon",
}


enum { KEYBOARD, MOUSE, JOYPAD }
enum JoypadMode { ADAPTIVE, FORCE_KEYBOARD, FORCE_JOYPAD }
enum JoypadModel { AUTO, XBOX, XBOX360, DS3, DS4, DUAL_SENSE, JOY_CON }


var _cached_model:String
var _base_path: String
var _use_joypad:bool

static var instance:Node


func _init() -> void:
	instance = self
	_base_path = get_script().resource_path.get_base_dir()
	_use_joypad = not Input.get_connected_joypads().is_empty()
	if not Input.joy_connection_changed.is_connected(on_joy_connection_changed):
		Input.joy_connection_changed.connect(on_joy_connection_changed)


func on_joy_connection_changed(_device: int, connected: bool):
	if connected:
		_cached_model = ""
		refresh.emit()


func _input(event: InputEvent) -> void:
	if _use_joypad and (event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion):
		_use_joypad = false
		refresh.emit()
	elif not _use_joypad and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		_use_joypad = true
		refresh.emit()


func pick_texture(action_name:String, joypad_mode:JoypadMode, joypad_model:JoypadModel, favor_mouse:bool) -> Texture2D:
	var is_joypad := false
	match joypad_mode:
		JoypadMode.ADAPTIVE:
			is_joypad = _use_joypad
		JoypadMode.FORCE_JOYPAD:
			is_joypad = true
		JoypadMode.FORCE_KEYBOARD:
			is_joypad = false

	var result:Texture2D = null
	if action_name in CUSTOM_ACTIONS:
		var image_list: PackedStringArray = CUSTOM_ACTIONS[action_name].split("|")
		assert(image_list.size() >= 3, "Need more |")
		
		if is_joypad and not image_list[JOYPAD].is_empty():
			result = get_image(JOYPAD, "%s/%s" % [get_joypad_model_name(0, joypad_model), image_list[JOYPAD]])
		elif not is_joypad:
			if (favor_mouse or image_list[KEYBOARD].is_empty()) and not image_list[MOUSE].is_empty():
				result = get_image(MOUSE, image_list[MOUSE])
			elif image_list[KEYBOARD]:
				result = get_image(KEYBOARD, image_list[KEYBOARD])

	else:
		var keyboard := -1
		var mouse := -1
		var joypad := -1
		var joypad_axis := -1
		var joypad_axis_value: float
		var joypad_id: int

		for event in InputMap.action_get_events(action_name):
			if event is InputEventKey and keyboard == -1:
				if event.keycode == 0:
					keyboard = event.physical_keycode
				else:
					keyboard = event.keycode

			elif event is InputEventMouseButton and mouse == -1:
				mouse = event.button_index
			elif event is InputEventJoypadButton and joypad == -1:
				joypad = event.button_index
				joypad_id = event.device
			elif event is InputEventJoypadMotion and joypad_axis == -1:
				joypad_axis = event.axis
				joypad_axis_value = event.axis_value
				joypad_id = event.device

		if _use_joypad:
			if joypad >= 0:
				result = get_joypad(joypad, joypad_id, joypad_model)
			elif joypad_axis >= 0:
				result = get_joypad_axis(joypad_axis, joypad_axis_value, joypad_id, joypad_model)

		if result == null:
			if mouse >= 0 and (favor_mouse or keyboard < 0):
				result = get_mouse(mouse)

			if result == null and keyboard >= 0:
				result = get_keyboard(keyboard)

	if result == null:
		result = load("res://addons/ActionIcon/Keyboard/Blank.png")

	return result


func get_keyboard(key: int) -> Texture2D:
	match key:
		KEY_0:
			return get_image(KEYBOARD, "0")
		KEY_1:
			return get_image(KEYBOARD, "1")
		KEY_2:
			return get_image(KEYBOARD, "2")
		KEY_3:
			return get_image(KEYBOARD, "3")
		KEY_4:
			return get_image(KEYBOARD, "4")
		KEY_5:
			return get_image(KEYBOARD, "5")
		KEY_6:
			return get_image(KEYBOARD, "6")
		KEY_7:
			return get_image(KEYBOARD, "7")
		KEY_8:
			return get_image(KEYBOARD, "8")
		KEY_9:
			return get_image(KEYBOARD, "9")
		KEY_A:
			return get_image(KEYBOARD, "A")
		KEY_B:
			return get_image(KEYBOARD, "B")
		KEY_C:
			return get_image(KEYBOARD, "C")
		KEY_D:
			return get_image(KEYBOARD, "D")
		KEY_E:
			return get_image(KEYBOARD, "E")
		KEY_F:
			return get_image(KEYBOARD, "F")
		KEY_G:
			return get_image(KEYBOARD, "G")
		KEY_H:
			return get_image(KEYBOARD, "H")
		KEY_I:
			return get_image(KEYBOARD, "I")
		KEY_J:
			return get_image(KEYBOARD, "J")
		KEY_K:
			return get_image(KEYBOARD, "K")
		KEY_L:
			return get_image(KEYBOARD, "L")
		KEY_M:
			return get_image(KEYBOARD, "M")
		KEY_N:
			return get_image(KEYBOARD, "N")
		KEY_O:
			return get_image(KEYBOARD, "O")
		KEY_P:
			return get_image(KEYBOARD, "P")
		KEY_Q:
			return get_image(KEYBOARD, "Q")
		KEY_R:
			return get_image(KEYBOARD, "R")
		KEY_S:
			return get_image(KEYBOARD, "S")
		KEY_T:
			return get_image(KEYBOARD, "T")
		KEY_U:
			return get_image(KEYBOARD, "U")
		KEY_V:
			return get_image(KEYBOARD, "V")
		KEY_W:
			return get_image(KEYBOARD, "W")
		KEY_X:
			return get_image(KEYBOARD, "X")
		KEY_Y:
			return get_image(KEYBOARD, "Y")
		KEY_Z:
			return get_image(KEYBOARD, "Z")
		KEY_F1:
			return get_image(KEYBOARD, "F1")
		KEY_F2:
			return get_image(KEYBOARD, "F2")
		KEY_F3:
			return get_image(KEYBOARD, "F3")
		KEY_F4:
			return get_image(KEYBOARD, "F4")
		KEY_F5:
			return get_image(KEYBOARD, "F5")
		KEY_F6:
			return get_image(KEYBOARD, "F6")
		KEY_F7:
			return get_image(KEYBOARD, "F7")
		KEY_F8:
			return get_image(KEYBOARD, "F8")
		KEY_F9:
			return get_image(KEYBOARD, "F9")
		KEY_F10:
			return get_image(KEYBOARD, "F10")
		KEY_F11:
			return get_image(KEYBOARD, "F11")
		KEY_F12:
			return get_image(KEYBOARD, "F12")
		KEY_LEFT:
			return get_image(KEYBOARD, "Left")
		KEY_RIGHT:
			return get_image(KEYBOARD, "Right")
		KEY_UP:
			return get_image(KEYBOARD, "Up")
		KEY_DOWN:
			return get_image(KEYBOARD, "Down")
		KEY_QUOTELEFT:
			return get_image(KEYBOARD, "Tilde")
		KEY_MINUS:
			return get_image(KEYBOARD, "Minus")
		KEY_PLUS:
			return get_image(KEYBOARD, "Plus")
		KEY_BACKSPACE:
			return get_image(KEYBOARD, "Backspace")
		KEY_BRACELEFT:
			return get_image(KEYBOARD, "BracketLeft")
		KEY_BRACERIGHT:
			return get_image(KEYBOARD, "BracketRight")
		KEY_SEMICOLON:
			return get_image(KEYBOARD, "Semicolon")
		KEY_QUOTEDBL:
			return get_image(KEYBOARD, "Quote")
		KEY_BACKSLASH:
			return get_image(KEYBOARD, "BackSlash")
		KEY_ENTER:
			return get_image(KEYBOARD, "Enter")
		KEY_ESCAPE:
			return get_image(KEYBOARD, "Esc")
		KEY_LESS:
			return get_image(KEYBOARD, "LT")
		KEY_GREATER:
			return get_image(KEYBOARD, "GT")
		KEY_QUESTION:
			return get_image(KEYBOARD, "Question")
		KEY_CTRL:
			return get_image(KEYBOARD, "Ctrl")
		KEY_SHIFT:
			return get_image(KEYBOARD, "Shift")
		KEY_ALT:
			return get_image(KEYBOARD, "Alt")
		KEY_SPACE:
			return get_image(KEYBOARD, "Space")
		KEY_META:
			return get_image(KEYBOARD, "Win")
		KEY_CAPSLOCK:
			return get_image(KEYBOARD, "CapsLock")
		KEY_TAB:
			return get_image(KEYBOARD, "Tab")
		KEY_PRINT:
			return get_image(KEYBOARD, "PrintScrn")
		KEY_INSERT:
			return get_image(KEYBOARD, "Insert")
		KEY_HOME:
			return get_image(KEYBOARD, "Home")
		KEY_PAGEUP:
			return get_image(KEYBOARD, "PageUp")
		KEY_DELETE:
			return get_image(KEYBOARD, "Delete")
		KEY_END:
			return get_image(KEYBOARD, "End")
		KEY_PAGEDOWN:
			return get_image(KEYBOARD, "PageDown")

	return null


func get_joypad_model_name(device: int, joypad_model:JoypadModel) -> String:
	if not _cached_model.is_empty():
		return _cached_model

	var model := ""
	if joypad_model == JoypadModel.AUTO:
		var device_name := Input.get_joy_name(maxi(device, 0))
		if device_name.contains("Xbox 360"):
			model = "Xbox360"
		elif device_name.contains("PS3"):
			model = "DS3"
		elif device_name.contains("PS4"):
			model = "DS4"
		elif device_name.contains("PS5"):
			model = "DualSense"
		elif device_name.contains("Joy-Con") or device_name.contains("Joy Con"):
			model = "JoyCon"
		else:
			model = "Xbox"
	else:
		model = MODEL_MAP[joypad_model]

	_cached_model = model
	return model


func get_joypad(button: int, device: int, joypad_model:JoypadModel) -> Texture2D:
	var folder := get_joypad_model_name(device, joypad_model) + "/"

	match button:
		JOY_BUTTON_A:
			return get_image(JOYPAD, folder + "A")
		JOY_BUTTON_B:
			return get_image(JOYPAD, folder + "B")
		JOY_BUTTON_X:
			return get_image(JOYPAD, folder + "X")
		JOY_BUTTON_Y:
			return get_image(JOYPAD, folder + "Y")
		JOY_BUTTON_LEFT_SHOULDER:
			return get_image(JOYPAD, folder + "LB")
		JOY_BUTTON_RIGHT_SHOULDER:
			return get_image(JOYPAD, folder + "RB")
		JOY_BUTTON_LEFT_STICK:
			return get_image(JOYPAD, folder + "L")
		JOY_BUTTON_RIGHT_STICK:
			return get_image(JOYPAD, folder + "R")
		JOY_BUTTON_BACK:
			return get_image(JOYPAD, folder + "Select")
		JOY_BUTTON_START:
			return get_image(JOYPAD, folder + "Start")
		JOY_BUTTON_DPAD_UP:
			return get_image(JOYPAD, folder + "DPadUp")
		JOY_BUTTON_DPAD_DOWN:
			return get_image(JOYPAD, folder + "DPadDown")
		JOY_BUTTON_DPAD_LEFT:
			return get_image(JOYPAD, folder + "DPadLeft")
		JOY_BUTTON_DPAD_RIGHT:
			return get_image(JOYPAD, folder + "DPadRight")
		JOY_BUTTON_MISC1:
			return get_image(JOYPAD, folder + "Share")

	return null


func get_joypad_axis(axis: int, value: float, device: int, joypad_model:JoypadModel) -> Texture2D:
	var folder := get_joypad_model_name(device, joypad_model) + "/"

	match axis:
		JOY_AXIS_LEFT_X:
			if value < 0:
				return get_image(JOYPAD, folder + "LeftStickLeft")
			elif value > 0:
				return get_image(JOYPAD, folder + "LeftStickRight")
			else:
				return get_image(JOYPAD, folder + "LeftStick")

		JOY_AXIS_LEFT_Y:
			if value < 0:
				return get_image(JOYPAD, folder + "LeftStickUp")
			elif value > 0:
				return get_image(JOYPAD, folder + "LeftStickDown")
			else:
				return get_image(JOYPAD, folder + "LeftStick")

		JOY_AXIS_RIGHT_X:
			if value < 0:
				return get_image(JOYPAD, folder + "RightStickLeft")
			elif value > 0:
				return get_image(JOYPAD, folder + "RightStickRight")
			else:
				return get_image(JOYPAD, folder + "RightStick")

		JOY_AXIS_RIGHT_Y:
			if value < 0:
				return get_image(JOYPAD, folder + "RightStickUp")
			elif value > 0:
				return get_image(JOYPAD, folder + "RightStickDown")
			else:
				return get_image(JOYPAD, folder + "RightStick")

		JOY_AXIS_TRIGGER_LEFT:
			return get_image(JOYPAD, folder + "LT")
		JOY_AXIS_TRIGGER_RIGHT:
			return get_image(JOYPAD, folder + "RT")

	return null


func get_mouse(button: int) -> Texture2D:
	match button:
		MOUSE_BUTTON_LEFT:
			return get_image(MOUSE, "Left")
		MOUSE_BUTTON_RIGHT:
			return get_image(MOUSE, "Right")
		MOUSE_BUTTON_MIDDLE:
			return get_image(MOUSE, "Middle")
		MOUSE_BUTTON_WHEEL_DOWN:
			return get_image(MOUSE, "WheelDown")
		MOUSE_BUTTON_WHEEL_LEFT:
			return get_image(MOUSE, "WheelLeft")
		MOUSE_BUTTON_WHEEL_RIGHT:
			return get_image(MOUSE, "WheelRight")
		MOUSE_BUTTON_WHEEL_UP:
			return get_image(MOUSE, "WheelUp")

	return null


func get_image(type: int, image: String) -> Texture2D:
	match type:
		KEYBOARD:
			return load(_base_path.path_join("Keyboard").path_join(image) + ".png") as Texture
		MOUSE:
			return load(_base_path.path_join("Mouse").path_join(image) + ".png") as Texture
		JOYPAD:
			return load(_base_path.path_join("Joypad").path_join(image) + ".png") as Texture

	return null
