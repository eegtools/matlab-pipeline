%% [output] = eeglab_study_plot_ersp_topo_tw_fb_compact(input)
% calculate and display ersp topographic distribution (in a set of frequency bands)
% for groups of scalp channels considered as regions of interests (ROI) in
% an EEGLAB STUDY with statistical comparisons based on the factors in the selected design.
% Use a representation with both time series (boxplot or errorbar) and
% topographic location with pairwise statistic comparisons
%
% project                                                                    = input.project;
% study_path                                                                 = input.study_path;
% design_num_vec                                                             = input.design_num_vec;
% design_factors_ordered_levels                                              = input.design_factors_ordered_levels;
% results_path                                                               = input.results_path;
% stat_analysis_suffix                                                       = input.stat_analysis_suffix;
% roi_list                                                                   = input.roi_list;
% roi_names                                                                  = input.roi_names;
% group_time_windows_list                                                    = input.group_time_windows_list;
% group_time_windows_names                                                   = input.group_time_windows_names;
% subject_time_windows_list                                                  = input.subject_time_windows_list;
% frequency_bands_list                                                       = input.frequency_bands_list;
% frequency_bands_names                                                      = input.frequency_bands_names;
% study_ls                                                                   = input.study_ls;
% num_permutations                                                           = input.num_permutations;
% correction                                                                 = input.correction;
% set_caxis                                                                  = input.set_caxis;
% paired_list                                                                = input.paired_list;
% stat_method                                                                = input.stat_method;
% display_only_significant_topo                                              = input.display_only_significant_topo;
% display_only_significant_topo_mode                                         = input.display_only_significant_topo_mode;
% display_compact_topo                                                       = input.display_compact_topo;
% display_compact_topo_mode                                                  = input.display_compact_topo_mode;
% list_select_subjects                                                       = input.list_select_subjects;
% ersp_measure                                                               = input.ersp_measure;
% subjects_data                                                              = input.subjects_data;
% mode                                                                       = input.mode;
% show_head                                                                  = input.show_head;
% do_plots                                                                   = input.do_plots;
% compact_display_ylim                                                       = input.compact_display_ylim;
% num_tails                                                                  = input.num_tails;
% show_text                                                                  = input.show_text;
% z_transform                                                                = input.z_transform;
% which_error_measure                                                        = input.which_error_measure;
% do_narrowband                                                              = input.do_narrowband;
% 
% output.STUDY                                                               = STUDY;
% output.EEG                                                                 = EEG;


function [output] = eeglab_study_plot_ersp_topo_tw_fb_compact(input)

if nargin < 1
    help eeglab_study_plot_ersp_topo_tw_fb_compact;
    return;
end;



project                                                                    = input.project;
study_path                                                                 = input.study_path;
design_num_vec                                                             = input.design_num_vec;
design_factors_ordered_levels                                              = input.design_factors_ordered_levels;
results_path                                                               = input.results_path;
stat_analysis_suffix                                                       = input.stat_analysis_suffix;
roi_list                                                                   = input.roi_list;
roi_names                                                                  = input.roi_names;
group_time_windows_list                                                    = input.group_time_windows_list;
group_time_windows_names                                                   = input.group_time_windows_names;
subject_time_windows_list                                                  = input.subject_time_windows_list;
frequency_bands_list                                                       = input.frequency_bands_list;
frequency_bands_names                                                      = input.frequency_bands_names;
study_ls                                                                   = input.study_ls;
num_permutations                                                           = input.num_permutations;
correction                                                                 = input.correction;
set_caxis                                                                  = input.set_caxis;
paired_list                                                                = input.paired_list;
stat_method                                                                = input.stat_method;
display_only_significant_topo                                              = input.display_only_significant_topo;
display_only_significant_topo_mode                                         = input.display_only_significant_topo_mode;
display_compact_topo                                                       = input.display_compact_topo;
display_compact_topo_mode                                                  = input.display_compact_topo_mode;
list_select_subjects                                                       = input.list_select_subjects;
ersp_measure                                                               = input.ersp_measure;
subjects_data                                                              = input.subjects_data;
mode                                                                       = input.mode;
show_head                                                                  = input.show_head;
do_plots                                                                   = input.do_plots;
compact_display_ylim                                                       = input.compact_display_ylim;
num_tails                                                                  = input.num_tails;
show_text                                                                  = input.show_text;
z_transform                                                                = input.z_transform;
which_error_measure                                                        = input.which_error_measure;
do_narrowband                                                              = input.do_narrowband;



pcond=[];
pgroup=[];
pinter=[];



display_compact_plots=project.results_display.ersp.compact_plots;
compact_display_h0 = project.results_display.ersp.compact_h0;
compact_display_v0 = project.results_display.ersp.compact_v0;
compact_display_sem = project.results_display.ersp.compact_sem;
compact_display_stats = project.results_display.ersp.compact_stats;
compact_display_xlim = project.results_display.ersp.compact_display_xlim;
compact_display_ylim = project.results_display.ersp.compact_display_ylim;





[study_path,study_name_noext,study_ext] = fileparts(study_path);

% start EEGLab
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

% load the study and working with the study structure
[STUDY ALLEEG] = pop_loadstudy( 'filename',[study_name_noext study_ext],'filepath',study_path);

% channels locations
locs                                        = eeg_mergelocs(ALLEEG.chanlocs);
locs_labels                                 = {locs.labels};


ersp_topo_stat.group_time_windows_names    = group_time_windows_names;
ersp_topo_stat.group_time_windows_list     = group_time_windows_list;

ersp_topo_stat.roi_names                   = roi_names;
ersp_topo_stat.roi_list                    = roi_list;
ersp_topo_stat.frequency_bands_names       = frequency_bands_names;
ersp_topo_stat.frequency_bands_list        = frequency_bands_list;
ersp_topo_stat.mode                        = mode;

ersp_curve_roi_fb_stat.roi_names           = roi_names;
ersp_curve_roi_fb_stat.roi_list            = roi_list;

ersp_curve_roi_fb_stat.mode                = mode;
ersp_curve_roi_fb_stat.frequency_bands_names   = frequency_bands_names;
ersp_curve_roi_fb_stat.frequency_bands_list    = frequency_bands_list;




%% ANALYSIS MODALITIES
if strcmp(mode.peak_type, 'group') && strcmp(mode.align, 'off')
    which_method_find_extrema = 'group_noalign';
elseif strcmp(mode.peak_type, 'group') && strcmp(mode.align, 'on')
    which_method_find_extrema = 'group_align';
elseif strcmp(mode.peak_type, 'individual') && strcmp(mode.align, 'off')
    which_method_find_extrema = 'individual_noalign';
elseif strcmp(mode.peak_type, 'individual') && strcmp(mode.align, 'on')
    which_method_find_extrema = 'individual_align';
elseif strcmp(mode.peak_type, 'off')
    display('Error: missing method for dealing with extrema: adopting individual_align')
    which_method_find_extrema = 'individual_align';
end

tw_stat_estimator           = mode.tw_stat_estimator;       ... mean, extremum
    time_resolution_mode        = mode.time_resolution_mode;    ... continous, tw
    sel_extrema                 = project.postprocess.ersp.sel_extrema;







for design_num=design_num_vec
    
    
    
    plot_dir=fullfile(results_path,stat_analysis_suffix,[STUDY.design(design_num).name,'-ersp_topo_tw_fb_compact','-', display_compact_topo_mode, '-', which_method_find_extrema, '_',datestr(now,30)]);
    mkdir(plot_dir);
    
    
    
    ersp_topo_stat.study_des                       = STUDY.design(design_num);
    ersp_topo_stat.study_des.num                   = design_num;
    
    group_time_windows_list_design                  = group_time_windows_list{design_num};
    group_time_windows_names_design                 = group_time_windows_names{design_num};
    
    ersp_topo_stat.group_time_windows_list_design   = group_time_windows_list_design;
    ersp_topo_stat.group_time_windows_names_design  = group_time_windows_names_design;
    
    
    % lista dei soggetti suddivisi per fattori
    list_design_subjects   = eeglab_generate_subjects_list_by_factor_levels(STUDY, design_num);
    individual_fb_bands    = eeglab_generate_subjects_bands_by_factor_levels(STUDY, design_num, subjects_data, frequency_bands_list);  ... {factor1,factor2}{subj}{band}
        
ersp_topo_stat.list_design_subjects=list_design_subjects;
ersp_topo_stat.individual_fb_bands=individual_fb_bands;

%         group_time_windows_list     = arrange_structure(project.postprocess.ersp.design, 'group_time_windows');
%         subject_time_windows_list   = arrange_structure(project.postprocess.ersp.design, 'subject_time_windows');
%         group_time_windows_names    = arrange_structure(project.postprocess.ersp.design, 'group_time_windows_names');
%         ersp_measure                = project.stats.ersp.measure;

ersp_curve_roi_fb_stat.study_des=STUDY.design(design_num);
ersp_curve_roi_fb_stat.list_design_subjects=list_design_subjects;
ersp_curve_roi_fb_stat.individual_fb_bands=individual_fb_bands;


% select the study design for the analyses
STUDY = std_selectdesign(STUDY, ALLEEG, design_num);

% exctract names of the factores and the names of the corresponding levels for the selected design
name_f1=STUDY.design(design_num).variable(1).label;
name_f2=STUDY.design(design_num).variable(2).label;

levels_f1=STUDY.design(design_num).variable(1).value;
levels_f2=STUDY.design(design_num).variable(2).value;

tlf1=length(levels_f1);
tlf2=length(levels_f2);









%% DOING CLASSICAL ANALYSIS/STATISTICS AND ALLOWING COMPATIBILITY FOR EXPORTING DATA
%% set representation to time-frequency representation
STUDY = pop_erspparams(STUDY, 'topotime',[] ,'plotgroups','apart' ,'plotconditions','apart','averagechan','on','method', stat_method);

%% for each roi in the list
for nroi = 1:length(roi_list)
    ersp=[];
    
    roi_channels=roi_list{nroi};
    roi_name=roi_names{nroi};
    STUDY = pop_statparams(STUDY, 'groupstats','off','condstats','off','method', stat_method);
    
    %% calculate ersp in the channels corresponding to the selected roi
    [STUDY ersp times freqs]=std_erspplot(STUDY,ALLEEG,'channels',roi_list{nroi},'noplot','on');
    
    if strcmp(ersp_measure, 'Pfu')
        for nf1=1:length(levels_f1)
            for nf2=1:length(levels_f2)
                ersp{nf1,nf2}=(10.^(ersp{nf1,nf2}/10)-1)*100;
                
            end
        end
    end
    
    %% select subjects
    for nf1=1:length(levels_f1)
        for nf2=1:length(levels_f2)
            if ~isempty(list_select_subjects)
                vec_select_subjects=ismember(list_design_subjects{nf1,nf2},list_select_subjects);
                if ~sum(vec_select_subjects)
                    dis('Error: the selected subjects are not represented in the selected design')
                    return;
                end
                ersp{nf1,nf2}=ersp{nf1,nf2}(:,:,:,vec_select_subjects);
                filtered_individual_fb_bands{nf1,nf2} = {individual_fb_bands{nf1,nf2}{vec_select_subjects}};
            else
                filtered_individual_fb_bands{nf1,nf2} = individual_fb_bands{nf1,nf2};
            end
        end
    end
    
    %% averaging channels in the roi
    ersp_roi=[];
    for nf1=1:length(levels_f1)
        for nf2=1:length(levels_f2)
            ersp_roi{nf1,nf2}=squeeze(mean(ersp{nf1,nf2},3));
        end
    end
    
    %% selecting and averaging powers in a frequency band
    for nband=1:length(frequency_bands_list)
        
        ersp_curve_roi_fb=[];
        for nf1=1:length(levels_f1)
            for nf2=1:length(levels_f2)
                subjs = length(filtered_individual_fb_bands{nf1,nf2});
                for nsub=1:subjs
                    
                    fmin=filtered_individual_fb_bands{nf1,nf2}{nsub}{nband}(1);
                    fmax=filtered_individual_fb_bands{nf1,nf2}{nsub}{nband}(2);
                    
                    ...[nfmin, nfmax] = eeglab_get_narrowband(ersp_curve_roi_fb{nf1,nf2}(:,nsub), [fmin fmax], [tmin tmax], [dfmin dfmax]);
                        ...sel_freqs = freqs >= nfmin & freqs <= nfmax;
                        
                    
                    narrowband=[];
                    if strcmp(do_narrowband,'on')
                        group_fmin=fmin;
                        group_fmax=fmax;
                        
                        [sub_adjusted_fmin, sub_adjusted_fmax, sub_realign_freq, sub_realign_freq_value, sub_realign_freq_value_lat, ....
                            mean_centroid_group_fb, mean_centroid_sub_realign_fb,....
                            median_centroid_group_fb, median_centroid_sub_realign_fb] = ...
                            eeglab_get_narrowband(ersp_matrix_sub, times, freqs, group_tmin, group_tmax, group_fmin, group_fmax, group_dfmin, group_dfmax,which_realign_measure);
                        
                        if ~isempty([sub_adjusted_fmin, sub_adjusted_fmax])
                            fmin=sub_adjusted_fmin;
                            fmax=sub_adjusted_fmax;
                        end
                        
                        
                        
                        
                        narrowband.adjusted_frequency_band{nf1,nf2}(nsub,:)=[sub_adjusted_fmin, sub_adjusted_fmax];
                        narrowband.realign_freq{nf1,nf2}(nsub)=sub_realign_freq;
                        narrowband.realign_freq_value{nf1,nf2}(nsub)=sub_realign_freq_value;
                        narrowband.realign_freq_value_lat{nf1,nf2}(nsub)=sub_realign_freq_value_lat;
                        
                        narrowband.mean_centroid_group_fb{nf1,nf2}(nsub)=mean_centroid_group_fb;
                        narrowband.mean_centroid_sub_realign_fb{nf1,nf2}(nsub)=mean_centroid_sub_realign_fb;
                        narrowband.median_centroid_group_fb{nf1,nf2}(nsub)=median_centroid_group_fb;
                        narrowband.median_centroid_sub_realign_fb{nf1,nf2}(nsub)=median_centroid_sub_realign_fb;
                    end
                    
                    sel_freqs = freqs >= fmin & freqs <= fmax;
                    ersp_curve_roi_fb{nf1,nf2}(:,nsub)=mean(ersp_roi{nf1,nf2}(sel_freqs,:,nsub),1);
                end
                
            end
        end
        
        
        %% involve functions based on finding extrema of time
        % windows
        
        
        
        group_time_windows_list_design  = group_time_windows_list{design_num};
        group_time_windows_names_design = group_time_windows_names{design_num};
        
        ersp_curve_roi_fb_stat.group_time_windows_list_design=group_time_windows_list_design;
        ersp_curve_roi_fb_stat.group_time_windows_names_design=group_time_windows_names_design;
        
        which_extrema_design            = project.postprocess.ersp.design(design_num).which_extrema_curve; ...which_extrema_ersp_curve_fb{design_num};
            which_extrema_design_roi        = which_extrema_design{nroi};
        which_extrema_design_roi_band   = which_extrema_design_roi{nband};
        
        % check if estimated TIMES is contained within intervals of interests
        max_times=max(times);
        max_v=-10000;
        for nwin=1:length(group_time_windows_list_design)
            max_v=max(max_v, group_time_windows_list_design{nwin}(2));
        end
        if max_v > max_times
            disp(['error !!: higher latency of available ERSP window' num2str(max_times) 'is less than highest latency of input windows' num2str(max_v)]);
            return;
        end
        
        switch which_method_find_extrema
            
            case 'group_noalign'
                ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).datatw = ...
                    eeglab_study_plot_find_extrema_avg(ersp_curve_roi_fb,levels_f1,levels_f2,group_time_windows_list_design,times,which_extrema_design_roi_band,sel_extrema);
            case 'group_align'
                disp('ERROR: still not implemented!!! adopting individual_align ');
                subject_time_windows_list_design=subject_time_windows_list{design_num};
                ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).datatw = ...
                    eeglab_study_plot_find_extrema_single(ersp_curve_roi_fb,levels_f1,levels_f2,group_time_windows_list_design,subject_time_windows_list_design,times,...
                    which_extrema_design_roi_band,sel_extrema);
                ...ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).datatw = ...
                    ...  eeglab_study_plot_find_extrema_avg(ersp_curve_roi_fb,levels_f1,levels_f2,group_time_windows_list_design,times,which_extrema_design_roi_band,sel_extrema);
                    
            case 'individual_noalign'
                ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).datatw = ...
                    eeglab_study_plot_find_extrema_gru(ersp_curve_roi_fb,levels_f1,levels_f2,group_time_windows_list_design,times,which_extrema_design_roi_band,sel_extrema);
            case 'individual_align'
                subject_time_windows_list_design=subject_time_windows_list{design_num};
                ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).datatw = ...
                    eeglab_study_plot_find_extrema_single(ersp_curve_roi_fb,levels_f1,levels_f2,group_time_windows_list_design,subject_time_windows_list_design,times,...
                    which_extrema_design_roi_band,sel_extrema);
        end
        
        
        times_plot=times;
        
        
        if strcmp(which_method_find_extrema,'group_align')
            tw_stat_estimator = 'tw_mean';
        end
        
        switch tw_stat_estimator
            case 'tw_mean'
                ersp_curve_roi_fb=ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).datatw.curve;
            case 'tw_extremum'
                ersp_curve_roi_fb=ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).datatw.extr;
        end
        
        times_plot=1:length(group_time_windows_list_design);
        
        %% calculate statistics
        [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(ersp_curve_roi_fb,num_tails,...
            'groupstats','on','condstats','on','mcorrect','none','threshold',NaN,'naccu',num_permutations,'method', stat_method,'paired',paired_list{design_num});
        for ind = 1:length(pcond),  pcond{ind}    =  abs(pcond{ind}) ; end;
        for ind = 1:length(pgroup),  pgroup{ind}  =  abs(pgroup{ind}) ; end;
        for ind = 1:length(pinter),  pinter{ind}  =  abs(pinter{ind}) ; end;
        
        [pcond_corr, pgroup_corr, pinter_corr] = eeglab_study_correct_pvals(pcond, pgroup, pinter,correction);
        
        if (strcmp(do_plots,'on'))
            eeglab_study_roi_ersp_curve_tw_fb_graph(STUDY, design_num, roi_name, name_f1, name_f2, levels_f1,levels_f2, ...
                ersp_curve_roi_fb, times_plot, frequency_bands_names{nband},group_time_windows_names{design_num},...
                pcond_corr, pgroup_corr, pinter_corr,study_ls,plot_dir,display_only_significant_topo,display_compact_plots,...
                compact_display_h0,compact_display_v0,compact_display_sem,compact_display_stats,...
                compact_display_xlim,compact_display_ylim,ersp_measure);
        end
        
        
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).narrowband          = narrowband;
        
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).frequency_band_name   = frequency_bands_names{nband};
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).frequency_band        = frequency_bands_list{nband};
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).ersp_curve_roi_fb     = ersp_curve_roi_fb;
        
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).pcond                 = pcond;
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).pgroup                = pgroup;
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).pinter                = pinter;
        
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).statscond             = statscond;
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).statsgroup            = statsgroup;
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).statsinter            = statsinter;
        
        
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).pcond_corr                 = pcond_corr;
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).pgroup_corr                = pgroup_corr;
        ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).pinter_corr                = pinter_corr;
    end
    
    ersp_curve_roi_fb_stat.dataroi(nroi).roi_channels=roi_channels;
    ersp_curve_roi_fb_stat.dataroi(nroi).roi_name=roi_name;
    
end
ersp_curve_roi_fb_stat.times=times_plot;


if strcmp(time_resolution_mode,'tw')
    ersp_curve_roi_fb_stat.group_time_windows_list                 = group_time_windows_list_design;
    ersp_curve_roi_fb_stat.group_time_windows_names                = group_time_windows_names_design;
    ersp_curve_roi_fb_stat.which_extrema_design                    = which_extrema_design;
    ersp_curve_roi_fb_stat.sel_extrema                             = sel_extrema;
    
    if strcmp(mode.peak_type,'individual')
        ersp_curve_roi_fb_stat.subject_time_windows_list = subject_time_windows_list;
    end
end




%% DOING MULTIPLE COMPARISONS ANALYSIS

% plot topo map of each band in frequency_bands_list in each time window in design_group_time_windows_list
STUDY = pop_statparams(STUDY, 'condstats','on', 'groupstats','on', 'alpha',study_ls,'naccu',num_permutations,'method', stat_method,...
    'mcorrect',correction,'paired',paired_list{design_num});

% for each roi in the list
for nroi = 1:length(roi_names)
    roi_channels=roi_list{nroi};
    roi_name=roi_names{nroi};
    
    
    
    STUDY = pop_statparams(STUDY, 'groupstats','off','condstats','off');
    
    % calculate ersp in the channels corresponding to the selected roi
    [STUDY ersp_topo_tw_fb times freqs]=std_erspplot(STUDY,ALLEEG,'channels',roi_channels,'noplot','on');
    
    
    %                     roi_mask =ones(1,length(locs_labels));
    roi_mask = ismember(locs_labels,roi_channels);
    
    ersp_topo_tw_fb_roi_avg=[];
    
    
    
    
    for nband=1:length(frequency_bands_list)
        
        frequency_band_name=frequency_bands_names{nband};
        
        
        for nf1=1:length(levels_f1)
            for nf2=1:length(levels_f2)
                ersp_topo_tw_fb_roi_avg{nf1,nf2}=ersp_curve_roi_fb_stat.dataroi(nroi).databand(nband).ersp_curve_roi_fb{nf1,nf2};
            end
        end
        
        
        
        
        if ~ isempty(design_factors_ordered_levels)
            if ~ isempty(design_factors_ordered_levels{design_num}{1})
                levels_f1=STUDY.design(design_num).variable(1).value;
                [match_lev reorder_lev]=ismember(design_factors_ordered_levels{design_num}{1},levels_f1);
                levels_f1=levels_f1(reorder_lev);
                ersp_topo_tw_fb_roi_avg=ersp_topo_tw_fb_roi_avg(reorder_lev,:);
            end
            
            if ~ isempty(design_factors_ordered_levels{design_num}{2})
                levels_f2=STUDY.design(design_num).variable(2).value;
                [match_lev reorder_lev]=ismember(design_factors_ordered_levels{design_num}{2},levels_f2);
                levels_f2=levels_f2(reorder_lev);
                ersp_topo_tw_fb_roi_avg=ersp_topo_tw_fb_roi_avg{:,reorder_lev};
            end
        end
        
        
        
        for nwin=1:length(group_time_windows_list_design)
            
            
            time_window_name        = group_time_windows_names_design{nwin};
            time_window             = group_time_windows_list_design{nwin};
            ersp_topo_tw_fb_roi_avg_tw=[];
            
            STUDY = pop_erspparams(STUDY, 'topotime',time_window ,'topofreq', frequency_bands_list{nband});
            
            [s1,s2] = size(ersp_topo_tw_fb_roi_avg);
            
            for n1 =1:s1
                for n2 = 1:s2
                    
                    pluto = ersp_topo_tw_fb_roi_avg{n1,n2};
                    ersp_topo_tw_fb_roi_avg_tw{n1,n2}= pluto(nwin,:);
                end
            end
            
            [stats.anova.stats_anova, stats.anova.stats.df_anova , stats.anova.p_anova]=statcond_corr(ersp_topo_tw_fb_roi_avg_tw, num_tails,'method', stat_method, 'naccu', num_permutations);
            
            
            % calculate statistics for each pairwise comparison
            % of each factor
            [stats.post_hoc.statscond, stats.post_hoc.statsgroup, stats.post_hoc.dfcond, stats.post_hoc.dfgroup, stats.post_hoc.pcond, ...
                stats.post_hoc.pgroup, stats.post_hoc.compcond, stats.post_hoc.compgroup]= ...
                pairwise_compairsons_stats(ersp_topo_tw_fb_roi_avg_tw,stat_method,num_permutations,num_tails);
            
            
            [stats.post_hoc.pcond_corr, stats.post_hoc.pgroup_corr, stats.post_hoc.pinter_corr] = eeglab_study_correct_pvals( stats.post_hoc.pcond,  stats.post_hoc.pgroup,  [],correction);
            
            
            if (strcmp(do_plots,'on'))
                
                eeglab_study_ersp_topo_graph(STUDY, design_num, ersp_topo_tw_fb_roi_avg_tw,set_caxis, locs, name_f1, name_f2, levels_f1,levels_f2,...
                    time_window_name,time_window, ...
                    frequency_band_name, ...
                    stats.post_hoc.pcond_corr, stats.post_hoc.pgroup_corr, stats.post_hoc.pinter_corr,study_ls,...
                    plot_dir,display_only_significant_topo,display_only_significant_topo_mode,...
                    display_compact_topo,display_compact_topo_mode,...
                    ersp_topo_tw_fb_roi_avg_tw,...
                    stats.post_hoc.compcond, stats.post_hoc.compgroup,...
                    roi_name, roi_mask,...
                    ersp_measure,show_head,compact_display_ylim,show_text,z_transform,which_error_measure);
            end
            
            
            ersp_topo_stat.dataroi(nroi).datatw_compact(nwin).databand(nband).time_window_name      = time_window_name;
            ersp_topo_stat.dataroi(nroi).datatw_compact(nwin).databand(nband).time_window           = time_window;
            
            ersp_topo_stat.dataroi(nroi).datatw_compact(nwin).databand(nband).frequency_band_name   = frequency_band_name;
            ersp_topo_stat.dataroi(nroi).datatw_compact(nwin).databand(nband).frequency_band        = frequency_bands_list{nband};
            ersp_topo_stat.dataroi(nroi).datatw_compact(nwin).databand(nband).ersp_topo             = ersp_topo_tw_fb;
            
            ersp_topo_stat.dataroi(nroi).datatw_compact(nwin).databand(nband).stats=stats;
            ersp_topo_stat.dataroi(nroi).datatw_compact(nwin).databand(nband).ersp_topo_tw_fb_roi_avg = ersp_topo_tw_fb_roi_avg;
            
            
            
            
        end
    end
end

ersp_compact.ersp_topo_stat=ersp_topo_stat;
ersp_compact.ersp_curve_roi_fb_stat=ersp_curve_roi_fb_stat;

%% EXPORTING DATA AND RESULTS OF ANALYSIS
out_file_name=fullfile(plot_dir,'ersp_compact')
save([out_file_name,'.mat'],'ersp_compact');

if ~ ( strcmp(which_method_find_extrema,'group_noalign') || strcmp(which_method_find_extrema,'continuous') );
    [dataexpcols, dataexp]=text_export_ersp_struct([out_file_name,'.txt'],ersp_curve_roi_fb_stat);
end

output.STUDY = STUDY;
output.EEG   = EEG;
end
end