function x = AWETCropSignal(inputSignal, fs, channelCount, startCrop, endCrop)

startCrop = startCrop*fs;
endCrop = (length(inputSignal)-(endCrop*fs));

if channelCount == 2
y1 = inputSignal(startCrop:endCrop,1);
y2 = inputSignal(startCrop:endCrop,2);

x = [y1 y2];

else
    if channelCount == 1
        
        x = inputSignal(startCrop:endCrop);
    end
end



end

