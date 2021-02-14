classdef RM < matlab.unittest.TestCase
         
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
        
        function remove_container(test)            
            docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer");
                        
            test.verifyWarningFree(@()docker.rm("MyArchContainer"));
            
        end
        
        function remove_container_w_force(test)            
            docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer");
                        
            test.verifyWarningFree(@()docker.rm("MyArchContainer","force",true));
            
        end
        
        function throw_error_remove_non_existent_container(test)            
            test.verifyError(@()docker.rm("MyArchContainer"),"Docker:errorFromDockerCLI");
        end
                
    end
end