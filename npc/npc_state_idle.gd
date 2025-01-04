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
	if owner is Traveler and owner.targeted_slot != null:
		owner.nav_agent.target_position = owner.targeted_slot.global_position
		state_machine.state = "moving"
		return
	
	var random_poi = find_poi()
	if random_poi == null:
		find_random_point()
	else:
		set_poi_point(random_poi)
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

func find_poi():
	var targets: Array
	
	for node in owner.current_location.get_children():
		if node is PointOfInterest:
			targets.append(node)
	var target
	if targets.size() > 0:
		target = targets.pick_random()
	
	return target

func set_poi_point(poi):
	var target = poi
	var random_vector = Vector2(randf_range(-200,200),randf_range(-200,200))
	var total_vector = target.global_position + random_vector
	if target != null:
		owner.nav_agent.target_position = total_vector
		while not owner.nav_agent.is_target_reachable():
			random_vector = Vector2(randf_range(-200,200),randf_range(-200,200))
			total_vector = target.global_position + random_vector
			owner.nav_agent.target_position = total_vector
