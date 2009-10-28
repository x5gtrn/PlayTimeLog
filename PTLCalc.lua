-----------------------------------
-- functions of showing log data --
-----------------------------------
function PlayTimeLog_CalculateAndSet (date)
	TodayValue_String:SetText(
		"       " ..	-- as indent
		PlayTimeLog_GetMinutes(PlayTimeLog_GetTime_Today(date)) .. "m")
	L7AValue_String:SetText(
		"       " ..	-- as indent
		PlayTimeLog_GetMinutes(PlayTimeLog_GetTime_7DaysAve()) .. "m")
end

function PlayTimeLog_GetTime_Today (date)
	return PlayTimeLogDB.dailyLog[tostring(date)]
end

function PlayTimeLog_GetTime_7DaysAve ()
	local total = 0
	local count = 0
	for i = #PlayTimeLogDB.dailyLog, 0, -1 do
		if (PlayTimeLogDB.dailyLog[i] == nil) then
			break
		end
		local key = PlayTimeLogDB.dailyLog[i]
		total = total + PlayTimeLogDB.dailyLog[tostring(key)]
		count = count + 1
		if (count >= 7) then
			break
		end
	end
	return floor(total / count)
end
