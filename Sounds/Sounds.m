%generate sounds

total_time = 0.1;
samp_rate = 20000;
t=[0:1/samp_rate:total_time];
A=1;
f=500;
y=[];
y=A*sin(2*pi*f*t);
y= y +0.25*A*sin(2*pi*f*t*2);
y = y + 0.123*A*sin(2*pi*f*t*3);

soundsc(y,samp_rate);

c = 261.63;
d = 293.66;
e = 329.63;
f = 349.23;
g = 392.00;
a = 440;
b = 493.88;

%create look up table
sound_lut = [];
for i=1:4
    index = (i-1) * 14 + 1
    sound_lut(index:index+2) = c;
    sound_lut(index+3:index+5) = d;
    sound_lut(index+6:index+8) = e;
    sound_lut(index+9:index+11) = f;
    sound_lut(index+12:index+14) = g;
    sound_lut(index+15:index+17) = a;
    sound_lut(index+18:index+20) = b;
    
    c = c * 2;
    d = d*2;
    e = e* 2;
    f = f*2;
    g = g*2
    a = a*2;
    b = b*2;
end
sound_lut = sound_lut';

sine_lut = cell(1,0);

for i=1:50
    sine_lut{i} = A*sin(2*pi*sound_lut(i)*t);
    soundsc(sine_lut{i},samp_rate);
    pause(0.4);
    sound_lut(i)
end








