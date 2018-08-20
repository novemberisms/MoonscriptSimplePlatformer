Entity = require "entity"
Vector = require "brinevector"

class Block extends Entity

	callgroups: {"Draw", "Collision"}
	blocksize: Vector 100, 100

	new: (@gridpos, @gridsize) =>
		@pos = gridpos % @blocksize
		@size = gridsize % @blocksize

		@registerEntity!

	draw: () =>
		love.graphics.rectangle "fill", self.pos.x, self.pos.y, self.size.x, self.size.y

	onCollide: (entity, vel, axis) =>
		switch axis
			when "x"
				if vel.x < 0 then @onCollideWithRight entity
				else @onCollideWithLeft entity

			when "y"
				if vel.y < 0 then @onCollideWithBottom entity
				else @onCollideWithTop entity 

			else
				error "invalid axis"

	onCollideWithRight: (entity) =>
		entity.vel.x = 0
		entity.pos.x = @pos.x + @size.x

	onCollideWithLeft: (entity) =>
		entity.vel.x = 0
		entity.pos.x = @pos.x - entity.size.x

	onCollideWithTop: (entity) =>
		entity.vel.y = 0
		entity.pos.y = @pos.y - entity.size.y
		entity\onLanding!

	onCollideWithBottom: (entity) =>
		entity.vel.y = 0
		entity.pos.y = @pos.y + @size.y
