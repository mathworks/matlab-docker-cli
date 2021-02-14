classdef CP < matlab.unittest.TestCase
    
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
        function copy_from_container_to_host(test)        
            docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer");            
            [filepath,~,~] = fileparts(mfilename('fullpath'));
            
            test.verifyWarningFree(@()docker.cp("MyArchContainer:/dev",fullfile(filepath)));            
            test.verifyTrue(isfolder(fullfile(filepath,"dev")));
                        
            rmdir(fullfile(filepath,"dev"),"s");
            docker.rm("MyArchContainer");     
        end
        
        function copy_with_symlink(test)        
            docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer");            
            [filepath,~,~] = fileparts(mfilename('fullpath'));
            
            test.verifyWarningFree(@()docker.cp("MyArchContainer:/dev",fullfile(filepath),"followlink",true));            
            test.verifyTrue(isfolder(fullfile(filepath,"dev")));
                        
            rmdir(fullfile(filepath,"dev"),"s");
            docker.rm("MyArchContainer");    
        end
        
        function copy_from_host_to_container_to_host(test)        
            docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer");            
            [filepath,~,~] = fileparts(mfilename('fullpath'));
                        
            test.verifyWarningFree(@()docker.cp(fullfile(filepath,"output","sampleFile.txt"),"MyArchContainer:/home/sampleFile1.txt"));             
            test.verifyWarningFree(@()docker.cp("MyArchContainer:/home/sampleFile1.txt",fullfile(filepath,"output","sampleFile2.txt"))); 
            
            test.verifyEqual(...
                fileread(fullfile(filepath,"output","sampleFile.txt")),...
                fileread(fullfile(filepath,"output","sampleFile2.txt")));
                                    
            delete(fullfile(filepath,"output","sampleFile2.txt"));
            docker.rm("MyArchContainer");    
        end
        
        function throw_error_for_missing_file(test)
            docker.create("archlinux:latest",string.empty(),string.empty(),"name","MyArchContainer");            
            [filepath,~,~] = fileparts(mfilename('fullpath'));
            
            test.verifyError(@()docker.cp("MyArchContainer:/dev/nonexistant.txt",fullfile(filepath,"nonexistant.txt")),"Docker:errorFromDockerCLI");            
                                    
            docker.rm("MyArchContainer");  
        end
    end
end