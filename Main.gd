extends Node

export (PackedScene) var Mob
var score


func _ready():
	randomize()
	# Set background colour to random
	$Background.color = Color(randf(), randf(), randf(), 1)


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()


func _on_MobTimer_timeout():
	# Choose random location on Path2D
	$MobPath/MobSpawnLocation.offset = randi()
	# Create mob instance and add to scene
	var mob = Mob.instance()
	add_child(mob)
	# Set mobs dir perpendicular to path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set mobs position to random location
	mob.position = $MobPath/MobSpawnLocation.position
	# Add randomness to direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed and direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	$HUD.connect("start_game", mob, "_on_start_game")


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

