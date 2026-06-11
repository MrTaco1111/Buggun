extends CharacterBody2D

var dir : float
var spawnPos : Vector2
var spawnRot : float
var spawnIndex : int
var pointWidth : float
var gasFloating : bool


func _ready():
	global_position = spawnPos + Vector2(80, 0).rotated(dir)
	global_rotation = spawnRot
	z_index = spawnIndex
	gasFloating = true
	$"SmokeyParticles".emitting = true
	$"SmokeyParticles".gravity = -500 * Vector2(1, 0).rotated(global_rotation)
	$"GunSprayParticles".emitting = true
	$"ExplosionParticles".emitting = true
	$SmokeGravityTimer.start(.4)
	$"DeleteTimer".start(4)


func _on_timer_timeout() -> void:
	$"SmokeyParticles".gravity = Vector2(0, -500)
	


func _on_delete_timer_timeout() -> void:
	queue_free()
