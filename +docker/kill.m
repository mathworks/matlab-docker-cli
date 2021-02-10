function kill(CONTAINER,options)
%KILL List images
%   The default docker images will show all top level images, their 
%   repository and tags, and their size.
%
%   Inputs:
%       CONTAINER - Name of container. 
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/kill/  
%

% Copyright 2021 The MathWorks, Inc.

arguments
    CONTAINER (1,1) string
    
    %% Image Properties
    options.signal string {mustBeScalarOrEmpty} = string.empty();
    
end

flags = containers.Map("signal","--signal");

OPTIONS = docker.internal.optionToStringMap(flags,options);

%% Run Command
command = "docker kill";

if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
end

command = command + " " + CONTAINER;


[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

end