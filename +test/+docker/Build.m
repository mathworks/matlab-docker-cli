classdef Build < matlab.unittest.TestCase
         
    methods (Test)        
        
        function build_image_from_dockerfile(test)
            [filepath,~,~] = fileparts(mfilename('fullpath'));
            
            test.verifyEmpty(docker.images("myimage:latest")); 
            test.verifyWarningFree(@()docker.build(filepath,"tag","myimage:latest"));
            test.verifyNotEmpty(docker.images("myimage:latest"));
            
            docker.rmi("myimage:latest");            
        end
        
        function error_when_no_dockerfile(test)
            [filepath,~,~] = fileparts(mfilename('fullpath'));
            
            test.verifyError(@()docker.build(fullfile(filepath,'output')),'Docker:errorFromDockerCLI');
        end 
                        
    end
end