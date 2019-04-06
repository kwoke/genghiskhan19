classdef jengaMain
    %   JENGAMAIN Main Class for stacking a jenga tower
    %   Robot and tower objects are instantiated here. This class also
    %   controls user input to change tower location
    
    properties
        robot
        tower
        
        jengaX
        jengaY
        jengaTheta
    end
    
    methods
        function obj = jengaMain()
            %STACKJENGA Construct an instance of this class
            obj.robot = robot();
            obj.tower = jengaTower();
        end
        
        function stackTower(x,y,theta)
            %METHOD1 Stack tower at a particular location and orientation
            obj.jengaX = x;
            obj.jengaY = y; 
            obj.jengaTheta = theta; 
            
        end
    end
end

