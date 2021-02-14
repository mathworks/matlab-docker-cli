classdef Rename < matlab.unittest.TestCase
    
    methods(TestClassSetup)
        function getArchLinuxImage(~)
            docker.pull("archlinux:latest");
        end
    end
    
    methods(TestMethodTeardown)
        function containerCleanup(~)
            docker.rm("MyArchContainer","force",true);
        end
    end
         
    methods (Test)        
        
        function rename_container(test) 
            docker.create("archlinux:latest","echo","Hello World","name","MyArchContainer");
            
            test.verifyWarningFree(@()docker.rename("MyArchContainer","MyRenamedContainer"));            
            
            docker.rm("MyRenamedContainer");   
        end  
        
        function fail_when_container_does_not_exist(test)
            test.verifyError(@()docker.rename("MyNonExistentContainer","MyRenamedContainer"),"Docker:errorFromDockerCLI");
        end
                        
    end
end