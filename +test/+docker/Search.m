classdef Search < matlab.unittest.TestCase
       
    methods(TestClassSetup)
        function getArchLinuxImage(~)
            docker.pull("archlinux:latest");
        end
    end
    
    methods (Test)        
        
        function list_images_avaliable(test)            
                                   
            test.verifyWarningFree(@()docker.search("archlinux"));
            test.verifyInstanceOf(docker.search("archlinux"),"struct");            
           
        end
        
        function list_images_avaliable_w_filter(test)            
                                   
            test.verifyWarningFree(@()docker.search("archlinux","filter","is-official=true"));
            test.verifyInstanceOf(docker.search("archlinux","filter","is-official=true"),"struct");            
           
        end 
                       
    end
end