% 读入带噪声的语音信号和噪声样本
[y, Fs] = audioread('myvoice_noisy.wav');
y = y(:,1); % 单声道处理
[noise, ~] = audioread('white_noise.wav');
noise = noise(:,1); % 单声道处理

% 截断或重复噪声样本以匹配语音信号的长度
if length(noise) < length(y)
    noise = repmat(noise, ceil(length(y)/length(noise)), 1);
end
noise = noise(1:length(y));

% 计算噪声信号和语音信号的FFT
N = length(y);
Y_fft = fft(y, N);
Noise_fft = fft(noise, N);

% 频谱减法
Y_filtered_fft = Y_fft - Noise_fft;
Y_filtered_fft(Y_filtered_fft < 0) = 0; % 防止负值

% 计算滤波后的时域信号
y_filtered = real(ifft(Y_filtered_fft));

% 规范化滤波后的信号
y_filtered_norm = y_filtered / max(abs(y_filtered));

% 绘制原始和滤波后的语音信号的FFT图
f = Fs*(0:(N/2))/N;
figure;
subplot(2,1,1);
plot(f, abs(Y_fft(1:N/2+1)));
title('Original Speech Signal FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,1,2);
plot(f, abs(Y_filtered_fft(1:N/2+1)));
title('Filtered Speech Signal FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% 播放原始和过滤后的语音信号
sound(y, Fs);
pause(length(y)/Fs + 1);
sound(y_filtered_norm, Fs);
pause(length(y_filtered)/Fs + 1);