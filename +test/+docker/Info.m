classdef Info < matlab.unittest.TestCase
     
    methods (Test)                  
        function information_returned_as_struct(test)
            test.verifyInstanceOf(docker.info(),"struct");
        end        
    end
end