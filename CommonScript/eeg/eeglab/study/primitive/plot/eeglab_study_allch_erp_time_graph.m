function [] = eeglab_study_allch_erp_time_graph(input)


erp_curve                                                                  = input.erp_curve;
pvalue                                                                     = input.project.stats.erp.pvalue;
allch                                                                      = input.allch;
amplim                                                                     = input.project.results_display.ylim_plot;
times                                                                      = input.times;
levels_f1                                                                  = input.levels_f1;
levels_f2                                                                  = input.levels_f2;
pcond_corr                                                                 = input.pcond_corr;
pgroup_corr                                                                = input.pgroup_corr;
plot_dir                                                                   = input.plot_dir;


tch = length(allch);

% dimensioni del cell array con gli erp grezzi
[s1 s2] = size(erp_curve);

% estraggo la matrice: le dimensioni dovrebbero essere tempo x canali x
% soggetti

pvalue_str=num2str(pvalue);

if isempty(amplim)
    amplim = [-5 5];
end


for ns1 = 1:s1 % per ciascun livello del primo fattore
    fig=figure('color','w'); % creo una figura che avrà tanti sub-plot quanti sono i livelli del secondo fattore
    for ns2 = 1:s2 % per ogni livello del secondo fattore
        subplot(1,s2+1,ns2); % riempo un subplot della figura
        mat_erp_plot = mean(erp_curve{ns1,ns2},3)';% calcolo la matrice che media sui soggetti(lascia x=tempi, y=canali)
        imagesc(times,1:tch,mat_erp_plot);%faccio il plot della matrice
        caxis(amplim);
        title([levels_f2{ns2}])
        line('XData', [0 0], 'YData', [1 tch], 'LineStyle', '--','LineWidth', 2, 'Color','k')
        xlabel('Times (ms)');
        if not(s2==2)
            if ns2 ==1
                set(gca,'YTick',1:tch,'YTicklabel',allch,'FontSize', 8)
                ylabel('Channels');
            end
        else
            set(gca,'YTick',1:tch,'YTicklabel',allch,'FontSize', 8)
        end
        
    end
    
    pplot = pgroup_corr(ns1);
    ss = pplot{1} < pvalue;
    
    if s2==2
        mat_diff_erp    = mean(erp_curve{ns1,1},3) - mean(erp_curve{ns1,2},3);
        mat_pvalue_plot = (ss.*mat_diff_erp)';
        pclim = amplim;
    else
        mat_pvalue_plot = ss';
        pclim = [-1 1];
    end
    
    
    subplot(1,s2+1,s2+1); % riempo l'ultimo subplot della figura con le probabilita'
    imagesc(times,1:tch,mat_pvalue_plot);%faccio il plot della matrice
    caxis(pclim);
    set(gca,'YTick',1:tch,'YTicklabel',allch,'FontSize', 8)
    line('XData', [0 0], 'YData', [1 tch], 'LineStyle', '--','LineWidth', 2, 'Color','k')
    title(['(P<',pvalue_str,')']);
    
    if s2==2
        cbar;title('uV');
    end
    
    suptitle(levels_f1{ns1})
    
    input.plot_dir    = plot_dir;
    input.fig         = fig;
    input.name_embed  = 'cros_cor';
    input.suffix_plot = ['erp_allch_',levels_f1{ns1}];
    save_figures(input);
    
    
end

for ns2 = 1:s2 % per ciascun livello del primo fattore
    fig=figure('color','w'); % creo una figura che avrà tanti sub-plot quanti sono i livelli del secondo fattore
    for ns1 = 1:s1 % per ogni livello del secondo fattore
        subplot(1,s1+1,ns1); % riempo un subplot della figura
        mat_erp_plot = mean(erp_curve{ns1,ns2},3)';% calcolo la matrice che media sui soggetti(lascia x=tempi, y=canali)
        imagesc(times,1:tch,mat_erp_plot);%faccio il plot della matrice
        caxis(amplim);
        title([levels_f1{ns1}])
        line('XData', [0 0], 'YData', [1 tch], 'LineStyle', '--','LineWidth', 2, 'Color','k')
        xlabel('Times (ms)');
        if not(s1==2)
            if ns1 ==1
                set(gca,'YTick',1:tch,'YTicklabel',allch,'FontSize', 8)
                ylabel('Channels');
            end
        else
            set(gca,'YTick',1:tch,'YTicklabel',allch,'FontSize', 8)
        end
        
    end
    
    pplot = pcond_corr(ns2);
    ss = pplot{1} < pvalue;
    
    if s1==2
        mat_diff_erp    = mean(erp_curve{1,ns2},3) - mean(erp_curve{2,ns2},3);
        mat_pvalue_plot = (ss.*mat_diff_erp)';
        pclim = amplim;
    else
        mat_pvalue_plot = ss';
        pclim = [-1 1];
    end
    
    
    subplot(1,s1+1,s1+1); % riempo l'ultimo subplot della figura con le probabilita'
    imagesc(times,1:tch,mat_pvalue_plot);%faccio il plot della matrice
    caxis(pclim);
    set(gca,'YTick',1:tch,'YTicklabel',allch,'FontSize', 8)
    line('XData', [0 0], 'YData', [1 tch], 'LineStyle', '--','LineWidth', 2, 'Color','k')
    title(['(P<',pvalue_str,')']);
    
    if s1==2
        cbar;title('uV');
    end
    
    suptitle(levels_f2{ns2})
    
    input.plot_dir    = plot_dir;
    input.fig         = fig;
    input.name_embed  = 'cros_cor';
    input.suffix_plot = ['erp_allch_',levels_f2{ns2}];
    save_figures(input);
end
end