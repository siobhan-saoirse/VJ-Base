/*--------------------------------------------------
	=============== VJ Base Autorun ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.

	██    ██      ██     ██████   █████  ███████ ███████
	██    ██      ██     ██   ██ ██   ██ ██      ██
	██    ██      ██     ██████  ███████ ███████ █████
	 ██  ██  ██   ██     ██   ██ ██   ██      ██ ██
	  ████    █████      ██████  ██   ██ ███████ ███████

--------------------------------------------------*/
if CLIENT then print("Loading VJ Base (Client)...") else print("Loading VJ Base (Server)...") end

VJBASE_VERSION = "2.15.3"
VJBASE_GETNAME = "VJ Base"

-- Shared --
AddCSLuaFile("autorun/vj_menu_spawninfo.lua")
AddCSLuaFile("autorun/vj_base_autorun.lua")
AddCSLuaFile("autorun/vj_controls.lua")
AddCSLuaFile("autorun/vj_globals.lua")
AddCSLuaFile("autorun/vj_convars.lua")
AddCSLuaFile("autorun/vj_files.lua")
AddCSLuaFile("autorun/vj_files_language.lua")
AddCSLuaFile("autorun/vj_files_particles.lua")
AddCSLuaFile("autorun/vj_menu_main.lua")
AddCSLuaFile("autorun/vj_menu_properties.lua")

-- Client --
AddCSLuaFile("autorun/client/vj_menu_main_client.lua")
AddCSLuaFile("autorun/client/vj_menu_plugins.lua")
AddCSLuaFile("autorun/client/vj_menu_snpc.lua")
AddCSLuaFile("autorun/client/vj_menu_weapon.lua")

-- Modules --
AddCSLuaFile("includes/modules/ai_vj_schedule.lua")
AddCSLuaFile("includes/modules/ai_vj_task.lua")
//AddCSLuaFile("includes/modules/sound_vj_track.lua")

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Main Hooks / Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("VJWelcome")
	util.AddNetworkString("VJSay")
elseif CLIENT then
	hook.Add("AddToolMenuTabs", "VJ_CREATETOOLTAB", function()
		spawnmenu.AddToolTab("DrVrej", "DrVrej", "vj_base/icons/vrejgaming.png") // "icon16/plugin.png"
		spawnmenu.AddToolCategory("DrVrej", "Main Menu", "#vjbase.menu.tabs.mainmenu")
		spawnmenu.AddToolCategory("DrVrej", "SNPCs", "#vjbase.menu.tabs.settings.snpc")
		spawnmenu.AddToolCategory("DrVrej", "Weapons", "#vjbase.menu.tabs.settings.weapon")
		spawnmenu.AddToolCategory("DrVrej", "HUDs", "#vjbase.menu.tabs.settings.hud")
		spawnmenu.AddToolCategory("DrVrej", "Tools", "#vjbase.menu.tabs.tools")
		spawnmenu.AddToolCategory("DrVrej", "SNPC Configures", "#vjbase.menu.tabs.configures.snpc")
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "VJBaseSpawn", function(ply, transition)
	-- Simple message for the users
	timer.Simple(1, function()
		net.Start("VJWelcome")
		net.Send(ply)
	end)
	
	if !game.SinglePlayer() && ply:SteamID() == "STEAM_0:0:22688298" then
		PrintMessage(HUD_PRINTTALK,"DrVrej Has Joined The Game!")
		PrintMessage(HUD_PRINTCENTER,"DrVrej Has Joined The Game!")
		local sd = CreateSound(game.GetWorld(),"vj_illuminati/Illuminati Confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
		timer.Simple(10, function() if sd then sd:Stop() end end)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("VJSay", function(len, pl)
	if pl:IsPlayer() && pl:SteamID() == "STEAM_0:0:22688298" then
		PrintMessage(HUD_PRINTTALK, "DrVrej is in the server!")
		local sd = CreateSound(game.GetWorld(), "vj_illuminati/Illuminati Confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Outdated GMod Version Check ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER && !isfunction(FindMetaTable("NPC").AutoMovement) then
	timer.Simple(1, function()
		if !VJBASE_GMOD_OUTDATED then
			VJBASE_GMOD_OUTDATED = true
			timer.Create("VJ_WARN_GModOutdated", 2, 0, function()
				PrintMessage(HUD_PRINTTALK, "--- Outdated version of Garry's Mod detected! ---")
				PrintMessage(HUD_PRINTTALK, "Opt out of the Chromium branch!")
			end)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SLV Base Check ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (SLVBase) then
	timer.Simple(1, function()
		if !VJBASE_ERROR_CONFLICT then
			VJBASE_ERROR_CONFLICT = true
			if CLIENT then
				chat.AddText(Color(255,100,0),"Confliction Detected!",
				Color(0,255,0)," VJ Base ",
				Color(255,255,255),"is being overridden by another addon!")
				chat.AddText(Color(0,200,200),"Incompatible Addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")

				local frame = vgui.Create("DFrame")
				frame:SetSize(600, 200)
				frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
				frame:SetTitle("VJ Base Error: Confliction Detected!")
				frame:SetBackgroundBlur(true)
				frame:MakePopup()
	
				local labelTitle = vgui.Create("DLabel", frame)
				labelTitle:SetPos(130, 30)
				labelTitle:SetText("CONFLICTION DETECTED!")
				labelTitle:SetFont("VJFont_Trebuchet24_Large")
				labelTitle:SetTextColor(Color(255,128,128))
				labelTitle:SizeToContents()
				
				local label1 = vgui.Create("DLabel", frame)
				label1:SetPos(70, 70)
				label1:SetText("VJ Base is being overridden by another addon!")
				label1:SetFont("VJFont_Trebuchet24_Medium")
				label1:SizeToContents()
				
				local label2 = vgui.Create("DLabel", frame)
				label2:SetPos(10, 100)
				label2:SetText("You have an addon installed that is overriding something in VJ Base. Uninstall the conflicting addon, and then restart your\n game to fix it. Click the link below to view all known incompatible addons. If you find any addons that are conflicting with\n                    VJ Base, be sure to leave a comment in the collection with a link to the incompatible addon!")
				label2:SizeToContents()
				
				local link = vgui.Create("DLabelURL", frame)
				link:SetSize(300, 20)
				link:SetPos(180, 140)
				link:SetText("Incompatible_addons_(Steam_Workshop_Collection)")
				link:SetURL("http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
				
				local buttonClose = vgui.Create("DButton", frame)
				buttonClose:SetText("CLOSE")
				buttonClose:SetPos(260, 160)
				buttonClose:SetSize(80, 35)
				buttonClose.DoClick = function()
					frame:Close()
				end
			elseif SERVER then
				timer.Create("VJBASE_ERROR_CONFLICT", 5, 0, function()
					print("VJ Base is being overridden by another addon! Incompatible Addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
				end)
			end
		end
	end)
end

if CLIENT then print("VJ Base client files initialized!") else print("VJ Base server files initialized!") end