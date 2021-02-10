function optionStr = optionToStringMap(flags,options)
%OPTIONTOSTRINGMAP Generate options string from argument
%   Detailed explanation goes here

arguments
    flags (:,1) containers.Map;
    options (1,1) struct;   
end

optionStr = string.empty();

for key = string(flags.keys)    
    
    values = options.(key);        
    if ~isempty(values)
        for value = values
            if isstring(value)
                optionStr(end+1) = flags(key) + " " + value; %#ok<AGROW>
            else
                optionStr(end+1) = flags(key) + "=" + value; %#ok<AGROW>
            end
        end                
    end
end

optionStr = optionStr.join();

end

