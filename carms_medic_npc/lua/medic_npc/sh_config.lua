--[[-----------
  Do not edit
-----------]]--

-- Declare the configuration tables
MedicNPC = MedicNPC || {};
MedicNPC.Config = MedicNPC.Config || {};
MedicNPC.Config.Sound = MedicNPC.Config.Sound || {};
MedicNPC.Config.Menu = MedicNPC.Config.Menu || {};
MedicNPC.Config.Lang = MedicNPC.Config.Lang || {};


--[[-------------------------
  Configuration starts here
-------------------------]]--

-- The model to be used by the NPC
MedicNPC.Config.Model = "models/Kleiner.mdl";

-- The default maximum amount of purchasable health and armour
MedicNPC.Config.MaxHealth = 100;
MedicNPC.Config.MaxArmour = 100;

-- The slider increments
MedicNPC.Config.HealthIncrement = 5;
MedicNPC.Config.ArmourIncrement = 5;

-- The cost of health and armour per unit
MedicNPC.Config.HealthCost = 50;
MedicNPC.Config.ArmourCost = 100;

-- NPC sound config, with randomly choose any sound
MedicNPC.Config.Sound.CantAfford = {
	"vo/k_lab/kl_fiddlesticks.wav",
	"vo/k_lab/kl_ohdear.wav"
};

-- Played when player with less than 20 health presents
MedicNPC.Config.Sound.LowHealth = {
	"vo/k_lab/kl_mygoodness01.wav"
};

MedicNPC.Config.Sound.NPCBuySound = {
	"vo/k_lab/kl_excellent.wav",
	"vo/k_lab/kl_diditwork.wav",
	"vo/k_lab/kl_fewmoments01.wav"
};

-- Chance of the above playing when a player buys health or armour
MedicNPC.Config.Sound.NPCBuySoundChance = 0.5;

MedicNPC.Config.Sound.HealthBought = {
	"items/smallmedkit1.wav"
};

MedicNPC.Config.Sound.ArmourBought = {
	"items/battery_pickup.wav"
};

-- The menu theme configuration
MedicNPC.Config.Menu.EnableBlur = true;

MedicNPC.Config.Menu.MainBG = Color( 45, 45, 45, 255 );
MedicNPC.Config.Menu.TitleBG = Color( 20, 20, 20, 120 );
MedicNPC.Config.Menu.MainOutline = Color( 255, 255, 255, 7 );

MedicNPC.Config.Menu.HealthBG = Color( 150, 50, 50, 100 );
MedicNPC.Config.Menu.ArmourBG = Color( 50, 60, 150, 100 );
MedicNPC.Config.Menu.HealthOutline = Color( 0, 0, 0, 120 );
MedicNPC.Config.Menu.ArmourOutline = Color( 0, 0, 0, 120 );
MedicNPC.Config.Menu.HealthSliderBG = Color( 10, 10, 10, 110 );
MedicNPC.Config.Menu.ArmourSliderBG = Color( 10, 10, 10, 110 );
MedicNPC.Config.Menu.HealthNotches = Color( 255, 255, 255, 120 );
MedicNPC.Config.Menu.ArmourNotches = Color( 255, 255, 255, 120 );
MedicNPC.Config.Menu.HealthSliderOutline = Color( 0, 0, 0, 85 );
MedicNPC.Config.Menu.ArmourSliderOutline = Color( 0, 0, 0, 85 );
MedicNPC.Config.Menu.HealthButton = Color( 10, 10, 10, 140 );
MedicNPC.Config.Menu.ArmourButton = Color( 10, 10, 10, 140 );
MedicNPC.Config.Menu.HealthButtonOutline = Color( 0, 0, 0, 60 );
MedicNPC.Config.Menu.ArmourButtonOutline = Color( 0, 0, 0, 60 );
MedicNPC.Config.Menu.TitleColor = Color( 255, 255, 255, 190 );
MedicNPC.Config.Menu.TextColor = Color( 255, 255, 255, 180 );


--[[-----------------------------------------------------------------------
  Donator configuration.
  Here you can add custom checks for the maxium health/armour purchaseable.
  
  If you are using ULX (or similar) use this:
    [AMOUNT] = function( ply )
		local ranks = {
			RANKS HERE
		}
		return table.HasValue( ranks, ply:GetUserGroup() )
	end,
	
	(See below for examples)
  
  If you are using "Custom Donation System" by Bub Hush:
    [AMOUNT] = function( ply )
		local ranks = { DONATOR RANK NUMBERS }
		return table.HasValue( ranks, ply:GetRank() )
	end,
	
	Example:
	[150] = function( ply )
		local ranks = { 1, 2 }
		return table.HasValue( ranks, ply:GetRank() )
	end,
	
	[200] = function( ply )
		local ranks = { 3 }
		return table.HasValue( ranks, ply:GetRank() )
	end,
  
  If you also wanted to make all admins able to purchase it, for instance:
    [150] = function( ply )
		local ranks = { 3 }
		return table.HasValue( ranks, ply:GetRank() ) or ply:IsAdmin()
	end,
  
  As long as you have some coding knowledge, the possibilites are endless;
  the general documentation is:
    [HEALTH] = function( ply )
		return SOME CONDITION
	end,
------------------------------------------------------------------------]]--

-- Maximum health values
MedicNPC.Config.DonatorHealths = {
	[150] = function( ply )
		local ranks = {
			"vip",
		}
		return table.HasValue( ranks, ply:GetUserGroup() )
	end,
	[200] = function( ply )
		local ranks = {
			"elitevip",
		}
		return table.HasValue( ranks, ply:GetUserGroup() ) or ply:IsAdmin()
	end,
}

-- Maximum armour values
MedicNPC.Config.DonatorArmours = {
	[150] = function( ply )
		local ranks = {
			"vip",
		}
		return table.HasValue( ranks, ply:GetUserGroup() )
	end,
	[200] = function( ply )
		local ranks = {
			"elitevip",
		}
		return table.HasValue( ranks, ply:GetUserGroup() ) or ply:IsAdmin()
	end,
}


--[[------------------------------------------
  Language configuration
  Here you can easily translate all the text
------------------------------------------]]--

MedicNPC.Config.Lang["3D2D_Title"] = "Medic NPC";  -- Text above NPC
MedicNPC.Config.Lang["Menu_Title"] = "Medic NPC";  -- Title on the medic menu
MedicNPC.Config.Lang["Health"] = "Health";
MedicNPC.Config.Lang["Armour"] = "Armour";
MedicNPC.Config.Lang["Purchase"] = "Purchase";

MedicNPC.Config.Lang["Bought_Health"] = "You bought %s health for %s!";  -- First %s is amount of health, second is the cost in order; must not remove either %s
MedicNPC.Config.Lang["Bought_Armour"] = "You bought %s armour for %s!";  -- First %s is amount of armour, second is the cost in order; must not remove either %s
MedicNPC.Config.Lang["Cant_Afford"] = "You cannot afford this!";

-- Less important, the notifications for admins when they save/remove/reload an NPC
MedicNPC.Config.Lang["Must_Be_Superadmin"] = "You must be superadmin to do that!";
MedicNPC.Config.Lang["Must_Be_Admin"] = "You must be admin to do that!";
MedicNPC.Config.Lang["Must_Be_Looking_At_NPC"] = "You must be looking at a medic NPC!";

MedicNPC.Config.Lang["Successfully_Saved"] = "NPC successfully saved!";
MedicNPC.Config.Lang["Successfully_Removed"] = "NPC successfully removed!";
MedicNPC.Config.Lang["Successfully_Reloaded"] = "NPC successfully reloaded!";
