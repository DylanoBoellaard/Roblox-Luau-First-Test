-- SwitchCase.lua
-- A reusable Lua implementation of a switch-case statement
-- Works similarly to switch statements in JavaScript, C#, etc.
-- Lua doesn't have a native switch-case function

local function switch(value)
	-- Return a function that accepts a table of cases (like a switch block)
	return function(cases)
		-- Try to find a matching case by value, or fall back to default
		local case = cases[value] or cases.default

		if case then
			-- Call the matched function, passing the original value
			return case(value)
		else
			-- Raise an error if no case or default is found
			error(string.format("Unhandled case (%s)", tostring(value)), 2)
		end
	end
end

-- Return the switch function as a module
return switch