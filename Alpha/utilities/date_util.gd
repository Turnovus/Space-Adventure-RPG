@icon("res://assets/textures/machine/clockwork.svg")
class_name DateUtil


const MINUTES_PER_HOUR = 60
const HOURS_PER_DAY = 24
const DAYS_PER_YEAR = 100

const TURNS_PER_HOUR = 10
const TURNS_PER_DAY = TURNS_PER_HOUR * HOURS_PER_DAY # 240
const TURNS_PER_YEAR = TURNS_PER_DAY * DAYS_PER_YEAR # 24,000

const ZERO_DAY = 1
const ZERO_YEAR = 1


static func get_full_date_string(turn : int, start_turn : int = 0) -> String:
	return "Year {year}, Day {day} - {time}".format({
		"year" : get_year(turn, start_turn) + ZERO_YEAR,
		"day" : get_day_this_year(turn, start_turn) + ZERO_DAY,
		"time" : get_time_of_day_string(turn, start_turn),
	})


static func get_time_of_day_string(turn : int, start_turn : int = 0) -> String:
	var hours = get_hours_this_day(turn, start_turn)
	var minutes = get_minutes_this_hour(turn, start_turn)
	
	return "{hour}:{minute}".format({
		"hour" : ("" if hours > 9 else "0") + str(hours),
		"minute" : ("" if minutes > 9 else "0") + str(minutes),
	})


static func get_minutes_this_hour(turn : int, start_turn : int = 0) -> int:
	return get_total_minutes(turn, start_turn) % MINUTES_PER_HOUR


@warning_ignore("integer_division")
static func get_total_minutes(turn : int, start_turn : int = 0) -> int:
	var current_turn = turn - start_turn
	return current_turn * (MINUTES_PER_HOUR / TURNS_PER_HOUR)


static func get_hours_this_day(turn : int, start_turn : int = 0) -> int:
	return get_total_hours(turn, start_turn) % HOURS_PER_DAY


@warning_ignore("integer_division")
static func get_total_hours(turn : int, start_turn : int = 0) -> int:
	var current_turn = turn - start_turn
	return current_turn / TURNS_PER_HOUR


static func get_day_this_year(turn : int, start_turn : int = 0) -> int:
	return get_total_days(turn, start_turn) % DAYS_PER_YEAR


@warning_ignore("integer_division")
static func get_total_days(turn : int, start_turn : int = 0) -> int:
	var current_turn = turn - start_turn
	return current_turn / TURNS_PER_DAY


@warning_ignore("integer_division")
static func get_year(turn : int, start_turn : int = 0) -> int:
	var current_turn = turn - start_turn
	return current_turn / TURNS_PER_YEAR
