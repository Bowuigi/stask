-- Library for the st (simple task) format
-- zlib License
--
-- (C) 2021 Bowuigi
--
-- This software is provided 'as-is', without any express or implied
-- warranty.  In no event will the authors be held liable for any damages
-- arising from the use of this software.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:
--
-- 1. The origin of this software must not be misrepresented; you must not
--    claim that you wrote the original software. If you use this software
--    in a product, an acknowledgment in the product documentation would be
--    appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be
--    misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.


-- @module st Simple task format reader and writer
local st = {}

-- @function st.switch Improved switch statement, much more efficient than if..elseif..else..end
-- @param string expr Expression to evaluate
-- @param table cases Table in the form of `{case = return_value}`
-- @return any If the return value is a function, the function is executed and its result is returned, otherwise, it will return the corresponding return value or the default value
function st.switch(expr, cases)
	-- Get the corresponding return value or the default case
	local case = cases[expr] or cases["default"]

	-- If it is a function, execute it and return its result. Otherwise, just reurn the value
	if (type(case) == "function") then
		return case()
	else
		return case
	end
end

-- @function st.read Read from `filename`, parse it and return the tasks found. If `filename` doesn't exist, nil is returned
-- @param string filename Path (relative or absolute) of the file to read
-- @return table|nil Task list on success, nil on failure
function st.read(filename)
	-- Open the file and return nil on failure
	local f = io.open(filename)
	if not f then return nil end

	local tasks = {}

	-- Parsing
	for line in f:lines() do
		-- Skip empty lines
		if (line == "") then
			goto continue
		end

		local task = ""
		local firstThree = line:sub(1,3)
		local isTask = not (firstThree:sub(1,1) == '\t' or firstThree:sub(1,1) == ' ')

		if (isTask) then
			local status = ""

			-- c = completed
			-- p = in progress
			-- n = not completed
			-- w = wait
			status = st.switch(firstThree, {
				["[x]"] = "c";
				["[-]"] = "p";
				["[w]"] = "w";
				["[_]"] = "n";
				["[ ]"] = "n";
				default = "n";
			})

			task = line:sub(5)
			-- Add the task to the task list
			tasks[#tasks+1] = {task=task, status=status, data={}}
		else
			-- Modify the latest task stored
			local key, value
			-- Matches key : "value" // key = "value"
			key, value = line:match("%s+(%S+)%s*[:=]%s*\"(.*)\"")
			if (key) then
				-- Set the task data as required
				tasks[#tasks].data[key] = value
			end
		end
		::continue::
	end

	f:close()
	return tasks
end

-- @function st.write a task list to a file
-- @param table tasks Task list to write
-- @param string filename Filename to write to
function st.write(tasks, filename)
	local content = ""
	for _, t in ipairs(tasks) do
		-- Task status
		content = content .. st.switch(t.status, {
			c = "[x] ";
			p = "[-] ";
			w = "[w] ";
			n = "[ ] ";
			default = "[?] ";
		})

		-- Task name
		content = content .. t.task

		if (t.data) then content = content.."\n" end

		-- Task data
		for k,v in pairs(t.data) do
			content = content.."\t".. k.." : \""..v .."\"\n"
		end

		content = content .. "\n"
	end

	-- Write to the file
	f = io.open(filename, "w")
	f:write(content)
	f:close()
end

return st
