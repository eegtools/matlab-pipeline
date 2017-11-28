%% [STUDY, EEG] = proj_eeglab_study_plot_roi_erp_curve(project, analysis_name, mode, varargin)
%
% calculate and display erp time series for groups of scalp channels consdered as regions of interests (ROI) in
% an EEGLAB STUDY with statistical comparisons based on the factors in the selected design.
%
% ====================================================================================================
% REQUIRED INPUT:
%
% ----------------------------------------------------------------------------------------------------
% project; a structure with the following MANDATORY fields:
%
% * project.study.filename; the filename of the study
% * project.paths.output_epochs; the path where the study file will be
%   placed (default: the same foleder of the epoched datasets)
% * project.paths.results; the path were the results will be saved
% * project.design; the experimental design:
%   project.design(design_number) = struct(
%                                         'name', design_name,
%                                         'factor1_name',  factor1_name,
%                                         'factor1_levels', factor1_levels ,
%                                         'factor1_pairing', 'on',
%                                         'factor2_name',  factor2_name,
%                                         'factor2_levels', factor2_levels ,
%                                         'factor2_pairing', 'on'
%                                         )
% * project.postprocess.erp.roi_list;
% * project.postprocess.erp.roi_names;
% * project.stats.erp.pvalue;
% * project.stats.erp.num_permutations;
% * project.stats.eeglab.erp.correction;
% * project.stats.eeglab.erp.method;
% * project.results_display.erp.time_smoothing;
% * project.results_display.erp.masked_times_max;
% * project.results_display.erp.display_only_significant_curve;
% * project.results_display.erp.compact_plots;
% * project.results_display.erp.compact_h0;
% * project.results_display.erp.compact_v0;
% * project.results_display.erp.compact_sem;
% * project.results_display.erp.compact_stats;
% * project.results_display.erp.single_subjects;
% * project.results_display.erp.compact_display_xlim;
% * project.results_display.erp.compact_display_ylim;
% * project.postprocess.erp.design
%
% ----------------------------------------------------------------------------------------------------
% analysis_name
%
%
% ----------------------------------------------------------------------------------------------------
% mode
%
%
%
% ====================================================================================================
% OPTIONAL INPUT:
%
% design_num_vec
% analysis_name
% roi_list
% roi_names
% study_ls
% num_permutations
% correction
% stat_method
% filter
% masked_times_max
% display_only_significant
% display_compact_plots
% compact_display_h0
% compact_display_v0
% compact_display_sem
% compact_display_stats
% display_single_subjects
% compact_display_xlim
% compact_display_ylim
% group_time_windows_list
% subject_time_windows_list
% group_time_windows_names
% sel_extrema
% list_select_subjects
% do_plots
% ====================================================================================================

function [STUDY, EEG] = proj_eeglab_study_define_roi_tw_datadriven(project, analysis_name,  varargin)

if nargin < 1
    help proj_eeglab_study_plot_roi_erp_curve;
    return;
end;

study_path                  = fullfile(project.paths.output_epochs, project.study.filename);
results_path                = project.paths.results;

paired_list = cell(length(project.design), 2);
for ds=1:length(project.design)
    paired_list{ds} = {project.design(ds).factor1_pairing, project.design(ds).factor2_pairing};
end

% VARARGIN DEFAULTS
list_select_subjects        = {};
design_num_vec              = [1:length(project.design)];

% roi_list                    = project.postprocess.erp.roi_list;
% roi_names                   = project.postprocess.erp.roi_names;

study_ls                    = project.stats.erp.pvalue;
% num_permutations            = project.stats.erp.num_permutations;
correction                  = project.stats.eeglab.erp.correction;
stat_method                 = project.stats.eeglab.erp.method;

filter                      = project.results_display.erp.time_smoothing;
masked_times_max            = project.results_display.erp.masked_times_max;
display_only_significant    = project.results_display.erp.display_only_significant_curve;
display_compact_plots       = project.results_display.erp.compact_plots;
compact_display_h0          = project.results_display.erp.compact_h0;
compact_display_v0          = project.results_display.erp.compact_v0;
compact_display_sem         = project.results_display.erp.compact_sem;
compact_display_stats       = project.results_display.erp.compact_stats;
display_single_subjects     = project.results_display.erp.single_subjects;
xlim        = project.results_display.erp.compact_display_xlim;
amplim        = project.results_display.erp.compact_display_ylim;


% group_time_windows_list     = arrange_structure(project.postprocess.erp.design, 'group_time_windows');
% subject_time_windows_list   = arrange_structure(project.postprocess.erp.design, 'subject_time_windows');
% group_time_windows_names    = arrange_structure(project.postprocess.erp.design, 'group_time_windows_names');

do_plots                    = project.results_display.erp.do_plots;
recompute_precompute                   = 'off';
recompute_grand_average                = 'on';
recompute_grouping_factor              = 'on';


% % ANALYSIS MODALITIES
% if strcmp(mode.peak_type, 'group') && strcmp(mode.align, 'off')
%     which_method_find_extrema = 'group_noalign';
% elseif strcmp(mode.peak_type, 'group') && strcmp(mode.align, 'on')
%     which_method_find_extrema = 'group_align';
% elseif strcmp(mode.peak_type, 'individual') && strcmp(mode.align, 'off')
%     which_method_find_extrema = 'individual_noalign';
% elseif strcmp(mode.peak_type, 'individual') && strcmp(mode.align, 'on')
%     which_method_find_extrema = 'individual_align';
% elseif strcmp(mode.peak_type, 'off')
%     which_method_find_extrema = 'continuous';
% end

% tw_stat_estimator           = mode.tw_stat_estimator;
% time_resolution_mode        = mode.time_resolution_mode;
% sel_extrema                 = project.postprocess.erp.sel_extrema;

for par=1:2:length(varargin)
    switch varargin{par}
        case {'design_num_vec', ...
                'analysis_name', ...
                'roi_list', ...
                'roi_names', ...
                'study_ls', ...
                'num_permutations', ...
                'correction', ...
                'stat_method', ...
                'filter', ...
                'masked_times_max', ...
                'display_only_significant', ...
                'display_compact_plots', ...
                'compact_display_h0', ...
                'compact_display_v0', ...
                'compact_display_sem', ...
                'compact_display_stats', ...
                'display_single_subjects', ...
                'compact_display_xlim', ...
                'compact_display_ylim', ...
                'group_time_windows_list', ...
                'subject_time_windows_list', ...
                'group_time_windows_names', ...
                'sel_extrema', ...
                'list_select_subjects', ...
                'do_plots',...
                'recompute_precompute',...
                'recompute_grand_average',...
                 'recompute_grouping_factor',...
                'levels_f1_grand_average_dd',...
                'levels_f2_grand_average_dd'...
                }
            
            if isempty(varargin{par+1})
                continue;
            else
                assign(varargin{par}, varargin{par+1});
            end
    end
end

dfcond=[];
dfgroup=[];
dfinter=[];


%=================================================================================================================================================================
%=================================================================================================================================================================
%=================================================================================================================================================================
%=================================================================================================================================================================
%=================================================================================================================================================================
[study_path,study_name_noext,study_ext] = fileparts(study_path);

% start EEGLab
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

% load the study and working with the study structure
[STUDY ALLEEG] = pop_loadstudy( 'filename',[study_name_noext study_ext],'filepath',study_path);

chanlocs = eeg_mergelocs(ALLEEG.chanlocs);
allch0         = {chanlocs.labels}; % comprende eventuali poligrafici

allch = allch0(project.eegdata.eeg_channels_list);


for design_num=design_num_vec
    
    
    
    % select the study design for the analyses
    STUDY                              = std_selectdesign(STUDY, ALLEEG, design_num);
    
    erp_curve_roi_stat.study_des       = STUDY.design(design_num);
    erp_curve_roi_stat.study_des.num   = design_num;
%     erp_curve_roi_stat.roi_names       = roi_names;
    
    name_f1                            = STUDY.design(design_num).variable(1).label;
    name_f2                            = STUDY.design(design_num).variable(2).label;
    
    levels_f1                          = STUDY.design(design_num).variable(1).value;
    levels_f2                          = STUDY.design(design_num).variable(2).value;
    
    grouping_factor                    = project.design(design_num).grouping_factor;
    comparing_factor                    = project.design(design_num).comparing_factor;
    
    % lista dei soggetti suddivisi per fattori
    list_design_subjects               = eeglab_generate_subjects_list_by_factor_levels(STUDY, design_num);
    
    
    
    
    
    
    
    str                                = datestr(now, 'dd-mmm-yyyy-HH-MM-SS');
    plot_dir                           = fullfile(results_path,analysis_name,[STUDY.design(design_num).name,'-erp_curve_','-',str]);
    mkdir(plot_dir);
    
    STUDY = pop_erpparams(STUDY, 'topotime',[] ,'plotgroups','apart' ,'plotconditions','apart','averagechan','off','method', stat_method);
    
    precompute_file = fullfile(study_path,['precompute_erp_allch_', char(STUDY.design(design_num).name), '.mat']);
    exist_precompute = exist(precompute_file);
    
    if (strcmp(recompute_precompute, 'on')  || not(exist_precompute))
        
        % erp_curve_allch cell array of dimension tlf1 x tlf2 , each cell of
        % dimension times x channels x subjects
        [STUDY, erp_curve_allch, times]=std_erpplot(STUDY,ALLEEG,'channels',allch,'noplot','on');
        
        save(precompute_file,'erp_curve_allch','times')
    else
        load(precompute_file);
    end
    
    
    for nf1=1:length(levels_f1)
        for nf2=1:length(levels_f2)
            if ~isempty(list_select_subjects)
                vec_select_subjects=ismember(list_design_subjects{nf1,nf2},list_select_subjects);
                if ~sum(vec_select_subjects)
                    disp('Error: the selected subjects are not represented in the selected design')
                    return;
                end
                %                     erp_curve_roi{nf1,nf2}=erp_curve_roi{nf1,nf2}(:,vec_select_subjects);
                erp_curve_allch{nf1,nf2}=erp_curve_allch{nf1,nf2}(:,1:length(allch),vec_select_subjects);
                erp_curve_allch_collsub{nf1,nf2} = mean(erp_curve_allch{nf1,nf2},3)';
                list_design_subjects{nf1,nf2}=list_design_subjects{nf1,nf2}(vec_select_subjects);
            end
        end
    end
    
    
    
    %% compute grand average file
    
    grand_average_file = fullfile(study_path,['grand_average_erp_allch_', char(STUDY.design(design_num).name), '.mat']);
    exist_grand_average = exist(grand_average_file);
    
    if (strcmp(recompute_grand_average, 'on')  || not(exist_grand_average))
        
        
        sel_levels_f1_grand_average_dd = ismember(levels_f1,levels_f1_grand_average_dd{design_num});
        sel_levels_f2_grand_average_dd = ismember(levels_f2,levels_f2_grand_average_dd{design_num});

        erp_curve_allch_grand_average = erp_curve_allch(sel_levels_f1_grand_average_dd,sel_levels_f2_grand_average_dd);
        erp_curve_allch_collsub_grand_average = erp_curve_allch_collsub(sel_levels_f1_grand_average_dd,sel_levels_f2_grand_average_dd);
        
        dim_erp_curve_allch = ndims(erp_curve_allch_grand_average{1});
        collapsing_dimension = dim_erp_curve_allch+1;
        
        % collapse the cells into a matrix, along an additional dimesion
        
        mat_collapsed_cell = cat(collapsing_dimension, erp_curve_allch_grand_average{:});
        
        % compute the average along dim_current_cells+1,
        mean_collapsed_cell_single_sub = mean(mat_collapsed_cell,collapsing_dimension);
        
        
        mean_collapsed_cell_all_sub = {mean(mean_collapsed_cell_single_sub,3)'};
        
        input_dd.curve         = mean_collapsed_cell_all_sub;
        input_dd.base_tw       = [project.epoching.bc_st.ms project.epoching.bc_end.ms];
        input_dd.times        = times;
        input_dd.levels_grouping_factor                                                     = {'grand_average'};
        input_dd.min_duration                                                               = project.postprocess.erp.design(design_num).min_duration ;                      % ha senso settare una diversa lunghezza minima a seconda della banda o del tipo del sgnale?
        input_dd.pvalue                                                                     = study_ls;                            % default will be 0.05
        input_dd.correction                                                                 = correction;                        % string. correction for multiple comparisons 'none'| 'fdr' | 'holms' | 'bonferoni'
        
        
        
        output_dd_grand_average = eeglab_study_curve_data_driven_onset_offset(input_dd);
        
        
        
        save(grand_average_file,'mean_collapsed_cell_all_sub','times','allch','output_dd_grand_average')
    else
        
        load(grand_average_file);
        
    end
    
    
    
    
    
    
    %% plot grand average
input_ga.erp_grand_average = mean_collapsed_cell_all_sub{:};      
input_ga.p_grand_average  = output_dd_grand_average.sigcell_pruned_gf{:};  
input_ga.erp_avgsub = erp_curve_allch_collsub_grand_average;
input_ga.pvalue = study_ls;
input_ga.allch = allch;                                                                     
input_ga.xlim = xlim;                                                                       
input_ga.amplim = amplim;                                                                   
input_ga.times = times;                                                                      
input_ga.levels_f1 = levels_f1(sel_levels_f1_grand_average_dd);                                                                  
input_ga.levels_f2 = levels_f2 (sel_levels_f2_grand_average_dd);                                                                
input_ga.plot_dir = plot_dir;  


% eeglab_study_allch_erp_time_dd_grand_average_graph(input_ga);
    
%% export grand average
input_ga_exp.p_grand_average  = output_dd_grand_average.sigcell_pruned_gf{:};  
input_ga_exp.erp_avgsub = erp_curve_allch_collsub_grand_average;
input_ga.levels_f1 = levels_f1(sel_levels_f1_grand_average_dd);                                                                  
input_ga.levels_f2 = levels_f2 (sel_levels_f2_grand_average_dd);
text_export_allch_erp_time_dd_grand_average(input_ga_exp);

    
    %% compute grouping factor
    if (isempty(grouping_factor) || isempty(comparing_factor))
        disp('missing grouping or comparing factor: calculate only significant deflections based on the grand average!!!')
    else
        
        grouping_factor_file = fullfile(study_path,['grouping_factor_erp_allch_', char(STUDY.design(design_num).name), '.mat']);
        exist_grouping_factor = exist(grouping_factor_file);
        
        if (strcmp(recompute_grouping_factor, 'on')  || not(exist_grouping_factor))
            
            % we have 2 kind of facors: 1 grouping factor and 1 comparing factor.
            % all levels of comparing factors will be averaged within each level of
            % grouping factor, therefore we can get an estiation of rois and tw
            % which is UNBIASED with respect to comparing factor: levels of
            % comparing factor will be compared considering the umbiased roi and
            % tw.
            
            
            if strcmp(grouping_factor, name_f1)
                levels_grouping_factor = levels_f1;
                name_grouping_factor   = name_f1;
                levels_comparing_factor = levels_f2;
                name_comparing_factor   = name_f2;
                
            else
                levels_grouping_factor = levels_f2;
                name_grouping_factor   = name_f2;
                levels_comparing_factor = levels_f1;
                name_comparing_factor   = name_f1;
            end
            tl_gf = length(levels_grouping_factor);
            cell_grouped_factor = {};
            
            %     for each level of grouping factor
            for nl_gf = 1:tl_gf
                %     each cell grouped factor = mean of all levels of comparing factor
                if strcmp(grouping_factor, name_f1)
                    % select all the cells (levels) of the comparing factor corresponding to the current level (nl_gf) of grouping factor
                    current_cells = erp_curve_allch(nl_gf,:);
                else
                    current_cells = erp_curve_allch(:,nl_gf);
                end
                dim_current_cells = ndims(current_cells{1});
                collapsing_dimension = dim_current_cells+1;
                
                % collapse the cells into a matrix, along an additional dimesion
                % corresponding to the cells (levels) of the comparing factor
                
                mat_collapsed_cell = cat(collapsing_dimension, current_cells{:});
                
                % compute the average along dim_current_cells+1, i.e. collapse cells (levels) of the comparing factor, but preserving single subjects. i.e. the dimensions will be channels x times x subjects
                mean_collapsed_cell_single_sub = mean(mat_collapsed_cell,collapsing_dimension);
                
                % compute the average along third dimension, i.e. subjects, will result in
                % a matrix channels x times
                
                mean_collapsed_cell_all_sub = mean(mean_collapsed_cell_single_sub,3);
                
                %         put the matrix into the cell corrsponding to the nl_gf level of
                %         grouping factor
                
                cell_grouped_factor{nl_gf} = mean_collapsed_cell_all_sub';
            end
            
            
            
            input_dd.curve         = cell_grouped_factor;
            input_dd.base_tw       = [project.epoching.bc_st.ms project.epoching.bc_end.ms];
            input_dd.times        = times;
            input_dd.levels_grouping_factor                                                     = levels_grouping_factor;
            input_dd.min_duration                                                               = project.postprocess.erp.design(design_num).min_duration ;                      % ha senso settare una diversa lunghezza minima a seconda della banda o del tipo del sgnale?
            input_dd.pvalue                                                                     = study_ls;                            % default will be 0.05
            input_dd.correction                                                                 = correction;                        % string. correction for multiple comparisons 'none'| 'fdr' | 'holms' | 'bonferoni'
            
                       
            
            output_dd_grouping_factor = eeglab_study_curve_data_driven_onset_offset(input_dd);
            save(grouping_factor_file,'cell_grouped_factor','times','output_dd_grouping_factor','allch')
        else
            
            load(grouping_factor_file);
        end
        
        
        %% plot grouping_factor
%         input_gf.erp_grand_average = mean_collapsed_cell_all_sub{:};
        input_gf.p_grouping_factor  = output_dd_grouping_factor.sigcell_pruned_gf;
        input_gf.erp_avgsub = erp_curve_allch_collsub;
        input_gf.erp_gf    = cell_grouped_factor;
        
        input_gf.pvalue = study_ls;
        input_gf.allch = allch;
        input_gf.xlim = xlim;
        input_gf.amplim = amplim;
        input_gf.times = times;
        input_gf.levels_f1 = levels_f1;
        input_gf.levels_f2 = levels_f2;
        input_gf.plot_dir = plot_dir;
        
        input_gf.levels_grouping_factor = levels_grouping_factor;
        input_gf.name_grouping_factor   = name_grouping_factor;
        input_gf.levels_comparing_factor = levels_comparing_factor;
        input_gf.name_comparing_factor   = name_comparing_factor;
        
        
        eeglab_study_allch_erp_time_dd_grouping_factor_graph(input_gf);
        
    end
    
    
    
    
    %     erp_curve_roi_stat.erp_curve_allch       = erp_curve_allch;
    %     erp_curve_roi_stat.allch                 = allch;
    %     erp_curve_roi_stat.times                 = times;
    %
    %     STUDY = pop_erpparams(STUDY, 'topotime',[] ,'plotgroups','apart' ,'plotconditions','apart','averagechan','on','method', stat_method);
    %     % for each roi in the list
    %     for nroi = 1:length(roi_list)
    %         % lista dei soggetti suddivisi per fattori
    %         list_design_subjects               = eeglab_generate_subjects_list_by_factor_levels(STUDY, design_num);
    %
    %         roi_channels=roi_list{nroi};
    %         roi_name=roi_names{nroi};
    %         STUDY = pop_statparams(STUDY, 'groupstats','off','condstats','off');
    %
    %
    %         [STUDY, erp_curve_roi, times]=std_erpplot(STUDY,ALLEEG,'channels',roi_list{nroi},'noplot','on');
    %
    %         for nf1=1:length(levels_f1)
    %             for nf2=1:length(levels_f2)
    %                 if ~isempty(list_select_subjects)
    %                     vec_select_subjects=ismember(list_design_subjects{nf1,nf2},list_select_subjects);
    %                     if ~sum(vec_select_subjects)
    %                         disp('Error: the selected subjects are not represented in the selected design')
    %                         return;
    %                     end
    %                     erp_curve_roi{nf1,nf2}=erp_curve_roi{nf1,nf2}(:,vec_select_subjects);
    %                      erp_curve_allch{nf1,nf2}=erp_curve_roi_stat.erp_curve_allch{nf1,nf2}(:,vec_select_subjects);
    %                     list_design_subjects{nf1,nf2}=list_design_subjects{nf1,nf2}(vec_select_subjects);
    %                 end
    %             end
    %         end
    %
    %         erp_curve_roi_stat.list_design_subjects = list_design_subjects;
    %
    %         if strcmp(time_resolution_mode,'tw')
    %             group_time_windows_list_design  = group_time_windows_list{design_num};
    %             group_time_windows_names_design = group_time_windows_names{design_num};
    %
    %
    %
    %
    %             erp_curve_roi_stat.group_time_windows_list_design=group_time_windows_list_design;
    %             erp_curve_roi_stat.group_time_windows_names_design=group_time_windows_names_design;
    %
    %             which_extrema_design            = project.postprocess.erp.design(design_num).which_extrema_curve;
    %             which_extrema_design_roi        = which_extrema_design{nroi};
    %
    %             input_find_extrema.which_method_find_extrema             = which_method_find_extrema;
    %             input_find_extrema.design_num                            = design_num;
    %             input_find_extrema.roi_name                              = roi_name;
    %             input_find_extrema.curve                                 = erp_curve_roi;
    %             input_find_extrema.levels_f1                             = levels_f1;
    %             input_find_extrema.levels_f2                             = levels_f2;
    %             input_find_extrema.group_time_windows_list_design        = group_time_windows_list_design;
    %             input_find_extrema.subject_time_windows_list             = subject_time_windows_list;
    %             input_find_extrema.times                                 = times;
    %             input_find_extrema.which_extrema_design_roi              = which_extrema_design_roi;
    %             input_find_extrema.sel_extrema                           = sel_extrema;
    %
    %
    %             erp_curve_roi_stat.dataroi(nroi).datatw.find_extrema = eeglab_study_plot_find_extrema(input_find_extrema);
    %
    %
    %             deflection_polarity_list                                       = project.postprocess.erp.design(design_num).deflection_polarity_list;
    %             deflection_polarity_roi                                        = deflection_polarity_list{nroi};
    %
    %             input_onset_offset.curve                                       = erp_curve_roi;
    %             input_onset_offset.levels_f1                                   = levels_f1;
    %             input_onset_offset.levels_f2                                   = levels_f2;
    %             input_onset_offset.group_time_windows_list_design              = group_time_windows_list_design;
    %             input_onset_offset.times                                       = times;
    %             input_onset_offset.deflection_polarity_list                    = deflection_polarity_roi;
    %             input_onset_offset.min_duration                                = project.postprocess.erp.design(design_num).min_duration ;
    %             input_onset_offset.base_tw                                     = [project.epoching.bc_st.ms project.epoching.bc_end.ms] ;                           % baseline in ms
    %             input_onset_offset.pvalue                                      = study_ls;                          % default will be 0.05
    %             input_onset_offset.correction                                  = correction ;                       % string. correction for multiple comparisons 'none'| 'fdr' | 'holms' | 'bonferoni'
    %
    %             erp_curve_roi_stat.dataroi(nroi).datatw.onset_offset = eeglab_study_curve_tw_onset_offset(input_onset_offset);
    %
    %         end
    %
    %         % M2 viene salvata dentro erp_curve_roi, bisogna creare una nuova struttura con gli estremi ele loro latenze, possibile salvare i dati in forma più grezza
    %         % (per ogni soggetto, i valori nella sottofinestra, non processati, se volessimo calcolare altre misure, tipo varianza, stdev, mediana, che comunque potremmo già calcolarci e salvarci anche qui).
    %
    %         % calculate statistics
    %
    %         %  pcond        - [cell] condition pvalues or mask (0 or 1) if an alpha value
    %         %                 is selected. One element per group.
    %         %  pgroup       - [cell] group pvalues or mask (0 or 1). One element per
    %         %                 condition.
    %         %  pinter       - [cell] three elements, condition pvalues (group pooled),
    %         %                 group pvalues (condition pooled) and interaction pvalues.
    %         %  statcond     - [cell] condition statistic values (F or T).
    %         %  statgroup    - [cell] group pvalues or mask (0 or 1). One element per
    %         %                 condition.
    %         %  statinter    - [cell] three elements, condition statistics (group pooled),
    %         %                 group statistics (condition pooled) and interaction F statistics.
    %
    %         times_plot=times;
    %
    %         if strcmp(time_resolution_mode,'tw')
    %             if strcmp(which_method_find_extrema,'group_align')
    %                 tw_stat_estimator = 'tw_mean'; % nel caso del pattern medio, forzo la media (NON vado a stimare gli estremi dei singoli soggetti come faccio negli altri 2 metodi)
    %             end
    %
    %             switch tw_stat_estimator
    %                 case 'tw_mean'
    %                     erp_curve_roi=erp_curve_roi_stat.dataroi(nroi).datatw.find_extrema.curve;
    %                 case 'tw_extremum'
    %                     erp_curve_roi=erp_curve_roi_stat.dataroi(nroi).datatw.find_extrema.extr;
    %
    %
    %
    %             end
    %             times_plot=1:length(group_time_windows_list_design);
    %
    %             %-------------------------------------------------------------------------------------------------------------
    %             % 04/06/15 : HERE SHOULD BE INTRODUCED ANY DESIRED CORRECTION TO THE DATA BEFORE STATISTICAL ANALYSIS
    %             %-------------------------------------------------------------------------------------------------------------
    %
    %             [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(erp_curve_roi, 2, 'groupstats','on','condstats','on','mcorrect','none',...
    %                 'threshold',NaN,'naccu',num_permutations,'method', stat_method,'paired',paired_list{design_num});
    %
    %             [stat df pvals] = statcond_corr(erp_curve_roi, 2, 'alpha',NaN,'naccu',num_permutations,'method', stat_method);
    %
    %             if iscell(df)
    %                 if length(pcond)
    %                     dfcond=df{1};
    %                 end
    %                 if length(pgroup)
    %                     dfgroup=df{1};
    %                 end
    %                 if length(pinter)
    %                     dfinter=df{1};
    %                 end
    %
    %             else
    %                 if length(pcond)
    %                     dfcond=df(1,:);
    %                 end
    %                 if length(pgroup)
    %                     dfgroup=df(1,:);
    %                 end
    %                 if length(pinter)
    %                     dfinter=df(1,:);
    %                 end
    %
    %
    %             end
    %
    %
    %
    %
    %             for ind = 1:length(pcond),  pcond{ind}    =  abs(pcond{ind}) ; end;
    %             for ind = 1:length(pgroup),  pgroup{ind}  =  abs(pgroup{ind}) ; end;
    %             for ind = 1:length(pinter),  pinter{ind}  =  abs(pinter{ind}) ; end
    %
    %
    %             [pcond_corr, pgroup_corr,  pinter_corr] = eeglab_study_correct_pvals(pcond, pgroup, pinter,correction);
    %
    %             if (strcmp(do_plots,'on'))
    %
    %                 input_graph.STUDY                                          = STUDY;
    %                 input_graph.design_num                                     = design_num;
    %                 input_graph.roi_name                                       = roi_name;
    %                 input_graph.name_f1                                        = name_f1;
    %                 input_graph.name_f2                                        = name_f2;
    %                 input_graph.levels_f1                                      = levels_f1;
    %                 input_graph.levels_f2                                      = levels_f2;
    %                 input_graph.erp_curve                                      = erp_curve_roi;
    %                 input_graph.times                                          = times_plot;
    %                 input_graph.time_windows_design_names                      = group_time_windows_names{design_num};
    %                 input_graph.pcond                                          = pcond_corr;
    %                 input_graph.pgroup                                         = pgroup_corr;
    %                 input_graph.pinter                                         = pinter_corr;
    %                 input_graph.study_ls                                       = study_ls ;
    %                 input_graph.plot_dir                                       = plot_dir;
    %                 input_graph.display_only_significant                       = display_only_significant;
    %                 input_graph.display_compact_plots                          = display_compact_plots;
    %                 input_graph.compact_display_h0                             = compact_display_h0;
    %                 input_graph.compact_display_v0                             = compact_display_v0;
    %                 input_graph.compact_display_sem                            = compact_display_sem;
    %                 input_graph.compact_display_stats                          = compact_display_stats;
    %                 input_graph.display_single_subjects                        = display_single_subjects;
    %                 input_graph.compact_display_xlim                           = compact_display_xlim;
    %                 input_graph.compact_display_ylim                           = compact_display_ylim;
    %
    %                 eeglab_study_roi_erp_curve_tw_graph(input_graph);
    %             end
    %
    %         else
    %             [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(erp_curve_roi, 2, 'groupstats','on','condstats','on','mcorrect','none',...
    %                 'threshold',NaN,'naccu',num_permutations,'method', stat_method,'paired',paired_list{design_num});
    %
    %             for ind = 1:length(pcond),  pcond{ind}    =  abs(pcond{ind}) ; end;
    %             for ind = 1:length(pgroup),  pgroup{ind}  =  abs(pgroup{ind}) ; end;
    %             for ind = 1:length(pinter),  pinter{ind}  =  abs(pinter{ind}) ; end
    %
    %             [pcond_corr, pgroup_corr,  pinter_corr] = eeglab_study_correct_pvals(pcond, pgroup, pinter,correction);
    %
    %             if ~ isempty(masked_times_max)
    %                 [pcond_corr, pgroup_corr, pinter_corr] = eeglab_study_roi_curve_maskp(pcond_corr, pgroup_corr, pinter_corr,times_plot, masked_times_max);
    %             end
    %             if (strcmp(do_plots,'on'))
    %
    %                 input_graph.STUDY                                          = STUDY;
    %                 input_graph.design_num                                     = design_num;
    %                 input_graph.roi_name                                       = roi_name;
    %                 input_graph.name_f1                                        = name_f1;
    %                 input_graph.name_f2                                        = name_f2;
    %                 input_graph.levels_f1                                      = levels_f1;
    %                 input_graph.levels_f2                                      = levels_f2;
    %                 input_graph.erp                                            = erp_curve_roi;
    %                 input_graph.times                                          = times;
    %                 input_graph.pcond                                          = pcond_corr;
    %                 input_graph.pgroup                                         = pgroup_corr;
    %                 input_graph.pinter                                         = pinter_corr;
    %                 input_graph.study_ls                                       = study_ls;
    %                 input_graph.filter                                         = filter;
    %                 input_graph.plot_dir                                       = plot_dir;
    %                 input_graph.display_only_significant                       = display_only_significant;
    %                 input_graph.display_compact_plots                          = display_compact_plots;
    %                 input_graph.compact_display_h0                             = compact_display_h0;
    %                 input_graph.compact_display_v0                             = compact_display_v0;
    %                 input_graph.compact_display_sem                            = compact_display_sem;
    %                 input_graph.compact_display_stats                          = compact_display_stats;
    %                 input_graph.display_single_subjects                        = display_single_subjects;
    %                 input_graph.compact_display_xlim                           = compact_display_xlim;
    %                 input_graph.compact_display_ylim                           = compact_display_ylim;
    %                 input_graph.list_design_subjects                           = list_design_subjects;
    %
    %                 eeglab_study_roi_erp_curve_graph(input_graph);
    %             end
    %         end
    %
    %         erp_curve_roi_stat.dataroi(nroi).roi_channels   = roi_channels;
    %         erp_curve_roi_stat.dataroi(nroi).roi_name       = roi_name;
    %         erp_curve_roi_stat.dataroi(nroi).erp_curve_roi  = erp_curve_roi;
    %         erp_curve_roi_stat.dataroi(nroi).pcond          = pcond;
    %         erp_curve_roi_stat.dataroi(nroi).pgroup         = pgroup;
    %         erp_curve_roi_stat.dataroi(nroi).pinter         = pinter;
    %         erp_curve_roi_stat.dataroi(nroi).statscond      = statscond;
    %         erp_curve_roi_stat.dataroi(nroi).statsgroup     = statsgroup;
    %         erp_curve_roi_stat.dataroi(nroi).statsinter     = statsinter;
    %         erp_curve_roi_stat.dataroi(nroi).dfcond         = dfcond;
    %         erp_curve_roi_stat.dataroi(nroi).dfgroup        = dfgroup;
    %         erp_curve_roi_stat.dataroi(nroi).dfinter        = dfinter;
    %         erp_curve_roi_stat.dataroi(nroi).pcond_corr     = pcond_corr;
    %         erp_curve_roi_stat.dataroi(nroi).pgroup_corr    = pgroup_corr;
    %         erp_curve_roi_stat.dataroi(nroi).pinter_corr    = pinter_corr;
    %
    %     end
    %
    %     erp_curve_roi_stat.times=times_plot;
    %
    %     if strcmp(time_resolution_mode,'tw')
    %         erp_curve_roi_stat.group_time_windows_list                 = group_time_windows_list_design;
    %         erp_curve_roi_stat.group_time_windows_names                = group_time_windows_names_design;
    %         erp_curve_roi_stat.which_extrema_design                    = which_extrema_design;
    %         erp_curve_roi_stat.sel_extrema                             = sel_extrema;
    %
    %         if strcmp(mode.peak_type,'individual')
    %             erp_curve_roi_stat.subject_time_windows_list            = subject_time_windows_list;
    %         end
    %     end
    %
    %     erp_curve_roi_stat.study_ls             = study_ls;
    %     erp_curve_roi_stat.num_permutations     = num_permutations;
    %     erp_curve_roi_stat.correction           = correction;
    %     erp_curve_roi_stat.list_select_subjects = list_select_subjects;
    %
    %
    %     %% EXPORTING DATA AND RESULTS OF ANALYSIS
    %     %         save(fullfile(plot_dir,'erp_curve_roi-stat.mat'),'erp_curve_roi_stat');
    %     %
    %     %         if ~ ( strcmp(which_method_find_extrema,'group_noalign') || strcmp(which_method_find_extrema,'continuous') );
    %     %             [dataexpcols, dataexp]=text_export_erp(plot_dir,erp_curve_roi_stat);
    %     %         end
    %     %
    %
    %     %% EXPORTING DATA AND RESULTS OF ANALYSIS
    %     out_file_name = fullfile(plot_dir,'erp_curve_roi-stat');
    %     save([out_file_name,'.mat'],'erp_curve_roi_stat','project');
    %
    %     %     if ~ ( strcmp(which_method_find_extrema,'group_noalign') || strcmp(which_method_find_extrema,'continuous') );
    %     %         [dataexpcols, dataexp] = text_export_erp_struct([out_file_name,'.txt'],erp_curve_roi_stat);
    %     % %         text_export_erp_resume_struct(erp_curve_roi_stat, [out_file_name '_resume']);
    %     % %         text_export_erp_resume_struct(erp_curve_roi_stat, [out_file_name '_resume_signif'], 'p_thresh', erp_curve_roi_stat.study_ls);
    %     %     end
    %     if not( strcmp(which_method_find_extrema,'group_noalign') || strcmp(which_method_find_extrema,'continuous') );
    %         [dataexpcols, dataexp] = text_export_erp_struct([out_file_name,'.txt'],erp_curve_roi_stat);
    %         text_export_erp_resume_struct(erp_curve_roi_stat, [out_file_name '_resume']);
    %         text_export_erp_resume_struct(erp_curve_roi_stat, [out_file_name '_resume_signif'], 'p_thresh', erp_curve_roi_stat.study_ls);
    %     end
    %
    %     if strcmp(which_method_find_extrema,'continuous') ;
    %         [dataexpcols, dataexp] = text_export_erp_continuous_struct([out_file_name,'.txt'],erp_curve_roi_stat);
    %         %         text_export_erp_resume_struct(erp_curve_roi_stat, [out_file_name '_resume']);
    %         %         text_export_erp_resume_struct(erp_curve_roi_stat, [out_file_name '_resume_signif'], 'p_thresh', erp_curve_roi_stat.study_ls);
    %             [dataexpcols, dataexp] = text_export_erp_allch_sub_continuous_struct(plot_dir,erp_curve_roi_stat);%[out_file_name,'_allch_sub_continuous.txt']
    %
    %     end
    %
    %     if strcmp(time_resolution_mode,'tw')
    %
    %         % esportare statistiche onset-offset: sia statistiche riassuntive di
    %         % ogni tw, sia il risultato punto a punto (linee sotto le curve) per
    %         % ogni roi, cond, soggetto, ... il tutto su 2 file di testo separati
    %         % per non fare casino: alla fine hai curve, linee di significatività,
    %         % statistiche riassuntive
    %         [dataexpcols, dataexp] = text_export_erp_onset_offset_sub_struct([out_file_name,'_sub_onset_offset.txt'],erp_curve_roi_stat);
    %         [dataexpcols, dataexp] = text_export_erp_onset_offset_avgsub_struct([out_file_name,'_avgsub_onset_offset.txt'],erp_curve_roi_stat);
    %
    %         [dataexpcols, dataexp] = text_export_erp_onset_offset_sub_continuous_struct([out_file_name,'_sub_onset_offset_continuous.txt'],erp_curve_roi_stat);
    %         [dataexpcols, dataexp] = text_export_erp_onset_offset_avgsub_continuous_struct([out_file_name,'_avgsub_onset_offset_continuous.txt'],erp_curve_roi_stat);
    %     end
    %     %
    %     %
    %
    %
    %     %% export onset_offset
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
    %
end
end
