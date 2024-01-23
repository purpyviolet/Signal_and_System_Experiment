% 本噪音分析加过滤是用的加噪之后的语音，由于本人手机录音功能自带降噪功能
% 故本方法对于原音频处理效果不佳，则选择加入新噪声来体现butterworth低通滤波的效果
% 读入myspeech.wav文件
[y, Fs] = audioread('myvoice_noisy.wav');
y = y(:,1); % 如果是立体声，仅使用第一个通道

% 对语音信号进行FFT
Y = fft(y);
P2 = abs(Y/length(y));
P1 = P2(1:length(y)/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(length(y)/2))/length(y);

% 绘制语音信号的单侧频谱
figure;
plot(f, P1);
title('Single-Sided Amplitude Spectrum of Speech Signal');
xlabel('Frequency (f)');
ylabel('|P1(f)|');

% 这里就要观察频谱来确定噪声的频谱区段了
% 大部分的能量集中在低频区域，这是典型的语音信号的特性，因为人类语音的基频
% （男性约85到180 Hz，女性约165到255 Hz）及其谐波主要分布在这个区域。
% 噪声主要集中在某个频带，例如高频部分


fc = 1000; % 截止频率设为1000 Hz

% 设定通带和阻带边界
% 例如，我们可以将通带边界设为fc，阻带边界设为fc+500
fp = fc; % 通带截止频率
fs = fc + 500; % 阻带截止频率

% 设定通带和阻带纹波
rp = 3;   % 通带纹波（dB）
rs = 40;  % 阻带衰减（dB）

% 计算滤波器阶数
[n, Wn] = buttord(fp/(Fs/2), fs/(Fs/2), rp, rs);

% 设计滤波器
[b, a] = butter(n, Wn, 'low');


% 应用滤波器到语音信号
y_filtered = filter(b, a, y);

% 对过滤后的信号进行FFT
Y_filtered = fft(y_filtered);
P2_filtered = abs(Y_filtered/length(y_filtered));
P1_filtered = P2_filtered(1:length(y_filtered)/2+1);
P1_filtered(2:end-1) = 2*P1_filtered(2:end-1);

% 绘制过滤后的信号的单侧频谱
figure;
plot(f, P1_filtered);
title('Single-Sided Amplitude Spectrum of Filtered Speech Signal');
xlabel('Frequency (f)');
ylabel('|P1(f)|');
% y 是原始的语音信号，Fs 是采样率
% y_filtered 是已经应用滤波器处理后的语音信号

% 播放原始语音信号
sound(y, Fs);
pause(length(y)/Fs + 1); % 确保原始语音播放完毕

% 播放滤波后的语音信号
sound(y_filtered, Fs);
pause(length(y_filtered)/Fs + 1); % 确保滤波后的语音播放完毕
