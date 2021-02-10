classdef Run < matlab.unittest.TestCase
         
    methods(TestClassSetup)
        function getArchLinuxImage(~)
            docker.pull("archlinux:latest");
        end
    end
    
    methods (Test)        
        
        function run_container(test)            
            
            test.verifyWarningFree(@()docker.run("archlinux:latest","tail","-f /dev/null","detach",true,"name","MyArchContainer"));
            
            docker.kill("MyArchContainer");
            docker.rm("MyArchContainer");
        end
        
        function run_container_w_output(test)            
            
            docker.pull("archlinux:latest","quiet",true);
            
            test.verifyEqual(docker.run("archlinux:latest","echo","Hello World","name","MyArchContainer"),"Hello World"+newline);
            
            docker.rm("MyArchContainer");
        end
        
        function throw_error_no_existant_repository(test)            
            
            test.verifyError(@()docker.run("foobar:baz","tail","-f /dev/null","detach",true,"name","MyBogusContainer"),"Docker:errorFromDockerCLI");
            
        end 
                
    end
end