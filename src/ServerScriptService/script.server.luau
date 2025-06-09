print("Hello world, from server!")

-- Excercise 1: Replace all vowels in a string with *
local hello = "hello"

function replaceVowels(str)
	-- string.gsub(str, pattern, replacement). The pattern is a string that matches the characters you want to replace, the replacement is the string that will replace the matched characters
	local newStr = string.gsub(str, "[aeiou]", "*")
	return newStr
end

print(replaceVowels(hello)) -- prints h*ll*
print(replaceVowels("A simple example string")) -- prints * s*mpl* *x*mpl* str*ng

-- Excercise 2: Count the number of words in a string, then print the total
local text = "This is a simple example string"

function countWords(str)
	-- Splits the string into an array of words, splits using the space character
	local words = string.split(str, " ")
	-- #words is the length operator, it returns the number of elements in a table
	return #words
end

print(countWords(text)) -- Prints 6
print(countWords("This is a test")) -- Prints 4

-- Roblox specific things
-- Creates a new part and adds it to the workspace
local part = Instance.new("Part", workspace)

part.BrickColor = BrickColor.new("Bright red")
part.Size = Vector3.new(5, 5, 5)
part.Position = Vector3.new(0, 10, 10)

-- Check if a player joined the game
game.Players.PlayerAdded:Connect(function(player)
	print("Player " .. player.Name .. " joined the game")
end)

-- TweenService -- Can be used to create animations
local TweenService = game:GetService("TweenService")

local part2 = Instance.new("Part", workspace)
local tween = TweenService:Create(part2, TweenInfo.new(1), {Size = Vector3.new(5, 5, 5)})
tween:Play()

-- Touched events
local part3 = Instance.new("Part", workspace)
part3.Position = Vector3.new(0, 10, 15)
part3.BrickColor = BrickColor.new("Bright yellow")

-- Prints what body part touched the part
part3.Touched:Connect(function(hit)
	print(hit.name)
end)

-- Tools
-- StarterPack is
local tool = Instance.new("Tool", game.StarterPack)
tool.Name = "My Tool"

-- Random stuff
-- randomseed(seed) - Sets the seed for the random number generator. The number generator will always display the same sequence of numbers when given the same seed
math.randomseed(2)
print("Randomizer: " .. math.random(1, 10)) -- prints a random number between 1 and 10