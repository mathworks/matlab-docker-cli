function build(PATH,options)
%BUILD Build an image from a Dockerfile
%   The docker build command builds Docker images from a Dockerfile and a 
%   “context”. A build’s context is the set of files located in the 
%   specified PATH or URL.
%
%   Inputs:
%       PATH - Path to folder containing Dockerfile.       
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/build/  
%

% Copyright 2021 The MathWorks, Inc.  

arguments
    PATH (1,1) string {mustBeFolder}
    
    %% Image Properties
    options.label string {mustBeScalarOrEmpty} = string.empty();
    options.addhost string {mustBeScalarOrEmpty} = string.empty();
    options.buildarg string = string.empty();
    options.output string {mustBeScalarOrEmpty} = string.empty();
    options.tag string {mustBeScalarOrEmpty} = string.empty();
    options.file string {mustBeScalarOrEmpty} = string.empty();
    
    %% Build Progress Options    
    options.pull logical {mustBeScalarOrEmpty} = logical.empty();
    options.quiet logical {mustBeScalarOrEmpty} = logical.empty();
    options.rm logical {mustBeScalarOrEmpty} = logical.empty();
    options.forcerm logical {mustBeScalarOrEmpty} = logical.empty();       
    
end

flags = containers.Map(...
    ["label","addhost","buildarg","output","tag","file","pull","quiet","rm","forcerm"],...
    ["--label","--add-host","--build-arg","--output","--tag","--file","--pull","--quiet","--rm","--force-rm"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);

%% Run Command
command = "docker build";
if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
end
command = command + " " + PATH;

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,'%s',msgType));
end

disp(result);

end




