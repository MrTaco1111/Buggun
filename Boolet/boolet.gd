extends CharacterBody2D

var dir : float
var spawnPos : Vector2
var spawnRot : float
var spawnIndex : int
var pointWidth : float
var hit : bool
var counter : int;
var hasEmittedBooletSprayParticles : bool


func _ready():
	global_position = spawnPos + Vector2(80, 0).rotated(dir)
	global_rotation = spawnRot
	z_index = spawnIndex
	pointWidth = 1
	$"GunSprayParticles".emitting = false
	$"BooletSprayParticles".emitting = false
	$"BooletTrail".width_curve.set_point_value(0, 1)
	$"BooletTrail".width_curve.bake()
	$"BooletTrailOutline".width_curve.set_point_value(0, 1)
	$"BooletTrailOutline".width_curve.bake()
	$"BooletTrailOutline".z_index = spawnIndex - 1
	$"Timer".start(.3)
	$"RayCast2D".force_raycast_update()
	
	hasEmittedBooletSprayParticles = false
	counter = 3
	if($"RayCast2D".is_colliding()):
		hit = true
	else:
		hit = false
	
	$"GunSprayParticles".emitting = true
	$"GunSprayParticles".gravity = -500 * Vector2(1, 0).rotated(global_rotation)


func _physics_process(_delta: float) -> void:
	if(hit):
		var hypotenuse = sqrt(pow($"RayCast2D".get_collision_point().x - global_position.x, 2) + pow($"RayCast2D".get_collision_point().y - global_position.y, 2))
		if(hypotenuse < 1500 and counter == 3):
			counter = 1
		$"BooletTrail".set_point_position(1, Vector2(hypotenuse/counter, 0))
		$"BooletTrailOutline".set_point_position(1, Vector2(hypotenuse/counter, 0))
		if(!hasEmittedBooletSprayParticles and counter == 1):
			$"BooletSprayParticles".position = Vector2(hypotenuse, 0)
			$"BooletSprayParticles".emitting = true
			hasEmittedBooletSprayParticles = false
	else:
		$"BooletTrail".set_point_position(1, Vector2(10000.0/counter, 0))
		$"BooletTrailOutline".set_point_position(1, Vector2(10000.0/counter, 0))
	$"Timer2".start(.01)
	if(counter > 1):
		counter -= 1


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	$"BooletTrail".width_curve.set_point_value(0, pointWidth)
	$"BooletTrail".width_curve.bake()
	$"BooletTrail".width -= 1
	$"BooletTrailOutline".width_curve.set_point_value(0, pointWidth)
	$"BooletTrailOutline".width_curve.bake()
	$"BooletTrailOutline".width -= 1
	if(pointWidth > 0):
		pointWidth -= .2
	if($"BooletTrailOutline".width <= 0):
		queue_free()
	pass # Replace with function body.
