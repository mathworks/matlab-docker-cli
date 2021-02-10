function out = info
%INFO Display system-wide information
%   This command displays system wide information regarding the Docker 
%   installation. Information displayed includes the kernel version, number 
%   of containers and images. The number of images shown is the number of 
%   unique images. The same image tagged under different names is counted 
%   only once.

command = "docker info --format ""{{json .}}""";

[status,result] = system(command);
if status ~= 0
    eidType = 'Docker:errorFromDockerCLI';
    msgType = result;
    throwAsCaller(MException(eidType,msgType))
end

out = jsondecode(result);

end