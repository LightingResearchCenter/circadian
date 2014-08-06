function mNoNan = nonanmean(dataArray)
%NONANMEAN Removes NaN elements before taking mean

nanIdx = isnan(dataArray);
noNanDataArray = dataArray(~nanIdx);
mNoNan = mean(noNanDataArray);

end

