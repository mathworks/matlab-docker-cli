function out = exec(CONTAINER,COMMAND,ARG,options)
%EXEC Run a command in a running container
%   The docker exec command runs a new command in a running container. The 
%   command started using docker exec only runs while the container’s 
%   primary process (PID 1) is running, and it is not restarted if the 
%   container is restarted.
%   COMMAND will run in the default directory of the container. If the 
%   underlying image has a custom directory specified with the WORKDIR 
%   directive in its Dockerfile, this will be used instead.
%   COMMAND should be an executable, a chained or a quoted command will not 
%   work.
%
%   Inputs:
%       CONTAINER - Name of container.     
%
%       COMMAND - Command to run in container. If no argument is required, 
%       set to string.empty().
%       ARG - Command argument. If no argument is required, set to 
%       string.empty(). If no COMMAND argument is provided, the ARG
%       argument gets ignored.
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/exec/  
%

% Copyright 2021 The MathWorks, Inc.

arguments
    CONTAINER (1,1) string;
        
    %% Commands
    COMMAND string {mustBeScalarOrEmpty};
    ARG string {mustBeScalarOrEmpty};
    
    %% Container Properties
    options.workdir string {mustBeScalarOrEmpty} = string.empty();
    options.env string = string.empty();    
    options.envfile string {mustBeScalarOrEmpty} = string.empty();
    
end

flags = containers.Map(...
    ["workdir","env","envfile"],...
    ["--workdir","--env","--env-file"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);


%% Run Command
command = "docker exec";

if ~isempty(OPTIONS)
    command = command + " " + OPTIONS; 
end

command = command + " " + CONTAINER;

if ~isempty(COMMAND)
    command = command + " " + COMMAND;
    if ~isempty(ARG)
        command = command + " " + ARG;
    end
end

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

out = string(result);

end

