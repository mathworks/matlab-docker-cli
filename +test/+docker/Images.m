classdef Images < matlab.unittest.TestCase
    
    methods(TestClassSetup)
        function getArchLinuxImage(~)
            docker.pull("archlinux:latest");
        end
    end
    
    methods (Test)  
        function returns_empty_when_repo_does_not_exist(test)
            test.verifyEmpty(docker.images("ubuntu:latest"));            
        end
        
        function information_returned_as_struct(test)                 
            test.verifyNotEmpty(docker.images("archlinux:latest"));
            test.verifyInstanceOf(docker.images("archlinux:latest"),"struct");            
        end
        
        function filter_based_on_condition(test)            
            test.verifyEmpty(docker.images("archlinux:latest","filter","""dangling=true"""));            
        end
        
    end
end