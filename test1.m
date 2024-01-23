% 叠加信号发声会比较刺耳（正弦信号），请注意降低音量！
% 读入.wav文件
[y, Fs] = audioread('myvoice.wav');
y = y(:,1); % 只取单声道进行处理

% 绘制原始波形
figure;
t = (0:length(y)-1)/Fs; % 创建时间向量
plot(t, y);
title('Original Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% 反转信号
y_reversed = flipud(y);

% 平移信号（例如，延迟0.5秒）
delay = 0.5; % 延迟时间，以秒为单位
num_delay_samples = round(Fs * delay); % 延迟的样本数
y_delayed = [zeros(num_delay_samples, 1); y(1:end-num_delay_samples)]; % 平移

% 绘制反转和平移后的波形
figure;
subplot(2,1,1);
plot(t, y_reversed);
title('Reversed Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, y_delayed);
title('Delayed Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% 生成正弦信号
f = 1000; % 正弦信号的频率
amplitude = 0.01; % 调整正弦波的振幅
sin_wave = amplitude*sin(2*pi*f*t)';

% 信号相加和相乘
y_add = y + sin_wave;
y_multiply = y .* sin_wave;

% 绘制相加和相乘后的波形
figure;
subplot(2,1,1);
plot(t, y_add);
title('Speech Signal plus Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, y_multiply);
title('Speech Signal times Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');

% 已经从前面的步骤中得到了y（语音信号）和Fs（采样频率）

% 1. 分析语音信号m(t)的频谱，绘制该频谱的波形
Y_m = fft(y); % 对语音信号进行FFT
P2 = abs(Y_m/length(y)); % 双侧频谱P2
P1 = P2(1:length(y)/2+1); % 单侧频谱P1
P1(2:end-1) = 2*P1(2:end-1); % 由于我们折叠了频谱，所以要乘以2（除了直流分量）
f_m = Fs*(0:(length(y)/2))/length(y); % 频率轴的定义

% 绘制语音信号的频谱
figure;
plot(f_m,P1);
title('Single-Sided Amplitude Spectrum of m(t)');
xlabel('Frequency (f)');
ylabel('|P1(f)|');

% 2. 分析语音信号与正弦信号相加的频谱，绘制该频谱的波形
f_sin = 1000; % 假设的正弦信号频率
sin_wave = sin(2*pi*f_sin*(0:length(y)-1)/Fs).'; % 创建正弦波
y_add = y + sin_wave; % 语音信号与正弦波相加
Y_add = fft(y_add); % 对结果进行FFT
P2_add = abs(Y_add/length(y_add));
P1_add = P2_add(1:length(y_add)/2+1);
P1_add(2:end-1) = 2*P1_add(2:end-1);
f_add = Fs*(0:(length(y_add)/2))/length(y_add);

% 使用对数尺度绘制相加后信号的频谱
figure;
plot(f_add, 10*log10(P1_add)); % 使用对数尺度来显示幅度
title('Single-Sided Amplitude Spectrum of m(t) + sin(2πft) on a Log Scale');
xlabel('Frequency (f)');
ylabel('10*log10(|P1(f)|)');

% 3. 分析语音信号与正弦信号的相乘的频谱，绘制该频谱的波形
y_multiply = y .* sin_wave; % 语音信号与正弦波相乘
Y_multiply = fft(y_multiply); % 对结果进行FFT
P2_multiply = abs(Y_multiply/length(y_multiply));
P1_multiply = P2_multiply(1:length(y_multiply)/2+1);
P1_multiply(2:end-1) = 2*P1_multiply(2:end-1);
f_multiply = Fs*(0:(length(y_multiply)/2))/length(y_multiply);

% 绘制相乘后信号的频谱
figure;
plot(f_multiply, P1_multiply);
title('Single-Sided Amplitude Spectrum of m(t) × sin(2πft)');
xlabel('Frequency (f)');
ylabel('|P1(f)|');

% 发声原始信号
clear sound;
sound(y, Fs);
pause(length(y)/Fs);  % 暂停时间等于信号长度除以采样率

% 发声反转信号
clear sound;
sound(y_reversed, Fs);
pause(length(y_reversed)/Fs);  

% 发声平移信号
clear sound;
sound(y_delayed, Fs);
pause(length(y_delayed)/Fs); 

% 发声相加信号
% y_add是两个信号相加后的结果
clear sound;
sound(y_add, Fs);
pause(length(y_add)/Fs);

% 发声相乘信号
% y_multiply是两个信号相乘后的结果
clear sound;
sound(y_multiply, Fs);
pause(length(y_multiply)/Fs);

