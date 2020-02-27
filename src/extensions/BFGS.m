function H_update  = BFGS(H, current_g, previous_g, current_x, previous_x, method)
    
    delta_g = current_g - previous_g;    % y
    delta_x = current_x - previous_x;    % x
    epsilon = 0.2;
    reg = 1e-3;
    
    if full(delta_g'*delta_x) > epsilon*full(delta_x'*H*delta_x)          
        r        = delta_g;
        alpha    = 1/(r'*delta_x + reg);
        beta     = -1/(delta_x'*H*delta_x + reg);
        H_update = H + alpha * r * (r)' + beta * H * delta_x * (delta_x)' * H; 
    else
        switch method
            case 'BFGS'       
               r           = delta_g;
               alpha       = 1/(r'*delta_x + reg);
               beta        = -1/(delta_x'*H*delta_x + reg);
               H_update = H + alpha * r * (r)' + beta * H * delta_x * (delta_x)' * H; 
            case 'DBFGS'
               theta       = (1-epsilon)*(delta_x'*H*delta_x)/(delta_x'*H*delta_x - delta_g'*delta_x + reg);        
               r           = theta * delta_g + (1-theta) * H * delta_x;
               alpha       = 1/(epsilon*delta_x'*H*delta_x + reg);
               beta        = -1/(delta_x'*H*delta_x + reg);
               H_update = H + alpha * r * (r)' + beta * H * delta_x * (delta_x)' * H;          
        end 
    end
end

