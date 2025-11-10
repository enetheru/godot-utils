@tool
extends EditorScript

const EditorLog = preload('uid://babswmnh2kosn')


func _run() -> void:
	EditorLog.printy( "_run()", null, self )

	if is_instance_valid(EnetheruUtils.plugin):
		EnetheruUtils.run_object( MyRunOb.new() )
	else:
		EditorLog.printy("Enetheru.utils plugin is not enabled.")
		return

	EditorLog.printy( "H1EditorScript Finished" )


class MyRunOb extends EnetheruUtils.RunObject:

	signal timer_completed
	signal scene_timer_completed

	var timer : Timer
	var scene_tree : SceneTree

	func _on_scene_tree_timer_timeout() -> void:
		EditorLog.printy("_on_scene_tree_timer_timeout()", null, self)
		scene_timer_completed.emit()

	func _on_timer_timeout() -> void:
		EditorLog.printy("_on_timer_timeout()", null, self)
		timer_completed.emit()

	func _run() -> void:
		EditorLog.printy("_run()", null, self)
		scene_tree = p.get_tree()

		timer = Timer.new()
		timer.one_shot = true
		timer.ignore_time_scale = true
		p.add_child( timer )

		@warning_ignore('return_value_discarded')
		timer.timeout.connect( _on_timer_timeout, CONNECT_ONE_SHOT )
		timer.start(5)

		@warning_ignore('return_value_discarded')
		scene_tree.create_timer(3).timeout.connect( _on_scene_tree_timer_timeout, CONNECT_ONE_SHOT)

		await timer.timeout
		timer.queue_free()
		EditorLog.printy("H1MyRunOb.Finished")
