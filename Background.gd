extends TextureRect

@onready var tutorial = $"%Tutorial"

func _ready():
	texture = Utils.get_random_background()
	if not SettingsManager.get_setting("tutorial_seen"):
		tutorial.popup_centered_clamped(Vector2(0,0), 0.5)
		SettingsManager.set_setting("tutorial_seen", true)
	
