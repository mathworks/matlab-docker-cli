classdef OptionToStringMap < matlab.unittest.TestCase
     
    methods (Test)
        
        function scalar_options(test)
            
            flags = containers.Map("flag","--flag");
            options.flag = logical.empty();
            
            test.verifyEmpty(docker.internal.optionToStringMap(flags,options));
            
            options.flag = true;
            test.verifyEqual(docker.internal.optionToStringMap(flags,options),"--flag=true");
            
            options.flag = "string";
            test.verifyEqual(docker.internal.optionToStringMap(flags,options),"--flag string");
            
        end 
        
        function vector_options(test)
            
            flags = containers.Map("flag","--flag");
            options.flag = ["string1","string2"];
            test.verifyEqual(docker.internal.optionToStringMap(flags,options),"--flag string1 --flag string2");
            
        end 
        
        function mixed_options(test)
            
            flags = containers.Map(["flag","otherflag"],["--flag","--other-flag"]);
            options.flag = true;
            options.otherflag = "string";
            test.verifyEqual(docker.internal.optionToStringMap(flags,options),"--flag=true --other-flag string");
            
        end 
        
        
    end
end