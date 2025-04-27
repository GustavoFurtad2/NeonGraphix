math.randomseed(os.time())

local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)

local RESOLUTION_WIDTH, RESOLUTION_HEIGHT = 320, 248

local render2D = NeonGraphix.render2D
local rendererID = render2D.createRenderer(Vector2.new(RESOLUTION_WIDTH, RESOLUTION_HEIGHT), Vector2.new(0, 0), Vector2.new(1, 1))

render2D.init(rendererID, game.Players.LocalPlayer)

local BLACK, WHITE = Color3.new(0, 0, 0), Color3.new(1, 1, 1)

local UIS = game:GetService("UserInputService")

local player1 = {
	x = 0, y = nil, w = 5, h = 40
}

local player2 = {
	x = nil, y = nil, w = 5, h = 40
}

player1.y = (RESOLUTION_HEIGHT / 2) - player1.h / 2
player2.y = player1.y

player2.x = RESOLUTION_WIDTH - player2.w

local moveSpeed = 1

local ball = {x = nil, y = nil, w = 5, h = 5}

ball.x = (RESOLUTION_WIDTH / 2) - ball.w / 2
ball.y = (RESOLUTION_HEIGHT / 2) - ball.h / 2

ball.directionX = math.random(0, 1) == 1 and 1 or -1
ball.directionY = math.random(0, 1) == 1 and 1 or -1

local function resetBall()

	ball.x = (RESOLUTION_WIDTH / 2) - ball.w / 2
	ball.y = (RESOLUTION_HEIGHT / 2) - ball.h / 2

	ball.directionX = math.random(0, 1) == 1 and 1 or -1
	ball.directionY = math.random(0, 1) == 1 and 1 or -1
end

local function updateBall()


	ball.x += ball.directionX * moveSpeed

	if ball.x < 0 or ball.x > RESOLUTION_WIDTH then

		resetBall()

		return
	end

	ball.y += ball.directionY * moveSpeed

	if ball.y < 0 or ball.y + ball.h > RESOLUTION_HEIGHT then
		ball.directionY = ball.directionY == 1 and -1 or 1
	end

	if ball.x < player1.x + player1.w and ball.x + ball.w > player1.x and ball.y < player1.y + player1.h and ball.y + ball.h > player1.y then

		ball.directionX = 1
		ball.directionY = math.random(0, 1) == 1 and 1 or -1
		moveSpeed += moveSpeed / 10
	elseif ball.x + ball.w > player2.x and ball.x < player2.x + player2.w and ball.y < player2.y + player2.h and ball.y + ball.h > player2.y then

		ball.directionX = -1
		ball.directionY = math.random(0, 1) == 1 and 1 or -1
		moveSpeed += moveSpeed / 10
	end
end


local function drawBall()

	render2D.drawRectangle(rendererID, Vector2.new(ball.x, ball.y), Vector2.new(ball.w, ball.h), Color3.new(1, 1, 1))
end

local function updatePlayers()

	if UIS:IsKeyDown(Enum.KeyCode.W) then

		if player1.y >= 0 then
			player1.y -= moveSpeed
		end

	elseif UIS:IsKeyDown(Enum.KeyCode.S) then

		if player1.y + player1.h <= RESOLUTION_HEIGHT then
			player1.y += moveSpeed
		end
	end

	if UIS:IsKeyDown(Enum.KeyCode.Up) then

		if player2.y >= 0 then
			player2.y -= moveSpeed
		end

	elseif UIS:IsKeyDown(Enum.KeyCode.Down) then

		if player2.y + player2.h <= RESOLUTION_HEIGHT then
			player2.y += moveSpeed
		end
	end
end

local function drawPlayers()

	render2D.drawRectangle(rendererID, Vector2.new(player1.x, player1.y), Vector2.new(player1.w, player1.h), WHITE)
	render2D.drawRectangle(rendererID, Vector2.new(player2.x, player2.y), Vector2.new(player2.w, player2.h), WHITE)
end

game:GetService("RunService").RenderStepped:Connect(function()

	render2D.clear(rendererID, BLACK)

	updatePlayers()
	updateBall()

	drawBall()
	drawPlayers()

	render2D.update(rendererID)
end)