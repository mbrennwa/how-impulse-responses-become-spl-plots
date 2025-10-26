% Figure 1

pkg load signal

clear all; close all;
[siz, fontsiz] = plot_defaults([7,9],14); 

figure()

t1 = -1.2; t2 = 15.5; % left and right ends of time axes (ms)

% Panel A: Dirac input
t = [0:0.001:t2]; % time in ms
d = zeros(size(t)); d(1) = 1;
ax1 = subplot(3,1,1);
plot(t,d,'k-');
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
t_start = 3.0; % start of IR
ax2 = subplot(3,1,2);
plot(t,1000*h,'k-');
r([3,4]) = [-70,120];
axis(r)
text (r(2)*0.97, r(4) - (r(4)-r(3))*0.18, '(B) Speaker output (no echos)', 'fontsize', fontsiz,'horizontalalignment','right');
ylabel ('Pressure (mPa)')
set(gca, 'XTickLabel', []);

% Panel C: Speaker response (no echo)
randn("seed", 1234);  % for reproducible random numbers (when replotting)
delay1 = 4; % echo delay (ms)
ndelay1 = round(delay1/1000*x.fs);
echo1 = h(1:end-ndelay1);
echo1 = [ zeros(ndelay1,1) ; h(1:end-ndelay1)];
k = find(t>t_start+delay1);
echo1(k) = echo1(k) + 0.022*randn(length(k),1);
[b, a] = butter(1, 2500/(x.fs/2)); % Normalized cutoff = fc / (fs/2)
echo1 = filtfilt(b, a, echo1);

delay2 = 6; % echo delay (ms)
ndelay2 = round(delay2/1000*x.fs);
echo2 = [ zeros(ndelay2,1) ; h(1:end-ndelay2)];
[b, a] = butter(1, 1500/(x.fs/2)); % Normalized cutoff = fc / (fs/2)
echo2 = filtfilt(b, a, echo2);

h = h + 0.33*echo1 + 0.5*echo2;

ax3 = subplot(3,1,3);
k1 = find(t<=t_start);
k2 = find(t<=t_start+delay1); k2 = [k1(end):k2(end)];
k3 = [ k2(end):length(t) ];
plot(t(k1),1000*(h(k1)),'g-' , t(k2),1000*(h(k2)),'b-' , t(k3),1000*(h(k3)),'r-');
axis(r)
text (r(2)*0.97, r(4) - (r(4)-r(3))*0.18, '(C) Speaker output (with echos)', 'fontsize', fontsiz,'horizontalalignment','right');
ylabel ('Pressure (mPa)')
xlabel('Time (ms)')

print ("FIGURE1.pdf", "-dpdf")
