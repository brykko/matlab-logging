classdef (Abstract) Handler < handle
    %HANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        level = logging.Level.OFF;
        sticky = false;
        
        % Customization which if 'true' causes the handler to print the
        % identity of the BaseClass object logging the event.
        printBaseClassSourceObject = true;
        printExceptionStackTrace = true;
        
        newLineChar
    end
    
    methods (Abstract)
        emit(self, level, name, varargin);
        emitFromLoggable(self, loggable);
        close(self);
        flush(self);
    end
    
end

