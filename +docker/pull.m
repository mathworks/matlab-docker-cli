function pull(NAME,options)
%PULL Pull an image or a repository from a registry
%   Most of your images will be created on top of a base image from the 
%   Docker Hub registry. Docker Hub contains many pre-built images that you 
%   can pull and try without needing to define and configure your own. To 
%   download a particular image, or set of images (i.e., a repository), 
%   use docker.pull.
%
%   Inputs:
%       NAME - Name of docker image NAME[:TAG|@DIGEST].       
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/pull/  
%

% Copyright 2021 The MathWorks, Inc.  

arguments
    NAME (1,1) string;
      
    %% Pull Options    
    options.alltags logical {mustBeScalarOrEmpty} = logical.empty();
    options.quiet logical {mustBeScalarOrEmpty} = logical.empty();
    options.disablecontenttrust logical {mustBeScalarOrEmpty} = logical.empty();
    
end

flags = containers.Map(...
    ["alltags","quiet","disablecontenttrust"],...
    ["--all-tags","--quiet","--disable-content-trust"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);

%% Run Command
command = "docker pull";
if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
end
command = command + " " + NAME;

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

disp(result);

end