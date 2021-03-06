% successfully sends polynomial coefficients
clear all % remove serial that insists on hanging around and fucking shit up
close all
serial = serial('COM3','BAUD',57600);

%% 4 polynomial coeffs
length = 1;
[a3, a2, a1, a0] = cubic_coeffs(0, 0, 1, 3, 0.5);
xdata = [a3 a2 a1 a0 0.5];
[a3, a2, a1, a0] = cubic_coeffs(1, 0, 0, 0, 0.5);
ydata = [a3 a2 a1 a0 0.5];
[a3, a2, a1, a0] = cubic_coeffs(0, 0, 1, 0, 0.5);
zdata = [a3 a2 a1 a0 0.5];
[a3, a2, a1, a0] = cubic_coeffs(0.5, 0, 0, -3, 0.5);
thdata = [a3 a2 a1 a0 0.5];

% length = 2;
% tv = 0.2; tf = 0.4;
% [a3, a2, a1, a0, b3, b2, b1, b0] = cubic_via_coeffs(0, 0, 1, 0, 0.3, tv, tf);
% xdata = [a3 a2 a1 a0 tv; b3 b2 b1 b0 tf-tv];
% [a3, a2, a1, a0, b3, b2, b1, b0] = cubic_via_coeffs(1, 0, 0, 0, 0.3, tv, tf);
% ydata = [a3 a2 a1 a0 tv; b3 b2 b1 b0 tf-tv];
% [a3, a2, a1, a0, b3, b2, b1, b0] = cubic_via_coeffs(0.5, 0, 0.5, 0, 1, tv, tf);
% zdata = [a3 a2 a1 a0 tv; b3 b2 b1 b0 tf-tv];
% [a3, a2, a1, a0, b3, b2, b1, b0] = cubic_via_coeffs(0.2, 0, .2, 0, 0, tv, tf);
% thdata = [a3 a2 a1 a0 tv; b3 b2 b1 b0 tf-tv];

%% open serial and wait to establish
fopen(serial);
pause(1.5);

%% send number of rows about to be sent
tic
fprintf(serial, string(length));
reply = strtrim(fscanf(serial));
if ~strcmp(join(string(reply)), string(length))
    disp('Device did not agree on length, will not send. '+join(string(reply)));
    fclose(serial);
    delete(serial);
    return;
else
    disp('Device agreed on length of '+string(length)+'.')
end
toc

%% send rows
tic
sendRow(serial, xdata);
sendRow(serial, ydata);
sendRow(serial, zdata);
sendRow(serial, thdata);
toc

%% received plotting data
[tx, x] = readRow(serial);
[ty, y] = readRow(serial);
[tz, z] = readRow(serial);
[tth, th] = readRow(serial);
subplot(121)
hold on
plot(tx, x)
plot(ty, y)
plot(tz, z)
plot(tth, th)
legend('x', 'y', 'z', 'theta')
xlabel('Time (s)')
subplot(122)
plot3(x,y,z)
xlabel('x')
ylabel('y')
zlabel('z')
%% clean up
fclose(serial);
delete(serial);

function sendRow(serial, data)
    length = size(data);
    for i = 1:length
        send = join(string(data(i, :)));
        disp("send: " + send);
        fprintf(serial, send);
        reply = strtrim(fscanf(serial));
        % if ~strcmp(string(i), reply)
        %     disp(reply);
        %    errors = errors + 1; 
        % end
        disp("recv: " + reply);
    end
end

function [t, d] = readRow(serial)
    i = 1;
    t = zeros(1, 99);
    d = zeros(1, 99);
    while i <= 100
        data = strtrim(fscanf(serial));
        res = regexp(data, '[+-]?\d+\.?\d*','match');
        t(i) = str2double(res{1});
        d(i) = str2double(res{2});
        i = i + 1;
    end
end