x = randn(10000, 1);	% 产生10000个正规分布随机数  
hist(x, 25); 	% 绘出直方图，显示x资料的分布情况和统计特性，数字25代表资料依
                %大小分堆的堆数，即是指方图内长条的个数

set(findobj(gca, 'type', 'patch'), 'edgecolor', 'r');  

