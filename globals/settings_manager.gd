# settings_manager.gd
extends Node

signal setting_changed(setting_name)

const CONFIG_FILE_PATH := "user://settings.cfg"
const SECTION_OPTIONS := "Options"
const SECTION_PARAMETERS := "Parameters"

var aihorde_url = "https://aihorde.net"
var _config := ConfigFile.new()
var _settings := {
	SECTION_OPTIONS: {
		"share": true,
		"api_key": "",
		"censor_nsfw": false,
		"trusted_workers": false,
        "prompt": "",
		"negative_prompt": "",
        "larger_settings": false
	},
	SECTION_PARAMETERS: {
		"post_processing": false,
		"loras": [],
		"tis": [],
		"workers": [],
		"blocklist": [],
		"width": 512,
		"height": 512,
		"sampler_name": "Euler a",
		"control_type": "none",
		"karras": false,
		"hires_fix": false,
		"nsfw": false,
		"seed": 0,
		"seed_resize_from_h": 0,
		"seed_resize_from_w": 0,
		"cfg_scale": 7.5,
		"steps": 50,
		"scheduler_name": "",
		"model_hash": "",
		"model_name": "",
        "remember_prompt": true,
        "denoising_strength": 0.7,
        "default_save_dir": "user://",
        "tutorial_seen": false
	}
}

func _ready() -> void:
	_load_config_from_file()

func _save_config_to_file() -> void:
	var save_error := _config.save(CONFIG_FILE_PATH)
	if save_error != OK:
		push_error("Failed to save config file.")

func _load_config_from_file() -> void:
	var load_error := _config.load(CONFIG_FILE_PATH)
	if load_error != OK:
		push_warning("Config file not found.")

func _populate_default_settings() -> void:
	for section in _settings.keys():
		for setting in _settings[section].keys():
			_config.set_value(section, setting, _settings[section][setting])

func get_setting(setting_name: String, section := SECTION_PARAMETERS) -> Variant:
	return _config.get_value(section, setting_name, _settings[section][setting_name])

func set_setting(setting_name: String, value, section := SECTION_PARAMETERS) -> void:
	_config.set_value(section, setting_name, value)
	_save_config_to_file()
	emit_signal("setting_changed", setting_name)

# Options
func get_api_key() -> String:
	return get_setting("api_key", SECTION_OPTIONS)

func set_api_key(key: String) -> void:
	set_setting("api_key", key, SECTION_OPTIONS)

func get_share() -> bool:
	return get_setting("share", SECTION_OPTIONS)

func set_share(share: bool) -> void:
	set_setting("share", share, SECTION_OPTIONS)

func get_censor_nsfw() -> bool:
	return get_setting("censor_nsfw", SECTION_OPTIONS)

func set_censor_nsfw(censor_nsfw: bool) -> void:
	set_setting("censor_nsfw", censor_nsfw, SECTION_OPTIONS)

func get_trusted_workers() -> bool:
	return get_setting("trusted_workers", SECTION_OPTIONS)

func set_trusted_workers(trusted_workers: bool) -> void:
	set_setting("trusted_workers", trusted_workers, SECTION_OPTIONS)

# Parameters
func get_prompt() -> String:
	return get_setting("prompt")

func set_prompt(prompt: String) -> void:
	set_setting("prompt", prompt)

func get_negative_prompt() -> bool:
	return get_setting("negative_prompt", SECTION_OPTIONS)

func set_negative_prompt(negative_prompt: bool) -> void:
	set_setting("negative_prompt", negative_prompt, SECTION_OPTIONS)

func get_models() -> Array:
	return get_setting("models")

func set_models(models: Array) -> void:
	set_setting("models", models)

func get_loras() -> Array:
	return get_setting("loras")

func set_loras(loras: Array) -> void:
	set_setting("loras", loras)

func get_tis() -> Array:
	return get_setting("tis")

func set_tis(tis: Array) -> void:
	set_setting("tis", tis)

func get_workers() -> Array:
	return get_setting("workers")

func set_workers(workers: Array) -> void:
	set_setting("workers", workers)

func get_blocklist() -> Array:
	return get_setting("blocklist")

func set_blocklist(blocklist: Array) -> void:
	set_setting("blocklist", blocklist)

func get_width() -> int:
	return get_setting("width")

func set_width(width: int) -> void:
	set_setting("width", width)

func get_height() -> int:
	return get_setting("height")

func set_height(height: int) -> void:
	set_setting("height", height)

func get_sampler_name() -> String:
	return get_setting("sampler_name")

func set_sampler_name(sampler_name: String) -> void:
	set_setting("sampler_name", sampler_name)

func get_steps() -> int:
	return get_setting("steps")

func set_steps(steps: int) -> void:
	set_setting("steps", steps)

func get_cfg_scale() -> float:
	return get_setting("cfg_scale")

func set_cfg_scale(cfg_scale: float) -> void:
	set_setting("cfg_scale", cfg_scale)

func get_seed() -> int:
	return get_setting("seed")

func set_seed(gen_seed: int) -> void:
	set_setting("seed", gen_seed)

func get_scheduler_name() -> String:
	return get_setting("scheduler_name")

func set_scheduler_name(scheduler_name: String) -> void:
	set_setting("scheduler_name", scheduler_name)

func get_seed_behavior() -> String:
	return get_setting("seed_behavior")

func set_seed_behavior(seed_behavior: String) -> void:
	set_setting("seed_behavior", seed_behavior)

func get_upscale_level() -> int:
	return get_setting("upscale_level")

func set_upscale_level(upscale_level: int) -> void:
	set_setting("upscale_level", upscale_level)

func get_upscale_strength() -> float:
	return get_setting("upscale_strength")

func set_upscale_strength(upscale_strength: float) -> void:
	set_setting("upscale_strength", upscale_strength)
