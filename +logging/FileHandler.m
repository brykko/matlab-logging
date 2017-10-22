classdef FileHandler < logging.Handler
    %FILEHANDLER
    
    properties
        fileId
        fileIsOpen = false;
        appendToFile = true;
        filePath
        logger
    end

    methods
        
        function self = FileHandler(filePath, append)
            
            if nargin == 2, self.appendToFile = append; end
            
            % Get the root logger
            self.logger = logging.getLogger('');
            self.logger.level = logging.Level.VERBOSE;
            
            if ispc()
                self.newLineChar = sprintf('\r\n');
            else
                self.newLineChar = sprintf('\n');
            end
            
            className = class(self);
            self.logger.name = className;
            self.logger.v('Constructor');
            self.filePath = filePath;     
            self.open();
            
        end
        
        function emit(self, level, name, varargin)
            
            if level >= self.level
                % If file is closed (e.g. by user calling 'fclose all'),
                % then fprintf throws an exception.  If this happens, try
                % to reopen the file
                try
                    outputString = logging.helpers.standardLogString(level, name, varargin{:});
                    fprintf(self.fileId, '%s%s', outputString, self.newLineChar);
                catch ex
                    if strcmp(ex.identifier, 'MATLAB:FileIO:InvalidFid')
                        self.fileIsOpen = false;
                        self.open();
                    else
                        ex.rethrow();
                    end
                end
            end
            
        end
        
        function emitFromLoggable(self, loggable)
            
            if loggable.level >= self.level
                % If file is closed (e.g. by user calling 'fclose all'),
                % then fprintf throws an exception.  If this happens, try
                % to reopen the file
                try
                    outputString = loggable.makeLogString(self.newLineChar);
                    fprintf(self.fileId, '%s%s', outputString, self.newLineChar);
                catch err
                    % Send a warning that we couldn't write to the log file
                    warning( ...
                        'logging:fileHandlerEmitFailed', ...
                        'Failed to write to log file, exception message: "%s"', ...
                        err.message)
                    
                    if strcmp(err.identifier, 'MATLAB:FileIO:InvalidFid')
                        self.fileIsOpen = false;
                        self.open();
                    end
                    
                end
            end
            
        end
        
        function close(self)
            if self.fileIsOpen
                try
                    fclose(self.fileId);
                    self.fileIsOpen = false;
                    self.logger.i('Closed log file "%s"', self.filePath);
                catch ex
                    self.logger.e(ex.message);
                end
            end
        end
        
        function open(self, append)
            
            if nargin == 1, append = self.appendToFile; end

            if ~self.fileIsOpen
                if append, mode = 'A'; else, mode = 'W'; end
                self.logger.i('Opening file "%s", append=%u', self.filePath, append);
                try
                    [self.fileId, msg] = fopen(self.filePath, mode);
                    if self.fileId == -1
                        self.logger.e('Failed to open log file "%s", message "%s"', self.filePath, msg);
                    else
                        self.fileIsOpen = true;
                        self.logger.i('Opened log file "%s"', self.filePath);
                    end
                catch err
                    self.logger.e(err.message);
                end
            end
        end
        
        function flush(self)
            % Flush the write buffer by closing and reopening in append mode
            self.logger.i('Flushing buffer');
            self.close();
            self.open(true);
        end
        
    end
    
end

