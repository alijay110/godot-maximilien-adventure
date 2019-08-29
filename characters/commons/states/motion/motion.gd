extends State
class_name Motion

# pixels/sec
#warning-ignore:unused_class_variable
export (float) var SPEED:= 125.0
#warning-ignore:unused_class_variable
export (float) var ACCELERATION:= 0.25


func get_input_direction() -> Vector2:
	var input_direction: Vector2 = Vector2.ZERO
	input_direction.x = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input_direction


func update_look_direction(host: Character, direction: Vector2) -> void:
	if direction and host.look_direction != direction:
		host.look_direction = direction
	if not direction.x in [-1, 1]:
		return
	host.get_node('Sprite').set_scale(Vector2(direction.x, 1))
	host.get_node('States').set_scale(Vector2(direction.x, 1))


func move(host: Character, input_direction: Vector2, speed: float, acceleration: float) -> void:
	host.velocity.x = lerp(host.velocity.x, host.look_direction.x * speed, acceleration) if input_direction else 0