extends Node

# GameManager.gd
# Project > Project Settings > Autoload > Afegeix aquest fitxer com a "GameManager"

const SAVE_PATH := "user://settings.cfg"

var settings := {
	"master_volume": 80.0,
	"music_volume": 80.0,
	"sfx_volume": 80.0,
}

func _ready() -> void:
	load_settings()
	apply_audio()


# ─── Guardar i carregar ───────────────────────────────────────────────────────

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "master_volume", settings["master_volume"])
	cfg.set_value("audio", "music_volume",  settings["music_volume"])
	cfg.set_value("audio", "sfx_volume",    settings["sfx_volume"])
	cfg.save(SAVE_PATH)

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return  # Primera vegada: usa valors per defecte
	settings["master_volume"] = cfg.get_value("audio", "master_volume", 80.0)
	settings["music_volume"]  = cfg.get_value("audio", "music_volume",  80.0)
	settings["sfx_volume"]    = cfg.get_value("audio", "sfx_volume",    80.0)

# ─── Aplicar volums als busos ────────────────────────────────────────────────

func apply_audio() -> void:
	_set_bus_volume("Master", settings["master_volume"])
	_set_bus_volume("Music",  settings["music_volume"])
	_set_bus_volume("SFX",    settings["sfx_volume"])

func _set_bus_volume(bus_name: String, percent: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		push_warning("Bus '%s' no trobat!" % bus_name)
		return
	AudioServer.set_bus_volume_db(idx, linear_to_db(percent / 100.0))
