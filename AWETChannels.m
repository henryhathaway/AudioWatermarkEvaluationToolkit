function outputSignal = AWETChannels(inputSignal, channelCount)

x = inputSignal;

if channelCount == 2
    outputSignal = sum(x, 2) / size(x, 2);
else
    if channelCount == 1
    outputSignal = [x x];
    end
end


end

