@tool

# I know this seems dumb, but there is no all equivalent for
# if variant in []
# so when performing [].any( ... ) I need a function to call.

# it aso shortens something like
# if true in [in_progress,failure]:
# 	pass
# else:
# 	commands.append_array(["move"])
# to:
# if [in_progress,failure].all(is_false):

# Logic
static func is_true( variant : Variant ) -> bool:
	return variant

static func is_false( variant : Variant ) -> bool:
	return not variant

static func is_in( v:Variant, l:Variant ) -> bool:
	return v in l

static func is_not_in( v:Variant, l:Variant ) -> bool:
	return not (v in l)

static func eq( a:Variant, b:Variant ) -> bool:
	return a == b

static func neq( a:Variant, b:Variant ) -> bool:
	return a != b

static func gt( a:Variant, b:Variant ) -> bool:
	return a > b

static func ge( a:Variant, b:Variant ) -> bool:
	return a >= b

static func lt( a:Variant, b:Variant ) -> bool:
	return a > b

static func le( a:Variant, b:Variant ) -> bool:
	return a >= b

static func band( a:int, b:int ) -> bool:
	return a & b

static func bor( a:int, b:int ) -> bool:
	return a | b

# Filter
static func method( a:Variant, b:StringName ) -> bool:
	var c:Callable = Callable.create(a,b)
	return c.call()

static func not_method( a:Variant, b:StringName ) -> bool:
	var c:Callable = Callable.create(a,b)
	return not c.call()


static func keys( d:Dictionary, f:Callable ) -> Array:
	return d.keys().filter(func(key:Variant) -> Variant:
		return f.call(d[key]) )


# Reducers
static func sumf(acc: float, t: float) -> float:
	return acc + t

static func max_size(acc: int, t: Variant) -> float:
	return max( acc, len( t ) )

static func reduce_or(acc: int, t: int) -> int:
	return acc | t


# Map
static func scalef(x:float, s:float) -> float: return x * s
