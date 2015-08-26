function [t Et]=output_reset(y,ic,t)

[Nv Nc]=size(y);

% if previous t are not specified, we revert to default t
% this will be the most primitive OR.
% specifying t from the last time should generally perform better
if(nargin < 3)
    t = generate_t(ic, Nc, Nv);
end

for p=1:Nv
    for i=1:Nc
        if i==ic(p)
            if y(p,i)>t(p,i)
                t(p,i)=y(p,i);
            end
        else
            if y(p,i)<t(p,i)
                t(p,i)=y(p,i);
            end
        end
    end
end

% Calculates output energies
Et = sum(t .* t) / Nv;
