---------------
-- variables --
---------------
PlayTimeLogDB = {
	dailyLog = {nil},
};
PlayTimeLogPCDB = {
	dailyLog = {nil},
};
local PlayTimeLogDebug = true;
local MH = "PlayTimeLog: ";
local startSessionTime = nil;

---------------------------------
-- functions called from frame --
---------------------------------
function PlayTimeLog_OnLoad(self)
	DEFAULT_CHAT_FRAME:AddMessage(MH .. "Loaded.", 1.0);
	
	SLASH_PLAYTIMELOG1 = "/playtimelog";
	SLASH_PLAYTIMELOG2 = "/ptl";
	SlashCmdList["PLAYTIMELOG"] =
		function(msg)
			PlayTimeLog_SlashCommandHanlder(self, msg);
		end
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_LOGOUT");
end

function PlayTimeLog_OnEvent(self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") then
		PlayTimeLogFrame:Hide();
		startSessionTime = self.startSessionTime;
		startSessionTime = time();
	
	elseif (event == "PLAYER_LOGOUT") then
		local playTime = time() - startSessionTime;
		PlayTimeLog_SavePlayTime(startSessionTime, playTime);
	end
end

-----------------------------------
-- functions of saving play time --
-----------------------------------
function PlayTimeLog_SavePlayTime(startTime, playTime)
	local t = startTime;
	while (PlayTimeLog_GetTruncDay(t, 1) - t < playTime) do
		local addingTime = PlayTimeLog_GetTruncDay(t, 1) - t;
		PlayTimeLog_AddPlayTimeToDailyLog(PlayTimeLog_GetTruncDay(t), addingTime);
		playTime = playTime - addingTime;
		t = PlayTimeLog_GetNextDay(t, 1);
	end
	PlayTimeLog_AddPlayTimeToDailyLog(PlayTimeLog_GetTruncDay(t), playTime);
	return PlayTimeLog_GetTruncDay(t); -- return last saved time as the key for debug.
end

function PlayTimeLog_AddPlayTimeToDailyLog(date, playTime)
	-- add play time per account.
	if (PlayTimeLogDB.dailyLog[date]) then
		PlayTimeLogDB.dailyLog[date] = PlayTimeLogDB.dailyLog[date] + playTime;
	else
		PlayTimeLogDB.dailyLog[date] = playTime;
	end
	-- add play time per character.
	if (PlayTimeLogPCDB.dailyLog[date]) then
		PlayTimeLogPCDB.dailyLog[date] = PlayTimeLogPCDB.dailyLog[date] + playTime;
	else
		PlayTimeLogPCDB.dailyLog[date] = playTime;
	end
end

-----------------------------------
-- functions of showing log data --
-----------------------------------
function PlayTimeLog_CalculateAndSet()
	TodayValue_String:SetText(
		"       " ..	-- as indent
		PlayTimeLog_GetMinutes(PlayTimeLog_GetTime_Toady()) .. "m");
end

function PlayTimeLog_GetTime_Toady()
	local playTime = time() - startSessionTime;
	startSessionTime = time();
	local date = PlayTimeLog_SavePlayTime(startSessionTime, playTime);
	return PlayTimeLogPCDB.dailyLog[date];
end

----------------------------------
-- functions of command & debug --
----------------------------------
function PlayTimeLog_SlashCommandHanlder(self, command)
	if (command == "") then
		PlayTimeLog_CalculateAndSet()
		PlayTimeLogFrame:Show();
	
	elseif (command == "resetchara") then
		PlayTimeLogPCDB.dailyLog = {nil};
		DEFAULT_CHAT_FRAME:AddMessage(MH .. "All logs of character are cleared.", 1.0);
	
	elseif (command == "resetall") then
		PlayTimeLogPC.dailyLog = {nil};
		PlayTimeLogPCDB.dailyLog = {nil};
		DEFAULT_CHAT_FRAME:AddMessage(MH .. "All logs are cleared.", 1.0);

	elseif (command == "debug") then
		local todayTime = PlayTimeLog_GetTime_Toady();
		PlayTimeLog_ShowDebugMessage(
			"Today =" .. todayTime ..
			"(" .. PlayTimeLog_GetHours(todayTime) * 60
				+ PlayTimeLog_GetMinutes(todayTime) .. "min)");
	
	else
		DEFAULT_CHAT_FRAME:AddMessage(MH .. "Invalid command.");
	end
end

function PlayTimeLog_ShowDebugMessage(debugmsg)
	if PlayTimeLogDebug then
		DEFAULT_CHAT_FRAME:AddMessage("ptlDebug: " .. debugmsg);
	end
end

-----------------------------------
-- functions of date & time util --
-----------------------------------
function PlayTimeLog_GetTruncDay(t, c)
	if (not c) then
		c = 0;
	end
	return time({
		year = tonumber(date("%Y", t + 86400 * c)),
		month = tonumber(date("%m", t + 86400 * c)),
		day = tonumber(date("%d", t + 86400 * c)),
		hour = 0,
		min = 0,
		sec = 0
	});
end

function PlayTimeLog_GetDays(t)
	if (not t or t < 0) then
		return 0;
	end
	return floor(t / 24 / 60 / 60);
end

function PlayTimeLog_GetHours(t)
	if (not t or t < 0) then
		return 0;
	end
	t = mod(t, 24 * 60 * 60);
	return floor(t / 60 / 60);
end

function PlayTimeLog_GetMinutes(t)
	if (not t or t < 0) then
		return 0;
	end
	t = mod(t, 24 * 60 * 60);
	t = mod(t, 60 * 60);
	return floor(t / 60);
end

function PlayTimeLog_GetSeconds(t)
	if (not t or t < 0) then
		return 0;
	end
	t = mod(t, 24 * 60 * 60);
	t = mod(t, 60 * 60);
	t = mod(t, 60);
	return t;
end

function PlayTimeLog_GetFormatedTimeText(t)
	if (not t or t < 0) then
		return "N/A"
	end
	
	local days = PlayTimeLog_GetDays(t);
	local hours = PlayTimeLog_GetHours(t);
	local minutes = PlayTimeLog_GetMinutes(t);
	local seconds = PlayTimeLog_GetSeconds(t);
	
	local timeText = "";
	if (days ~= 0) then
		timeText = timeText .. format("%d" .. "d" .. " ", days);
	end
	if (days ~= 0 or hours ~= 0) then
		timeText = timeText .. format("%d" .. "h" .. " ", hours);
	end
	if (days ~= 0 or hours ~= 0 or minutes ~= 0) then
		timeText = timeText .. format("%d" .. "m" .. " ", minutes);
	end
	timeText = timeText .. format("%d" .. "s", seconds);
	
	return timeText;
end
