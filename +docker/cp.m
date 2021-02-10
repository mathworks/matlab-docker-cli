function cp(SRC_PATH,DEST_PATH,options)
%CP Copy files/folders between a container and the local filesystem
%   The docker cp utility copies the contents of SRC_PATH to the DEST_PATH.
%   You can copy from the container’s file system to the local machine or 
%   the reverse, from the local filesystem to the container.
%
%   Inputs:
%       SRC_PATH - Source file path. If the source path is on the host, 
%       then provide the path as normal as a string. If the source path is
%       in the container, then list the path as <CONTAINER>:<path>. For
%       example, "MyContainer:/usr/var/myfile.txt".
%
%       DEST_PATH - Destination file path. If the destination path is on 
%       the host, then provide the path as normal as a string. If the 
%       destination path is in the container, then list the path as 
%       <CONTAINER>:<path>. For example, "MyContainer:/usr/temp".
%
%       OPTIONS - Use the options provided as strings or logicals. The 
%       values for the options are described in detail on
%       https://docs.docker.com/engine/reference/commandline/cp/  
%

% Copyright 2021 The MathWorks, Inc.   

arguments
    SRC_PATH (1,1) string
    DEST_PATH (1,1) string
    
    options.archive logical {mustBeScalarOrEmpty} = logical.empty();
    options.followlink logical {mustBeScalarOrEmpty} = logical.empty();
end

flags = containers.Map(...
    ["archive","followlink"],...
    ["--archive","--follow-link"]);

OPTIONS = docker.internal.optionToStringMap(flags,options);

%% Run Command
command = "docker cp";
if ~isempty(OPTIONS)
    command = command + " " + OPTIONS;
end
command = command + " " + SRC_PATH + " " + DEST_PATH;


[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

disp(result);

end
