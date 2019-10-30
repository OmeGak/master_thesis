function tau_history = update_tau_history(tau_history,one_photon_tau_history)

    VAR = size(tau_history,1) - length(one_photon_tau_history);
    if VAR < 0
        tau_history = [tau_history; zeros(length(one_photon_tau_history) - size(tau_history,1), size(tau_history,2))];
    elseif VAR > 0
        one_photon_tau_history = [one_photon_tau_history; zeros(size(tau_history,1)-length(one_photon_tau_history),1)];
    end
    
    tau_history = [tau_history, one_photon_tau_history];

end