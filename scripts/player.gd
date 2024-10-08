extends CharacterBody2D
class_name Player

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D


@export var SPEED = 400.0
@export var JUMP_VELOCITY = -900.0
@export var attacking = false
@export var hit = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_health = 3
var health = 0 
var can_take_damege = true


func _ready():
	health = max_health

func _process(delta):
	if Input.is_action_just_pressed("attack") && !hit:
		attack()

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		sprite_2d.scale.x = abs(sprite_2d.scale.x) * -1
		$attackArea.scale.x = abs($attackArea.scale.x)* -1
	if Input.is_action_pressed("right"):
		sprite_2d.scale.x = abs(sprite_2d.scale.x)
		$attackArea.scale.x = abs($attackArea.scale.x)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor() && !hit:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction && !hit:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)
	update_animation()
	move_and_slide()

func attack():
	var overlapping_objects = $attackArea.get_overlapping_areas()
	for area in overlapping_objects:
		area.get_parent().take_damage(1)
	attacking = true
	animation_player.play("attack")

func update_animation():
	if !attacking && !hit:
		if velocity.x != 0:
			animation_player.play("run")
		else:
			animation_player.play("idle")
		if velocity.y > 0:
			animation_player.play("jump")
		if velocity.y < 0:
			animation_player.play("fall")

func take_damage(damage_amount : int):
	if can_take_damege:
		iframes()
		hit = true
		attacking = false
		animation_player.play("hit")
		health -= damage_amount
	if health <= 0:
		die()

func iframes():
	can_take_damege = false
	await get_tree().create_timer(1).timeout
	can_take_damege = true

func die():
	GameManager.respawn_player()
