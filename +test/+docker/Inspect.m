classdef Inspect < matlab.unittest.TestCase
      
    methods(TestClassSetup)
        function getArchLinuxImage(~)
            docker.pull("archlinux:latest");
        end
    end    
    
    methods (Test)  
        function error_when_object_not_present(test)
            test.verifyError(@()docker.inspect("Bogus"),"Docker:errorFromDockerCLI");            
        end
        
        function information_returned_as_struct(test)            
            test.verifyInstanceOf(docker.inspect("archlinux:latest"),"struct"); 
        end
        
    end
end