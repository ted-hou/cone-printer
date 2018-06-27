x = 1.75/2;
y = 4.5/2;
h = 3;
margin = 0.25;
spacing = 0.025;

drawCone(x, y, h, 'DrawCaps', 'off', 'XMargin', margin, 'YMargin', margin, 'Spacing', spacing, 'FileName', 'cone.pdf');
drawCone(x, y, h, 'DrawCaps', 'on', 'XMargin', margin, 'YMargin', margin, 'Spacing', spacing, 'FileName', 'cone_w_cap.pdf');
drawCone(x, y, h, 'DrawCaps', 'only', 'XMargin', margin, 'YMargin', margin, 'Spacing', spacing, 'FileName', 'cap.pdf');
