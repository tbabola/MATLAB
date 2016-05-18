function loadTDT

% LQ 01/05/05, change RP2_1 and RP2_2 to RPX, ADD PA5_3 and PA5_4
global root_dir Stimuli COMM

COMM = struct('PA5_1',[],'PA5_2',[],'PA5_3',[],'PA5_4',[],'RX6',[],'asr1',0,'RCO',[]);

COMM.RX6=actxcontrol('RPco.x',[0 0 1 1]);
invoke(COMM.RX6,'ConnectRX6','GB',1);
invoke(COMM.RX6,'ClearCOF');

COMM.PA5_1 = actxcontrol('PA5.x',[0 0 1 1]);
invoke(COMM.PA5_1,'ConnectPA5','GB',1);
invoke(COMM.PA5_1,'SetAtten',120);

COMM.PA5_2 = actxcontrol('PA5.x',[0 0 1 1]);
invoke(COMM.PA5_2,'ConnectPA5','GB',2);
invoke(COMM.PA5_2,'SetAtten',120);

COMM.PA5_3 = actxcontrol('PA5.x',[0 0 1 1]);
invoke(COMM.PA5_3,'ConnectPA5','GB',3);
invoke(COMM.PA5_3,'SetAtten',120);

COMM.PA5_4 = actxcontrol('PA5.x',[0 0 1 1]);
invoke(COMM.PA5_4,'ConnectPA5','GB',4);
invoke(COMM.PA5_4,'SetAtten',120);
