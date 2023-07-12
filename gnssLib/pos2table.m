function table = pos2table(pos)
    % Transforma uma matriz com os dados .POS em uma tabela.
    table = array2table(pos);
    table.Properties.VariableNames(1:8) = {'time','xecef', 'yecef',... 
    'zecef', 'lat', 'lon', 'alt', 'fix'};
end