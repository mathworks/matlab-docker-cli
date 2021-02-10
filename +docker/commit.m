function commit(CONTAINER,REPOSITORY,options)
%COMMIT Create a new image from a container’s changes
%   It can be useful to commit a container’s file changes or settings into 
%   a new image. This allows you to debug a container by running an 
%   interactive shell, or to export a working dataset to another server. 
%   Generally, it is better to use Dockerfiles to manage your images in a 
%   documented and maintainable way.
%
%   Inputs:
%       CONTAINER - Name of container.
%       REPOSITORY - Name of the repository. If no repository is required,
%       set to string.empty().
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/commit/  
%

% Copyright 2021 The MathWorks, Inc.  

arguments
    CONTAINER (1,1) string
    REPOSITORY string {mustBeScalarOrEmpty}
    
    options.author string {mustBeScalarOrEmpty} = string.empty();
    options.change string {mustBeScalarOrEmpty} = string.empty();
    options.message string {mustBeScalarOrEmpty} = string.empty();
    options.pause logical {mustBeScalarOrEmpty} = logical.empty();
end

flags = containers.Map(...
    ["author","change","message","pause"],...
    ["--author","--change","--message","--pause"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);

%% Run Command
if isempty(OPTIONS)
    command = "docker commit " + CONTAINER;
else
    command = "docker commit " + OPTIONS + " " + CONTAINER + " " + REPOSITORY;
end

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

disp(result);

end
