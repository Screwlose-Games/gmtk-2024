extends State

class_name WalkState

@onready var animation_player: AnimationPlayer = %Felicity/AnimationPlayer

#@onready var debugger: StateDebugger = %StateDebugger

func _init():
	machine = StateMachine.new()
	add_child(machine)

func enter_state(_data: Dictionary = {}):
	animation_player.play("Walk Right")
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
	animation_player.stop()
	machine.change_state(null)
	#if debugger:
		#debugger.states.erase(self)
