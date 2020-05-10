function outputSignal = AWETResample(inputSignal, inputFs, newFs)

x = inputSignal;

newFsScale = newFs/inputFs;

[p,q] = rat(newFsScale);

outputSignal = resample(x,p,q);

end

