function [a,b] = AWETNotch(fs, f0, Q)

w0 = 2*pi*f0/fs;        
alpha = sin(w0)/(2*Q);  

b0 =   1;               
b1 =  -2*cos(w0);       
b2 =   1;               
a0 =   1 + alpha;       
a1 =  -2*cos(w0);       
a2 =   1 - alpha;       
                        
a = [a0, a1, a2];       
b = [b0, b1, b2];       


end

