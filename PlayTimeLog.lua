---------------
-- variables --
---------------
PlayTimeLogDB = {
	dailyLog = {nil},
}
PlayTimeLogPCDB = {
	dailyLog = {nil},
}
PlayTimeLog_startSessionTime = nil
local PlayTimeLogDebug = true
local MH = "PlayTimeLog: "

---------------------------------
-- functions called from frame --
---------------------------------
function PlayTimeLog_OnLoad (self)
	DEFAULT_CHAT_FRAME:AddMessage(MH .. "Loaded.", 1.0)
	
	SLASH_PLAYTIMELOG1 = "/playtimelog"
	SLASH_PLAYTIMELOG2 = "/ptl"
	SlashCmdList["PLAYTIMELOG"] =
		function(msg)
			PlayTimeLog_SlashCommandHanlder(self, msg)
		end
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LOGOUT")
end

function PlayTimeLog_OnEvent (self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") then
		PlayTimeLogFrame:Hide()
		PlayTimeLog_startSessionTime = self.startSessionTime
		PlayTimeLog_startSessionTime = time()
	
	elseif (event == "PLAYER_LOGOUT") then
		local playTime = time() - PlayTimeLog_startSessionTime
		PlayTimeLog_SavePlayTime(playTime)
	end
end

----------------------------------
-- functions of command & debug --
----------------------------------
function PlayTimeLog_SlashCommandHanlder (self, command)
	if (command == "" or command == "show") then
		local playTime = time() - PlayTimeLog_startSessionTime
		PlayTimeLog_startSessionTime = time()
		local date = PlayTimeLog_SavePlayTime(playTime)
		
		PlayTimeLog_CalculateAndSet(date)
		PlayTimeLogFrame:Show()
	
	elseif (command == "resetchara") then
		PlayTimeLogPCDB.dailyLog = {nil}
		DEFAULT_CHAT_FRAME:AddMessage(MH .. "All logs of character are cleared.", 1.0)
	
	elseif (command == "resetall") then
		PlayTimeLogPC.dailyLog = {nil}
		PlayTimeLogPCDB.dailyLog = {nil}
		DEFAULT_CHAT_FRAME:AddMessage(MH .. "All logs are cleared.", 1.0)
	
	elseif (command == "debug") then
		if PlayTimeLogDebug then
			local playTime = time() - PlayTimeLog_startSessionTime
			PlayTimeLog_startSessionTime = time()
			local today = PlayTimeLog_SavePlayTime(playTime)
			
			PlayTimeLog_ShowDebugMessage(
				"Today =" .. today ..
				"(" .. PlayTimeLog_GetMinutes(PlayTimeLogDB.dailyLog[tostring(today)]) .. "min)")
			PlayTimeLog_ShowDebugMessage(
				"DB.dailyLog size=" .. #PlayTimeLogDB.dailyLog)
			PlayTimeLog_ShowDebugMessage(
				"PCDB.dailyLog size=" .. #PlayTimeLogPCDB.dailyLog)
		end
	
	else
		DEFAULT_CHAT_FRAME:AddMessage(MH .. "Invalid command.")
	end
end

function PlayTimeLog_ShowDebugMessage (debugmsg)
	if PlayTimeLogDebug then
		DEFAULT_CHAT_FRAME:AddMessage("ptlDebug: " .. debugmsg)
	end
end
