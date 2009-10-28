---------------
-- variables --
---------------
PlayTimeLogDB = {
	dailyLog = {nil},
}
PlayTimeLogPCDB = {
	dailyLog = {nil},
}
local PlayTimeLogDebug = true
local MH = "PlayTimeLog: "
local startSessionTime = nil

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
		startSessionTime = self.startSessionTime
		startSessionTime = time()
	
	elseif (event == "PLAYER_LOGOUT") then
		local playTime = time() - startSessionTime
		PlayTimeLog_SavePlayTime(startSessionTime, playTime)
	end
end

----------------------------------
-- functions of command & debug --
----------------------------------
function PlayTimeLog_SlashCommandHanlder (self, command)
	if (command == "") then
		PlayTimeLog_CalculateAndSet()
		PlayTimeLogFrame:Show()
	
	elseif (command == "resetchara") then
		PlayTimeLogPCDB.dailyLog = {nil}
		DEFAULT_CHAT_FRAME:AddMessage(MH .. "All logs of character are cleared.", 1.0)
	
	elseif (command == "resetall") then
		PlayTimeLogPC.dailyLog = {nil}
		PlayTimeLogPCDB.dailyLog = {nil}
		DEFAULT_CHAT_FRAME:AddMessage(MH .. "All logs are cleared.", 1.0)
	
	elseif (command == "debug") then
		local todayTime = PlayTimeLog_GetTime_Toady()
		PlayTimeLog_ShowDebugMessage(
			"Today =" .. todayTime ..
			"(" .. PlayTimeLog_GetHours(todayTime) * 60
				+ PlayTimeLog_GetMinutes(todayTime) .. "min)")
		PlayTimeLog_ShowDebugMessage(
			"DB.dailyLog size=" .. #PlayTimeLogDB.dailyLog)
		PlayTimeLog_ShowDebugMessage(
			"PCDB.dailyLog size=" .. #PlayTimeLogPCDB.dailyLog)
	
	else
		DEFAULT_CHAT_FRAME:AddMessage(MH .. "Invalid command.")
	end
end

function PlayTimeLog_ShowDebugMessage (debugmsg)
	if PlayTimeLogDebug then
		DEFAULT_CHAT_FRAME:AddMessage("ptlDebug: " .. debugmsg)
	end
end
