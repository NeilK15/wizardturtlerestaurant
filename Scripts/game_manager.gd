extends Node


var curr_interactable: Interactable = null

var player: Player = null;
var game: Game = null;
var nav_machine: NavigationMachine = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game/Player")
	game = get_node("/root/Game")
	nav_machine = game.get_nav_machine()

func over_interactable(interactable:Interactable) -> void:
	curr_interactable = interactable

func left_interactable(interactable:Interactable) -> void:
	if curr_interactable == interactable:
		curr_interactable = null

func interact():
	if curr_interactable:
		curr_interactable.interact_with()

func deactivate_player(turtle_cam: Camera2D):
	var player_cam = player.get_node("./Camera2D")
	if not player_cam:
		print("ERROR")
		return

	game.hide_crosshair()

	# deactivating player controls
	if player:
		player.change_state(Player.PlayerState.RESTING)

	# switching camerass
	await CameraTransition.transition_camera2D(player_cam, turtle_cam, 0.5)

func activate_player(turtle_cam: Camera2D):
	var player_cam = player.get_node("./Camera2D")
	if not player_cam:
		print("ERROR")
		return

	# switching camerass
	await CameraTransition.transition_camera2D(turtle_cam, player_cam, 0.5)

	# deactivating player controls
	if player:
		player.change_state(Player.PlayerState.CONTROLLED)



func get_game() -> Game:
	return game

func get_nav_machine() -> NavigationMachine:
	return nav_machine