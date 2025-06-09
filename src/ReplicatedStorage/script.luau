--Variables
textVariable = "Dragonwolf"
numberVariable = 10

--Prints the values of the variables, use the .. to concatenate values and variables
print("textVariable: " .. textVariable .. " & numberVariable: " .. numberVariable)

-- it is also possible to use string.format() for slightly cleaner code
-- %s is used for strings, %d is used for numbers and %f is used for floats. You can also add a number after the % to specify the number of decimal places. (%.2f for max 2 decimals)
print(string.format("Player %s is level %d", textVariable, numberVariable))

cash = 5000

-- If statement
if cash >= 5000 then
	print("You have enough money to buy the car")
elseif cash >= 2500 then
	print("You have enough money to buy the bike")
else
	print("You do not have enough money to buy a vehicle")
end

-- Switch Case (not a native Lua function)
-- It's required to import the base reusable function from ReplicatedStorage
local switch = require(game.ReplicatedStorage.Functions.SwitchCase)

local fruit = "banana"

switch(fruit) {
	apple = function(val)
		print("Switch-Case: Apples are red or green!")
	end,

	banana = function(val)
		print("Switch-Case: Bananas are yellow!")
	end,

	default = function(val)
		print("Switch-Case: Default: Unknown fruit: " .. val)
	end,
}

-- For loop
-- The loop will run 5 times, the first value is the variable, the second is the number to stop at, the third is the incrementer. Incrementer can be changed to any number and is not required. It will default to 1 if not provided.
for	i = 1,5,1 do
	print("Number " .. i)
	--task.wait(1) -- Waits one second before printing the next number
end

-- Functions
function roastPlayer(name)
	switch(name) {
		Sir_Dragonwolf = function(val)
			print(name .. " is a gigachad")
		end,
		
		Gigachad = function(val)
			print(name .. " is a super gigachad")
		end,
		
		Sigma = function(val)
			print(name .. " is not a gigachad, they are a sigma")
		end,
		
		default = function(val)
			print("roastPlayer Default: " .. name .. " Might not be on the list, sadge")
		end,
	}
end

roastPlayer("Sir_Dragonwolf")
roastPlayer("Sigma")
roastPlayer("sigma")

-- Tables
-- Tables are like dictionaries in Python, or objects / arrays in JavaScript. They are a collection of key-value pairs.
-- To access a value in a table, use the key name. To access a value in a table inside a table, use the key name of the table, then the key name of the value.
-- To access a specific index in a table, use the index number. Lua arrays start at index 1, not 0. For example: print(players[1]) for 100
-- players is a dictionary with the key names being the player names and the values being the player's money
local players = {
	Sir_Dragonwolf = 100,
	Gigachad = 200,
	Sigma = 300
}

-- key is a variable that can be used to represent any key name. value is a variable that can be used to represent any value inside of a dictionary.
-- pairs(players) is used for looping through key-value pairs in dictionary-style tables.
-- The #players length operator only works reliably with array-style tables (with consecutive numeric keys).
for key, value in pairs(players) do
	print("Table players: " .. key .. " has " .. value .. " money")
end
-- print(players.Sir_Dragonwolf .. players.Sir_Dragonwolf)

-- Variables
-- globalVariable is a global variable, it is accessible from anywhere in this script, even if it's not in the same scope
globalVariable = "I am a global variable"
-- localVariable is a local variable, it is not accessible outside of the script or scope
local localVariable = "I am a local variable"

-- Operator Precedence
-- () gets evaluated first, then the rest of the operators
-- 1. ^ (Exponent) - Raises a number to a power of another number
-- 2. not, #, - (Unary) (not reverses a boolean, # counts the length of a string or number of elements in a table, - (negative) makes a variable negative)
-- 3. *, /, % (Multiplicative, Division, Modulo)
-- 4. +, - (Additive, Subtractive)
-- 5. .. (Concatenation)
-- 6. <, <=, >, >=, ==, ~= (Comparison) - ~= is the not equal operator (!= in javascript)
-- 7. and
-- 8. or

-- Data Types
-- nil      - a special value that represents nothing (null in other languages)
-- boolean  - a type that can only have two values: true or false
-- number   - a type that can only have numbers or decimals
-- string   - is text
-- table    - a collection of key-value pairs (arrays or dictionaries in other languages) - { }
-- function - a block of reusable code
-- userdata - stores arbitrary C data - It stores data from external sources like Roblox objects, UI elements, parts, etc.
-- thread   - manages independent sequences of execution (asynchronous stuff, meaning it can run in the background and not block the main program) - coroutine.create(function()) - creates a new coroutine
-- Lua is a dynamically typed language, meaning that variables can change type at runtime (meaning a number can be changed to a string without errors)

type(true) -- returns boolean. Type is used to check the type of a variable

-- Multiline Strings. You can use the [[ ]] syntax to create a multi-line string, the string will keep the indentation
local multiLineString = [[
	This is a multi-line string
	It can span multiple lines
]]

print(multiLineString)

local userdata = Instance.new("Part")
print(type(userdata)) -- userdata

local co = coroutine.create(function()
	print("Coroutine started")
	coroutine.yield("Coroutine yielded")
	print("Coroutine finished")
end)

coroutine.resume(co) -- Starts the coroutine

-- repeat until statement (kinda like a for loop, but different)
local i = 1
repeat
    print("Repeat until:" .. i)
    i = i + 1
until i > 5

for ip,v in ipairs({1,2,3}) do
	print(ip,v)
end

-- Function in a function
function apply(func, x)
	return func(x)
end

local function double(y)
	return y * 2
end

print(apply(double, 10)) -- 20

-- This function returns a function that adds n to its input
function makeAdder(n)
	return function(x)
		return x + n
	end
end

-- add5 is a function that adds 5 to its input
local add5 = makeAdder(5)
print(add5(10)) -- prints 15

-- This function returns the sum of all its arguments
function sum(...)
	local total = 0
	-- _ is a special variable that represents the first argument in a function, v is the second argument, ipairs is a built-in function that returns an iterator over a table, ... is a special variable that represents all the arguments passed to a function
	for _,v in ipairs({...}) do
		total = total + v
	end
	return total
end
print(sum(1,2,3)) -- prints 6

-- This function returns the maximum value of its arguments
function max(...)
	local args = {...}
	local maxValue = args[1]
	for _,v in ipairs({...}) do
		if v > maxValue then
			maxValue = v
		end
	end
	
	return maxValue
end

print(max(3,7,2,8,5)) -- prints 8