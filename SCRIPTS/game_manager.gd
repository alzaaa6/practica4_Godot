extends Node

# GameManager.gd
# Project > Project Settings > Autoload > Afegeix aquest fitxer com a "GameManager"

const SAVE_PATH := "user://settings.cfg"

var settings := {
	#Audio
	"master_volume": 80.0,
	"music_volume": 80.0,
	"sfx_volume": 80.0,
	#grafics
	"window_mode": 0,
}

var in_game := false
var fase_boost := false

# Jugador
var vida_max := 100.0
var vida_actual := 100.0
var atac := 20.0
var defensa := 20.0

# Oleades
var oleada_actual := 1
var enemics_per_oleada := 5
var enemics_eliminats := 0

func _ready() -> void:
	load_settings()
	apply_audio()
	apply_window_mode()


# ─── Guardar i carregar ───────────────────────────────────────────────────────

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "master_volume", settings["master_volume"])
	cfg.set_value("audio", "music_volume",  settings["music_volume"])
	cfg.set_value("audio", "sfx_volume",    settings["sfx_volume"])
	cfg.set_value("graphics", "window_mode", settings["window_mode"])
	cfg.save(SAVE_PATH)

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return  # Primera vegada: usa valors per defecte
	settings["master_volume"] = cfg.get_value("audio", "master_volume", 80.0)
	settings["music_volume"]  = cfg.get_value("audio", "music_volume",  80.0)
	settings["sfx_volume"]    = cfg.get_value("audio", "sfx_volume",    80.0)
	settings["window_mode"] = cfg.get_value("graphics", "window_mode", 0)


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
	
func apply_window_mode() -> void:
	match settings["window_mode"]:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		
# Funcions de DEBUG
func rebre_damage(damage: float) -> void:
	vida_actual = max(0, vida_actual - damage)

func eliminar_enemic() -> void:
	if fase_boost:
		return  # No es pot eliminar enemics durant el boost
	enemics_eliminats += 1
	if enemics_eliminats >= enemics_per_oleada:
		enemics_eliminats = 0
		oleada_actual += 1
		fase_boost = true
		print("--- SELECCIONA BOOST ---")
		print("F5: Atac | F6: Defensa | F7: Vida")
# Ja NO funcions de debug

func aplicar_boost(tipus: String) -> void:
	if !fase_boost:
		return  # No es pot agafar boost fora de la fase de boost
	fase_boost = false
	match tipus:
		"atac":
			atac += 5
			print("BOOST ATAC aplicat! | Atac: ", atac, " | Defensa: ", defensa, " | Vida: ", vida_actual)
		"defensa":
			defensa += 5
			print("BOOST DEFENSA aplicat! | Atac: ", atac, " | Defensa: ", defensa, " | Vida: ", vida_actual)
		"vida":
			vida_actual = vida_max
			print("BOOST VIDA aplicat! | Atac: ", atac, " | Defensa: ", defensa, " | Vida: ", vida_actual)
	print("--- NOVA OLEADA %d ---" % oleada_actual)
