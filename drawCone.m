%% drawCone: draws cones onto a US-letter sized paper
function [coneDimensions] = drawCone(varargin)
	p = inputParser;

	addOptional(p, 'x', 0.75, @isnumeric)
	addOptional(p, 'y', 2.25, @isnumeric)
	addOptional(p, 'h', 3, @isnumeric)
	addParameter(p, 'XMargin', 0.5, @isnumeric)
	addParameter(p, 'YMargin', 0.5, @isnumeric)
	addParameter(p, 'Spacing', 0.75, @isnumeric)
	addParameter(p, 'Filename', '', @ischar)
	addParameter(p, 'DrawCaps', 'off', @ischar)

	parse(p,varargin{:})

	x = p.Results.x;
	y = p.Results.y;
	h = p.Results.h;
	spacing = p.Results.Spacing;
	filename = p.Results.Filename;
	drawCaps = p.Results.DrawCaps;
	if strcmp(drawCaps, 'off')
		drawCaps = 0;
	elseif strcmp(drawCaps, 'on')
		drawCaps = 1;
	elseif strcmp(drawCaps, 'only')
		drawCaps = 2;
	end

	% Get cone dimensions
	[alpha, r, R] = getConeDimensions(x, y, h);
	fprintf([...
		'Folded cone dimensions:\n',...
			'\theight = ', num2str(h), ' cm;\n',...
			'\tradius (lower opening) = ', num2str(x), ' cm;\n',...
			'\tradius (upper opening) = ', num2str(y), ' cm;\n\n',...
		'Unfolded cone dimensions:\n',...
			'\tangle = ', num2str(180/pi*alpha), ' degrees;\n',...
			'\tradius (lower opening) = ', num2str(r), ' cm;\n',...
			'\tradius (upper opening) = ', num2str(R), ' cm;\n'...
	])
	coneDimensions.alpha = alpha;
	coneDimensions.r = r;
	coneDimensions.R = R;

	% Figure out how many cones we can cut out from one circle
	numConesPerCircle = floor(2*pi/alpha);

	% Get points (vertices) on the outer circle
	vertices = zeros(numConesPerCircle + 1, 2);
	for iCone = 0:numConesPerCircle
		vertices(iCone + 1, :) = [R*cos(-iCone*alpha), R*sin(-iCone*alpha)];
	end

	% Create a letter-sized figure (21.59 cm x 27.94 cm)
	paperSize = [21.59, 27.94];
	marginSize = [p.Results.XMargin, p.Results.YMargin];
	axSize = paperSize - 2*marginSize;
	fig = figure('Units', 'centimeters', 'Position', [0, 0, paperSize]);
	ax 	= axes('Units', 'centimeters', 'Position', [marginSize, axSize]);
	ax.XTick = [];
	ax.YTick = [];
	ax.XLim = [0, axSize(1)];
	ax.YLim = [0, axSize(2)];
	ax.Visible = 'off';

	% Figure out how many circles we can fit in one page
	if drawCaps < 2
		numCols = floor(axSize(1)/(spacing + 2*R));
		numRows = floor(axSize(2)/(spacing + 2*R));
		if drawCaps == 0
			numRows = numRows + 1;
			numCols = numCols + 1;
		end

		% Draw circles and lines
		for iRow = 1:numRows
			for iCol = 1:numCols
				thisCenter = [(2*iCol - 1)*(spacing/2 + R), (2*iRow - 1)*(spacing/2 + R)];
				thisVertices = vertices + repmat(thisCenter, [size(vertices, 1), 1]);

				theta = linspace(0, -numConesPerCircle*alpha, 3600);
				line(...
					'XData', repmat(thisCenter(1), size(theta)) + R*cos(theta),...
					'YData', repmat(thisCenter(2), size(theta)) + R*sin(theta),...
					'Color','k'...
				);
				line(...
					'XData', repmat(thisCenter(1), size(theta)) + r*cos(theta),...
					'YData', repmat(thisCenter(2), size(theta)) + r*sin(theta),...
					'Color','k'...
				);
				for iVertex = 1:size(thisVertices, 1)
					line(...
						'XData', [thisCenter(1), thisVertices(iVertex, 1)],...
						'YData', [thisCenter(2), thisVertices(iVertex, 2)],...
						'Color', 'k'...
					);
				end
			end
		end
	end

	% Figure out how many caps we can draw in the blank space up
	if drawCaps > 0
		% First draw on top
		numColsCap = floor(axSize(1)/(spacing + 2*y));
		if drawCaps == 1
			newBottom = numRows*(spacing + 2*R);
		else
			newBottom = 0;
		end
		numRowsCap = floor((axSize(2) - newBottom)/(spacing + 2*y));

		for iRow = 1:numRowsCap
			for iCol = 1:numColsCap
				thisCenter = [(2*iCol - 1)*(spacing/2 + y), newBottom + (2*iRow - 1)*(spacing/2 + y)];

				theta = linspace(0, 2*pi, 3600);
				line(...
					'XData', repmat(thisCenter(1), size(theta)) + y*cos(theta),...
					'YData', repmat(thisCenter(2), size(theta)) + y*sin(theta),...
					'Color','k'...
				);
			end
		end	

		% Then draw on the right
		numRowsCap = floor(axSize(2)/(spacing + 2*y));
		if drawCaps == 1
			newLeft = numCols*(spacing + 2*R);
		else
			newLeft = 0;
		end
		numColsCap = floor((axSize(1) - newLeft)/(spacing + 2*y));

		for iRow = 1:numRowsCap
			for iCol = 1:numColsCap
				thisCenter = [newLeft + (2*iCol - 1)*(spacing/2 + y), (2*iRow - 1)*(spacing/2 + y)];

				theta = linspace(0, 2*pi, 3600);
				line(...
					'XData', repmat(thisCenter(1), size(theta)) + y*cos(theta),...
					'YData', repmat(thisCenter(2), size(theta)) + y*sin(theta),...
					'Color','k'...
				);
			end
		end
	end

	if ~isempty(filename)
		saveFigure(filename);
	end
end