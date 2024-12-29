extends Node2D

func _physics_process(delta):
	var targeted_scene_transition: SceneTransition
	targeted_scene_transition = find_scene_transition()
		
	if targeted_scene_transition != null:
		owner.nav_agent.target_position = targeted_scene_transition.global_position
		owner.state_machine.state = "moving"
	else:
		owner.state_machine.state = "idle"


func find_scene_transition() -> SceneTransition:
	print("targeted: " + str(owner.targeted_location))
	if !owner.targeted_location.is_empty():
		var transition: SceneTransition
		
		var transition_children: Array = []
		for child in owner.current_location.get_children():
			if child is SceneTransition:
				transition_children.append(child)
		
		if transition_children.size() == 1:
			transition = transition_children[0]
		else:
			for child in transition_children:
				if child.to_location == owner.targeted_location:
					transition = child
				else:
					for lead in child.leads_to:
						if lead == owner.targeted_location:
							transition = child
		

		
		print("transition: " + str(transition))
		return transition
	else: return
