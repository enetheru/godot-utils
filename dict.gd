@tool

# This constructor type really bugs me, I'm thinking of creating my own much simpler one to use
# I fully expect failures from this class when using it.
# I want the failures to be immediate.
static func new_from_dict( o:Object, d:Dictionary ) -> Object:
	for key : StringName in d.keys():
		o.set(key, d[key] )
	return o

# Turns out the above is a dumb name, because the new part is irrelevant, I can assign
# the values from the dict to any object, not just new ones.
static func assign( o:Object, d:Dictionary ) -> Object:
	for key : StringName in d.keys():
		o.set(key, d[key] )
	return o


# The inverse of that is to get a dictionary of specific options, which I can just provide.
static func populate_dict( d:Dictionary, o:Object ) -> void:
	for key : StringName in d.keys():
		d[key] = o.get( key )


# I dont like the name of the above.
static func extract( d:Dictionary, o:Object ) -> void:
	for key : StringName in d.keys():
		d[key] = o.get( key )
