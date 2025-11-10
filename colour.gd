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
