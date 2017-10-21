function str = dateStrFast(dateNum)
%DATESTRFAST calculates the standard log date string

% Use builtin to get the date components
[y,mo,d,h,min,s] = datevecmx(dateNum, true);  mo(mo==0) = 1;
ms = round((s-floor(s)) * 1000);
s = floor(s);
str = sprintf('%02u:%02u:%02u.%03u', h, min, s, ms);

end

