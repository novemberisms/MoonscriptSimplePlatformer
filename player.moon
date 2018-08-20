Entity = require "entity"
Vector = require "brinevector"

import graphics from love
import isDown from love.keyboard

class Player extends Entity
	callgroups: {"Update", "Draw", "Collision"}
	size: Vector 50, 50
	color: {255, 0, 0, 255}

	gravity: Vector 0, 1000
	terminal_speed: 4000
	walk_speed: 500

	jump_height: 350
	jump_jetpack_time: 0.2

	new: (@pos) =>
		@size = @size
		@vel = Vector 0, 0
		@acc = Vector 0, 0

		@airborne = false
		@jump_speed = @getJumpSpeed @gravity.y, @jump_jetpack_time, @jump_height
		@jump_fuel = @jump_jetpack_time

		print "Jump range", @getJumpRange(@jump_speed, @walk_speed, @gravity.y, @jump_jetpack_time)

		@registerEntity!

	update: (dt) =>
		@getInput(dt)

		@acc = @gravity
		@vel += (@acc * dt)\trim @terminal_speed

		for _, axis in Vector.axes "yx"
			@pos[axis] += @vel[axis] * dt
			for _, entity in @colliders!
				entity\onCollide @, @vel, axis

	draw: () =>
		graphics.setColor unpack @color
		graphics.rectangle "fill", @pos.x, @pos.y, @size\split!
		graphics.setColor 255, 255, 255, 255

	getInput: (dt) =>
		h_dir = 0
		if isDown "a"
			h_dir -= 1
		if isDown "d"
			h_dir += 1
		if isDown "w"
			@jump(dt)

		@vel.x = h_dir * @walk_speed

	jump: (dt) =>
		@jump_fuel -= dt
		if @jump_fuel <= 0
			@jump_fuel = 0
			return
		else
			@vel.y = @jump_speed

	onLanding: () =>
		@jump_fuel = @jump_jetpack_time
		@airborne = false

	getJumpSpeed: (g, t_j, h) =>
		-- derived by hand. those years in college weren't wasted! (just a bit)
		-- g is the gravity constant
		-- t_j is the jetpack time
		-- h is the desired jump height (must be positive)
		-- returns the yvel for jumping, which should be a negative number

		A = g * t_j
		B = math.sqrt g
		C = math.sqrt (g * t_j * t_j + 2 * h)

		A - B * C

	getJumpRange: (v_y, v_x, g, t_j) =>
		A = math.sqrt v_y * (v_y - 2 * g * t_j)
		B = g * t_j - v_y
		C = v_x / g

		C * (A + B)
