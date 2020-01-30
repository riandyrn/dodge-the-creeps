extends Area2D

signal hit

export var speed = 400 # how fast the player will move (pixels/sec)
var screen_size

# this will be called when node enter the scene tree
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# this will be called on every frame
func _process(delta):
	# calculate player velocity
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	# check whether should play player animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	# set player position
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = (velocity.x < 0)
	else:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = (velocity.y > 0)


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	# hoo.., ini set property disable ke true tapi di defer sampai ini 
	# safe untuk dilakukan --> mirip kayak di go ya? Cuma kalau di go
	# pas keluar dari function
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
