function rmi(IMAGES,options)
%RMI Remove one or more images
%   Removes (and un-tags) one or more images from the host node. If an 
%   image has multiple tags, using this command with the tag as a parameter 
%   only removes the tag. If the tag is the only one for the image, both 
%   the image and the tag are removed. 
%   This does not remove images from a registry. You cannot remove an image 
%   of a running container unless you use the -f option.
%
%   Inputs:
%       CONTAINERS - Name of docker containers.       
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/rmi/  
%

% Copyright 2021 The MathWorks, Inc.  

arguments
    IMAGES (:,1) string
    
    %% Removal Options
    options.force logical {mustBeScalarOrEmpty} = logical.empty();
    options.noprune logical {mustBeScalarOrEmpty} = logical.empty();
    
end

flags = containers.Map(...
    ["force","noprune"],...
    ["--force","--no-prune"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);


%% Run Command
command = "docker rmi";

if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
end

for image = IMAGES
    command = command + " " + image;
end

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

end