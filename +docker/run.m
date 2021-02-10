function out = run(IMAGE,COMMAND,ARG,options)
%RUN Run a command in a new container
%   The docker run command first creates a writeable container layer over 
%   the specified image, and then starts it using the specified command. 
%   That is, docker run is equivalent to the API /containers/create then 
%   /containers/(id)/start. A stopped container can be restarted with all 
%   its previous changes intact using docker start.
%
%   Inputs:
%       IMAGE - Name of image.     
%
%       COMMAND - Command to run when container starts. If no argument is 
%       required, set to string.empty().
%       ARG -  Command argument. If no argument is required, set to string.empty().
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/create/  
%

% Copyright 2021 The MathWorks, Inc.  

arguments
    IMAGE (1,1) string;
        
    %% Commands
    COMMAND string {mustBeScalarOrEmpty};
    ARG string {mustBeScalarOrEmpty};
    
    %% Container Properties
    options.label string {mustBeScalarOrEmpty} = string.empty();
    options.name string {mustBeScalarOrEmpty} = string.empty();
    options.addhost string {mustBeScalarOrEmpty} = string.empty();
    options.publish string {mustBeScalarOrEmpty} = string.empty();
    options.detach logical {mustBeScalarOrEmpty} = logical.empty();
    
    %% Setup and Cleanup Options    
    options.pull {mustBeMember(options.pull,["always","missing","never"])} = "missing";    
    options.rm logical {mustBeScalarOrEmpty} = logical.empty();     
    
end

flags = containers.Map(...
    ["label","name","addhost","publish","pull","rm","detach"],...
    ["--label","--name","--add-host","--publish","--pull","--rm","--detach"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);


%% Run Command
command = "docker run";
if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
end

command = command + " " + IMAGE;
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

