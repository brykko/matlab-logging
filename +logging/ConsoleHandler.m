classdef ConsoleHandler < logging.Handler
    %CONSOLEHANDLER
    
    properties
        useColors (1,1) logical = false
    end
    
    methods
        
        function self = ConsoleHandler()
            self@logging.Handler();
            self.newLineChar = sprintf('\n');
        end
        
        % Basic emit method
        function emit(self, level, name, varargin)
            import logging.Level
            levelName = Level.getName(level);
            levelColor = Level.getColor(levelName);
            if level >= self.level
                outputString = logging.helpers.standardLogString(level, name, varargin{:});
                outputString = [outputString self.newLineChar];
                if self.useColors
                    logging.helpers.printColor(outputString, levelColor);
                else
                    fprintf('%s', outputString);
                end
            end
        end
        
        % Modified method taking Loggable arg
        function emitFromLoggable(self, loggable)
            import logging.Level
            
            level = loggable.level;
            levelName = Level.getName(level);
            levelColor = Level.getColor(levelName);
            
            if level >= self.level
                outputString = loggable.makeLogString(self.newLineChar);
                outputString = strrep(outputString, sprintf('\r\n'), self.newLineChar);
                outputString = [outputString self.newLineChar];
                if self.useColors
                    logging.helpers.printColor(outputString, levelColor);
                else
                    fprintf('%s%s', outputString);
                end
            end
            
        end
        
        function close(self)
        end
        
        function flush(self)
        end
        
    end
    
end