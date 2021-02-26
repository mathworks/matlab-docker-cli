classdef Run < matlab.unittest.TestCase
         
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
        
        function run_container(test)            
            
            test.verifyWarningFree(@()docker.run("archlinux:latest","tail","-f /dev/null","detach",true,"name","MyArchContainer"));
            
            docker.kill("MyArchContainer");
            docker.rm("MyArchContainer");
        end
        
        function run_container_w_environment_var(test)
            
            [filepath,~,~] = fileparts(mfilename('fullpath'));
            docker.build(fullfile(filepath,"dockerfiles","envvar"),"tag","myimage:latest");
            
            test.verifyEqual(...
                docker.run("myimage:latest",string.empty(),string.empty(),...
                "env","MYENVVAR=""Hello""",...
                "name","MyArchContainer"),"Hello"+newline);
            
            docker.rm("MyArchContainer");
            docker.rmi("myimage:latest");
        end        
        
        function run_container_w_output(test)            
            
            docker.pull("archlinux:latest","quiet",true);
            
            test.verifyEqual(docker.run("archlinux:latest","echo","Hello World","name","MyArchContainer"),"Hello World"+newline);
            
            docker.rm("MyArchContainer");
        end
        
        function run_container_w_volumes(test)
            docker.pull("archlinux:latest","quiet",true);
            
            test.verifyWarningFree(@()docker.run("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer","workdir","/mydir","volume",strrep(pwd,"\","/") + ":/mydir"));
                        
            test.verifyEqual(string(docker.inspect("MyArchContainer").Mounts.Source),strrep(pwd,"\","/"));
            test.verifyEqual(string(docker.inspect("MyArchContainer").Mounts.Destination),"/mydir");
            
            docker.rm("MyArchContainer");            
        end
        
        function throw_error_no_existant_repository(test)            
            
            test.verifyError(@()docker.run("foobar:baz","tail","-f /dev/null","detach",true,"name","MyBogusContainer"),"Docker:errorFromDockerCLI");
            
        end 
                
    end
end