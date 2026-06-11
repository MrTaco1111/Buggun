extends Camera2D

@export var randomStrength : float = 30.0
@export var shakeFade : float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if(Global.ammo >= 1):
	#	position = ((Global.charPosition-global_position)*2 + get_local_mouse_position())/3
	#else:
	#	position = -((Global.charPosition-global_position)*50 + get_local_mouse_position())/51


	if Global.shot or Global.blankBlast:
		var localHitstop
		if(Global.shot):
			localHitstop = .4
		else:
			localHitstop = .2
		await get_tree().create_timer(localHitstop, true, false, true).timeout
		screenshake()
	pass
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * _delta)
		if(!Global.pause):
			offset = randomOffset()


func screenshake():
	shake_strength = randomStrength

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
