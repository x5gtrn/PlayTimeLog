-----------------------------------
-- functions of showing log data --
-----------------------------------
function PlayTimeLog_CalculateAndSet ()
	TodayValue_String:SetText(
		"       " ..	-- as indent
		PlayTimeLog_GetMinutes(PlayTimeLog_GetTime_Toady()) .. "m")
end

function PlayTimeLog_GetTime_Toady ()
	return PlayTimeLogPCDB.dailyLog[tostring(date)]
end
