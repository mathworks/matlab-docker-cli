classdef Pull < matlab.unittest.TestCase
    
    methods (Test)        
        
        function pull_and_remove_image(test)   
            test.verifyWarningFree(@()docker.pull("archlinux:latest"));            
            test.verifyNotEmpty(docker.images("archlinux:latest"));            
            docker.rmi("archlinux:latest");
        end
        
        function pull_and_remove_image_w_option(test)   
            test.verifyWarningFree(@()docker.pull("archlinux:latest","quiet",true));            
            test.verifyNotEmpty(docker.images("archlinux:latest"));            
            docker.rmi("archlinux:latest");
        end
        
        function fail_to_remove_nonexistent_image(test)
            test.verifyError(@()docker.pull("foobar:baz"),"Docker:errorFromDockerCLI");
        end     
                
    end
end