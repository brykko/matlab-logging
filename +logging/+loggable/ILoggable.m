classdef (Abstract) ILoggable < handle
    %ILOGGABLE simple interface for objs that generate a log record
    %
    % A logger will accept any object that implements this interface
    
    properties (Abstract)
        % LEVEL - loggable events must define a level for filtering
        level
    end
    
    methods (Abstract)
        % MAKELOGSTRING - method used by handlers to generate the message
        %
        % Handlers will call the MAKELOGSTRING method to generate a 
        % complete formatted string that can be printed directly to the
        % handler output stream. This is in contrast with the normal
        % handler behaviour of assembling a log string from multiple
        % components.
        logStr = makeLogString(self, newLineChars)
    end
    
end

