--[[-----------------------------------------------------------------
  The serverside init.lua file for the medic NPC by [GGS] 92carmnad
-----------------------------------------------------------------]]--

-- Download the clientside and shared files to the client
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

-- Include the shared file
include( "shared.lua" );

-- Include the configuration file
include( "medic_npc/sh_config.lua" );

--[[-----------------------------------
  Function called when NPC is spawned
-----------------------------------]]--

function ENT:Initialize()
	-- Assign the entity's physical properties
	self:SetModel( MedicNPC.Config.Model );
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
	self:SetNPCState( NPC_STATE_SCRIPT );
	self:SetSolid( SOLID_BBOX );
	self:CapabilitiesAdd( bit.bor( CAP_ANIMATEDFACE, CAP_TURN_HEAD ) );
	self:SetUseType( SIMPLE_USE );
	self:DropToFloor();
	self:SetMaxYawSpeed( 90 );
end;

--[[------------------------------
  When use is pressed on the NPC
------------------------------]]--

-- Procedure called when the player presses a key on the NPC
function ENT:AcceptInput( _input, _activator, _caller )
	-- If the input is not equal to use then don't continue (return)
	if ( _input != "Use" ) then return; end;
	
	-- Check that the caller is valid and is a player, plus that they are in range and actually looking at the NPC
	if ( _caller && IsValid( _caller ) && _caller:IsPlayer() && ( _caller:GetPos():Distance( self:GetPos() ) < 200 ) && ( _caller:GetEyeTrace().Entity == self ) ) then
		net.Start( "MedicNPC.OpenMenu" );
			net.WriteEntity( self );
		net.Send( _caller );
		
		if ( _caller:Health() < 20 ) then
			self:EmitSound( table.Random( MedicNPC.Config.Sound.LowHealth ), 75, 100, 1, CHAN_VOICE );
		end;
	end;
end;