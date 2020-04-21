--[[--------------------------------------------------------------------
  The clientside cl_init.lua file for the medic NPC by [GGS] 92carmnad
--------------------------------------------------------------------]]--

-- Include the shared Lua files
include( "medic_npc/sh_config.lua" );
include( "shared.lua" );

--[[----------
  3D2D Title
----------]]--

function ENT:Draw()
	-- Draw the entity model
	self:DrawModel();

	-- Declare and assign the position and angle variables
	local _pos = self:GetPos();
	local _ang = self:GetAngles();
	local _ang2 = self:GetAngles();

	-- Adjust the angles of each side of the text
	_ang:RotateAroundAxis( _ang:Forward(), 90 );
	_ang:RotateAroundAxis( _ang:Right(), 90 );
	_ang2:RotateAroundAxis( _ang:Forward(), -90 );
	_ang2:RotateAroundAxis( _ang:Up(), -90 );
	
	local _title = MedicNPC.Config.Lang["3D2D_Title"];
	local _sin_offset = 20 * math.sin( CurTime() * 2 );
	local _speed = 1.5;
	
	surface.SetFont( "Carm.MedicNPC.128" );
	local _title_size, _ = surface.GetTextSize( _title );
	
	-- Draw the 3D2D text
	cam.Start3D2D( _pos + self:GetUp() * 81, _ang, 0.05 );
		for _i=1, string.len( _title ) do
			local _offsetx, _ = surface.GetTextSize( string.sub( _title, 1, _i - 1 ) );
			draw.SimpleTextOutlined( _title[_i], "Carm.MedicNPC.128", -_title_size/2 + _offsetx, 10 * math.sin( CurTime() * _speed - math.pi/6 * _i ), HSVToColor( math.abs( math.sin( ( 0.1 * CurTime() ) - ( math.pi/180 * _i ) ) ) * 360, 1, 1 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 240 ) );
		end;
	cam.End3D2D();
	
	-- ... and repeat on the other side
	cam.Start3D2D( _pos + self:GetUp() * 81, _ang2, 0.05 );
		for _i=1, string.len( _title ) do
			local _offsetx, _ = surface.GetTextSize( string.sub( _title, 1, _i - 1 ) );
			draw.SimpleTextOutlined( _title[_i], "Carm.MedicNPC.128", -_title_size/2 + _offsetx, 10 * math.sin( CurTime() * _speed - math.pi/6 * _i ), HSVToColor( math.abs( math.sin( ( 0.1 * CurTime() ) - ( math.pi/180 * _i ) ) ) * 360, 1, 1 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 240 ) );
		end;
	cam.End3D2D();
end;