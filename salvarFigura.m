function salvarFigura(fig_handle, nome_arquivo)
    % Cria a pasta 'imagens' se ela não existir e salva a figura
    pasta_destino = 'imagens';
    if ~exist(pasta_destino, 'dir')
        mkdir(pasta_destino);
    end
    caminho_completo = fullfile(pasta_destino, [nome_arquivo '.png']);
    saveas(fig_handle, caminho_completo);
end