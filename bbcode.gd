static func h1( text : String, font_size : int ) -> String:
	return "".join([
		"[font_size=%s]" % [font_size],
		"[br]",
		"[b]=== %s ===[/b]" % text,
		"[/font_size]",
		])


static func h2( text : String, font_size : int ) -> String:
	return "".join([
		"[font_size=%s]" % [font_size],
		"[br]",
		"[b]--- %s ---[/b]" % text,
		"[/font_size]",
		])
