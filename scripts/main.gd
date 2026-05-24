extends Node2D

# Assumes HUD is a CanvasLayer, ScorePanel is a Panel, and ScoreLabel is a Label
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel

# We don't strictly need the level_root onready var since we instantiate dynamically,
# but keeping it if you use it elsewhere.
@onready var level_root: Node2D = $LevelRoot

var level: int = 1
var score: int = 0
var current_level_root: Node = null

func _ready() -> void:
	# Clear the placeholder LevelRoot in the scene if it exists
	if has_node("LevelRoot"):
		$LevelRoot.queue_free()
		
	_load_level(level)
	_update_score_display() # Initialize the UI text at 0

func _load_level(level_number: int) -> void:
	if current_level_root and is_instance_valid(current_level_root):
		current_level_root.queue_free()
		
	var level_path = "res://scenes/levels/level_%s.tscn" % level_number
	
	# Safety check to see if the next level file actually exists
	if ResourceLoader.exists(level_path):
		current_level_root = load(level_path).instantiate()
		add_child(current_level_root)
		current_level_root.name = "LevelRoot"
		_setup_level(current_level_root)
	else:
		print("No more levels found! Game Over or Victory!")

func _setup_level(level_root: Node) -> void:
	# Connect Exit
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
		
	# Look for a container node named "Coins" (Plural)
	var coins_container = level_root.get_node_or_null("Coins")
	if coins_container:
		for coin in coins_container.get_children():
			# Verify the coin has the 'collected' signal before connecting
			if coin.has_signal("collected"):
				coin.collected.connect(increase_score)

func _on_exit_body_entered(body: Node2D) -> void:
	# Assuming your Player script has a class_name Player or you check the name
	if body.name == "Player":
		level += 1
		if body.has_method("set_deferred"): 
			body.set_deferred("can_move", false)
		_load_level(level)

func increase_score() -> void:
	score += 1
	_update_score_display()

func _update_score_display() -> void:
	if score_label:
		score_label.text = "SCORE: %s" % score
