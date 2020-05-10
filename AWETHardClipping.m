function x = AWETHardClipping(inputSig, channelCount, positiveParameter, negativeParameter)

sigLength = length(inputSig);   
                                
                                
if channelCount == 1
    x = inputSig;
for i = 1:sigLength                         
    if (inputSig(i) > positiveParameter)    
        x(i) = positiveParameter;      
    end                                     
                                            
    if (inputSig(i) < negativeParameter)    
        x(i) = negativeParameter;     
    end                                     
end                                         
else
    if channelCount == 2
     x1 = inputSig(:,1);
     x2 = inputSig(:,2);
     
     for i1 = 1:sigLength
         if(x1(i1) > positiveParameter)
             x1(i1) = positiveParameter;
         end
         
         if(x2(i1) > positiveParameter)
             x2(i1) = positiveParameter;
         end
         
         if (x1(i1) < negativeParameter)
             x1(i1) = negativeParameter;
         end
         
         if (x2(i1) < negativeParameter)
             x2(i1) = negativeParameter;
         end
     end
         x = [x1 x2];
    end
    
                                            
end

