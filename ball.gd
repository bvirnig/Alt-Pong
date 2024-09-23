extends CharacterBody2D

var ball_scene = preload("res://ball.tscn")

var win_size : Vector2
const START_SPEED : int = 500
const ACCEL : int = 50
var speed : int
var dir : Vector2
const MAX_Y_VECTOR : float = 0.6
var ball_count : int = 0  # Counter for the number of balls spawned
const MAX_BALLS : int = 8  # Maximum number of balls allowed
var game_node : Node2D  # Reference to the main game node

# Called when the node enters the scene tree for the first time.
func _ready():
	win_size = get_viewport_rect().size
	game_node = get_parent()  # Store a reference to the main game node
	$SpawnTimer.start()  # Start the timer to spawn balls

func new_ball():
	if ball_count < MAX_BALLS and game_node.make_balls:  # Check the main scene's boolean
		var more_ball = ball_scene.instantiate()
		more_ball.position.x = win_size.x / 2  # Center the new ball horizontally
		more_ball.position.y = randi_range(200, win_size.y - 200)  # Randomize vertical position
		more_ball.speed = START_SPEED  # Set speed for the new ball
		more_ball.dir = random_direction()  # Set direction for the new ball
		get_parent().add_child(more_ball)  # Add the new ball to the scene

		ball_count += 1  # Increment the ball counter

func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()  # Randomly choose between -1 and 1 for x direction
	new_dir.y = randf_range(-1, 1)  # Randomize y direction
	return new_dir.normalized()  # Normalize the direction vector

# Physics processing and collision handling remain unchanged

func _physics_process(delta):
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		collider = collision.get_collider()
		# If ball hits paddle
		if collider == $"../Player" or collider == $"../CPU":
			speed += ACCEL
			dir = new_direction(collider)
			$HitSound.play()  # Play the hit sound effect
		# If it hits a wall
		else:
			dir = dir.bounce(collision.get_normal())

func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	# Flip the horizontal direction
	if dir.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / (collider.p_height / 2)) * MAX_Y_VECTOR
	return new_dir.normalized()

func _on_spawn_timer_timeout() -> void:
	new_ball()  # Spawn a new ball when the timer times out
