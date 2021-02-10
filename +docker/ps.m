function out = ps(options)
%PS List containers and information
%   List containers and information
%
%   Inputs:
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/ps/  
%

% Copyright 2021 The MathWorks, Inc.

arguments
    options.latest logical {mustBeScalarOrEmpty} = logical.empty();
    options.last logical {mustBeScalarOrEmpty} = logical.empty();
    options.size logical {mustBeScalarOrEmpty} = logical.empty();
    options.notrunc logical {mustBeScalarOrEmpty} = logical.empty();
    options.quiet logical {mustBeScalarOrEmpty} = logical.empty();
    options.all logical {mustBeScalarOrEmpty} = logical.empty();
end

flags = containers.Map(...
    ["latest","last","size","notrunc","quiet","all"],...
    ["--latest","--last","--size","--no-trunc","--quiet","--all"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);


%% Run Command
command = "docker ps --format ""{{json .}}""";

if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
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