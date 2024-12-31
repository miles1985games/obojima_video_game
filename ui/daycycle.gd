extends CanvasModulate

@export var gradient: GradientTexture1D
@onready var day_cycle_ui = $DayCycleUI

@export var INGAME_SPEED = 1.0
@export var INITIAL_HOUR: float

#one day = 2 PI
const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGRAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

var time: float = 0.0
var past_minute: float = -1.0

var player

signal time_tick

func _ready():
	World.time_handler = self
	time = INGRAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR
	await get_tree().create_timer(.1).timeout
	player = World.active_player

func _process(delta) -> void:
	if player and player.state_machine.state != "ui":
		time += delta * INGRAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
		var value = (sin(time - PI / 2) + 1.0) / 2.0
		self.color = gradient.gradient.sample(value)
		
		recalculate_time()

func recalculate_time() -> void:
	var total_minutes = int(time / INGRAME_TO_REAL_MINUTE_DURATION)
	var day = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if past_minute != minute:
		past_minute = minute
		day_cycle_ui.time_tick(day, hour, minute)
		time_tick.emit(day, hour, minute)
