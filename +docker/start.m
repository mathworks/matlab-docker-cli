function out = start(CONTAINERS,options)
%START Start one or more stopped containers
%   Start one or more stopped containers.
%
%   Inputs:
%       CONTAINERS - |string| Name of docker containers.       
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/start/ 
%

% Copyright 2021 The MathWorks, Inc.  

arguments
    CONTAINERS (:,1) string
    
    %% Start Options
    options.attach logical {mustBeScalarOrEmpty} = logical.empty();
    
end

flags = containers.Map("attach","--attach");

OPTIONS = docker.internal.optionToStringMap(flags,options);


%% Run Command
command = "docker start";

if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
end

for container = CONTAINERS
    command = command + " " + container;
end

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

out = string(result);

end