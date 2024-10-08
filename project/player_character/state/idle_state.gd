extends State

class_name IdleState

@onready var main_animation_player: AnimationPlayer = %Felicity/%MainAnimations
@onready var overlapping_animation_player: AnimationPlayer = %Felicity/%OverlappingAnimations
@onready var player_input_handler: Node = %PlayerInputHandler


#@onready var debugger: StateDebugger = %StateDebugger

func _init():
	machine = StateMachine.new()
	add_child(machine)

func enter_state(_data: Dictionary = {}):
	main_animation_player.play("Idle")
	overlapping_animation_player.play("Adjustglasses")
	#Fall
#Idle
#JumpUp
#Land
#Push
#RESET
#Walk Right
#jump
	
	pass
	#if debugger:
		#debugger.states.append(self)

func update(delta):
	if not machine.state == null:
		machine.state.update(delta)

func exit_state():
	main_animation_player.stop()
	overlapping_animation_player.stop()
	machine.change_state(null)
	#if debugger:
		#debugger.states.erase(self)
