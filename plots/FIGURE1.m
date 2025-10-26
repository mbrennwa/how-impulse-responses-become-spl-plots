% Figure 1

pkg load signal

clear all; close all;
[siz, fontsiz] = plot_defaults([5,6],14); 

figure()

t1 = -1.2; t2 = 15.5; % left and right ends of time axes (ms)

% Panel A: Dirac input
t = [0:0.001:t2]; % time in ms
d = zeros(size(t)); d(1) = 1;
ax1 = subplot(3,1,1);
plot(t,d);
r = [t1,t2,-0.1,1.1];
axis(r)
text (r(2)*0.97, r(4) - (r(4)-r(3))*0.18, '(A) Speaker input', 'fontsize', fontsiz,'horizontalalignment','right');
ylabel ('Drive Voltage')
set(gca,'ytick',[])
set(gca, 'XTickLabel', []);

% Panel B: Speaker response (no echo)
x = load('12PR320_1m_onaxis.mat');
t = x.t*1000; % time in ms
h = x.h; % sound pressure in µPa
ax2 = subplot(3,1,2);
plot(t,1000*h);
r([3,4]) = [-70,110];
axis(r)
text (r(2)*0.97, r(4) - (r(4)-r(3))*0.18, '(B) Speaker output (no echos)', 'fontsize', fontsiz,'horizontalalignment','right');
ylabel ('Pressure (mPa)')
set(gca, 'XTickLabel', []);

% Panel C: Speaker response (no echo)
randn("seed", 12345);  % for reproducible random numbers (when replotting)
[t_start,t_rise] = mataa_guess_IR_start(h,t,20); t_start = t_start+t_rise;
delay1 = 4; % echo delay (ms)
ndelay1 = round(delay1/1000*x.fs);
echo1 = h(1:end-ndelay1)
echo1 = [ zeros(ndelay1,1) ; h(1:end-ndelay1)];
k = find(t>t_start+delay1);
echo1(k) = echo1(k) + 0.022*randn(length(k),1);
[b, a] = butter(1, 2500/(x.fs/2)); % Normalized cutoff = fc / (fs/2)
echo1 = 0.33*filtfilt(b, a, echo1);

delay2 = 6; % echo delay (ms)
ndelay2 = round(delay2/1000*x.fs);
echo2 = [ zeros(ndelay2,1) ; h(1:end-ndelay2)];
[b, a] = butter(1, 1500/(x.fs/2)); % Normalized cutoff = fc / (fs/2)
echo2 = 0.25*filtfilt(b, a, echo2);

ax3 = subplot(3,1,3);
plot(t,1000*(h+echo1+echo2));
axis(r)
text (r(2)*0.97, r(4) - (r(4)-r(3))*0.18, '(C) Speaker output (with echos)', 'fontsize', fontsiz,'horizontalalignment','right');
ylabel ('Pressure (mPa)')
xlabel('Time (ms)')

print ("FIGURE1.pdf", "-dpdf")
