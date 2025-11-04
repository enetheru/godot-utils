@tool
extends EditorPlugin
class_name EnetheruUtils

static var plugin : EnetheruUtils

class RunObject:
	signal finished

	var p : EnetheruUtils
	var c : Callable

	func _init( plugin : EnetheruUtils = EnetheruUtils.plugin,
				run_func : Callable = _run
				) -> void:
		p = plugin; c = run_func

	func run() -> void:
		Util.printy( "run()", null, self )
		await c.call()
		p.active_run = null
		finished.emit()

	func _run() -> void:
		Util.printy( "_run()", null, self )


static var active_run : RunObject


func _init() -> void:
	plugin = self


func _enter_tree() -> void:
	Util.printy("_enter_tree()", null, self)
	Util.printy( get_path() )


func _exit_tree() -> void:
	Util.printy("_exit_tree()", null, self)


static func check() -> void:
	if is_instance_valid( plugin.active_run ):
		Util.printy("Warning: active_run was still a valid instance.")
		active_run = null


static func run( run_func : Callable ) -> void:
	Util.printy("run(%s)", run_func.get_method(), plugin)
	check()
	active_run = RunObject.new( plugin, run_func )
	active_run.run()


static func run_object( run_object : RunObject ) -> void:
	Util.printy("run_object(%s)", run_object, plugin)
	check()
	active_run = run_object
	active_run.run()
