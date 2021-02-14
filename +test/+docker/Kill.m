classdef Kill < matlab.unittest.TestCase
         
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
        
        function kill_running_container(test)
            docker.run("archlinux:latest","tail","-f /dev/null","detach",true,"name","MyArchContainer");
            
            test.verifyEqual(docker.inspect("MyArchContainer").State.Status,'running');            
            test.verifyWarningFree(@()docker.kill("MyArchContainer"));            
            test.verifyEqual(docker.inspect("MyArchContainer").State.Status,'exited');
                        
            docker.rm("MyArchContainer","force",true);
        end 
        
        function kill_running_container_w_signal(test)
            docker.run("archlinux:latest","tail","-f /dev/null","detach",true,"name","MyArchContainer");
            
            test.verifyEqual(docker.inspect("MyArchContainer").State.Status,'running');            
            test.verifyWarningFree(@()docker.kill("MyArchContainer","signal","KILL"));            
            test.verifyEqual(docker.inspect("MyArchContainer").State.Status,'exited');
                        
            docker.rm("MyArchContainer","force",true);
        end
        
        function error_kill_non_existant_container(test)
            
            test.verifyError(@()docker.kill("MyArchContainer"),"Docker:errorFromDockerCLI");            
           
        end 
        
                        
    end
end