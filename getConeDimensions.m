%% getConeDimension: get flattened cone dimensions (alpha, r, and R) from folded dimensions (x, y and h)
% Inputs:
% 	x - radius of lower cone opening (e.g. 15 cm)
% 	y - radius of upper cone opening (e.g. 40 cm)
% 	h - height of cone (e.g. 30 cm)
% Outputs:
% 	alpha 	- angle of unfolded cone (in radians)
% 	r 		- radius of smaller circle
% 	R 		- radius of larger circle

function [alpha, r, R] = getConeDimension(x, y, h)
	edge = sqrt(h^2 + (y - x)^2);
	alpha = 2*pi*(y - x)/edge;
	r = x*edge/(y - x);
	R = y*edge/(y - x);
end