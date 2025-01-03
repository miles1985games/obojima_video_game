extends Node2D

var state_machine: Node2D
var idle_timer: Timer
var idle_time: float = 3.0

var max_wander_distance: float = 200

func _ready():
	state_machine = get_parent()
	idle_timer = Timer.new()
	idle_timer.wait_time = idle_time
	idle_timer.timeout.connect(wander)
	add_child(idle_timer)

func _physics_process(delta):
	if idle_timer.is_stopped():
		idle_timer.start()
	
	owner.sprite.play("stand")

func wander():
	find_random_point()
	idle_timer.stop()
	idle_timer.wait_time = idle_time + randf_range(0,6)
	
	state_machine.state = "moving"

func find_random_point():
	var random_vector = Vector2(randf_range(-max_wander_distance, max_wander_distance), \
		randf_range(-max_wander_distance, max_wander_distance))
	
	var total_vector = owner.global_position + random_vector
	owner.nav_agent.target_position = total_vector
	
	while not owner.nav_agent.is_target_reachable():
		random_vector = Vector2(randf_range(-max_wander_distance, max_wander_distance), \
		randf_range(-max_wander_distance, max_wander_distance))
		total_vector = owner.global_position + random_vector
		owner.nav_agent.target_position = total_vector
	
	return total_vector

func find_targeted_interest():
	var targets: Array
	var rng
	for i in owner.active_interests.keys():
		if owner.active_interests[i] == 5:
			rng = randi_range(1,15)
		if owner.active_interests[i] == 4:
			rng = randi_range(1,20)
		if owner.active_interests[i] == 3:
			rng = randi_range(1,25)
		if owner.active_interests[i] == 2:
			rng = randi_range(1,30)
		if owner.active_interests[i] == 1:
			rng = randi_range(1,35)
	
		if rng < 10:
			targets.append([i, owner.active_interests[i]])
			targets.sort_custom(sort_ascending)
	
	var target = targets.pop_back()
	return target

func sort_ascending(a, b):
	if a[1] < b[1]:
		return true
	return false

func set_interest_point(interest):
	var target
	for child in owner.current_location.get_children():
		if child.is_in_group("interest") and child.is_in_group(interest[0]):
			target = child
	
	var random_vector = Vector2(randf_range(-50,50),randf_range(-50,50))
	var total_vector = target.global_position + random_vector
	if target != null:
		owner.nav_agent.target_position = total_vector
		while not owner.nav_agent.is_target_reachable():
			random_vector = Vector2(randf_range(-50,50),randf_range(-50,50))
			total_vector = target.global_position + random_vector
			owner.nav_agent.target_position = total_vector
