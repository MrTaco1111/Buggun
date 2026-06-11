extends Node

var charPosition : Vector2
var pause : bool
var shot : bool
var blankBlast : bool
@export var ammo : float

func _ready() -> void:
	pause = false
	pass # Replace with function body.


func hitstop(timescale : float, duration : float):
	pause = true
	Engine.time_scale = timescale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
	pause = false
	pass
