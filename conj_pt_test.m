function [detJ,isterminal,direction] = conj_pt_test(t,Y)
% Inputs t = arc length, Y = solution vector at arc length t
% Computes det(J) to see if suff cond's were met. 
% If det(J)=0 at any point, found a non-minimum local extrema == conj pt

isterminal = 0; % Don't stop solving when detJ = 0
direction = []; % We want to know every time detJ = 0, not just pos or 
                % neg slope instances (if det is incr or decr)

% If t = 0, then det(J(t)) = 0, but this isn't a conjugate point, so we'll
% only check det(J(t)) when t>0
if t==0
    detJ = 1;
else
    % Get matrix J
    J = reshape(Y(16:24),3,3)';
    % Compute det(J(t))
    detJ = det(J);
end

end
