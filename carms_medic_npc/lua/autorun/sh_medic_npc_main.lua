--[[------------------------------
  Main file that loads the addon
------------------------------]]--

-- Make the client download all the clientside files
AddCSLuaFile( "medic_npc/sh_config.lua" );
AddCSLuaFile( "medic_npc/cl_medic_menu.lua" );
AddCSLuaFile( "medic_npc/cl_dnumslider.lua" );

-- Load the shared configuration file
include( "medic_npc/sh_config.lua" );

-- Load the clientside files
if CLIENT then
	include( "medic_npc/cl_medic_menu.lua" );
	include( "medic_npc/cl_dnumslider.lua" );
end;

-- Load the server files
if SERVER then
	include( "medic_npc/sv_purchasing.lua" );
	include( "medic_npc/sv_saving.lua" );
end;
