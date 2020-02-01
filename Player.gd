extends Area2D

signal hit

export var speed = 400 # how fast the player will move (pixels/sec)
var screen_size
var velocity = Vector2()
# add this variable to hold the clicked position
var target = Vector2()

# this will be called when node enter the scene tree
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func start(pos):
	position = pos
	# initial target is the start position
	target = pos
	show()
	$CollisionShape2D.disabled = false
	
# change the target whenever a touch event happens --> hmm.., ada ini juga ya ternyata?
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

# this will be called on every frame
func _process(delta):
	# move towards the target and stop when close
	if position.distance_to(target) > 10:
		velocity = (target-position).normalized() * speed
	else:
		velocity = Vector2()
		
#	# calculate player velocity
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1
	
	# check whether should play player animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	# set player position
	position += velocity * delta
	# we don't need to clamp player position because player
	# can't click outside the screen
#	position.x = clamp(position.x, 0, screen_size.x)
#	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = (velocity.x < 0)
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = (velocity.y > 0)

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	# hoo.., ini set property disable ke true tapi di defer sampai ini 
	# safe untuk dilakukan --> mirip kayak di go ya? Cuma kalau di go
	# pas keluar dari function
	$CollisionShape2D.set_deferred("disabled", true)
	
