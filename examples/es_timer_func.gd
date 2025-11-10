@tool
extends EditorScript

func _run() -> void:
	print( "_run()")

	if is_instance_valid(EnetheruUtils.plugin):
		EnetheruUtils.run( test_func )
	else:
		print("Enetheru.utils plugin is not enabled.")
		return

	print( "EditorScript Finished" )


static func test_func() -> void:
	print("test_func()")
	var utils := EnetheruUtils.plugin
	var scene_tree := utils.get_tree()

	var timer_completed : Signal
	var scene_timer_completed : Signal

	var timer := Timer.new()
	timer.one_shot = true
	timer.ignore_time_scale = true
	utils.add_child( timer )

	@warning_ignore('return_value_discarded')
	timer.timeout.connect(
		func() -> void:
			print("_on_timer_timeout()")
			scene_timer_completed.emit(),
		CONNECT_ONE_SHOT )
	timer.start(5)

	@warning_ignore('return_value_discarded')
	scene_tree.create_timer(3).timeout.connect(
		func() -> void:
			print("_on_scene_tree_timer_timeout")
			timer_completed.emit(),
		CONNECT_ONE_SHOT)

	await timer.timeout
	timer.queue_free()
	print("Finished")
