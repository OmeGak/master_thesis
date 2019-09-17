function Xx = accept_reject(func)
    test_x = linspace(0,1);
    A = max(func(test_x));

    % sample random number according to well-chosen distribution
    X = rand();
    
    % sample uniform random number
    U = rand();
    
    % acceptance criterion
    if U <= func(X)/A
        % accept
        Xx = X;
    else
        Xx = [];
    end
end