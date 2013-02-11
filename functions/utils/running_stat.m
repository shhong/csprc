function [acc ret] = running_stat()

m = 0;
s = 0;
k = 0;

    function accumulator(x)
        k = k+1;
        m1 = m + (x-m)/k;
        s = s + (x-m).*(x-m1);
        m = m1;
    end

    function [m1 s1] = accessor()
        m1 = m;
        if k>1
            s1 = s/(k-1);
        else
            s1 = nan;
        end
        k1 = k;
    end

acc = @accumulator;
ret = @accessor;

end
