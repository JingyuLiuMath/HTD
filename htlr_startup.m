function htlr_startup()
% htlr_startup

file_path = mfilename('fullpath');
tmp = strfind(file_path, 'htlr');
file_path = file_path(1:(tmp(end)-1));
addpath(genpath([file_path 'src']));

end