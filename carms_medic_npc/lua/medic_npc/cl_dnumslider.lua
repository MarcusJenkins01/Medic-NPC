--[[---------------------------------------------------------------
  The DNumSlider rewrite by [GGS] 92carmnad to add incrementation
---------------------------------------------------------------]]--

local PANEL = {};

function PANEL:Init()
	self.Increment = 1;
	self.Slider.Color = Color( 0, 0, 0, 0 );
	self.Slider.OutlineColor = Color( 0, 0, 0, 0 );
	self.Slider.NotchColor = Color( 255, 255, 255, 85 );
	
	self.Slider.OnCursorMoved = function( _slider, _x, _y )
		if ( !_slider.Dragging && !_slider.Knob.Depressed ) then return; end;
		
		-- Work out the fraction of the width that the increment corresponds to
		local _slider_increment = 1 / ( self:GetRange() / self:GetIncrement() );
		
		local _w, _h = _slider:GetSize();
		local _knob_w, _knob_h = _slider.Knob:GetSize();
		
		-- Correct the swaying of the knob as it moves away from the centre 
		if ( _slider.m_bTrappedInside ) then
			_x = _x - _knob_w * 0.5;
			_y = _y - _knob_h * 0.5;
			_w = _w - _knob_w;
			_h = _h - _knob_h;
		end
		
		-- Work out the fraction of x and y to the width and height
		_x = math.Clamp( _x, 0, _w ) / _w;
		_y = math.Clamp( _y, 0, _h ) / _h;
		
		-- Snap the values to the nearest interval
		_x = math.Clamp( math.Round( _x / _slider_increment ) * _slider_increment, 0, 1 );
		_y = math.Clamp( math.Round( _y / _slider_increment ) * _slider_increment, 0, 1 );
		
		-- Default, locks the x or y value if SetLockX or SetLockY is used
		if ( _slider.m_iLockX ) then
			_x = _slider.m_iLockX;
		end;
		
		if ( _slider.m_iLockY ) then
			_y = _slider.m_iLockY;
		end;
		
		-- Translate ratios to proper values
		_x, _y = _slider:TranslateValues( _x, _y );
		
		_slider:SetSlideX( _x );
		_slider:SetSlideY( _y );
		
		-- So that GetSize and various other screen space functions will work correctly
		_slider:InvalidateLayout();
	end;
	
	-- Set background color of the slider
	self.Slider.SetColor = function( _slider, _color )
		_slider.Color = _color;
	end;
	
	-- Set outline color of the slider
	self.Slider.SetOutlineColor = function( _slider, _color )
		_slider.OutlineColor = _color;
	end;
	
	-- Set color of the slider notches
	self.Slider.SetNotchColor = function( _slider, _color )
		_slider.NotchColor = _color;
	end;
	
	-- Paint the slider
	self.Slider.Paint = function( _slider, _w, _h )
		-- Draw the background
		surface.SetDrawColor( _slider.OutlineColor );
		surface.DrawOutlinedRect( 1, 0, _w-2, _h );
		draw.RoundedBox( 0, 1, 0, _w-2, _h, _slider.Color );
		
		-- Draw the bottom line
		draw.RoundedBox( 0, 7, _h - 5, _w - 14, 1, _slider.NotchColor );
		
		-- Draw the interval lines
		local _range = self:GetRange();
		for i = 0, _range, self:GetIncrement() do
			draw.RoundedBox( 0, 7 + ( i * ( ( _w - 15 ) / _range ) ), 5, 1, _h-10, _slider.NotchColor );
		end;
	end;
end;

function PANEL:GetIncrement()
	return self.Increment || 1;
end;

function PANEL:SetIncrement( _value )
	-- Make sure the increment is between 1 and the range
	_value = math.Clamp( tonumber( _value ) || 1, 1, self:GetRange() );
	
	-- If it's already equal to that, don't bother changing it again
	if ( self:GetIncrement() == _value ) then return; end;
	
	self.Increment = _value;
end;

function PANEL:SetTextColor( _color )
	self.TextArea:SetTextColor( _color );
end;

function PANEL:SetFont( _font )
	self.TextArea:SetFont( _font );
end;

vgui.Register( "Carm.DNumSlider", PANEL, "DNumSlider" );