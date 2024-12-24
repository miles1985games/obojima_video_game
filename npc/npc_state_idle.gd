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
	var point = find_random_point()
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
