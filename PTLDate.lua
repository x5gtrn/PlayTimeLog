-----------------------------------
-- functions of date & time util --
-----------------------------------
function PlayTimeLog_GetTruncDay (t, c)
	if (not c) then
		c = 0
	end
	return time({
		year = tonumber(date("%Y", t + 86400 * c)),
		month = tonumber(date("%m", t + 86400 * c)),
		day = tonumber(date("%d", t + 86400 * c)),
		hour = 0,
		min = 0,
		sec = 0
	})
end

function PlayTimeLog_GetDays (t)
	if (not t or t < 0) then
		return 0
	end
	return floor(t / 24 / 60 / 60)
end

function PlayTimeLog_GetHours (t)
	if (not t or t < 0) then
		return 0
	end
	t = mod(t, 24 * 60 * 60)
	return floor(t / 60 / 60)
end

function PlayTimeLog_GetMinutes (t)
	if (not t or t < 0) then
		return 0
	end
	t = mod(t, 24 * 60 * 60)
	t = mod(t, 60 * 60)
	return floor(t / 60)
end

function PlayTimeLog_GetSeconds (t)
	if (not t or t < 0) then
		return 0
	end
	t = mod(t, 24 * 60 * 60)
	t = mod(t, 60 * 60)
	t = mod(t, 60)
	return t
end

function PlayTimeLog_GetFormatedTimeText (t)
	if (not t or t < 0) then
		return "N/A"
	end
	
	local days = getDays(t)
	local hours = getHours(t)
	local minutes = getMinutes(t)
	local seconds = getSeconds(t)
	
	local timeText = ""
	if (days ~= 0) then
		timeText = timeText .. format("%d" .. "d" .. " ", days)
	end
	if (days ~= 0 or hours ~= 0) then
		timeText = timeText .. format("%d" .. "h" .. " ", hours)
	end
	if (days ~= 0 or hours ~= 0 or minutes ~= 0) then
		timeText = timeText .. format("%d" .. "m" .. " ", minutes)
	end
	timeText = timeText .. format("%d" .. "s", seconds)
	
	return timeText
end
