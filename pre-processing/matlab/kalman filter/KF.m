classdef KF < handle
    properties(Access = public)
        X   % state vector
        a   % acceleration variance
        P   % covariance of state
        allX =[]
        allP= []
    end
    methods
        function predict(obj,dt)
            F = [1 0 dt 0;
                 0 1 0 dt;
                 0 0 1 0;
                 0 0 0 1];
            new_X = F*obj.X;
            G=transpose([0.5*dt^2, 0.5*dt^2, dt, dt]);
            new_P = (F*obj.P*transpose(F)) + (G*transpose(G)*obj.a);
            obj.P = new_P;
            obj.X= new_X;
            
        end
        function update(obj,Z,R)
            H = [1 0 0 0;
                0 1 0 0];
            %Z
            %R
            Y = Z-(H*obj.X);
            S = H*obj.P*transpose(H) + R;
            K= obj.P*transpose(H)*inv(S);
            new_X = obj.X + K*Y;
            new_P = (eye(4) -K*H)*obj.P; 
            obj.P = new_P;
            obj.X = new_X;
           
            obj.allX(length(obj.allX)+1,:) =  transpose(new_X) 
            %obj.allP(length(obj.allP)+1) =  transpose(new_P)
            
        end
        function initialize(obj, x, y, v_x, v_y, P,a,n)
            obj.X = transpose([x y v_x v_y])
            obj.P = P
            obj.a = a
            
            
        end
%         function increment(obj,inc)
%             obj.ctr = obj.ctr+inc;
%         end
%         function start(obj)
%             obj.ctr = 1;
%         end
    end
end  
        