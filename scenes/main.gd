extends Node2D

var game_over : bool = false
var score := [0, 0]  # 0: Player, 1: CPU
var make_balls : bool = true  # Control ball spawning
const PADDLE_SPEED : int = 500
var game_timer : float = 30.0  # Starting timer value
@onready var timer_label : Label = $TimerLabel  # Update this path to your Label node

func _ready():
	pass

func _on_ball_timer_timeout():
	if not game_over:  # Only create a new ball if the game is still active
		$Ball.new_ball()
		$GameTimer.start()

func _on_score_left_body_entered(body):
	if not game_over:  # Check if the game is still active
		score[1] += 1
		$Hud/CPUScore.text = str(score[1])
		$BallTimer.start()

func _on_score_right_body_entered(body):
	if not game_over:  # Check if the game is still active
		score[0] += 1
		$Hud/PlayerScore.text = str(score[0])
		$BallTimer.start()

func _on_game_timer_timeout() -> void:
	game_over = true
	make_balls = false  # Stop creating new balls
	print("Game Over!")  # This should print when the timer ends
	remove_balls()  # Remove all balls from the scene

func remove_balls():
	for child in get_children():  # Ensure you reference the correct node
		if child.is_in_group("balls"):
			child.queue_free()  # Remove the ball from the scene

func _process(delta):
	if not game_over:
		game_timer -= delta  # Decrease the timer
		timer_label.text = "Time Left: " + str(int(game_timer))  # Update the label with the timer value
		if game_timer <= 0:
			_on_game_timer_timeout()  # Trigger game over if timer reaches 0
