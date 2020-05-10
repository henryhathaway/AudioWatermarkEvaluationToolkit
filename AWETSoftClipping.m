function y = AWETSoftClipping(scInput, scGain)

y = scInput;   

y = y.*scGain;  
                


for i = 1:length(y)   
                           
    
 if(y(i) >= 1)        
     y(i) =  2/3;          
                          
     
 elseif(y(i) <= -1)  
     y(i) = -2/3;           
                            
 else                       
     
y(i) =y(i) - (y(i)^3)/3; 
                                    
 end
end

end

