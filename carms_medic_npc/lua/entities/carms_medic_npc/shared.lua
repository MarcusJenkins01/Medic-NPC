--[[---------------------------------------------------------------
  The shared shared.lua file for the medic NPC by [GGS] 92carmnad
---------------------------------------------------------------]]--

-- Include the configuration file
include( "medic_npc/sh_config.lua" );

-- Assign the entity base and its type
ENT.Base = "base_ai";
ENT.Type = "ai";

-- Assign the entity information
ENT.PrintName = "Medic NPC";
ENT.Category = "Carm's Entities";

-- Allow it to be spawned through the Q menu
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Author = "[GGS] 92carmnad";

-- Set the entity up to animate itself
ENT.AutomaticFrameAdvance = true;
