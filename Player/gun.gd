extends Node2D

@onready var main = get_tree().get_root().get_node("main")
@onready var boolet = load("res://Boolet/Boolet.tscn")
@onready var blast = load("res://BlankBlast/blankBlast.tscn")
var canShoot
@export var hitStopTime : float 

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ammo = 3.0
	canShoot = true
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	if(!Global.pause):
		look_at(get_global_mouse_position())
		if(abs(fmod(rotation, 2 * PI)) > PI/2 and abs(fmod(rotation, 2 * PI)) < 3 * PI / 2):
			$"GunSprite".flip_v = true
		else:
			$"GunSprite".flip_v = false
	

	
	if (Input.is_action_just_pressed("left_click") and canShoot and !$"GunWallDetector".is_colliding() and Global.ammo >= 1):
		Global.shot = true
		canShoot = false
		Global.ammo -= 1
		shoot()
		$"Timer".start(.3)
	elif (Input.is_action_just_pressed("left_click") and Global.ammo == 0 and canShoot):
		Global.blankBlast = true
		canShoot = false
		$"Timer".start(2)
		blankBlast()


func shoot():
	var instance = boolet.instantiate()
	instance.dir = rotation
	instance.spawnPos = $"GunSprite".global_position
	instance.spawnRot = rotation
	instance.spawnIndex = z_index - 1
	main.add_child.call_deferred(instance)
	Global.hitstop(0, hitStopTime)


func blankBlast():
	var instance = blast.instantiate()
	instance.dir = rotation
	instance.spawnPos = $"GunSprite".global_position
	instance.spawnRot = rotation
	instance.spawnIndex = z_index - 1
	main.add_child.call_deferred(instance)
	Global.hitstop(0, hitStopTime/3)


func _on_timer_timeout():
	canShoot = true
	pass # Replace with function body.
