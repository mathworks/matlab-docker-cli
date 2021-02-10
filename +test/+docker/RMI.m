classdef RMI < matlab.unittest.TestCase
         
    methods (Test)
        function pull_and_remove_image(test)            
            docker.pull("archlinux:latest");            
            numberOfImages = docker.info().Images;            
            test.verifyWarningFree(@()docker.rmi("archlinux:latest"));            
            test.verifyEqual(docker.info().Images,numberOfImages - 1);
            test.verifyEmpty(docker.images("archlinux:latest"));
        end
        
        function pull_and_remove_image_w_force(test)            
            docker.pull("archlinux:latest");            
            numberOfImages = docker.info().Images;            
            test.verifyWarningFree(@()docker.rmi("archlinux:latest","force",true));            
            test.verifyEqual(docker.info().Images,numberOfImages - 1);
            test.verifyEmpty(docker.images("archlinux:latest"));
        end
        
        function fail_to_remove_nonexistent_image(test)
            test.verifyError(@()docker.rmi("archlinux:latest"),"Docker:errorFromDockerCLI");
        end     
    end
end