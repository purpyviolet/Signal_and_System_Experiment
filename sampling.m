% 设定余弦信号的参数
A = 1;      % 余弦信号的幅度
f = 5;      % 余弦信号的频率
t = 0:0.001:1; % 时间向量

% 连续的余弦信号
continuous_cosine = A * cos(2 * pi * f * t);

% 抽样频率fs分别选为f、2f和4f
fs1 = f;
fs2 = 2 * f;
fs3 = 4 * f;

% 抽样信号
sampled_cosine1 = continuous_cosine(1:1/fs1:end);
sampled_cosine2 = continuous_cosine(1:1/fs2:end);
sampled_cosine3 = continuous_cosine(1:1/fs3:end);

% 绘制连续信号及其抽样信号的波形
figure;
subplot(4,1,1);
plot(t, continuous_cosine);
title('Continuous Cosine Signal');

subplot(4,1,2);
stem(t(1:1/fs1:end), sampled_cosine1);
title(['Sampled Cosine Signal at fs = ' num2str(fs1) ' Hz']);

subplot(4,1,3);
stem(t(1:1/fs2:end), sampled_cosine2);
title(['Sampled Cosine Signal at fs = ' num2str(fs2) ' Hz']);

subplot(4,1,4);
stem(t(1:1/fs3:end), sampled_cosine3);
title(['Sampled Cosine Signal at fs = ' num2str(fs3) ' Hz']);


% 设定矩形信号的参数
E = 1;      % 矩形信号的幅度
tau = 0.1;  % 矩形信号的宽度
f = 1/tau;  % 根据宽度确定频率

% 连续的矩形信号
continuous_rect = E * (mod(t, tau) < tau/2);

% 抽样信号
sampled_rect1 = continuous_rect(1:1/fs1:end);
sampled_rect2 = continuous_rect(1:1/fs2:end);
sampled_rect3 = continuous_rect(1:1/fs3:end);

% 绘制连续信号及其抽样信号的波形
figure;
subplot(4,1,1);
plot(t, continuous_rect);
title('Continuous Rectangular Signal');

subplot(4,1,2);
stem(t(1:1/fs1:end), sampled_rect1);
title(['Sampled Rectangular Signal at fs = ' num2str(fs1) ' Hz']);

subplot(4,1,3);
stem(t(1:1/fs2:end), sampled_rect2);
title(['Sampled Rectangular Signal at fs = ' num2str(fs2) ' Hz']);

subplot(4,1,4);
stem(t(1:1/fs3:end), sampled_rect3);
title(['Sampled Rectangular Signal at fs = ' num2str(fs3) ' Hz']);


% 读入myspeech.wav文件
[y, Fs] = audioread('myvoice.wav');
y = y(:,1); % 只取单声道进行处理

% 设定抽样间隔
N1 = 2;
N2 = 4;
N3 = 8;

% 对语音信号进行抽样
sampled_y1 = y(1:N1:end);
sampled_y2 = y(1:N2:end);
sampled_y3 = y(1:N3:end);

% 绘制原始语音信号及其抽样信号的波形
figure;
subplot(4,1,1);
plot((1:length(y))/Fs, y);
title('Original Speech Signal');

subplot(4,1,2);
stem((1:N1:length(y))/Fs, sampled_y1);
title(['Sampled Speech Signal with N = ' num2str(N1)]);

subplot(4,1,3);
stem((1:N2:length(y))/Fs, sampled_y2);
title(['Sampled Speech Signal with N = ' num2str(N2)]);

subplot(4,1,4);
stem((1:N3:length(y))/Fs, sampled_y3);
title(['Sampled Speech Signal with N = ' num2str(N3)]);
xlabel('Time (s)');
ylabel('Amplitude');

sound(sampled_y1, Fs/N1);
pause(length(sampled_y1)/(Fs/N1) + 1);

sound(sampled_y2, Fs/N2);
pause(length(sampled_y2)/(Fs/N2) + 1);

sound(sampled_y3, Fs/N3);
