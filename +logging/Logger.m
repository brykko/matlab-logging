classdef Logger < handle
    %LOGGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        handlers = {}
        level
        name
        parent
        useParentHandlers
        useStackCallName
    end
    
    methods (Access = private)
        
        function self = Logger()
            import logging.LogManager
            self.level = LogManager.LOGGER_LOGGING_LEVEL;
            self.useParentHandlers = LogManager.USE_PARENT_HANDLERS;
            self.useStackCallName = LogManager.USE_STACK_CALL_NAME;
        end
        
        function logm(self, stackIndex, level, varargin)
            
            if level >= self.level
                
                if self.useStackCallName
                    name = logging.helpers.buildStackName(dbstack(stackIndex));
                else
                    name = self.name;
                end
                
                for h = 1:numel(self.handlers)
                    if isa(varargin{1}, 'logging.ILoggable')
                        self.handlers{h}.emitFromLoggable(varargin{1})
                    else
                        self.handlers{h}.emit(level, name, varargin{:})
                    end
                end
                
                % Start with self and work up the tree
                logger = self;
                
                while ~isempty(logger.parent) && logger.useParentHandlers
                    % Continue up the tree
                    logger = logger.parent;
                    for h = 1:numel(logger.handlers)
                        if isa(varargin{1}, 'logging.loggable.ILoggable')
                            logger.handlers{h}.emitFromLoggable(varargin{1});
                        else
                            logger.handlers{h}.emit(level, name, varargin{:});
                        end
                    end
                end
                
            end
        end
        
    end
    
    methods
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%                LOGGING METHODS                    %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function reset(self)
            for h = numel(self.handlers) : -1 : 1
                handler = self.handlers{h};
                if ~handler.sticky
                    self.handlers(h, :) = [];
                    handler.close();
                    handler.delete();
                end
            end
        end
        
        function log(self, level, varargin)
            self.logm(2, level, varargin{:})
        end
        
        % METHOD FOR LOGGABLE OBJS (PREFERRED).
        % This allows Loggable objs to be passed straight to the handler,
        % which facilitates customization of log output.
        function logLoggable(self, loggable)
            self.logm(2, loggable.level, loggable)
        end
        
        % VERBOSE
        function v(self, varargin)
            self.logm(2, logging.Level.VERBOSE, varargin{:})
        end
        
        % INFO
        function i(self, varargin)
            self.logm(2, logging.Level.INFO, varargin{:})
        end
        
        % DEBUG
        function d(self, varargin)
            self.logm(2, logging.Level.DEBUG, varargin{:})
        end
        
        % WARNING
        function w(self, varargin)
            self.logm(2, logging.Level.WARNING, varargin{:})
        end
        
        % ERROR
        function e(self, varargin)
            self.logm(2, logging.Level.ERROR, varargin{:})
        end
        
        % FATAL ERROR
        function f(self, varargin)
            self.logm(2, logging.Level.FATAL, varargin{:})
        end
        
        function addHandler(self, handler)
            self.handlers{end+1, 1} = handler;
        end
        
        function handlers = getHandlers(self, varargin)
            
            if nargin == 1
                handlers = self.handlers;
            elseif nargin == 2
                handlerType = varargin{1};
                handlers = {};
                for h = 1:numel(self.handlers)
                    handler = self.handlers{h};
                    if isa(handler, handlerType)
                        handlers = [handlers; {handler}];
                    end
                end
            end
            
            if self.useParentHandlers && ~isempty(self.parent)
                handlers = [handlers; self.parent.getHandlers(varargin{:})];
            end
            
        end
        
    end
    
    methods (Static)
        
        function logger = getLogger(name)
            
            manager = logging.LogManager.getInstance();
    
            if nargin == 0
                name = logging.helpers.buildStackName(dbstack(1));
            end
            
            logger = manager.getLogger(name);
            
            if isempty(logger)
                logger = logging.Logger();
                logger.name = name;
                
                % If logger is not root, set parent as the root logger
                if ~strcmp(name, '')
                    logger.parent = manager.getLogger('');
                end
                
                % Register with the log manager
                manager.addLogger(logger);
            end
        end
        
    end
    
end

