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
		print( "run()" )
		await c.call()
		p.active_run = null
		finished.emit()

	func _run() -> void:
		print( "_run()" )


static var active_run : RunObject


func _init() -> void:
	plugin = self


func _enter_tree() -> void:
	print("_enter_tree()")

	var editor_theme : Theme = EditorInterface.get_editor_theme()
	var button_icon : Texture2D = editor_theme.get_icon("Button", "EditorIcons")
	add_custom_type("RichIconButton", "Control", preload('ui/rich_icon_button.gd'), button_icon)

	print( get_path() )


func _exit_tree() -> void:
	print("_exit_tree()")
	remove_custom_type("RichIconButton")


static func check() -> void:
	if is_instance_valid( plugin.active_run ):
		print("Warning: active_run was still a valid instance.")
		active_run = null


static func run( run_func : Callable ) -> void:
	print("run(%s)" % run_func.get_method())
	check()
	active_run = RunObject.new( plugin, run_func )
	active_run.run()


static func run_object( object : RunObject ) -> void:
	print("run_object(%s)" % object)
	check()
	active_run = object
	active_run.run()
