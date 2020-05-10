function outputSignal = AWETCropRegion(inputSignal,fs, channelCount, startRegion, endRegion)

signalLength = length(inputSignal);

startCrop = startRegion*fs;
endCrop = startCrop + (endRegion*fs);

if channelCount == 2
    
    sL = inputSignal(:,1);
    sR = inputSignal(:,2);
    
    yLeft = [sL(1:startCrop); sL(endCrop:end)];
    
    yRight = [sR(1:startCrop); sR(endCrop:end)];
    
    outputSignal = [yLeft yRight];
    
else
    if channelCount == 1
        
        y1 = [inputSignal(1:startCrop); inputSignal(endCrop:end)];
        
        outputSignal = y1;
        
    end
end

end

