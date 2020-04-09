delete(instrfindall);
clear;

s = serial('/dev/cu.usbmodem14201');
set(s, 'Terminator', 'CR/LF');
set(s, 'FlowControl', 'none'); 
set(s, 'BaudRate', 9600);
set(s, 'Parity', 'none');
set(s, 'DataBits', 8); 
set(s, 'StopBit', 1);
set(s, 'BytesAvailableFcn', @readdata);
set(s, 'BytesAvailableFcnCount', 10);
set(s, 'BytesAvailableFcnMode', 'byte');
fopen(s);

function readdata(obj, event)
    n = fscanf(obj, "%s", 100)
end
