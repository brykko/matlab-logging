function logger = getLogger(varargin)
%GETLOGGER returns the Logger instance for a class or function
%
% LOG = GETLOGGER(CLS) returns a Logger instance LOG for the class name
% specified by the string CLS.
%
% Repeated calls to GETLOGGER for the same string will always return
% the same Logger instance.

logger = logging.Logger.getLogger(varargin{:});

end

