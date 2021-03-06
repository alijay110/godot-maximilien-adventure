extends State

onready var stream: Resource = load("res://sound/movement/falling-sounds/sfx_sounds_falling3.wav")


"""
@param {Player} host
"""
func enter(host: Player) -> void:
	host.get_node("AnimationPlayer").play("Death")
	play_sound(host, stream, 1)
	host.input_enable = false
	host.velocity = Vector2.ZERO
	host.gravity_enable = false


"""
@param {Playe} host
@emit ui_loose_life_show
"""
func exit(host: Player) -> void:
	assert host is Player
	UiManager.show_lost_a_life_screen()


"""
@signal animation_finished
"""
func _on_Animation_finished(anim_name: String, host: Player) -> void:
	assert anim_name == "Death"
	assert host is Player
	emit_signal("finished", "Respawn")