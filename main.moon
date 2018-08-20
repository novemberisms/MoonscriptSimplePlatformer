Entity = require "entity"
Block = require "block"
Player = require "player"
Vector = require "brinevector"

local player

love.load = ->
	player = Player Vector(150, 150)
	a = Block Vector(-1, 0), Vector(1, 6)
	b = Block Vector(0, 6), Vector(8, 1)
	c = Block Vector(8, 0), Vector(1, 6)
	d = Block Vector(0, 3), Vector(2, 3)

love.update = (dt) ->
	Entity\update dt

love.draw = () ->
	Entity\draw!
