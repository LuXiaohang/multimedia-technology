x = randn(30);	% 產生 30×30 的亂數（正規分佈）矩陣
z = eig(x);		% 計算 x 的「固有值」（或稱「特徵值」）
plot(z, 'o')  
grid on			% 畫出格線 
