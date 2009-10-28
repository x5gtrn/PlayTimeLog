-----------------------------------
-- functions of saving play time --
-----------------------------------
function PlayTimeLog_SavePlayTime (playTime)
	local t = PlayTimeLog_startSessionTime
	while (PlayTimeLog_GetTruncDay(t, 1) - t < playTime) do
		local addingTime = PlayTimeLog_GetTruncDay(t, 1) - t
		PlayTimeLog_AddPlayTimeToDailyLog(PlayTimeLog_GetTruncDay(t), addingTime)
		playTime = playTime - addingTime
		t = PlayTimeLog_GetTruncDay(t, 1)
	end
	PlayTimeLog_AddPlayTimeToDailyLog(PlayTimeLog_GetTruncDay(t), playTime)
	return PlayTimeLog_GetTruncDay(t) -- return last saved time as the key for debug.
end

function PlayTimeLog_AddPlayTimeToDailyLog (date, playTime)
	local strDate = tostring(date)
	-- add play time per account.
	if (PlayTimeLogDB.dailyLog[strDate]) then
		PlayTimeLogDB.dailyLog[strDate] = PlayTimeLogDB.dailyLog[strDate] + playTime
	else
		PlayTimeLogDB.dailyLog[#PlayTimeLogDB.dailyLog + 1] = date
		PlayTimeLogDB.dailyLog[strDate] = playTime
	end
	-- add play time per character.
	if (PlayTimeLogPCDB.dailyLog[strDate]) then
		PlayTimeLogPCDB.dailyLog[strDate] = PlayTimeLogPCDB.dailyLog[strDate] + playTime
	else
		PlayTimeLogPCDB.dailyLog[#PlayTimeLogPCDB.dailyLog + 1] = date
		PlayTimeLogPCDB.dailyLog[strDate] = playTime
	end
end
