# <img src="Media/Icon.png" width="64" height="64"> Godot Action Icon

Action Icon is an ImageTexture-based custom Texture node that you can put on a Control and it will display the associated action. Just activate the plugin, create a Resource of type ActionTexture and use it. Note that in-editor preview is limited.

![](Media/Screenshot1.png)

It has a couple of display modes to configure:

- Action Name: the name of the action from project's Input Map
- Joypad Mode: whether the action should display keyboard key or joypad button. If set to "Adaptive", the icon will automatically change when it detects keyboard or joypad input. Only relevant to actions that have both assigned.

![](ReadmeActions.gif)

You can define a custom action, by going to `ActionIcon.gd` script and editing the `CUSTOM_ACTIONS` constant. By default there is a "move" action that displays WSAD/Left Stick. Some device sets include extra buttons that can be used for custom actions.

- Joypad Model: model of the joypad to display. Supported are: Xbox, Xbox360, DualShock 3, DualShock 4, DualSense, Joy-Con. If set to Auto, the script will try to auto-detect the controller based on the device id of joypad events and joy name returned by Godot. "Any Device" option will default to the first joypad. Fallbacks to Xbox if detection fails. All auto-model icons are refreshed when new device is connected, so icons will auto-update if joypad changes.
- Favor Mouse: if an action has a keyboard and mouse button configured, `favor_mouse` set to true will display the mouse button

![](ReadmeSize.gif)

You can customize the appearance of buttons by going to 'addons/ActionIcon` and relevant button folders. By default the Action Icon comes with keyboard, mouse and joypad buttons from [xelu's CC0 input icons pack](https://opengameart.org/content/free-keyboard-and-controllers-prompts-pack).

___
This is a fork of [KoBeWi/Godot-Action-Icon](https://github.com/KoBeWi/Godot-Action-Icon).