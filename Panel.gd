# change visibility for Panel in : $Display/Panels/Controls
# change background & hide panel when generating
# auto adjust text edit height

extends Control
# warning-ignore-all:RETURN_VALUE_DISCARDED

const TWEEN_DURATION := 0.4
const ANIM_ANCHOR := ["anchor_left", "anchor_right"]

# for loading the images for background
var thread: Thread

@onready var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

# the `panel` container we will control
@onready var controls: Control = $"%Controls"

# Used for ref button groups, kinda hacky
# the way it work is by duplicating existing button and modify it
# so the "button group" will be the same / shared.
# !!! `button` name should be the same as `panel` name that we want to control
@onready var button_panels: BaseButton = $Display/Panels

# cycle background every generation
@onready var background: TextureRect = $"../.."
@onready var generate_button: Button = $"%GenerateButton"

# auto adjustment for the text
@onready var text_edit_list := [
	$"%PromptLine",
	$"%NegativePromptLine"
]


func _ready() -> void:
	#add_child(tween) ## Tweens were changed in v4
	
	# hide all panel, just in case
	for node in controls.get_children():
		node.hide()
	
	# Get the groups and remove everything but the base button varients
	var btnGroups = button_panels.get_groups()
	for button in btnGroups:
		if button.get_variant() != BaseButton:
			btnGroups.pop_at(btnGroups.find(button))

	# we pass the button name to get panel name :D
	for button in btnGroups:
		button.connect("toggled", Callable(self, "_show_panel").bind(button.name))
		if button.pressed:
			_show_panel(true, button.name)
	
	# to change background and hide panels
	generate_button.connect("button_up", Callable(self, "_generating"))
	
	# adjust text edit height
	for node in text_edit_list:
		node.connect("text_changed", Callable(self, "_edit_rect_min_size_y").bind(node))
		node.connect("cursor_changed", Callable(self, "_edit_rect_min_size_y").bind(node))
		node.connect("focus_entered", Callable(self, "_edit_rect_min_size_y").bind(node))
		node.connect("focus_exited", Callable(self, "_edit_rect_min_size_y").bind(node))
		node.connect("mouse_entered", Callable(self, "_edit_rect_min_size_y").bind(node))
		node.connect("mouse_exited", Callable(self, "_edit_rect_min_size_y").bind(node))


func _show_panel(active: bool, panel_name: String) -> void:
	var panel: Control = controls.get_node_or_null(panel_name)
	
	if !panel:
		print_debug("Panel Not found: " + panel_name)
		return
	
	if panel.visible == active:
		button_panels.button_pressed = true
		return # Hide on double click
	
	if active:
		tween.interpolate_property(
				panel, "modulate:a",
				0, 1,
				TWEEN_DURATION
			)
		for anchor in ANIM_ANCHOR:
			tween.interpolate_property(
					button_panels,
					anchor,
					 -1, 0,
					TWEEN_DURATION,
					Tween.TRANS_CIRC
			)
	
	tween.interpolate_property(
			panel, "visible",
			!active, active,
			TWEEN_DURATION
		)
	tween.start()
	
	# if button is button_panels refrence then hide the panels
	button_panels.visible = bool(button_panels.name != panel_name)


func _edit_rect_min_size_y(text_edit: TextEdit) -> void:
	var line_count :int = 1 # to add 1 blank space at the bottom of text edit
	
	line_count += text_edit.get_line_count()
	
	# loop to know the warp value
	for line in text_edit.get_line_count():
		line_count += text_edit.get_line_wrap_count(line)
	
	text_edit.custom_minimum_size.y = line_count * text_edit.get_line_height()


func _generating() -> void:
	# hide the panel when generating button pressed
	button_panels.button_pressed = true
	
	# cycle the background
	thread = Thread.new()
	thread.start(Callable(self, "_change_background"))


func _change_background() -> void:
	background.modulate.v = 0
	tween.interpolate_property(
			background, "modulate:v",
			0, 1,
			TWEEN_DURATION
	)
	tween.start()
	background.texture = Utils.get_random_background()


func _exit_tree() -> void:
	if thread:
		thread.wait_to_finish()
