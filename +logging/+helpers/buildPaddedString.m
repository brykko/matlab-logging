function str = buildPaddedString(substrings, paddedLengths, overflowMode)
%BUILDPADDEDSTRING builds a string from substrings, each of which is padded
%with white space to a specified length

numSubstrings = numel(substrings);

assert(isa(substrings, 'cell'), 'Argument "substrings" must be a cell array')

assert(numSubstrings == numel(paddedLengths), ...
    'Length of "substrings" array and "paddedLength" vector must match');

if ~iscell(overflowMode)
    overflowMode = {overflowMode};
end

if numel(overflowMode) == 1
    overflowMode = repmat(overflowMode, size(substrings));
else
    assert(isequal(size(overflowMode), size(substrings)), ...
        'Argument "overflowMode" must be a char string or a cell array of strings equal in size to argument "substrings"');
end

str = [];

for s = 1:numSubstrings
    
    substr = substrings{s};
    nPad = paddedLengths(s) - length(substr);
    
    if nPad > 0
        substr = [substr blanks(nPad)];
    else
        % Overflow mode is 'none': error
        if strcmpi(overflowMode{s}, 'none')
            error('Substring #%u "%s" overflowed padded length of %u', s, substr, paddedLengths(s))
        elseif strcmpi(overflowMode{s}, 'trim')
        % Overflow mode is 'trim': truncate the substring. The truncated
        % substring will be 1 character shorter than the requested padded
        % length, with a white space appended to the end to separate it
        % from the following substring
            substr = [substr(1: paddedLengths(s)-1) ' '];
        end
    end
    
    str = [str substr];
    
end


end

