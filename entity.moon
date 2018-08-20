Vector = require "brinevector"

class Entity

	-- these class variables are invisible to instances
	@Entities: {}
	@UpdateEntities: {}
	@DrawEntities:{}
	@CollisionEntities: {}

	callgroups: {}
	pos: Vector!
	size: Vector!

	registerEntity: () =>
		table.insert @@Entities, @
		@addToCallgroups!

	addToCallgroups: () =>
		for group_name in *@callgroups
			group = group_name .. "Entities"
			table.insert @@[group], @

	-- overrides

	override_err: (fn_name) => error "(#{@@__name}) need to override #{fn_name} function"

	new: => @override_err "new"
	update: => @override_err "update"
	draw: => @override_err "draw"
	onCollide: (entity, vel, axis) => @override_err "onCollide"

	-- iterators

	-- local function
	itercollider = (e, curr) ->
		collision_entities = @CollisionEntities
		for i = curr + 1, #collision_entities
			if @isColliding e, collision_entities[i]
				return i, collision_entities[i]

	-- usage: for _, col in @colliders!
	colliders: () =>
		-- return the iterator function, the invariant state, and the start condition
		return itercollider, @, 0

	-- static
	-- these methods are invisible to instances, and so can share the same names as methods in them!

	@update: (dt) => entity\update dt for entity in *@UpdateEntities

	@draw: () => entity\draw! for entity in *@DrawEntities

	@getColliding: (entity) =>
		[collider for collider in *@CollisionEntities when @isColliding collider, entity]

	@isColliding: (a, b) =>
		-- a_tl is a top left, which is equal to a.pos
		-- a_br is a bottom right
		if a == b then return false
		a_br = a.pos + a.size
		b_br = b.pos + b.size
		if a.pos.x >= b_br.x then return false
		if a.pos.y >= b_br.y then return false
		if a_br.x <= b.pos.x then return false
		if a_br.y <= b.pos.y then return false
		true