classdef ExceptionLoggable < logging.loggable.Loggable
    %EXCEPTIONLOGGABLE extends the Loggable event class to describe an
    %exception.
    
    properties
        exception
        wasCaught = false;
    end
    
    methods
        
        function self = ExceptionLoggable(level, source, stack, exception)
            
            self@logging.loggable.Loggable(level, source, '')
            
            % Set subclass-specific props
            self.exception = exception;
            self.stack = stack;
            
            % Create exception-specific message
            self.generateMessage();
            
        end
        
        function set.wasCaught(self, value)
            assert(islogical(value) && isscalar(value), 'Value for property "wasCaught" must be scalar logical')
            % Message must be updated
            self.generateMessage();
        end
        
    end
    
    methods (Access = protected)
        
        % Instead of the user specifying a message, a standard exception
        % message is automatically created here, using the informationg in
        % the supplied call stack and MException
        function generateMessage(self)
            
            if isempty(self.stack)
                callerName = 'MatlabCommandWindow';
            else
                callerName = self.stack(1).name;
                callerLine = self.stack(1).line;
                callerFile = self.stack(1).file;
            end
            
            exceptionId = self.exception.identifier;
            exceptionMessage = self.exception.message;
            
            if self.wasCaught
                wasCaughtStr = ' caught';
            else
                wasCaughtStr = '';
            end
            
            if isempty(self.stack)
                self.message = sprintf('Exception%s in "MatlabCommandWindow"; ID "%s"; message "%s"',...
                    wasCaughtStr, callerName, exceptionId, exceptionMessage);  
            else
                self.message = sprintf('Exception%s in "%s" in file "%s" line %u; ID "%s"; message "%s"',...
                    wasCaughtStr, callerName, callerFile, callerLine, exceptionId, exceptionMessage);
            end
        end
        
    end
end

