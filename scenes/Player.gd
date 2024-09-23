extends StaticBody2D

var win_height : int
var p_height : int
var is_moving = false  # Variable to track if the paddle is moving

# Called when the node enters the scene tree for the first time.
func _ready():
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= get_parent().PADDLE_SPEED * delta
		if not is_moving:  # Play sound if it's not already playing
			$PlayerMoveSound.play()
			is_moving = true  # Set the moving state to true
	elif Input.is_action_pressed("ui_down"):
		position.y += get_parent().PADDLE_SPEED * delta
		if not is_moving:  # Play sound if it's not already playing
			$PlayerMoveSound.play()
			is_moving = true  # Set the moving state to true
	else:
		if is_moving:  # Stop the sound if we were moving and now we are not
			$PlayerMoveSound.stop()
			is_moving = false  # Set the moving state to false

	# Limit paddle movement to window
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
