function listtostr(_t)
	local str="{"
	for v in all(_t) do
		str = str..","..v
	end
	str = str.."}"
	return str
end

-- square root of value
function sqr(x) return x*x end

function point_dinstance(x1,y1,x2,y2)
	return sqrt(sqr(x2-x1)+sqr(y2-y1))
end

function middle_point(x1,y1,x2,y2)
	return flr((x1+x2)/2),flr((y1+y2)/2)
end

-- check if two hitboxes collde
-- hibox has the following structure: {x,y,w,h}
function hitbox_collide(_hb1,_hb2)
	-- hb=hitbox, tb=targetbox
	-- hitbox coords point to top-left
	local hb_x,hb_y,hb_w,hb_h = unpack(_hb1)
	local tb_x,tb_y,tb_w,tb_h = unpack(_hb2)

	if (hb_y > tb_y+tb_h) return false
	if (hb_y+hb_h < tb_y) return false
	if (hb_x > tb_x+tb_w) return false
	if (hb_x+hb_w < tb_x) return false
	return true
end

function log(_text)
	printh(_text,"tower/log")
end

--- easing functions ---
-- credit for functions: https://www.lexaloffle.com/bbs/?pid=easingcheatsheet-2
function easeinoutquad(t)
	if(t<.5) then
		return t*t*2
	else
		t-=1
		return 1-t*t*2
	end
end
function easeoutinquart(t)
	if t<.5 then
		t-=.5
		return .5-8*t*t*t*t
	else
		t-=.5
		return .5+8*t*t*t*t
	end
end
function easeoutovershoot(t)
	t-=1
	return 1+2.7*t*t*t+1.7*t*t
end