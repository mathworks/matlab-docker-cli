function rename(CONTAINER,NEWNAME)
%RENAME Rename a container
%   Rename a container
%
%   Inputs:
%       CONTAINER - Name of docker container.       
%       NEWNAME - New name for container.
%

% Copyright 2021 The MathWorks, Inc.  

arguments
    CONTAINER (1,1) string    
    NEWNAME (1,1) string
end

%% Run Command
command = "docker rename " + CONTAINER + " " + NEWNAME;

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

end