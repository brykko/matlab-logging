function str = buildStackTraceString(stack, newLineChar)
%BUILDSTACKTRACESTRING takes a function call stack (as a structure, as
%stored in an MException object) and creates a multi-line string for
%logging Handler output.

MAX_ALLOWED_NAME_LENGTH = 70;
MAX_ALLOWED_FILE_LENGTH = 40;

stackSize = length(stack);

if isempty(stack)
    str = 'Matlab Command Window';
    return
end

str = ['<Begin stack trace>' newLineChar];

tab = sprintf('\t');

maxNameLength = 0;
maxFileLength = 0;

for s = 1:stackSize
    if length(stack(s).name) > maxNameLength
        maxNameLength = length(stack(s).name);
    end
    if length(stack(s).file) > maxFileLength
        maxFileLength = length(stack(s).file);
    end
end

maxNameLength = min(maxNameLength + 8, MAX_ALLOWED_NAME_LENGTH);
maxFileLength = min(maxFileLength + 16, MAX_ALLOWED_FILE_LENGTH);

for s = 1:stackSize
    
    % Build the name and line number strings
    strName = stack(s).name;            
    strLine = sprintf('at line %u', stack(s).line);
    
    % Build the file string
    [~, fn, ext] = fileparts(stack(s).file);
    strFile = [fn ext];
    strFile = sprintf('in file "%s"', strFile);
    
    if ispc
        strFile = strrep(strFile, '\', '\\');
    end
    
    strings = {strName, strFile, strLine};
    
    line = logging.helpers.buildPaddedString(strings, [maxNameLength maxFileLength 20], 'fit');
    
    str = [str tab line newLineChar];
    
end

str = [str '<End stack trace>' newLineChar];

end

