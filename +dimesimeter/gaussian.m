function filtered = gaussian(data, window)

%window is number of points on each side of current point that you want to
%consider
window = window*2;
filtered = filtfilt(gausswin(window)/sum(gausswin(window)), 1, data);

end

