extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

const TEXTURES := {
	"vida": preload("res://ASSETS/boost_vida_marc.png"),
	"atac": preload("res://ASSETS/boost_atac_marc.png"),
	"defensa": preload("res://ASSETS/boost_defensa_marc.png"),
}

var tipus := ""

func init(tipus_boost: String) -> void:
	tipus = tipus_boost
	sprite.texture = TEXTURES[tipus]

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("jugador"):
		GameManager.aplicar_boost(tipus)
		# Elimina tots els boosts restants
		for boost in get_tree().get_nodes_in_group("boost"):
			boost.queue_free()
