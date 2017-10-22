classdef Level
    %LEVEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        FATAL       = 60;
        ERROR       = 50;
        WARNING     = 40;
        INFO        = 30;
        DEBUG       = 20;
        VERBOSE     = 10;
        
        OFF         = 255;
        ALL         = 0;
        
        COLORS      = struct( ...
            'FATAL',    [1.0 0.0 0.5], ...
            'ERROR',    [1.0 0.0 0.5], ...
            'WARNING',  [1.0 0.7 0.0], ...
            'INFO',     [0.0 1.0 0.0], ...
            'DEBUG',    [0.2 1.0 1.0], ...
            'VERBOSE',  [0.8 1.0 1.0], ...
            'ALL',      [0.0 0.0 0.0])
        
    end
    
    methods (Access = private)
        function self = Level()
        end
    end
    
    methods (Static)
        
        function str = getName(level)
            
            import logging.Level
            
            switch level
                case Level.FATAL,       str = 'FATAL';
                case Level.ERROR,       str = 'ERROR';
                case Level.WARNING,     str = 'WARNING';
                case Level.INFO,        str = 'INFO';
                case Level.DEBUG,       str = 'DEBUG';
                case Level.VERBOSE,     str = 'VERBOSE';
                case Level.OFF,         str = 'OFF';
                case Level.ALL,         str = 'ALL';
                    
                otherwise,              str = sprintf('CUSTOM(%d)', level);
            end
        end
        
        function col = getColor(level)
            import logging.Level
            
            switch level
                case Level.FATAL,       col = Level.COLORS.FATAL;
                case Level.ERROR,       col = Level.COLORS.ERROR;
                case Level.WARNING,     col = Level.COLORS.WARNING;
                case Level.INFO,        col = Level.COLORS.INFO;
                case Level.DEBUG,       col = Level.COLORS.DEBUG;
                case Level.VERBOSE,     col = Level.COLORS.VERBOSE;
                case Level.ALL,         col = Level.COLORS.ALL;
                    
                otherwise,              col = Level.COLORS.ALL;
            end
        end
        
        function str = getShortName(level)
            
            import logging.Level
            
            switch level
                case Level.FATAL,       str = '[F]';
                case Level.ERROR,       str = '[E]';
                case Level.WARNING,     str = '[W]';
                case Level.INFO,        str = '[I]';
                case Level.DEBUG,       str = '[D]';
                case Level.VERBOSE,     str = '[V]';
                    
                case Level.OFF,         str = 'OFF';
                case Level.ON,          str = 'ON';
                    
                otherwise,              str = sprintf('CUSTOM(%d)', level);
            end
        end
        
        function level = getLevel(name)
            %getLevel  Returns numeric logging level for corresponding string.
            
            import logging.Level
            
            switch name
                case 'FATAL',   level = Level.FATAL;
                case 'ERROR',   level = Level.ERROR;
                case 'WARNING', level = Level.WARNING;
                case 'INFO',    level = Level.INFO;
                case 'DEBUG',   level = Level.DEBUG;
                case 'VERBOSE', level = Level.VERBOSE;
                case 'OFF',     level = Level.OFF;
                case 'ALL',     level = Level.ALL;
                otherwise,      level = -1;
            end
        end
        
    end
    
end

