function [nr,nc] = bestplotdim(num)
% BESTPLOTDIM find the best subplot layout for a given number of subplots
%    [NR,NC] = BESTPLOTDIM(NUM) returns the number of rows NR and number
%    of columns NC for the layout closest to square given the number of
%    subplots required NUM.

    row_range = 1:num;
    col_range = num./row_range;
    [val,idx] = min(row_range+col_range);
    nr = row_range(idx);
    nc = ceil(col_range(idx));

end