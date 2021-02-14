classdef Commit < matlab.unittest.TestCase
    
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
        
        function create_new_image(test)                        
            docker.create("archlinux:latest","echo","Hello World","name","MyArchContainer");
            
            test.verifyWarningFree(@()docker.commit("MyArchContainer","mycustomimage","author","thisguy"));
            
            test.verifyEqual(docker.inspect("mycustomimage").Author,'thisguy');
            
            docker.rmi("mycustomimage");    
            docker.rm("MyArchContainer");       
        end  
        
        function fail_when_image_does_not_exist(test)
            test.verifyError(@()docker.commit("NonExistantContainer","mycustomimage","author","thisguy"),"Docker:errorFromDockerCLI");
        end
                        
    end
end