@tool

static func random( darken : float = 0.0 ) -> Color:
	var c := Color(randf(),randf(),randf())
	c = c.clamp(Color(0.4,0.4,0.4))
	c = c.lightened(0.2).darkened(darken)
	var v := Vector3(c.r,c.g,c.b)
	v -= Vector3(0.5,0.5,0.5)
	v = v.normalized() / 2 + Vector3(0.5,0.5,0.5)
	c = Color(v.x,v.y,v.z)
	return c

const NUMBER_OF_EXAMPLES = 3
const BLOCK = "■■■■■■■■■■■■"  # Large Unicode block for visible color swatch

static func random_pastel(alpha: float = 1.0) -> Color:
	var hue:float = randf()
	var saturation:float = randf_range(0.15, 0.45)
	var value:float = randf_range(0.85, 0.98)
	return Color.from_hsv(hue, saturation, value, alpha)


static func random_neon(alpha: float = 1.0) -> Color:
	var hue:float = randf()
	var sat:float = randf_range(0.85, 1.0)      # Very high saturation
	var val:float = randf_range(0.85, 1.0)      # Bright
	return Color.from_hsv(hue, sat, val, alpha)


static func random_earthy(alpha: float = 1.0) -> Color:
	var hue:float = randf_range(0.00, 0.3)     # Browns, oranges, greens
	var sat:float = randf_range(0.25, 0.65)
	var val:float = randf_range(0.35, 0.75)     # Mid to lower brightness
	return Color.from_hsv(hue, sat, val, alpha)


static func random_muted(alpha: float = 1.0) -> Color:
	var hue:float = randf()
	var sat:float = randf_range(0.10, 0.40)     # Low saturation
	var val:float = randf_range(0.45, 0.75)     # Mid brightness
	return Color.from_hsv(hue, sat, val, alpha)


static func random_warm(alpha: float = 1.0) -> Color:
	var hue:float = randf_range(0.04, 0.45) - 0.26 # Red → Yellow range
	if hue < 0: hue += 1.0
	var sat:float = randf_range(0.40, 0.85)
	var val:float = randf_range(0.70, 0.95)
	return Color.from_hsv(hue, sat, val, alpha)


static func random_cool(alpha: float = 1.0) -> Color:
	var hue:float = randf_range(0.20, 0.75) # Green → Blue → Purple
	var sat:float = randf_range(0.30, 0.80)
	var val:float = randf_range(0.65, 0.95)
	return Color.from_hsv(hue, sat, val, alpha)


## Generates a complete UI palette (Light + Dark variants) based on a single base color.
static func generate_ui_palette2(base_color: Color, style: String = "unnamed") -> Dictionary:
	var base_hue: float = base_color.h
	var base_sat: float = base_color.s
	var _base_val: float = base_color.v

	var palette: Dictionary = {}

	# ====================== LIGHT MODE ======================
	palette.light = {}
	var l:Dictionary = palette.light

	l.background     = Color.from_hsv(base_hue, base_sat * 0.15, 0.98)
	l.surface        = Color.from_hsv(base_hue, base_sat * 0.20, 0.94)
	l.panel          = Color.from_hsv(base_hue, base_sat * 0.18, 0.89)
	l.elevated       = Color.from_hsv(base_hue, base_sat * 0.22, 0.82)

	l.primary        = Color.from_hsv(base_hue, clampf(base_sat * 0.9, 0.4, 0.95), 0.88)
	var l_prime:Color = l.primary
	l.primary_hover  = Color.from_hsv(base_hue, clampf(base_sat * 1.05, 0.45, 1.0), 0.94)
	l.primary_pressed= Color.from_hsv(base_hue, clampf(base_sat * 1.1, 0.5, 1.0), 0.72)
	l.primary_disabled = l_prime.darkened(0.3)

	l.text_primary   = Color.from_hsv(0.0, 0.0, 0.12)
	l.text_secondary = Color.from_hsv(0.0, 0.0, 0.45)
	l.text_disabled  = Color.from_hsv(0.0, 0.0, 0.68)
	l.text_on_primary = Color.WHITE if l_prime.get_luminance() < 0.6 else Color(0.1, 0.1, 0.1)

	l.success = Color.from_hsv(0.38, 0.55, 0.82)
	l.warning = Color.from_hsv(0.12, 0.65, 0.90)
	l.error   = Color.from_hsv(0.98, 0.60, 0.85)
	l.info    = Color.from_hsv(0.55, 0.55, 0.85)

	l.border  = Color.from_hsv(base_hue, base_sat * 0.35, 0.75)
	l.divider = Color.from_hsv(base_hue, base_sat * 0.20, 0.85)

	# ====================== DARK MODE ======================
	palette.dark = {}
	var d:Dictionary = palette.dark

	d.background     = Color.from_hsv(base_hue, base_sat * 0.25, 0.08)
	d.surface        = Color.from_hsv(base_hue, base_sat * 0.30, 0.14)
	d.panel          = Color.from_hsv(base_hue, base_sat * 0.28, 0.20)
	d.elevated       = Color.from_hsv(base_hue, base_sat * 0.32, 0.28)

	d.primary        = Color.from_hsv(base_hue, clampf(base_sat * 1.1, 0.5, 1.0), 0.82)
	var d_prime:Color = d.primary
	d.primary_hover  = Color.from_hsv(base_hue, clampf(base_sat * 1.2, 0.55, 1.0), 0.88)
	d.primary_pressed= Color.from_hsv(base_hue, clampf(base_sat * 1.15, 0.5, 1.0), 0.65)
	d.primary_disabled = d_prime.darkened(0.35)

	d.text_primary   = Color.from_hsv(0.0, 0.0, 0.92)
	d.text_secondary = Color.from_hsv(0.0, 0.0, 0.65)
	d.text_disabled  = Color.from_hsv(0.0, 0.0, 0.45)
	d.text_on_primary = Color.BLACK if d_prime.get_luminance() > 0.7 else Color.WHITE

	d.success = Color.from_hsv(0.38, 0.65, 0.75)
	d.warning = Color.from_hsv(0.12, 0.75, 0.82)
	d.error   = Color.from_hsv(0.98, 0.70, 0.78)
	d.info    = Color.from_hsv(0.55, 0.65, 0.78)

	d.border  = Color.from_hsv(base_hue, base_sat * 0.40, 0.35)
	d.divider = Color.from_hsv(base_hue, base_sat * 0.25, 0.22)

	# Top level shortcuts
	palette.base_color = base_color
	palette.primary = palette.light.primary      # Most used
	palette.style = style

	return palette


static func print_color( color:Color ) -> void:
	var hex:String = color.to_html(false)
	var line:String = "[color=#%s]%s[/color]   " % [hex, BLOCK]
	line += "%-18s  #%s   %s" % ['base_color', hex, color]
	print_rich(line)


static func print_colours( dict:Dictionary, heading:String = '' ) -> void:
	if not heading.is_empty():
		print_rich("--- %s ---" % heading)

	for key:StringName in dict:
		var value:Variant = dict[key]
		if (value is Dictionary):
			var sub_dict:Dictionary = value
			print_colours(sub_dict, key)
			continue

		if value is Color:
			var colour:Color = value
			print_color(colour)
			continue

		print("%s: Unknown" % key)


static func colour_test() -> void:
	print_rich("\n[b]=== Colors ===[/b]\n")

	for style:Callable in [Enetheru.colour.random, random_pastel, random_neon, random_earthy,
		random_muted, random_warm,
		random_cool]:
			print_rich("--- %s ---" % style.get_method())
			for i in 10:
				var color:Color = style.call()
				print_color(color)

	for style:Callable in [Enetheru.colour.random, random_pastel, random_neon, random_earthy,
		random_muted, random_warm,
		random_cool]:
			var style_name:String = style.get_method()
			for i in NUMBER_OF_EXAMPLES:
				print_rich("\n[b]== %s Example %d ==[/b]" % [style_name, i])
				var color:Color = style.call()
				print_color(color)
				var palette:Dictionary = generate_ui_palette2(color, style_name)
				print_colours(palette, "--- Palette(%s) ---" % palette.style)
