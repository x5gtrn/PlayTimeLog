-----------------------------------
-- functions of saving play time --
-----------------------------------
function PlayTimeLog_SavePlayTime (startTime, playTime)
	local t = startTime
	while (PlayTimeLog_GetTruncDay(t, 1) - t < playTime) do
		local addingTime = PlayTimeLog_GetTruncDay(t, 1) - t
		PlayTimeLog_AddPlayTimeToDailyLog(PlayTimeLog_GetTruncDay(t), addingTime)
		playTime = playTime - addingTime
		t = PlayTimeLog_GetNextDay(t, 1)
	end
	PlayTimeLog_AddPlayTimeToDailyLog(PlayTimeLog_GetTruncDay(t), playTime)
	return PlayTimeLog_GetTruncDay(t) -- return last saved time as the key for debug.
end

function PlayTimeLog_AddPlayTimeToDailyLog (date, playTime)
	-- add play time per account.
	if (PlayTimeLogDB.dailyLog[date]) then
		PlayTimeLogDB.dailyLog[date] = PlayTimeLogDB.dailyLog[date] + playTime
	else
		PlayTimeLogDB.dailyLog[date] = playTime
	end
	-- add play time per character.
	if (PlayTimeLogPCDB.dailyLog[date]) then
		PlayTimeLogPCDB.dailyLog[date] = PlayTimeLogPCDB.dailyLog[date] + playTime
	else
		PlayTimeLogPCDB.dailyLog[date] = playTime
	end
end
