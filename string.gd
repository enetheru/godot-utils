@tool

static var bbstrip_regex := RegEx.new()


static func _static_init() -> void:
	var err : Error = bbstrip_regex.compile("\\[.*?\\]")
	assert( err == OK )


static func strip_bbcode( msg : String) -> String:
	return bbstrip_regex.sub(msg, "", true)


static func sbytes( bytes : PackedByteArray, cols : int = 8 ) -> String:
	if bytes.is_empty(): return "Empty"
	var retval : Array = ["size: %d" % bytes.size()]
	var position := 0
	while true:
		var slice : PackedByteArray = bytes.slice(position, position + cols)
		if not slice.size(): break

		# new line
		var line : String = ""
		# Position
		line += "%08X: " % position
		# bytes as hex pairs
		for v in slice: line += "%02X " % v
		# pad to width
		line = line.rpad( 10 + cols*3, ' ')
		# ascii
		for v in slice: line += char(v) if v > 32 else '.'

		retval.append(line)
		position += cols
		if slice.size() < cols: break

	return '\n'.join( retval )


static func id_str( id : int, length : int = 4 ) -> String:
	return "0x" + ("%016X" % id).right(length)


static func to_bin( val : int, width : int = 8 ) -> String:
	#return "val: %d width: %d" % [val, width]
	var output : Array
	while width:
		width -= 1
		if val & 0x1: output.append('1')
		else: output.append('0')
		val = val >> 1

	output.reverse()
	return ''.join( output )


static func mask_to_str( val : int, width : int = 8 ) -> String:
	return to_bin( val, width )


static func trunc( value : Variant, length : int = 10 ) -> String:
	var input := str(value)
	if input.length() < length: return input
	return input.left(length - 2) + " "


static func center(width: int, s: String, pad_char: String = " ") -> String:
	if s.length() >= width: return s
	@warning_ignore('integer_division')
	var left_pad: int = (width - s.length()) / 2
	return s.lpad(s.length() + left_pad, pad_char).rpad(width, pad_char)
