function [uvw_str,w2,azm,tilt,lag] = dbl_rot_30min(uvw,X,N)
%{
 Double angle rotation to achieve mean V = 0 and mean W = 0.
 Assume input data is exactly 1 hr.
 Rotation is applied in 10 min segments.
 Output azm, tilt and lag are 6x1 arrays.

 X is scalar array of the same length as uvw.
 w2 is lag shifted for maximum correlation with X in
    each 10min segment.

THIS VERSION USES A FIXED VALUE FOR LAG BETWEEN SONIC AND LICOR
%}

uvw_str = uvw;
w2 = uvw(:,3);
tilt = NaN(2,1); azm = tilt; lag = tilt;

ii = 1;
for jj = 1:2
    [uvw_str(ii:ii+N-1,:),azm(jj),tilt(jj)] = dbl_rot(uvw(ii:ii+N-1,:));
%     lag(jj) = lagcorrection(X(ii:ii+N-1),uvw_str(ii:ii+N-1,3),60);
    lag(jj) = -3;  % choose fixed value for lag
    if lag(jj)<0
        w2(ii-lag(jj):ii+N-1) = uvw_str(ii:ii+N-1+lag(jj),3);
    elseif lag(jj)>0
        w2(ii:ii+N-1-lag(jj)) = uvw_str(ii+lag(jj):ii+N-1,3);
    end
    ii = ii + N;
end

tilt = tilt*180/pi; % convert to degrees
azm = azm*180/pi;
end
