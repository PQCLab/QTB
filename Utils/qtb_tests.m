classdef qtb_tests
    
%QTB_TESTS Defines static tests methods
methods(Static)
    
function desc = create_test(dim, fun_state, measurement_fun, varargin)
    input = inputParser;
    addRequired(input, 'dim');
    addRequired(input, 'fun_state');
    addRequired(input, 'fun_meas');
    addParameter(input, 'code', 'Test');
    addParameter(input, 'title', 'Test');
    addParameter(input, 'name', 'Untitled test');
    addParameter(input, 'seed', 42);
    addParameter(input, 'nsample', 1000);
    addParameter(input, 'nexp', 1000);
    addParameter(input, 'rank', prod(dim));
    parse(input, dim, fun_state, measurement_fun, varargin{:});
    opt = input.Results;
    desc.dim = opt.dim;
    desc.fun_state = opt.fun_state;
    desc.fun_meas = opt.fun_meas;
    desc.code = opt.code;
    desc.title = opt.title;
    desc.name = opt.name;
    desc.seed = opt.seed;
    desc.nsample = opt.nsample;
    desc.nexp = opt.nexp;
    desc.rank = opt.rank;
end

function desc = get_test(name, dim)
    all_codes = qtb_tests.get_all_codes();
    if ~any(contains(all_codes, name))
        error('QTB:TestName', 'Unavaliable test name `%s`', name);
    end
    desc = feval(strcat('qtb_tests.test_', name), dim);
end

function codes = get_all_codes()
    codes = {'rps', 'rmspt2', 'rmsptd', 'rnp'};
end

function descs = get_all_tests(dim)
    default_tests = qtb_tests.get_all_codes();
    descs = cell(1, length(default_tests));
    for j_test = 1:length(default_tests)
        descs{j_test} = qtb_tests.get_test(default_tests{j_test}, dim);
    end
end

function desc = test_rps(dim)
    desc = qtb_tests.create_test(dim, ...
                                @() qtb_state(dim, 'haar_dm', 'rank', 1), ...
                                @standard_meas, ...
                                'code', 'rps', ...
                                'title', 'RPS', ...
                                'name', 'Random pure states', ...
                                'seed', 161, ...
                                'nsample', 10.^([2,3,4,5,6] + max(0, length(dim) - 3)), ...
                                'nexp', 1000, ...
                                'rank', 1);
end

function desc = test_rmspt2(dim)
    desc = qtb_tests.create_test(dim, ...
                                @() qtb_state(dim, 'haar_dm', 'rank', 2), ...
                                @standard_meas, ...
                                'code', 'rmspt2', ...
                                'title', 'RMSPT-2', ...
                                'name', 'Random mixed states by partial tracing: rank-2', ...
                                'seed', 1312, ...
                                'nsample', 10.^([2,3,4,5,6] + max(0, length(dim) - 2)), ...
                                'nexp', 1000, ...
                                'rank', 2);
end

function desc = test_rmsptd(dim)
    d = prod(dim);
    desc = qtb_tests.create_test(dim, ...
                                @() qtb_state(dim, 'haar_dm', 'rank', d), ...
                                @standard_meas, ...
                                'code', 'rmsptd', ...
                                'title', 'RMSPT-d', ...
                                'name', 'Random mixed states by partial tracing: rank-d', ...
                                'seed', 117218, ...
                                'nsample', 10.^([2,3,4,5,6] + (length(dim) - 1)), ...
                                'nexp', 1000, ...
                                'rank', d);
end

function desc = test_rnp(dim)
    desc = qtb_tests.create_test(dim, ...
                                @() qtb_state(dim, 'haar_dm', 'rank', 1, 'init_err', {'unirnd', 0, 0.05}, 'depol', {'unirnd', 0, 0.01}), ...
                                @standard_meas, ...
                                'code', 'rnp', ...
                                'title', 'RNP', ...
                                'name', 'Random noisy preparation', ...
                                'seed', 758942, ...
                                'nsample', 10.^([2,3,4,5,6] + (length(dim) - 1)), ...
                                'nexp', 1000, ...
                                'rank', prod(dim));
end

end
end
