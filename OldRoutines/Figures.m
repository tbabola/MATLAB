%Development figure

%set values for ISC, IHC, SGN, in vivo bursting
ISC_currents    = [3;3;3;4;5;6;7;8;10;10;9;6;3;2;1;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
IHC_currents    = [0;0;1;3;4;6;7;8;10;10;9;6;2;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
SGN_bursting    = [0;0;0;1;3;5;7;9;10;10;9;6;2;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
aud_bursting    = [0;1;3;5;6;7;8;9;10;10;9;4;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
SGN_refinement  = [2;4;6;8;9;8;3;2;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
time = [0:1:30]; %P0-P20
time_heat = [0:0.01:30];

%interpolate points
interp_ISC = interp1(time,ISC_currents,time_heat);
interp_IHC = interp1(time,IHC_currents,time_heat);
interp_SGN = interp1(time,SGN_bursting,time_heat);
interp_aud = interp1(time,aud_bursting,time_heat);
interp_refine = interp1(time,SGN_refinement,time_heat);
spacer = zeros(size(time_heat,2),1)';


figure;
cmap = gray;
grayud = flipud(cmap);
colormap(grayud);
subplot(7,1,1);
imagesc(interp_ISC);
axis off;
subplot(7,1,2);
imagesc(interp_IHC);
axis off;
subplot(7,1,3);
imagesc(interp_SGN);
axis off;
subplot(7,1,4);
imagesc(interp_aud);
axis off;
subplot(7,1,5);
plot(time,ISC_currents);
subplot(7,1,6);
imagesc(spacer,[0 10]);
axis off;
subplot(7,1,7);
imagesc(interp_refine,[0 10]);
axis off;

hA = gca;
hA.XRuler.MinorTicks;
hA.XRuler.MinorTick = [0:1:20];

