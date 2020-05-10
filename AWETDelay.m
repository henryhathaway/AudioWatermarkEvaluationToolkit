function outputSignal = AWETDelay(inputSignal, fs, channelCount, delaySeconds, delayGain)

x = inputSignal;

b = [1 delayGain];
N = round(delaySeconds*fs);
h = zeros(1, fs);
h(1) = b(1);
h(N) = b(2);

y1 = x(:,1);
y2 = x(:,2);

if channelCount == 1
    y = conv(x, h);
    outputSignal = y;
else
    if channelCount ==2
       y1Conv = conv(y1, h);
       y2Conv = conv(y2, h);
       
       outputSignal = [y1Conv y2Conv];
    end
end


end

