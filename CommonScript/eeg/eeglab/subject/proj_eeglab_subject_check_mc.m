function EEG  =  proj_eeglab_subject_check_mc(project, varargin)

    list_select_subjects    = project.subjects.list;
    custom_suffix           = '';

    for par=1:2:length(varargin)
        switch varargin{par}
            case {  ...
                    'list_select_subjects', ...
                    'custom_suffix' ...
                    }

                if isempty(varargin{par+1})
                    continue;
                else
                    assign(varargin{par}, varargin{par+1});
                end
        end
    end

    if not(iscell(list_select_subjects)), list_select_subjects = {list_select_subjects}; end
    numsubj = length(list_select_subjects);


    checks.condition_triggers                           = project.task.events.valid_marker;
    
    checks.begin_trial.switch                           = 'on';
    checks.begin_trial.input.begin_trial_marker         = project.task.events.trial_start_trigger_value;
    checks.begin_trial.input.end_trial_marker           = project.task.events.trial_end_trigger_value;

    checks.end_trial.switch                             = 'on';
    checks.end_trial.input.end_trial_marker             = project.task.events.trial_end_trigger_value;
    checks.end_trial.input.begin_trial_marker           = project.task.events.trial_start_trigger_value;

    checks.begin_baseline.switch                        = 'on';
    checks.begin_baseline.input.begin_baseline_marker   = project.task.events.baseline_start_trigger_value;
    checks.begin_baseline.input.end_baseline_marker     = project.task.events.baseline_end_trigger_value;
    
    checks.end_baseline.switch                          = 'on';
    checks.end_baseline.input.begin_baseline_marker     = project.task.events.baseline_start_trigger_value;
    checks.end_baseline.input.end_baseline_marker       = project.task.events.baseline_end_trigger_value;
    checks.end_baseline.input.end_trial_marker          = project.task.events.trial_end_trigger_value;
    
    checks.conditions_triggers                          = project.task.events.mrkcode_cond;
    

    for subj=1:numsubj

        subj_name                   = list_select_subjects{subj};
        input_file_name             = proj_eeglab_subject_get_filename(project, subj_name,'input_epoching','custom_suffix', custom_suffix);
        EEG                         = pop_loadset(input_file_name);

        results                     = eeglab_subject_check_mc2(EEG, checks);

    end



end