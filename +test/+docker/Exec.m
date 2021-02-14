classdef Exec < matlab.unittest.TestCase
         
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
        
        function exec_in_container(test)
            docker.run("archlinux:latest","tail","-f /dev/null","detach",true,"name","MyArchContainer");
            
            test.verifyEqual(docker.exec("MyArchContainer","echo","""Hello World"""),"Hello World"+newline());
                        
            docker.rm("MyArchContainer","force",true);     
        end
        
        function exec_in_container_in_workdir(test)
            docker.run("archlinux:latest","tail","-f /dev/null","detach",true,"name","MyArchContainer");
            
            test.verifyEqual(docker.exec("MyArchContainer","echo","""Hello World""","workdir","/home"),"Hello World"+newline());
                        
            docker.rm("MyArchContainer","force",true);     
        end 
        
        function throw_error_in_exec(test)
            docker.run("archlinux:latest","tail","-f /dev/null","detach",true,"name","MyArchContainer");
            
            test.verifyError(@()docker.exec("MyArchContainer","sfgasafahk",string.empty()),"Docker:errorFromDockerCLI");
                        
            docker.rm("MyArchContainer","force",true);     
        end
                        
    end
end