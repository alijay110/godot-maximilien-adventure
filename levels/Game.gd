extends Node2D

export (String) var level_name = "Placeholder"
export (float) var fall_damage = 25.0
var limit_bottom: float = 0
var limit_left: float = 0
var limit_right: float = 0
var player_out_of_bound: bool = false

func _ready() -> void:
	# set level name
	level_name = TranslationServer.translate(level_name)
	
	if ProjectSettings.get_setting("Debug/debug_mode"):
		DebugManager.set_level_name(level_name)
	
	# all enemy should know the player position
	if $World/Enemies.get_child_count() > 0:
		for enemy in $World/Enemies.get_children():
			$World/Player.connect("player_position_changed", enemy, "_on_player_Position_changed")
	$World/Player.connect("player_global_position_changed", self, "_on_player_Position_changed")
	
	# set max score
	GameManager.set_max_score($World/Collectibles/Gems.get_child_count())
	
	# Check player global position for out of bounds death
	limit_bottom = $World/Player/Camera.limit_bottom
	limit_left = $World/Player/Camera.limit_left
	limit_right = $World/Player/Camera.limit_right


func _on_player_Position_changed(new_position: Vector2) -> void:
	if not player_out_of_bound:
		if _compute_player_bound(new_position):
			player_out_of_bound = true
			_on_Player_fall()


func _get_nearest_quick_spawn_point(player_position: Vector2) -> Vector2:
	# get spawn nodes
	var spawn_points = get_tree().get_nodes_in_group("block_corner")
	
	# assume the first spawn node is closest
	var nearest_spawn_point = spawn_points[0]
	
	# look through spawn nodes to see if any are closer
	for spawn_point in spawn_points:
		if spawn_point.global_position.distance_to(player_position) < nearest_spawn_point.global_position.distance_to(player_position):
			nearest_spawn_point = spawn_point
	
	return nearest_spawn_point.get_node("SpawnPoint").global_position


func _on_Player_fall() -> void:
	$World/Player.get_node("Health").take_damage(fall_damage)
	var spawn_point = _get_nearest_quick_spawn_point($World/Player.grounded_position)
	
	if $World/Player.is_alive:
		$World/Player.teleport(spawn_point)
	player_out_of_bound = false


func _compute_player_bound(position: Vector2) -> bool:
	return limit_bottom < position.y or limit_left > position.x or limit_right < position.x