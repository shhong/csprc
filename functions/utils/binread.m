function r = binread(fname)
% r = binread(filename) is a dangerously stupid binary file reader that
% returns a double array r hopefully read from the file with filename.
%
% Written by: Sungho Hong, CNS Unit, Okinawa Inst of Sci Tech
% Email: shhong@oist.jp
%

f = fopen(fname);
r = fread(f,'double');
fclose(f);

end