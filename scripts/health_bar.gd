extends Control

@onready var fill_max = $ColorRect.size.x
var fill_amount : float

# 2 / 3 = 0.66 * 67 = 44
func update_healthbar(health, max_health):
	fill_amount = (float(health) / max_health) * fill_max
	$ColorRect.size.x = fill_amount
	
