classdef Create < matlab.unittest.TestCase
    
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
        
        function create_container(test)
            docker.pull("archlinux:latest");
            numberOfContainers = docker.info().Containers;
            
            test.verifyWarningFree(@()docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer"));
            test.verifyEqual(docker.info().Containers,numberOfContainers + 1);
            test.verifyNotEmpty(docker.inspect("MyArchContainer"));
            
            docker.rm("MyArchContainer");       
        end  
        
        function create_container_w_volumes(test)
            docker.pull("archlinux:latest","quiet",true);
            
            test.verifyWarningFree(@()docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer","volume",strrep(pwd,"\","/") + ":/mydir"));
                        
            test.verifyEqual(string(docker.inspect("MyArchContainer").Mounts.Source),strrep(pwd,"\","/"));
            test.verifyEqual(string(docker.inspect("MyArchContainer").Mounts.Destination),"/mydir");
            
            docker.rm("MyArchContainer");            
        end
        
        function fail_when_image_does_not_exist(test)
            test.verifyError(@()docker.create("foobar:baz",string.empty(),string.empty(),"name","MyArchContainer"),"Docker:errorFromDockerCLI");
        end
                        
    end
end