function saveFigure(filename)
	filename = strsplit(filename, '.');
	if length(filename) < 2
		filetype = '-dpdf';
	else
		filetype = ['-d', filename{2}];
	end
	try
		print(filename{1}, filetype);
		fprintf(['Template saved to ', filename{1}, '.', filename{2}, '\n']);
	catch ME
		warning(['Failed to save as ', filename{1}, '.', filename{2}, ' (', ME.message, ')']);
	end
end