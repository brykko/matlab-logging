function outputString = standardLogString(level, name, varargin)
%STANDARDLOGSTRING generates the standard formatted log string

timeStr = logging.helpers.dateStrFast(now());
levelStr = logging.Level.getShortName(level);
nameStr =  name;
messageStr = sprintf(varargin{:});

substrings = {timeStr, levelStr, nameStr, messageStr};
substringLengths = [14 5 30 0];
overflowModes = {'none', 'none', 'trim', 'fit'};

outputString = logging.helpers.buildPaddedString( ...
    substrings, ...
    substringLengths, ...
    overflowModes);
end