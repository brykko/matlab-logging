function name = buildStackName(stack)
%BUILDSTACKNAME constructs a logger name from the function call stack

if isempty(stack)
    name = 'MatlabCommandWindow';
else
    name = stack(1).name;
    for i = length(stack)-1 : -1 : 1
        name = [name '>' stack(i).name];
    end
end

end

