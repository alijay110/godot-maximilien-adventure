extends State

onready var stream: Resource = load('res://sound/movement/falling-sounds/sfx_sounds_falling3.wav')

func enter(host: Player) -> void:
	host.get_node('AnimationPlayer').play('Death')
	play_sound(host, stream, 1)
	host.input_enable = false
	host.velocity = Vector2.ZERO
	host.gravity_enable = false


func exit(host: Player) -> void:
	assert host is Player
	UiManager.show_lost_a_life_screen()


#warning-ignore:unused_argument
#warning-ignore:unused_argument
func _on_Animation_finished(anim_name: String, host: Character) -> void:
	assert anim_name == 'Death'
	emit_signal('finished', 'Respawn')