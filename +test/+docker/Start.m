classdef Start < matlab.unittest.TestCase
    
    methods(TestClassSetup)
        function getArchLinuxImage(~)
            docker.pull("archlinux:latest");
        end
    end
         
    methods (Test)        
        
        function start_container(test) 
            docker.create("archlinux:latest","echo","Hello World","name","MyArchContainer");
            
            test.verifyEqual(docker.start("MyArchContainer","attach",true),"Hello World"+newline);            
            
            docker.rm("MyArchContainer");       
        end  
        
        function fail_when_container_does_not_exist(test)
            test.verifyError(@()docker.start("MyArchContainer"),"Docker:errorFromDockerCLI");
        end
                        
    end
end