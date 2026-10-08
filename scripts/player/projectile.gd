extends RigidBody3D
class_name Projectile

# --

@export var flight_time : float = 1
@export var arch_height : float = 5

# --

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
# --

func shoot(source_pos : Vector3, target_pos : Vector3) -> void:
	global_position = source_pos
	
	# Conseguimos la dirección hacia el target
	# Y la multiplicamos por 1.1 para hacer que le atine mejor el proyectil
	var start_pos := global_position
	var delta_pos := target_pos - start_pos
	delta_pos *= 1.1
	
	# Conseguimos la velocidad horizontal
	var hor_vel := Vector3(delta_pos.x, 0.0, delta_pos.z) / flight_time
	
	# Conseguimos la altura maxima que vamos a alcanzar
	var height = delta_pos.y + arch_height
	
	# Calculamos cuanto de la gravedad vamos a necesitar modificar para lograr
	# el height y el speed que queremos
	# Usamos la equación de proyectiles. De fisica.
	var required_gravity = (8.0 * height - 4.0 * delta_pos.y) / (flight_time * flight_time)
	var ver_vel := sqrt(2.0 * required_gravity * height)
	
	# Modificamos la gravedad
	# (SI, zarpado)
	var default_gravity: float = -get_gravity().y
	gravity_scale = required_gravity / default_gravity
	
	# Seteamos nuestra velocidad final
	linear_velocity = Vector3(hor_vel.x, ver_vel, hor_vel.z)

# --

func _on_body_entered(body : Node3D) -> void:
	# Si es un "shooteable" acá le decimos que pasa cuando lo shooteamos
	print(body)
	queue_free()
