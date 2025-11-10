@tool

static var bbstrip_regex := RegEx.new()


static func _static_init() -> void:
	var err : Error = bbstrip_regex.compile("\\[.*?\\]")
	assert( err == OK )


static func strip_bbcode( msg : String ) -> String:
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




var box_heavy : String  = "━┃┏┓┗┛┣┫┳┻╋"

var box_double : String = "═║╔╗╚╝╠╣╦╩╬"

var box_light_ext : String = "╭╮╯╰╱╲╳╴╵╶╷╌╎┄┆┈┊"

var box_heavy_ext : String = "╸╹╺╻╍╏┅┇┉┋"

var box_mixed : String = "┍┎┑┒┕┖┙┚┝┞┟┠┡┢┥┦┧┨┩┪┭┮┯┰┱┲┵┶┷┸┸┹┺┽┾┿╀╁╂╃╄╅╆╇╈╉╊╒╓╕╖╘╙╛╜╞╟╡╢╤╥╧╨╪╫╼╽╾╿"

enum Line {
	RIGHT  = 0x1,
	UP     = 0x2,
	LEFT   = 0x4,
	DOWN   = 0x8,

	# HEAVY
	RIGHT_H  = 0x10,
	UP_H     = 0x20,
	LEFT_H   = 0x40,
	DOWN_H   = 0x80,

	# DOUBLE
	RIGHT_D  = 0x100,
	UP_D     = 0x200,
	LEFT_D   = 0x400,
	DOWN_D   = 0x800,

	# DASHED
	DASH2   = 0x1000,
	DASH3   = 0x2000,
	DASH4   = 0x4000,

	# LINES
	HL  = LEFT | RIGHT,
	VL  = UP | DOWN,
	# Dashed
	HL2 = LEFT | RIGHT | DASH2,
	VL2 = UP | DOWN | DASH2,
	HL3 = LEFT | RIGHT | DASH3,
	VL3 = UP | DOWN | DASH3,
	HL4 = LEFT | RIGHT | DASH4,
	VL4 = UP | DOWN | DASH4,

	# Corners
	UL  = UP | LEFT,
	UR  = UP | RIGHT,
	DL  = DOWN | LEFT,
	DR  = DOWN | RIGHT,

	# T-Junction
	TR  = VL | RIGHT,
	TL  = VL | LEFT,
	TU  = HL | UP,
	TD  = HL | DOWN,

}

var box_light : String =  "─│┌┐└┘├┤┬┴┼"
var lp : Dictionary[int,String] = {
	Line.HL : "─",
	Line.VL : "│",
	Line.UL : "┌",
	Line.UR : "┐",
	Line.DL : "└",
	Line.DR : "┘",
	Line.TR : "├",
	Line.TL : "┤",
	Line.TU : "┴",
	Line.TD : "┬",
}

	## Braille base and patterns (0-15 for 4-bit fill)
	#var braille_base: int = 0x2800
	#print(char(braille_base))
			## Optional: Add side dots (bits 4-7) for gradient density (btop-style)
			#if block_fill_ratio > 0.5:
				#braille_idx |= 0b11110000  # Full side for >50%
			#elif block_fill_ratio > 0.25:
				#braille_idx |= 0b01110000  # Partial side


static func braillev(v : int) -> String:
	# Braille base and patterns (0-15 for 4-bit fill)
	var braille_base: int = 0x2800
	var b : Array = [
		0b10000000,
		0b01000000,
		0b00100000,
		0b00000100,
		0b00010000,
		0b00000010,
		0b00001000,
		0b00000001]
	var accum : int = 0
	for i in range(v): accum |= b[i]
	return char(braille_base + accum)
