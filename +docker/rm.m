function rm(CONTAINERS,options)
%RM Remove one or more containers
%   Remove one or more containers.
%
%   Inputs:
%       CONTAINERS - Name of docker containers.       
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/rm/  
%

% Copyright 2021 The MathWorks, Inc.  

arguments
    CONTAINERS (:,1) string
    
    %% Removal Options
    options.force logical {mustBeScalarOrEmpty} = logical.empty();
    options.volumes string = string.empty();
    
end

flags = containers.Map(...
    ["force","volumes"],...
    ["--force","--volumes"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);


%% Run Command
command = "docker rm";

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

end