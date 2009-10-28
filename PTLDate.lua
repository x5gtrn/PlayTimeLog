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

function PlayTimeLog_GetDay (t)
	if (not t or t < 0) then
		return 0
	end
	return floor(t / 24 / 60 / 60)
end

function PlayTimeLog_GetHour (t)
	if (not t or t < 0) then
		return 0
	end
	t = mod(t, 24 * 60 * 60)
	return floor(t / 60 / 60)
end

function PlayTimeLog_GetHours (t)
	local days = PlayTimeLog_GetDay(t) * 24
	return PlayTimeLog_GetHour(t) + days
end

function PlayTimeLog_GetMinute (t)
	if (not t or t < 0) then
		return 0
	end
	t = mod(t, 24 * 60 * 60)
	t = mod(t, 60 * 60)
	return floor(t / 60)
end

function PlayTimeLog_GetMinutes (t)
	local hours = PlayTimeLog_GetHours(t) * 60
	return PlayTimeLog_GetMinute(t) + hours
end

function PlayTimeLog_GetSecond (t)
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
	
	local days = PlayTimeLog_GetDay(t)
	local hours = PlayTimeLog_GetHour(t)
	local minutes = PlayTimeLog_GetMinute(t)
	local seconds = PlayTimeLog_GetSecond(t)
	
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
