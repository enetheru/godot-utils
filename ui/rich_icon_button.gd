@tool
extends Control


# ██████  ██████   ██████  ██████  ███████ ██████  ████████ ██ ███████ ███████ #
# ██   ██ ██   ██ ██    ██ ██   ██ ██      ██   ██    ██    ██ ██      ██      #
# ██████  ██████  ██    ██ ██████  █████   ██████     ██    ██ █████   ███████ #
# ██      ██   ██ ██    ██ ██      ██      ██   ██    ██    ██ ██           ██ #
# ██      ██   ██  ██████  ██      ███████ ██   ██    ██    ██ ███████ ███████ #
func                        ________PROPERTIES_______              ()->void:pass

var _default_props: Dictionary = {
	&"icon_type": null,
	&"icon_name": null,
	&"focus_mode": Control.FOCUS_ALL,
	&"mouse_default_cursor_shape": Control.CURSOR_POINTING_HAND,
	&"mouse_filter": Control.MOUSE_FILTER_STOP,
	&"size_flags_horizontal": Control.SIZE_SHRINK_CENTER,
	&"size_flags_vertical": Control.SIZE_FILL,
	&"horizontal_alignment": HORIZONTAL_ALIGNMENT_CENTER,
	&"vertical_alignment": VERTICAL_ALIGNMENT_CENTER,
	&"text_position": SIDE_LEFT,
	&"toggle_mode": false,
	&"toggle_state": false,
	&"separation": 0,
}

var style_names : PackedStringArray = [
	&"normal",
	&"hover",
	&"pressed",
	&"toggled",
	&"disabled",
	&"focus" ]



@export var icon_type : String: set = set_icon_type
@export var icon_name : String: set = set_icon_name

@export var icon_texture: Texture2D = null:
	set = set_icon_texture

@export var icon_size: float = 0:
	set(v):
		icon_size = v
		if is_node_ready(): preliminary_layout()


@export_multiline var button_text: String = "":
	set = set_button_text


@export var enable_bbcode: bool = false:
	set(v):
		enable_bbcode = v
		if is_node_ready():
			rebuild()
			queue_redraw()


@export var text_position: Side:
	set(v):
		text_position = v
		if is_node_ready(): rebuild()


@export var horizontal_alignment: HorizontalAlignment:
	set(v):
		horizontal_alignment = v
		if is_node_ready(): preliminary_layout()


@export var vertical_alignment: VerticalAlignment:
	set(v):
		vertical_alignment = v
		if is_node_ready(): preliminary_layout()


@export var disabled: bool = false:
	set(v):
		disabled = v
		if is_node_ready():
			queue_redraw()

@export var toggle_mode: bool = false:
	set(v):
		toggle_mode = v
		if is_node_ready(): queue_redraw()

@export var toggle_state: bool = false:
	set(v):
		toggle_state = v
		if is_node_ready(): queue_redraw()

@export var separation: int = 0:
	set(v):
		separation = v
		if is_node_ready(): preliminary_layout()

@export var draw_debug: bool = false:
	set(v):
		draw_debug = v
		if is_node_ready(): queue_redraw()


func _property_can_revert(property: StringName) -> bool:
	return _default_props.has(property)


func _property_get_revert(property: StringName) -> Variant:
	return _default_props.get(property, null)

# --------------------------------------------------------------------- #
# Internal nodes
var _inner_cont: BoxContainer
var _icon_rect: TextureRect
var _text_label: RichTextLabel

# State
var _hovered: bool = false
var _pressed: bool = false


#            ███████ ██  ██████  ███    ██  █████  ██      ███████             #
#            ██      ██ ██       ████   ██ ██   ██ ██      ██                  #
#            ███████ ██ ██   ███ ██ ██  ██ ███████ ██      ███████             #
#                 ██ ██ ██    ██ ██  ██ ██ ██   ██ ██           ██             #
#            ███████ ██  ██████  ██   ████ ██   ██ ███████ ███████             #
func                        _________SIGNALS_________              ()->void:pass

signal pressed()
signal toggle( toggled_on : bool )

#             ███████ ██    ██ ███████ ███    ██ ████████ ███████              #
#             ██      ██    ██ ██      ████   ██    ██    ██                   #
#             █████   ██    ██ █████   ██ ██  ██    ██    ███████              #
#             ██       ██  ██  ██      ██  ██ ██    ██         ██              #
#             ███████   ████   ███████ ██   ████    ██    ███████              #
func                        __________EVENTS_________              ()->void:pass

func _on_mouse_entered() -> void:
	_hovered = true
	final_layout.call_deferred()


func _on_mouse_exited() -> void:
	_hovered = false
	final_layout.call_deferred()


#      ██████  ██    ██ ███████ ██████  ██████  ██ ██████  ███████ ███████     #
#     ██    ██ ██    ██ ██      ██   ██ ██   ██ ██ ██   ██ ██      ██          #
#     ██    ██ ██    ██ █████   ██████  ██████  ██ ██   ██ █████   ███████     #
#     ██    ██  ██  ██  ██      ██   ██ ██   ██ ██ ██   ██ ██           ██     #
#      ██████    ████   ███████ ██   ██ ██   ██ ██ ██████  ███████ ███████     #
func                        ________OVERRIDES________              ()->void:pass

func _enter_tree() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL
	if not is_node_ready():
		rebuild()


func _ready() -> void:
	@warning_ignore_start('return_value_discarded')
	focus_entered.connect(final_layout, CONNECT_DEFERRED)
	focus_exited.connect(final_layout, CONNECT_DEFERRED)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	resized.connect( preliminary_layout, CONNECT_DEFERRED )
	@warning_ignore_restore('return_value_discarded')
	add_theme_color_override("MyColorOverride", Color.ALICE_BLUE)
	try_set_icon()


#                   ██ ███    ██ ██████  ██    ██ ████████                     #
#                   ██ ████   ██ ██   ██ ██    ██    ██                        #
#                   ██ ██ ██  ██ ██████  ██    ██    ██                        #
#                   ██ ██  ██ ██ ██      ██    ██    ██                        #
#                   ██ ██   ████ ██       ██████     ██                        #
func                        __________INPUT__________              ()->void:pass

func _gui_input(e: InputEvent) -> void:
	if disabled: return

	if e is InputEventMouseButton and _hovered:
		var event : InputEventMouseButton = e
		_gui_mouse_input(event)

	elif e is InputEventKey and has_focus():
		var event : InputEventKey = e
		_gui_key_input(event)


func _gui_mouse_input( event : InputEventMouseButton ) -> void:
	match event.button_index:
		MOUSE_BUTTON_LEFT when event.pressed:
			_pressed = true
			if toggle_mode:
				toggle_state = !toggle_state
				toggle.emit( toggle_state )
			final_layout.call_deferred()
			get_viewport().set_input_as_handled()

		MOUSE_BUTTON_LEFT when _pressed:
			_pressed = false
			final_layout.call_deferred()
			pressed.emit()
			get_viewport().set_input_as_handled()


func _gui_key_input( event : InputEventKey ) -> void:
	match event.keycode:
		KEY_ENTER, KEY_KP_ENTER, KEY_SPACE when event.pressed:
			pressed.emit()
			get_viewport().set_input_as_handled()


#             ██       █████  ██    ██  ██████  ██    ██ ████████              #
#             ██      ██   ██  ██  ██  ██    ██ ██    ██    ██                 #
#             ██      ███████   ████   ██    ██ ██    ██    ██                 #
#             ██      ██   ██    ██    ██    ██ ██    ██    ██                 #
#             ███████ ██   ██    ██     ██████   ██████     ██                 #
func                        __________LAYOUT_________              ()->void:pass

func _get_current_style() -> StringName:
	if   disabled:     return &"disabled"
	elif _pressed:     return &"pressed"
	elif _hovered:     return &"hover"
	elif toggle_state: return &"toggled"
	elif has_focus():  return &"focus"
	else:              return &"normal"


func _get_current_stylebox() -> StyleBox:
	return get_theme_stylebox(_get_current_style(), &"Button")


func _get_theme_font_size() -> float:
	if has_theme_font_size(&"font_size", &"Button"):
		return get_theme_font_size(&"font_size", &"Button")

	if has_theme_font(&"font", &"Button"):
		var font: Font = get_theme_font(&"font", &"Button")
		if font: return font.get_height()

	return 16


func _get_minimum_size() -> Vector2:
	if not _inner_cont or not is_inside_tree(): return Vector2(8,8)

	if is_instance_valid(_icon_rect) and is_instance_valid(_text_label) and icon_size == 0:
		match text_position:
			SIDE_LEFT,  SIDE_RIGHT:
				_icon_rect.custom_minimum_size.x = _inner_cont.size.y
				_icon_rect.custom_minimum_size.y = _inner_cont.size.y

			SIDE_TOP, SIDE_BOTTOM:
				_icon_rect.custom_minimum_size.x = _inner_cont.size.x
				_icon_rect.custom_minimum_size.y = _inner_cont.size.x


	var style: StyleBox = _get_current_stylebox()
	var style_min : Vector2 = style.get_minimum_size()

	var content_size : Vector2 = _inner_cont.get_combined_minimum_size()

	var min_w : float = max(style_min.x, style.content_margin_left + content_size.x + style.content_margin_right)
	var min_h : float = max(style_min.y, style.content_margin_top + content_size.y + style.content_margin_bottom)
	return Vector2(min_w, min_h)


func _draw() -> void:
	var style : StyleBox = _get_current_stylebox()
	draw_style_box(style, Rect2(Vector2.ZERO, size))

	if not draw_debug: return
	draw_rect(Rect2(_inner_cont.position, _inner_cont.size), Color.RED, false, 2)

	var dofs : Vector2 = _inner_cont.position # Draw Offset
	if is_instance_valid(_icon_rect):
		draw_rect(Rect2(dofs + _icon_rect.position, _icon_rect.size), Color.ORANGE, false, 2)

	if is_instance_valid(_text_label):
		draw_rect(Rect2(dofs + _text_label.position, _text_label.size), Color.YELLOW, false, 2)


#         ███    ███ ███████ ████████ ██   ██  ██████  ██████  ███████         #
#         ████  ████ ██         ██    ██   ██ ██    ██ ██   ██ ██              #
#         ██ ████ ██ █████      ██    ███████ ██    ██ ██   ██ ███████         #
#         ██  ██  ██ ██         ██    ██   ██ ██    ██ ██   ██      ██         #
#         ██      ██ ███████    ██    ██   ██  ██████  ██████  ███████         #
func                        _________METHODS_________              ()->void:pass

func set_icon_type( v : String ) -> void:
	icon_type = v
	try_set_icon()


func set_icon_name( v : String ) -> void:
	icon_name = v
	try_set_icon()


func try_set_icon() -> void:
	if icon_texture: return
	var editor_theme := EditorInterface.get_editor_theme()
	if editor_theme.has_icon(icon_name, icon_type):
		icon_texture = editor_theme.get_icon(icon_name, icon_type )


func set_icon_texture( value : Texture2D ) -> void:
	var was_empty : bool = is_instance_valid( icon_texture )
	icon_texture = value

	if is_node_ready():
		if was_empty != is_instance_valid(value):
			rebuild.call_deferred()
		else:
			preliminary_layout()


func set_button_text( value : String ) -> void:
	var was_empty : bool = button_text.is_empty()
	button_text = value

	if is_node_ready():
		if was_empty != value.is_empty():
			rebuild.call_deferred()
		else:
			preliminary_layout()


func rebuild() -> void:
	if not is_inside_tree(): return

	# --- Remove old content ---
	if _inner_cont and _inner_cont.get_parent() == self:
		_inner_cont.queue_free()
	_inner_cont = null
	_icon_rect  = null
	_text_label = null

	# --- Create container ---
	if text_position in [SIDE_LEFT, SIDE_RIGHT]:
		_inner_cont = HBoxContainer.new()
	else:
		_inner_cont = VBoxContainer.new()

	_inner_cont.name = &"LayoutContainer"
	_inner_cont.alignment = BoxContainer.ALIGNMENT_CENTER
	_inner_cont.size_flags_horizontal = SIZE_SHRINK_CENTER
	_inner_cont.size_flags_vertical   = SIZE_SHRINK_CENTER
	add_child(_inner_cont)

	# --- Icon ---
	if icon_texture:
		_icon_rect = TextureRect.new()
		_icon_rect.name = &"Icon"
		_icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		_icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_icon_rect.size_flags_horizontal = SIZE_SHRINK_CENTER
		_icon_rect.size_flags_vertical   = SIZE_SHRINK_CENTER
		_inner_cont.add_child(_icon_rect)

	# --- Label ---
	if not button_text.is_empty():
		_text_label = RichTextLabel.new()
		_text_label.name = &"Label"
		_text_label.fit_content = true
		_text_label.scroll_active = false
		_text_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		_text_label.mouse_filter = MOUSE_FILTER_PASS
		#_text_label.size_flags_horizontal = SIZE_SHRINK_CENTER
		#_text_label.size_flags_vertical   = SIZE_SHRINK_CENTER
		_text_label.add_theme_stylebox_override(_get_current_style(), StyleBoxEmpty.new())
		_inner_cont.add_child(_text_label)

	preliminary_layout()


func preliminary_layout() -> void:

	_inner_cont.add_theme_constant_override(&"separation", separation)
	_inner_cont.reset_size()

	if is_instance_valid(_icon_rect):
		_icon_rect.texture = icon_texture
		var font_size : float = _get_theme_font_size()
		if icon_size != 0:
			_icon_rect.custom_minimum_size = Vector2(icon_size, icon_size)
		else:
			_icon_rect.custom_minimum_size = Vector2(font_size, font_size)

	if is_instance_valid(_text_label):
		_text_label.text = button_text
		_text_label.bbcode_enabled = enable_bbcode
		_text_label.horizontal_alignment = horizontal_alignment
		_text_label.vertical_alignment = vertical_alignment

	# --- Order ---
	if is_instance_valid(_text_label) and is_instance_valid(_icon_rect):
		match text_position:
			SIDE_LEFT,  SIDE_TOP:
				_inner_cont.move_child( _text_label, 0)

			SIDE_RIGHT, SIDE_BOTTOM:
				_inner_cont.move_child( _icon_rect,  0)

	# --- Final layout ---
	update_minimum_size()
	final_layout.call_deferred()


func final_layout() -> void:
	if not _inner_cont or not is_inside_tree(): return

	var style : StyleBox = _get_current_stylebox()

	var available_w : float = size.x - style.content_margin_left - style.content_margin_right
	var available_h : float = size.y - style.content_margin_top - style.content_margin_bottom

	var inner_size : Vector2 = get_minimum_size()

	var x_pos : float = style.content_margin_left + max(0, (available_w - inner_size.x) / 2.0)
	var y_pos : float = style.content_margin_top + max(0, (available_h - inner_size.y) / 2.0)

	var offset := Vector2(1, 1) if _pressed and not disabled else Vector2.ZERO
	_inner_cont.position = Vector2(x_pos, y_pos) + offset

	queue_redraw()
