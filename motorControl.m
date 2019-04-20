classdef motorControl < handle
    %MOTORCONTROL Handles motor control
    %   Initialisation of motors, and sending and receiving commands
    
    properties
        BAUDRATE
        DEVICENAME
        port_num
        
        lib_name
        notfound
        warnings
   
        motor1                  %XL430
        motor1_ID       = 1;
        motor2                  %XL430
        motor2_ID       = 2;
        motor3                  %XL430
        motor3_ID       = 3;
        motor4                  %XL320
        motor4_ID       = 4;
        motor5                  %XL320
        motor5_ID       = 5;
        motorE                  %XL320
        motorE_ID       = 6;
    end
    
    methods
        function obj = motorControl()
            %MOTORCONTROL Construct an instance of this class
            %   Detailed explanation goes here
            obj.startConnection();
            obj.startMotors();
        end
        
        function startConnection(obj)
            %% Load Libraries
            obj.lib_name = '';
            
            if strcmp(computer, 'PCWIN')
                obj.lib_name = 'dxl_x86_c';
            elseif strcmp(computer, 'PCWIN64')
                obj.lib_name = 'dxl_x64_c';
            elseif strcmp(computer, 'GLNX86')
                obj.lib_name = 'libdxl_x86_c';
            elseif strcmp(computer, 'GLNXA64')
                obj.lib_name = 'libdxl_x64_c';
            elseif strcmp(computer, 'MACI64')
                obj.lib_name = 'libdxl_mac_c';
            end
            
            % Load Libraries
            if ~libisloaded(obj.lib_name)
                [obj.notfound, obj.warnings] = loadlibrary(obj.lib_name, 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h');
            end
       

            %% Open Port and set Baud Rate
            obj.BAUDRATE = 57600; % 1000000
            obj.DEVICENAME = 'COM3';
            
            % Initialize PortHandler Structs
            % Set the port path
            % Get methods and members of PortHandlerLinux or PortHandlerWindows
            obj.port_num = portHandler(obj.DEVICENAME);
            
            % Initialize PacketHandler Structs
            packetHandler();
            
            % Open port
            if (openPort(obj.port_num))
                fprintf('Succeeded to open the port!\n');
            else
                unloadlibrary(obj.lib_name);
                fprintf('Failed to open the port!\n');
                input('Press any key to terminate...\n');
                return;
            end
            % Set port baudrate
            if (setBaudRate(obj.port_num, obj.BAUDRATE))
                fprintf('Succeeded to change the baudrate!\n');
            else
                unloadlibrary(obj.lib_name);
                fprintf('Failed to change the baudrate!\n');
                input('Press any key to terminate...\n');
                return;
            end
            
            % Initialize PacketHandler Structs
            packetHandler();
        end
        
        function startMotors(obj)
            obj.motor1 = XL430(obj.motor1_ID,obj.port_num, 0, 360);
            obj.motor2 = XL430(obj.motor2_ID,obj.port_num, 0, 360);
            obj.motor3 = XL430(obj.motor3_ID,obj.port_num, 0, 360);
%             obj.motor4 = XL320(obj.motor4_ID,obj.port_num, 0, 300);
%             obj.motor5 = XL320(obj.motor5_ID,obj.port_num, 0, 300);
%             obj.motorE = XL320(obj.motorE_ID,obj.port_num, 0, 300);
        end
        
        function enableTorque(obj)
            obj.motor1.torqueEnable;
%             obj.motor2.torqueEnable;
%             obj.motor3.torqueEnable;
%             obj.motor4.torqueEnable;
%             obj.motor5.torqueEnable;
%             obj.motorE.torqueEnable;
        end
        
        function endConnection(obj)
            obj.motor1.torqueDisable;
            obj.motor2.torqueDisable;
            obj.motor3.torqueDisable;
%             obj.motor4.torqueDisable;
%             obj.motor5.torqueDisable;
%             obj.motorE.torqueDisable;
            
            % Close port
            calllib(obj.lib_name, 'closePort', obj.port_num);

            % Unload Library
            unloadlibrary(obj.lib_name);
        end
        
        function setAngles(obj,q1,q2,q3,q4,q5)
            obj.motor1.setPos(q1);
            obj.motor2.setPos(q2);
            obj.motor3.setPos(q3);
            obj.motor4.setPos(q4);
            obj.motor5.setPos(q5);
        end
    end
     
end

