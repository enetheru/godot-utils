@tool

static func test_or_wait(
			test : Callable,
			expects : Variant,
			sig : Signal
			) -> Variant:
	var test_result : Variant = test.call()
	if test_result == expects: return test_result == expects
	print("Note: test_or_wait( '%s()', expects '%s' got '%s'" % [
		test.get_method(),test_result, expects
	])
	print("Waiting: for %s.%s" % [sig.get_object(),sig.get_name()])
	await sig
	print("Resuming: after %s.%s" % [sig.get_object(),sig.get_name()])
	return test.call() == expects

# Rudimentary ScopeGuard class in GDScript (Godot 4+)
# This class extends Object to leverage NOTIFICATION_PREDELETE for automatic cleanup
# when the object's reference count reaches zero (i.e., end of scope).

class ScopeGuard:
	var _callback: Callable
	var _wait : bool = false

	func _init(callback: Callable, wait : bool = false) -> void:
		_callback = callback
		_wait = wait

	func _notification(what: int) -> void:
		if what == NOTIFICATION_PREDELETE:
			if _wait: await _callback.call()
			else: _callback.call()
