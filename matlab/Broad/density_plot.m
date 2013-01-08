function plot = density_plot(X,Y,sigma)
if min(X) < 0
	X = X + abs(min(X));
end
if min(Y) < 0
	Y = Y + abs(min(Y));
end
X = X./max(X);
Y = Y./max(Y);

plot = zeros(1100);
X = round(X*1050);
Y = round(Y*1050);
template = gaus2D(10,100,100,sigma,sigma);

for ii = 1:length(X)
    try
		plot(X(ii)-50:X(ii)+50,Y(ii)-50:Y(ii)+50) = plot(X(ii)-50:X(ii)+50,Y(ii)-50:Y(ii)+50) + template;
    catch M
    end
end


imagesc(flipud(plot(50:1050,50:1050)));
%set(gca,'XTick',[1 200 400 600 800 1000]);
%set(gca,'XTickLabel',{'0.0';'0.4';'0.8';'1.2';'1.6';'2'});
%set(gca,'YTick',[1 200 400 600 800 1000]);
%set(gca,'YTickLabel',{'1.0';'0.8';'0.6';'0.4';'0.2';'0.0'});