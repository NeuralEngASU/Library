classdef Vicon < handle
    properties
        m_udp;
        pointsMat;
        oldPoints;
    end % END PROPERTIES
    
    methods
        function m_obj = Vicon()
        end % END FUNCTION
        function GetPoints(obj)
            
            obj.pointsMat = zeros(5,4);
        end % END FUNCTION
        
        function init(obj)
            obj.pointsMat = zeros(5,4);
            obj.oldPoints = zeros(5,4);
%             m_udp = 
        end % END FUNCTION
    end % END METHODS
end % END CLASS
% EOF