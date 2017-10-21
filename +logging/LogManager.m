classdef LogManager < handle
    %LOGMANAGER single-instance manager for all log handlers
    
    properties (Constant)
        
        ROOT_LOGGER_LOGGING_LEVEL           = logging.Level.ALL;
        ROOT_CONSOLE_HANDLER_LOGGING_LEVEL  = logging.Level.INFO;
        LOGGER_LOGGING_LEVEL                = logging.Level.VERBOSE;
        
        USE_PARENT_HANDLERS = true;
        USE_STACK_CALL_NAME = false;
        
    end
    
    properties
        loggerMap
    end
    
    methods (Access = private)
        function self = LogManager()
            self.loggerMap = containers.Map();
        end
    end
    
    methods (Static)
        
        function self = getInstance()
            %GETINSTANCE - return singleton
            persistent instance
            if isempty(instance)
                self = logging.LogManager();
                instance = self;
                self.createRootLogger();
            else
                self = instance;
            end
        end
        
        function createRootLogger()
            
            import logging.*
            
            rootConsoleHandler = ConsoleHandler();
            rootConsoleHandler.level = LogManager.ROOT_CONSOLE_HANDLER_LOGGING_LEVEL;
            rootConsolehandler.sticky = true;
            
            rootLogger = logging.getLogger('');
            rootLogger.level = LogManager.ROOT_LOGGER_LOGGING_LEVEL;
            rootLogger.addHandler(rootConsoleHandler);
            
        end
        
    end
    
    methods
        
        function logger = getLogger(self, name)
            %GETLOGGER returns handle to named Logger, or empty array if not found.
            % Java: matching logger or null if none is found
            %
            if ~self.loggerMap.isKey( name )
                logger = [];
            else
                logger = self.loggerMap( name );
            end
        end
        
        function success = addLogger(self, logger)
            %ADDLOGGER  Logger class will call this method to add a new Logger object to LogManager.
            % Java:  Add a named logger.  This does nothing and returns false if a logger with the same name is already registered.
            if ~self.loggerMap.isKey(logger.name)
                % add to map
                self.loggerMap(logger.name) = logger;
                success = true;
            else
                success = false;
            end
        end
        
        function reset(self)
            %RESET  close and remove handlers.
            % Each logger will instruct its registerd handlers to close().
            % Each logger will remove any registered handlers that are not "sticky" (e.g. root console handler).
            
            keys = self.loggerMap.keys();
            for key = keys
                logger = self.loggerMap( key{1} );
                logger.reset();
            end
            
        end
        
        function resetAll(self)
            %RESETALL close and remove handlers, remove loggers, reset root logger and root console handler logging levels.
            % Logger reset:
            %   Each logger will instruct its associated handlers to close().
            %   Each logger will remove any handlers that are not "sticky" (e.g. root console handler).
            % Delete loggers (except the root logger).
            % Set the root logger back to its default logging level.
            % Set the root console handler back to its default logging level.
            import logging.LogManager
            
            keys = self.loggerMap.keys();
            for key = keys
                logger = self.loggerMap( key{1} );
                logger.reset();
                if ~strcmp(logger.name, '')
                    %delete( obj.loggerMap(key{1}) );
                    self.loggerMap.remove( key{1} );
                else
                    logger.level = LogManager.ROOT_LOGGER_LOGGING_LEVEL;
                    % get handle to the root console handler and restore its default logging level
                    consoleHandlers = logger.getHandlers('logging.ConsoleHandler');
                    consoleHandlers{1}.level = LogManager.ROOT_CONSOLE_HANDLER_LOGGING_LEVEL;
                end
            end
        end
        
        function keys = getLoggerNames(self)
            %GETLOGGERNAMES returns cell array of Logger registered names.
            keys = self.loggerMap.keys();
        end
        
        function printLoggers(self)
            %PRINTLOGGERS prints table of loggers and associated handlers.
            
            import logging.Level
            
            fprintf('\n');
            fprintf('--- LogManager table ---\n');
            
            loggerNames = self.loggerMap.keys();
            for loggerName = loggerNames
                logger = self.loggerMap( loggerName{1} );
                if strcmp( logger.name, '' )
                    indent = 0;
                else
                    indent = 2;
                end
                
                for i = 1:indent
                    fprintf(' ');
                end
                
                if logger.useParentHandlers
                    useParentLogger = 'Y';
                else
                   useParentLogger = 'N';
                end
                
                fprintf( '+ LOGGER ''%s'' %s [%s]\n', logger.name, Level.getName(logger.level), useParentLogger );
                
                handlers = logger.getHandlers();
                for handler = handlers
                    for i = 1:indent
                        fprintf(' ');
                    end
                    fprintf( '    HANDLER %s %s\n', class(handler{1}), Level.getName(handler{1}.level) );
                end
            end
            fprintf('\n');
        end
        
    end
    
    
end

