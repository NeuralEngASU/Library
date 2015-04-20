function imf = filexch_emd(x)
% Empiricial Mode Decomposition (Hilbert-Huang Transform)
% imf = emd(x)
% Func : findpeaks

%IMF = Intrinsic Mode Function:  represents simple oscillatory modes found
%within complicated data (not harmonic) and has variable amplitude and frequency.  Must meet the following (1) in the whole dataset, the number of
%extrema and the number of zero-crossings must either equal or differ at
%most by one and (2) at any point, the average value of the envelope is zero

x   = transpose(x(:));
imf = [];
while ~ismonotonic(x) %setting stop criteria(if x is not monotonic, continue looping)
   x1 = x;
   sd = Inf;
   while (sd > 0.1) || ~isimf(x1)
      s1 = getspline(x1); %find local maxima via "findpeaks" function and connect with a cubic spline interpolation via "spline" function to get the upper envelope
      s2 = -getspline(-x1);  %find local maxima via "findpeaks" function and connect with a cubic spline interpolation via "spline" function to get the lower envelope
      x2 = x1-(s1+s2)/2; %find the average of the data envelope and take the difference between the data, x1, and the mean to get the first possible component
      
      %Need to check to see that h1 satisfies the definition of an IMF
      %before using it as the new data set.
      
      sd = sum((x1-x2).^2)/sum(x1.^2);
      x1 = x2;
   end
   
   imf{end+1} = x1;
   x          = x-x1;
end
imf{end+1} = x;

% % %Plots
% % 
% figure;
% for k=1:length(imf);
%     subplot(5,4,k)
%     plot (S.Sz(s).Times,imf{k},'.','MarkerSize',2);
%     hold on;
%     title(['Sz ' num2str(s) ', Ch 97, IMF ' num2str(k)])
%     %ylim([-100 100])
%     xlim([10 140])
% end


% FUNCTIONS

function u = ismonotonic(x)

u1 = length(fndpeaks(x))*length(fndpeaks(-x));
if u1 > 0, u = 0;
else      u = 1; end

function u = isimf(x)

N  = length(x);
u1 = sum(x(1:N-1).*x(2:N) < 0);
u2 = length(fndpeaks(x))+length(fndpeaks(-x));
%findpeaks requires a row or column vector with real numbers
if abs(u1-u2) > 1, u = 0;
else              u = 1; end

function s = getspline(x)

N = length(x);
p = fndpeaks(x);
s = spline([0 p N+1],[0 x(p) 0],1:N);
