classdef PS < matlab.unittest.TestCase
       
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
        
        function list_containers(test)            
            docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer");
                        
            test.verifyWarningFree(@()docker.ps());
            test.verifyInstanceOf(docker.ps(),"struct");
            
            docker.rm("MyArchContainer");
        end
        
        function list_containers_w_notrunc(test)            
            docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer");
                        
            test.verifyWarningFree(@()docker.ps("notrunc",true));
            
            docker.rm("MyArchContainer");
        end
        
        function list_containers_w_notrunc_all(test)            
            docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer");
                        
            test.verifyWarningFree(@()docker.ps("notrunc",true,"all",true));
            
            docker.rm("MyArchContainer");
        end
                
    end
end