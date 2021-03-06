function scorePlots(valuesTest,countryTest, valuesValid, countryValid ,LV,print)
    [values_mncn_test, values_mean]=mncn(valuesTest);
    [w,T_test,p,q,T_o_test,P_o,W_o] = OPLS(values_mncn_test',countryTest,LV);
    [values_mncn_valid, values_mean]=mncn(valuesValid);
    [w,T_valid,p,q,T_o_valid,P_o,W_o] = OPLS(values_mncn_valid',countryValid,LV);
    figure
    hold on
    gscatter(T_test,T_o_test(:,1),countryTest,'br');
    gscatter(T_valid,T_o_valid(:,1),countryValid,'gm');
    hold off
    legend({'Test', [print ' test set'],'Valid', print});
    xlabel('x')
end
