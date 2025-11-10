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
