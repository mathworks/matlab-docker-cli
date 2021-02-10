function out = images(REPOSITORY,options)
%IMAGES List images
%   The default docker images will show all top level images, their 
%   repository and tags, and their size.
%
%   Inputs:
%       REPOSITORY - Name of image repository. 
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/images/  
%

% Copyright 2021 The MathWorks, Inc.

arguments
    REPOSITORY string {mustBeScalarOrEmpty};
    
    %% Image Properties
    options.all logical {mustBeScalarOrEmpty} = logical.empty();
    options.filter string = string.empty();
    options.notrunc logical {mustBeScalarOrEmpty} = logical.empty();
    options.quiet logical {mustBeScalarOrEmpty} = logical.empty();
    
end

flags = containers.Map(...
    ["all","filter","notrunc","quiet"],...
    ["--all","--filter","--no-trunc","--quiet"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);

%% Run Command
command = "docker images --format ""{{json .}}""";

if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
end

if ~isempty(REPOSITORY)
    command = command + " " + REPOSITORY;
end

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

if isempty(result)
   out = struct.empty(); 
end

result = string(result);
result = splitlines(result);
result = result(1:end-1);

for i = 1:length(result)
    out(i) = jsondecode(result(i));
end

end