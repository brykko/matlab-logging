function printColor(str, col)
% PRINTCOLOR - print colored text to console, context sensitive.
%
% If using MATLAB desktop, the java-dependent cprintf function is used.
% Inside a UNIX terminal, ANSI color-codes are used instead.

if matlab.internal.display.isHot
    % Full java display: use cprintf
    logging.helpers.cprintf(col, '%s', str);
elseif isunix()
    % Unix terminal: use ANSI codes
    col = floor(col*255);
    fprintf('\033[38;2;%u;%u;%um%s\033[0m', col(1), col(2), col(3), str);
else
    % Default to standard output
    fprintf('%s', str);
end