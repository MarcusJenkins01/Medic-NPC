-- Include the configuration file
include( "medic_npc/sh_config.lua" );

--[[-------------
  Font creation
-------------]]--

local _font_sizes = { 128, 24, 18, 16, 14 };

-- Automatically create fonts of all required sizes
for _, _fontsize in pairs( _font_sizes ) do
	surface.CreateFont( "Carm.MedicNPC." .. _fontsize, {
		font = "Roboto",
		size = _fontsize,
		antialias = true
	} );
end;

-- Fetch and assign the blur material to a variable
local _blur = Material( "pp/blurscreen" );

-- The procedure to draw the blur material for the panel
local function DrawBlur( _panel, _amount )
	-- Declare and assign the position and size values
	local _x, _y = _panel:LocalToScreen( 0, 0 );
	local _w, _h = ScrW(), ScrH();
	
	-- Set the blur material to render
	surface.SetDrawColor( 255, 255, 255, 255 );
	surface.SetMaterial( _blur );
	
	-- Iterate 6 times to layer the blur up
	for i = 1, 6 do
		-- Apply the variable density
		_blur:SetFloat( "$blur", ( i / 3 ) * ( _amount || 6 ) );
		_blur:Recompute();
		render.UpdateScreenEffectTexture();

		-- Draw the blur material
		surface.DrawTexturedRect( -_x, -_y, _w, _h );
	end;
end;

-- Fetch and assign the gradient material to a variable
local _gradient_down = Material( "vgui/gradient_down" );

-- The procedure to draw a gradient highlight when hovered
local function DrawHover( _x, _y, _w, _h, _alpha )
	-- Set the gradient material to render
	surface.SetDrawColor( 255, 255, 255, _alpha );
	surface.SetMaterial( _gradient_down );
	
	-- Draw the gradient material
	surface.DrawTexturedRect( _x, _y, _w, _h );
end;

-- Fetch and assign the gradient material to a variable
local _gradient_up = Material( "vgui/gradient_up" );

-- The procedure to draw the depressed gradient highlight when clicked
local function DrawClicked( _x, _y, _w, _h, _alpha )
	-- Set the gradient material to render
	surface.SetDrawColor( 255, 255, 255, _alpha );
	surface.SetMaterial( _gradient_up );
	
	-- Draw the gradient material
	surface.DrawTexturedRect( _x, _y, _w, _h );
end;

--[[--------------
  The main menu
--------------]]--

local function DrawMedicMenu()
	--[[--------------
	  The main panel
	--------------]]--
	
	local _medicmenu_main = vgui.Create( "DFrame" );
	_medicmenu_main:SetSize( 450, 270 );
	_medicmenu_main:Center();
	_medicmenu_main:SetTitle( "" );
	_medicmenu_main:MakePopup();
	--_medicmenu_main:ShowCloseButton( false );
	_medicmenu_main.Paint = function( _self, _w, _h )
		-- Main frame paint
		if MedicNPC.Config.Menu.EnableBlur then
			DrawBlur( _self, 2 );
			MedicNPC.Config.Menu.MainBG = Color( 20, 20, 20, 160 );
		end;
		
		surface.SetDrawColor( MedicNPC.Config.Menu.MainOutline );
		surface.DrawOutlinedRect( 0, 0, _w, _h );
		draw.RoundedBox( 0, 0, 0, _w, _h, MedicNPC.Config.Menu.MainBG );
		
		-- Title and title box paint
		surface.SetDrawColor( MedicNPC.Config.Menu.MainOutline );
		surface.DrawOutlinedRect( 2, 2, _w - 4, 38 );
		draw.RoundedBox( 0, 2, 2, _w - 4, 38, MedicNPC.Config.Menu.TitleBG );
		draw.SimpleText( MedicNPC.Config.Lang["Menu_Title"], "Carm.MedicNPC.24", _w / 2, 21, MedicNPC.Config.Menu.TitleColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
	end;

	-- Close the menu when anything becomes invalid or player dies
	_medicmenu_main.Think = function()
		if ( !LocalPlayer() || !IsValid( LocalPlayer() ) || !LocalPlayer():Alive() ) then
			_medicmenu_main:Remove();
		end;
	end;

	--[[------------------
	  The health section
	------------------]]--
	
	-- Max health purchaseable
	local _max_healths = { MedicNPC.Config.MaxHealth };
	
	-- Check if player is donator
	for _health, _check in pairs( MedicNPC.Config.DonatorHealths ) do
		if _check( LocalPlayer() ) then
			table.insert( _max_healths, _health );
		end;
	end;
	
	-- Get maximum if they have multiple donator packages
	local _max_health = math.max( unpack( _max_healths ) );
	
	-- The health frame
	local _medicmenu_health = vgui.Create( "DFrame", _medicmenu_main );
	_medicmenu_health:SetSize( _medicmenu_main:GetWide() - 20, 100 );
	_medicmenu_health:SetPos( 10, 50 );
	_medicmenu_health:SetTitle( "" );
	_medicmenu_health:ShowCloseButton( false );
	_medicmenu_health:SetDraggable( false );
	_medicmenu_health.HealthSelected = _min_health;
	_medicmenu_health.Paint = function( _self, _w, _h )
		-- Draw blur if enabled
		if MedicNPC.Config.Menu.EnableBlur then
			DrawBlur( _self, 2 );
		end;
		
		-- Draw the background
		surface.SetDrawColor( MedicNPC.Config.Menu.HealthOutline );
		surface.DrawOutlinedRect( 0, 0, _w, _h );
		draw.RoundedBox( 0, 0, 0, _w, _h, MedicNPC.Config.Menu.HealthBG );

		-- Header
		draw.SimpleText( MedicNPC.Config.Lang["Health"] .. ": " .. LocalPlayer():Health() .. " ⇒ " .. _medicmenu_health.HealthSelected, "Carm.MedicNPC.18", 12, 11, MedicNPC.Config.Menu.TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
	end;
	
	-- The health slider
	local _medicmenu_health_slider = vgui.Create( "Carm.DNumSlider", _medicmenu_health );
	_medicmenu_health_slider:SetText( "" );
	_medicmenu_health_slider:SetPos( -296, 36 );
	_medicmenu_health_slider:SetSize( 735, 20 );
	_medicmenu_health_slider:SetMax( _max_health );
	_medicmenu_health_slider:SetValue( 0 );
	_medicmenu_health_slider:SetDecimals( 0 );
	
	-- Custom derma functions
	_medicmenu_health_slider:SetIncrement( MedicNPC.Config.HealthIncrement );
	_medicmenu_health_slider:SetTextColor( MedicNPC.Config.Menu.TextColor );
	_medicmenu_health_slider:SetFont( "Carm.MedicNPC.14" );
	_medicmenu_health_slider.Slider:SetColor( MedicNPC.Config.Menu.HealthSliderBG );
	_medicmenu_health_slider.Slider:SetOutlineColor( MedicNPC.Config.Menu.HealthSliderOutline );
	_medicmenu_health_slider.Slider:SetNotchColor( MedicNPC.Config.Menu.HealthNotches );
	
	-- Refresh the current health value if changed
	_medicmenu_health_slider.Think = function( self )
		-- Round up health to closest increment
		local _min_health = math.Round( math.ceil( LocalPlayer():Health() / MedicNPC.Config.HealthIncrement ) ) * MedicNPC.Config.HealthIncrement;
		
		-- If the player's health changes, update the minimum
		if ( _min_health != self:GetMin() ) then
			self:SetMin( _min_health );
			
			if ( self:GetValue() < self:GetMin() ) then
				self:SetValue( self:GetMin() );
			end;
		end;
		
		-- Ensure slider corresponds to selected value
		if ( self.Slider:GetSlideX() != self.Scratch:GetFraction( self:GetValue() ) ) then
			self.Slider:SetSlideX( self.Scratch:GetFraction( self:GetValue() ) );
		end;
		
		-- Keep the value saved on the frame consistent with the slider value
		if ( _medicmenu_health.HealthSelected != math.Round( self:GetValue() ) ) then
			_medicmenu_health.HealthSelected = math.Round( self:GetValue() );
		end;
	end;
	
	-- The button to purchase the health
	local _medicmenu_health_button = vgui.Create( "DButton", _medicmenu_health );
	_medicmenu_health_button:SetPos( 11, 64 );
	_medicmenu_health_button:SetSize( 130, 22 );
	_medicmenu_health_button:SetText( "" );
	_medicmenu_health_button.Depressed = false;
	_medicmenu_health_button.OnDepressed = function( _self )
		_medicmenu_health_button.Depressed = true;
	end;
	_medicmenu_health_button.OnReleased = function( _self )
		_medicmenu_health_button.Depressed = false;
	end;
	_medicmenu_health_button.Paint = function( _self, _w, _h )
		-- Main button
		draw.RoundedBox( 0, 0, 0, _w, _h, MedicNPC.Config.Menu.HealthButton );
		surface.SetDrawColor( MedicNPC.Config.Menu.HealthButtonOutline );
		surface.DrawOutlinedRect( 0, 0, _w, _h );
		
		-- Purchase text
		local _cost = math.Round( MedicNPC.Config.HealthCost * ( _medicmenu_health.HealthSelected - LocalPlayer():Health() ) );
		draw.SimpleText( MedicNPC.Config.Lang["Purchase"] .. ": " .. DarkRP.formatMoney( _cost ) .. Either( ( string.len( tostring( _cost ) ) < 5 ), string.sub( ".00000", 1, 6 - string.len( tostring( _cost ) ) ), "" ), "Carm.MedicNPC.16", 6, 3, MedicNPC.Config.Menu.TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
		
		-- Draw highlights for hover and click
		if ( _self:IsHovered() && !_self.Depressed ) then
			DrawHover( 0, 0, _w, _h, 5 );
		elseif _self.Depressed then
			DrawClicked( 0, 0, _w, _h, 5 );
		end;
	end;
	_medicmenu_health_button.DoClick = function()
		if ( ( _medicmenu_health.HealthSelected - LocalPlayer():Health() ) > 0 ) then
			net.Start( "MedicNPC.PurchaseHealth" );
				net.WriteInt( _medicmenu_health.HealthSelected, 32 );
			net.SendToServer();
		end;
	end;
	
	--[[------------------
	  The armour section
	------------------]]--
	
	-- Max armour purchaseable
	local _max_armours = { MedicNPC.Config.MaxArmour };
	
	-- Check if player is donator
	for _armour, _check in pairs( MedicNPC.Config.DonatorArmours ) do
		if _check( LocalPlayer() ) then
			table.insert( _max_armours, _armour );
		end;
	end;
	
	-- Get maximum if they have multiple donator packages
	local _max_armour = math.max( unpack( _max_armours ) );
	
	-- The armour frame
	local _medicmenu_armour = vgui.Create( "DFrame", _medicmenu_main );
	_medicmenu_armour:SetSize( _medicmenu_main:GetWide() - 20, 100 );
	_medicmenu_armour:SetPos( 10, 160 );
	_medicmenu_armour:SetTitle( "" );
	_medicmenu_armour:ShowCloseButton( false );
	_medicmenu_armour:SetDraggable( false );
	_medicmenu_armour.ArmourSelected = _min_armour;
	_medicmenu_armour.Paint = function( _self, _w, _h )
		-- Draw blur if enabled
		if MedicNPC.Config.Menu.EnableBlur then
			DrawBlur( _self, 2 );
		end;
		
		-- Draw the background
		surface.SetDrawColor( MedicNPC.Config.Menu.ArmourOutline );
		surface.DrawOutlinedRect( 0, 0, _w, _h );
		draw.RoundedBox( 0, 0, 0, _w, _h, MedicNPC.Config.Menu.ArmourBG );

		-- Header
		draw.SimpleText( MedicNPC.Config.Lang["Armour"] .. ": " .. LocalPlayer():Armor() .. " ⇒ " .. _medicmenu_armour.ArmourSelected, "Carm.MedicNPC.18", 12, 11, MedicNPC.Config.Menu.TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
	end;
	
	-- The armour slider
	_medicmenu_armour_slider = vgui.Create( "Carm.DNumSlider", _medicmenu_armour );
	_medicmenu_armour_slider:SetText( "" );
	_medicmenu_armour_slider:SetPos( -296, 36 );
	_medicmenu_armour_slider:SetSize( 735, 20 );
	_medicmenu_armour_slider:SetMax( _max_armour );
	_medicmenu_armour_slider:SetValue( 0 );
	_medicmenu_armour_slider:SetDecimals( 0 );
	
	-- Custom derma functions
	_medicmenu_armour_slider:SetIncrement( MedicNPC.Config.ArmourIncrement );
	_medicmenu_armour_slider:SetTextColor( MedicNPC.Config.Menu.TextColor );
	_medicmenu_armour_slider:SetFont( "Carm.MedicNPC.14" );
	_medicmenu_armour_slider.Slider:SetColor( MedicNPC.Config.Menu.ArmourSliderBG );
	_medicmenu_armour_slider.Slider:SetOutlineColor( MedicNPC.Config.Menu.ArmourSliderOutline );
	_medicmenu_armour_slider.Slider:SetNotchColor( MedicNPC.Config.Menu.ArmourNotches );
	
	-- Refresh the current armour value if changed	
	_medicmenu_armour_slider.Think = function( self )
		-- Round up armour to closest increment
		local _min_armour = math.Round( math.ceil( LocalPlayer():Armor() / MedicNPC.Config.ArmourIncrement ) ) * MedicNPC.Config.ArmourIncrement;
		
		-- If the player's armour changes, update the minimum
		if ( _min_armour != self:GetMin() ) then
			self:SetMin( _min_armour );
			
			if ( self:GetValue() < self:GetMin() ) then
				self:SetValue( self:GetMin() );
			end;
		end;
		
		-- Ensure slider corresponds to selected value
		if ( self.Slider:GetSlideX() != self.Scratch:GetFraction( self:GetValue() ) ) then
			self.Slider:SetSlideX( self.Scratch:GetFraction( self:GetValue() ) );
		end;
		
		-- Keep the value saved on the frame consistent with the slider value
		if ( _medicmenu_armour.ArmourSelected != math.Round( self:GetValue() ) ) then
			_medicmenu_armour.ArmourSelected = math.Round( self:GetValue() );
		end;
	end;
	
	-- The button to purchase the armour
	local _medicmenu_armour_button = vgui.Create( "DButton", _medicmenu_armour );
	_medicmenu_armour_button:SetPos( 11, 64 );
	_medicmenu_armour_button:SetSize( 130, 22 );
	_medicmenu_armour_button:SetText( "" );
	_medicmenu_armour_button.OnDepressed = function( _self )
		_medicmenu_armour_button.Depressed = true;
	end;
	_medicmenu_armour_button.OnReleased = function( _self )
		_medicmenu_armour_button.Depressed = false;
	end;
	_medicmenu_armour_button.Paint = function( _self, _w, _h )
		-- Main button
		draw.RoundedBox( 0, 0, 0, _w, _h, MedicNPC.Config.Menu.ArmourButton );
		surface.SetDrawColor( MedicNPC.Config.Menu.ArmourButtonOutline );
		surface.DrawOutlinedRect( 0, 0, _w, _h );
		
		-- Text
		local _cost = math.Round( MedicNPC.Config.ArmourCost * ( _medicmenu_armour.ArmourSelected - LocalPlayer():Armor() ) );
		draw.SimpleText( MedicNPC.Config.Lang["Purchase"] .. ": " .. DarkRP.formatMoney( _cost ) .. Either( ( string.len( tostring( _cost ) ) < 5 ), string.sub( ".00000", 1, 6 - string.len( tostring( _cost ) ) ), "" ), "Carm.MedicNPC.16", 6, 3, MedicNPC.Config.Menu.TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
		
		-- Draw highlights for hover and click
		if ( _self:IsHovered() && !_self.Depressed ) then
			DrawHover( 0, 0, _w, _h, 5 );
		elseif _self.Depressed then
			DrawClicked( 0, 0, _w, _h, 5 );
		end;
	end;
	_medicmenu_armour_button.DoClick = function()
		if ( ( _medicmenu_armour.ArmourSelected - LocalPlayer():Armor() ) > 0 ) then
			net.Start( "MedicNPC.PurchaseArmour" );
				net.WriteInt( _medicmenu_armour.ArmourSelected, 32 );
			net.SendToServer();
		end;
	end;

end;

--[[-----------------
  MedicNPC.OpenMenu
-----------------]]--

-- Open the menu on the client when use is pressed on the NPC serverside
net.Receive( "MedicNPC.OpenMenu", function()
	local _ply = LocalPlayer();
	-- Assign the entity that was sent to the client as the _npc variable
	local _npc = net.ReadEntity();
	
	-- Check that the player is within range and is looking at the NPC to prevent exploits
	if ( _ply:GetEyeTrace().Entity && ( _ply:GetEyeTrace().Entity:GetClass() == "carms_medic_npc" ) ) then
		-- Draw the menu
		DrawMedicMenu();
	end;
end );