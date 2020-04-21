--[[----------------------------------------
  Where all the saving and loading happens
----------------------------------------]]--

-- Include the configuration file
include( "medic_npc/sh_config.lua" );

MedicNPC = MedicNPC || {};

--[[------------------------------------------------------
  Serverside function to retrieve all the saved NPC data
------------------------------------------------------]]--

MedicNPC.GetMapSaves = function()
	local _map = game.GetMap();
	local _text_file = "carms_npcs/medic/" .. _map .. ".txt";
	
	-- If any saves for the current map then return the saved NPC data table
	if file.Exists( _text_file, "DATA" ) then
		local _data_tbl = util.JSONToTable( file.Read( _text_file, "DATA" ) );
		return _data_tbl;
	end;
	
	-- If not returned, returned an empty table instead
	return {};
end;

--[[----------------------------------
  Serverside function to save an NPC
----------------------------------]]--

MedicNPC.SaveNPC = function( _npc )
	if !_npc || !_npc:IsValid() || ( _npc:GetClass() != "carms_medic_npc" ) then return; end;
	
	local _map = game.GetMap();
	local _text_file = "carms_npcs/medic/" .. _map .. ".txt";
	
	-- Create data table for NPC
	local _npc_pos = _npc:GetPos();
	local _npc_ang = _npc:GetAngles();
	
	local _npc_data_tbl = {
		Pos = _npc_pos,
		Ang = _npc_ang
	};
	
	-- If save directory doesn't exist, create it
	if !file.Exists( "carms_npcs/medic", "DATA" ) then
		file.CreateDir( "carms_npcs/medic" );
	end;
	
	-- Fetch saves data
	local _data_tbl = MedicNPC.GetMapSaves();
	
	-- The NPC's ID to save it under
	local _id = 1;
	if _npc:GetNWInt( "NPC_ID", 0 ) > 0 then
		-- If already exists, use its current ID to update it
		_id = _npc:GetNWInt( "NPC_ID" );
	elseif ( table.Count( _data_tbl ) > 0 ) then
		-- Else, generate a new auto-increment key like in a database
		_id = math.max( unpack( table.GetKeys( _data_tbl ) ) ) + 1;
	end;
	
	-- Add to data table
	_data_tbl[_id] = _npc_data_tbl;
	
	-- Convert to JSON and write to file
	local _json_table = util.TableToJSON( _data_tbl );
	file.Write( _text_file, _json_table );
	
	-- Remove NPC created by the player
	_npc:Remove();
	
	-- Spawn in new world NPC
	local _world_npc = ents.Create( "carms_medic_npc" );
	_world_npc:SetPos( _npc_pos );
	_world_npc:SetAngles( _npc_ang );
	_world_npc:Spawn();
	_world_npc:SetNWInt( "NPC_ID", _id );
end;

--[[------------------------------------
  Serverside function to remove an NPC
------------------------------------]]--

MedicNPC.RemoveNPC = function( _npc )
	if !_npc || !_npc:IsValid() || ( _npc:GetClass() != "carms_medic_npc" ) then return; end;
	
	local _map = game.GetMap();
	local _text_file = "carms_npcs/medic/" .. _map .. ".txt";
	
	-- Get the ID of the NPC
	local _id = _npc:GetNWInt( "NPC_ID", 0 );
	
	-- Retrieve saves data
	local _data_tbl = MedicNPC.GetMapSaves();
	
	-- Remove NPC from data table
	if _data_tbl[_id] then
		_data_tbl[_id] = nil;
		
		-- Save to file
		local _json_table = util.TableToJSON( _data_tbl );
		file.Write( _text_file, _json_table );
	end;
	
	_npc:Remove();
end;

--[[------------------------------------
  Serverside function to reload an NPC
------------------------------------]]--

MedicNPC.ReloadNPC = function( _npc )
	if !_npc || !_npc:IsValid() || ( _npc:GetClass() != "carms_medic_npc" ) then return; end;
	
	local _map = game.GetMap();
	local _text_file = "carms_npcs/medic/" .. _map .. ".txt";
	
	-- Get the ID of the NPC
	local _id = _npc:GetNWInt( "NPC_ID", 0 );
	
	-- Retrieve saves data
	local _data_tbl = MedicNPC.GetMapSaves();
	
	-- Set the NPC's position and angles to that in the saves data
	if _data_tbl[_id] then
		_npc:SetPos( _data_tbl[_id].Pos );
		_npc:SetAngles( _data_tbl[_id].Ang );
	end;
	
	_npc:DropToFloor();
	_npc:SetModel( MedicNPC.Config.Model );
end;

--[[-------------------------------------------
  Chat command to save NPC you are looking at
-------------------------------------------]]--

hook.Add( "PlayerSay", "MedicNPC.ChatCommand.SaveNPC", function( _ply, _text )
	if ( _text == "!savemedicnpc" ) then
		if !_ply:GetEyeTrace().Entity || !_ply:GetEyeTrace().Entity:IsValid() then return; end;
		
		-- If player isn't superadmin, notify then and return
		if !_ply:IsSuperAdmin() then
			_ply:ChatPrint( MedicNPC.Config.Lang["Must_Be_Superadmin"] );
			return;
		end;
		
		local _hitent = _ply:GetEyeTrace().Entity;
		
		-- If not a medic NPC, then notify and return
		if ( _hitent:GetClass() != "carms_medic_npc" ) then
			_ply:ChatPrint( MedicNPC.Config.Lang["Must_Be_Looking_At_NPC"] );
			return;
		end;
		
		MedicNPC.SaveNPC( _hitent );
		_ply:ChatPrint( MedicNPC.Config.Lang["Successfully_Saved"] );
		
		-- Return an empty string to hide command from chat
		return "";
	end;
end );

--[[---------------------------------------------
  Chat command to remove NPC you are looking at
---------------------------------------------]]--

hook.Add( "PlayerSay", "MedicNPC.ChatCommand.RemoveNPC", function( _ply, _text )
	if ( _text == "!removemedicnpc" ) then
		if !_ply:GetEyeTrace().Entity || !_ply:GetEyeTrace().Entity:IsValid() then return; end;
		
		-- If player isn't superadmin, notify then and return
		if !_ply:IsSuperAdmin() then
			_ply:ChatPrint( MedicNPC.Config.Lang["Must_Be_Superadmin"] );
			return;
		end;
		
		local _hitent = _ply:GetEyeTrace().Entity;
		
		-- If not a medic NPC, then notify and return
		if ( _hitent:GetClass() != "carms_medic_npc" ) then
			_ply:ChatPrint( MedicNPC.Config.Lang["Must_Be_Looking_At_NPC"] );
			return;
		end;
		
		MedicNPC.RemoveNPC( _hitent );
		_ply:ChatPrint( MedicNPC.Config.Lang["Successfully_Removed"] );
		
		-- Return an empty string to hide command from chat
		return "";
	end;
end );

--[[---------------------------------------------
  Chat command to reload NPC you are looking at
---------------------------------------------]]--

hook.Add( "PlayerSay", "MedicNPC.ChatCommand.ReloadNPC", function( _ply, _text )
	if ( _text == "!reloadmedicnpc" ) then
		if !_ply:GetEyeTrace().Entity || !_ply:GetEyeTrace().Entity:IsValid() then return; end;
		
		-- If player isn't admin, notify then and return
		if !_ply:IsAdmin() then
			_ply:ChatPrint( MedicNPC.Config.Lang["Must_Be_Admin"] );
			return;
		end;
		
		local _hitent = _ply:GetEyeTrace().Entity;
		
		-- If not a medic NPC, then notify and return
		if ( _hitent:GetClass() != "carms_medic_npc" ) then
			_ply:ChatPrint( MedicNPC.Config.Lang["Must_Be_Looking_At_NPC"] );
			return;
		end;
		
		MedicNPC.ReloadNPC( _hitent );
		_ply:ChatPrint( MedicNPC.Config.Lang["Successfully_Reloaded"] );
		
		-- Return an empty string to hide command from chat
		return "";
	end;
end );

--[[------------------------------------------------
  Spawn in all the NPCs after entities have loaded
------------------------------------------------]]--

hook.Add( "InitPostEntity", "MedicNPC.LoadNPCS", function()
	-- Get all the saved NPCs for the current map
	local _data_tbl = MedicNPC.GetMapSaves();
	
	-- Iterate through and spawn each
	for _id, _npc_data in pairs( _data_tbl ) do
		local _npc = ents.Create( "carms_medic_npc" );
		_npc:SetPos( _npc_data.Pos );
		_npc:SetAngles( _npc_data.Ang );
		_npc:Spawn();
		_npc:SetNWInt( "NPC_ID", _id );
	end;
end );
