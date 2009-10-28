-----------------------------------
-- functions of showing log data --
-----------------------------------
function PlayTimeLog_CalculateAndSet ()
	TodayValue_String:SetText(
		"       " ..	-- as indent
		PlayTimeLog_GetMinutes(PlayTimeLog_GetTime_Toady()) .. "m")
end

function PlayTimeLog_GetTime_Toady ()
	local playTime = time() - startSessionTime
	startSessionTime = time()
	local date = PlayTimeLog_SavePlayTime(startSessionTime, playTime)
	return PlayTimeLogPCDB.dailyLog[tostring(date)]
end
