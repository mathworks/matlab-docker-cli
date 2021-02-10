function out = search(TERM,options)
%SEARCH Search the Docker Hub for images
%   Search Docker Hub for images.
%
%   Inputs:
%       TERM - Term to search for on hub, e.g. "busybox".
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/search/  
%

% Copyright 2021 The MathWorks, Inc.   

arguments
    TERM (1,1) string;
    
    %% Image Properties
    options.filter string {mustBeScalarOrEmpty} = string.empty();
    options.notrunc logical {mustBeScalarOrEmpty} = logical.empty();
    options.limit {mustBeInRange(options.limit,1,100),mustBeInteger(options.limit)} = 25;
    
end

flags = containers.Map(...
    ["filter","limit","notrunc"],...
    ["--filter","--limit","--no-trunc"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);

%% Run Command
command = "docker search --format ""{{json .}}""";

if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
end

command = command + " " + TERM;

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