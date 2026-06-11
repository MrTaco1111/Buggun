extends CharacterBody2D


const SPEED : float = 300.0
const JUMP_VELOCITY : float = -2000.0
const BLAST_VELOCITY : float = -2000.0
@onready var coyoteCheck : bool = true
var canCoyoteJump : bool
@onready var dashFrames : int = 0
@onready var canDash : bool = true

func _physics_process(delta: float) -> void:
	Global.charPosition = position

	if not is_on_floor():
		velocity += get_gravity() * delta
		if(coyoteCheck):
			$"CoyoteTimer".start(.15)
			coyoteCheck = false
	else:
		canCoyoteJump = true
		coyoteCheck = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or canCoyoteJump:
			canCoyoteJump = false
			velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("dash") and canDash:
		dashFrames = 1
		canDash = false
		$"DashTimer".start(1)

	if(dashFrames > 0):
		if $"cricket sprite".flip_h == true:
			velocity.x = -6000
		else:
			velocity.x = 6000
		dashFrames += 1
		if(dashFrames == 15):
			dashFrames = 0
			if $"cricket sprite".flip_h == true:
				velocity.x = -2000
			else:
				velocity.x = 2000

	if Input.is_action_just_pressed("ui_down") and velocity.y < 2000:
		velocity.y += 3000


	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and velocity.x * direction < 2500:
		velocity.x += direction * SPEED

		if(direction == -1 and !$"cricket sprite".flip_h):
			$"cricket sprite".flip_h = true
		elif(direction == 1):
			$"cricket sprite".flip_h = false
	elif !direction:
		if is_on_floor():
			velocity.x  = move_toward(velocity.x, 0, SPEED/2)
	else:
		if !(not is_on_floor() and direction == velocity.x/abs(velocity.x)):
			velocity.x  = move_toward(velocity.x, 0, SPEED/2)


	if Global.shot:
		var mousePos = get_local_mouse_position().normalized()
		Global.shot = false
		velocity.x += (mousePos.x * BLAST_VELOCITY / 5)
		if(velocity.y > 0 and mousePos.y > 0):
			velocity.y = (mousePos.y * BLAST_VELOCITY/10)
		else:
			velocity.y += (mousePos.y * BLAST_VELOCITY/10)


	if Global.blankBlast:
		var mousePos = get_local_mouse_position().normalized()
		Global.blankBlast = false
		if(velocity.x > 0 and mousePos.x > 0):
			velocity.x = (mousePos.x * BLAST_VELOCITY*4)
		elif(velocity.x < 0 and mousePos.x < 0):
			velocity.x = (mousePos.x * BLAST_VELOCITY*4)
		else:
			velocity.x += (mousePos.x * BLAST_VELOCITY*4)
		if(velocity.y > 0 and mousePos.y > 0):
			velocity.y = (mousePos.y * BLAST_VELOCITY*1.5)
		else:
			velocity.y += (mousePos.y * BLAST_VELOCITY)


	move_and_slide()


func _on_coyote_timer_timeout() -> void:
	canCoyoteJump = false


func _on_dash_timer_timeout() -> void:
	canDash = true
