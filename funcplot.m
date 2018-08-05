
e = 2.718281828459;
fp = fplot(@(x) 1/(e^(-(30*(x-0.5))) + 1), [0,1])
title('Blending Curves')
xlabel('x');
ylabel('y');

hold on
keyboard;

fp = fplot(@(x) 1/(e^(-(10*(x-0.5))) + 1), [0,1])
title('Blending Curves')
xlabel('x');
ylabel('y');
%r_low = 1/(e^(-(10*(r-0.5))) + 1);