--[[---------------------
  Serverside purchasing
---------------------]]--

-- Include the configuration file
include( "medic_npc/sh_config.lua" );

--[[-------------------
  Add network strings
-------------------]]--
	
util.AddNetworkString( "MedicNPC.OpenMenu" );
util.AddNetworkString( "MedicNPC.PurchaseHealth" );
util.AddNetworkString( "MedicNPC.PurchaseArmour" );

--[[-----------------------
  MedicNPC.PurchaseHealth
-----------------------]]--

-- Procedure called when the NPC clicks the purchase button for health
net.Receive( "MedicNPC.PurchaseHealth", function( _len, _ply )
	-- Assign the health and the cost as variables
	local _health = net.ReadInt( 32 );
	local _added_health = ( _health - _ply:Health() );
	local _cost = _added_health * MedicNPC.Config.HealthCost;
	
	-- Max health purchaseable
	local _max_healths = { MedicNPC.Config.MaxHealth };
	
	-- Check if player is donator
	for _hp, _check in pairs( MedicNPC.Config.DonatorHealths ) do
		if _check( _ply ) then
			table.insert( _max_healths, _hp );
		end;
	end;
	
	-- Get maximum if they have multiple donator packages
	local _max_health = math.max( unpack( _max_healths ) );
	
	-- Check that the player is valid and health is acceptable
	if !( _ply && IsValid( _ply ) &&_ply:Alive()  && ( _health <= _max_health ) && IsValid( _ply:GetEyeTrace().Entity ) && ( _ply:GetEyeTrace().Entity:GetClass() == "carms_medic_npc" ) ) then return; end;
	
	-- The purchasing part
	if _ply:canAfford( _cost ) then
		DarkRP.notify( _ply, 0, 5, string.format( MedicNPC.Config.Lang["Bought_Health"], _added_health, DarkRP.formatMoney( _cost ) ) );
		_ply:addMoney( -_cost );
		_ply:SetHealth( _health );
		
		local _npc = _ply:GetEyeTrace().Entity;
		
		-- Randomly play NPC buy sound
		local _num = math.random( 1, 100 );
		if  ( _num < ( MedicNPC.Config.Sound.NPCBuySoundChance * 100 ) ) then
			_npc:EmitSound( table.Random( MedicNPC.Config.Sound.NPCBuySound ), 75, 100, 1, CHAN_VOICE );
		end;
		
		-- Emit health buy sound
		_ply:EmitSound( table.Random( MedicNPC.Config.Sound.HealthBought ), 75, 100, 1 );
	else
		DarkRP.notify( _ply, 1, 5, MedicNPC.Config.Lang["Cant_Afford"] );
		
		-- Emit random cannot afford sound
		local _npc = _ply:GetEyeTrace().Entity;
		_npc:EmitSound( table.Random( MedicNPC.Config.Sound.CantAfford ), 75, 100, 1, CHAN_VOICE );
	end;
end );

--[[-----------------------
  MedicNPC.PurchaseArmour
-----------------------]]--

-- Procedure called when the NPC clicks the purchase button for armour
net.Receive( "MedicNPC.PurchaseArmour", function( _len, _ply )
	-- Assign the armour and the cost as variables
	local _armour = net.ReadInt( 32 );
	local _added_armour = ( _armour - _ply:Armor() );
	local _cost = _added_armour * MedicNPC.Config.ArmourCost;
	
	-- Max armour purchaseable
	local _max_armours = { MedicNPC.Config.MaxArmour };
	
	-- Check if player is donator
	for _armour, _check in pairs( MedicNPC.Config.DonatorArmours ) do
		if _check( _ply ) then
			table.insert( _max_armours, _armour );
		end;
	end;
	
	-- Get maximum if they have multiple donator packages
	local _max_armour = math.max( unpack( _max_armours ) );
	
	-- Check that the player is valid and armour is acceptable
	if !( _ply && IsValid( _ply ) &&_ply:Alive()  && ( _armour <= _max_armour ) && IsValid( _ply:GetEyeTrace().Entity ) && ( _ply:GetEyeTrace().Entity:GetClass() == "carms_medic_npc" ) ) then return; end;
	
	-- The purchasing part
	if _ply:canAfford( _cost ) then
		DarkRP.notify( _ply, 0, 5, string.format( MedicNPC.Config.Lang["Bought_Armour"], _added_armour, DarkRP.formatMoney( _cost ) ) );
		_ply:addMoney( -_cost );
		_ply:SetArmor( _armour );
		
		local _npc = _ply:GetEyeTrace().Entity;
		
		-- Randomly play NPC buy sound
		local _num = math.random( 1, 100 );
		if  ( _num < ( MedicNPC.Config.Sound.NPCBuySoundChance * 100 ) ) then
			_npc:EmitSound( table.Random( MedicNPC.Config.Sound.NPCBuySound ), 75, 100, 1, CHAN_VOICE );
		end;
		
		-- Emit armour buy sound
		_ply:EmitSound( table.Random( MedicNPC.Config.Sound.ArmourBought ), 75, 100, 1 );
	else
		DarkRP.notify( _ply, 1, 5, "You cannot afford this!" );
		
		-- Emit random cannot afford sound
		local _npc = _ply:GetEyeTrace().Entity;
		_npc:EmitSound( table.Random( MedicNPC.Config.Sound.CantAfford ), 75, 100, 1, CHAN_VOICE );
	end;
end );
