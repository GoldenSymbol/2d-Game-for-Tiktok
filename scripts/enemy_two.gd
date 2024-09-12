extends CharacterBody2D


var SPEED = -100.0
var facing_right = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dead = false
var max_health = 3
var health
var curr_speed = 0.0
var hit = false
var can_attack = true

func _ready():
	health = max_health
	$AnimationPlayer.play("run")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	velocity.x = SPEED
	move_and_slide()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		SPEED = abs(SPEED)
	else :
		SPEED = abs(SPEED) * -1


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !dead && can_attack:
		area.get_parent().take_damage(1)

func take_damage(damage_amount):
	if !dead:
		$AnimationPlayer.play("hit")
		health -= damage_amount
		get_node("HealthBar").update_healthbar(health, max_health)
		if health <= 0:
			die()

func get_hit():
	hit = !hit
	if hit:
		curr_speed = SPEED
		SPEED = 0
		can_attack = false
	else:
		SPEED = curr_speed
		can_attack = true
		$AnimationPlayer.play("run")

func die():
	dead = true
	SPEED = 0
	$AnimationPlayer.play("dead")
