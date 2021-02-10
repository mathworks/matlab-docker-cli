function create(IMAGE,COMMAND,ARG,options)
%CREATE Create a new container
%   The docker create command creates a writeable container layer over the 
%   specified image and prepares it for running the specified command. The 
%   container ID is then printed to STDOUT.
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
    
    %% Setup and Cleanup Options    
    options.pull {mustBeMember(options.pull,["always","missing","never"])} = "missing";    
    options.rm logical {mustBeScalarOrEmpty} = logical.empty();     
    
end

flags = containers.Map(...
    ["label","name","addhost","publish","pull","rm"],...
    ["--label","--name","--add-host","--publish","--pull","--rm"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);


%% Run Command
command = "docker create"; 
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

disp(result);

end

