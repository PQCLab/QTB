function fun_est = est_ppi()

fun_est = @handler;

end

function dm = handler(meas, data, dim)

Dim = prod(dim);

M = cellfun(@(m) m.elem, meas, 'UniformOutput', false);
M = cat(3, M{:});
B = reshape(permute(M,[3,2,1]), size(M,3), []);

prob = cellfun(@(kj) kj(:)/sum(kj), data, 'UniformOutput', false);
prob = vertcat(prob{:});

dm = reshape(B\prob, Dim, Dim);
dm = (dm+dm')/2;
dm = proj_spectrahedron(dm/trace(dm));

end

