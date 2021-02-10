function out = inspect(NAME)
%INSPECT Return low-level information on Docker objects
%   Docker inspect provides detailed information on constructs controlled 
%   by Docker.
%
%   Inputs:
%       NAME - Name of docker object. 
%

% Copyright 2021 The MathWorks, Inc.

arguments
    NAME string;
end


%% Run Command
command = "docker inspect --format ""{{json .}}"" " + NAME;

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

result = string(result);
result = splitlines(result);
result = result(1:end-1);

for i = 1:length(result)
    out(i) = jsondecode(result(i));
end

end