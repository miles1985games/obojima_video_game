extends Node2D

var max_enter_variance: float = 100
var final_enter_point: Vector2 = Vector2.ZERO

func _physics_process(_delta):
	if final_enter_point == Vector2.ZERO:
		if owner.current_location != null:
			if owner.current_location.npc_enter_point != null:
				var enter_point = owner.current_location.npc_enter_point.global_position
				final_enter_point = find_landing_point(enter_point)
	else:
		owner.state_machine.state = "moving"

func find_landing_point(enter_point):
	var total_vector = enter_point + Vector2(randf_range(-max_enter_variance, max_enter_variance), \
		randf_range(-max_enter_variance, max_enter_variance))
		
	owner.nav_agent.target_position = total_vector
	
	while not owner.nav_agent.is_target_reachable():
		total_vector = enter_point + Vector2(randf_range(-max_enter_variance, max_enter_variance), \
			randf_range(-max_enter_variance, max_enter_variance))
		
		owner.nav_agent.target_position = total_vector
	
	return total_vector
