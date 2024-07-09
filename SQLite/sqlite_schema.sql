CREATE TABLE 
       electrodes 
     ( electrode_name TEXT NOT NULL
     , PRIMARY KEY (electrode_name)
     );

INSERT INTO 
       electrodes VALUES 
     ( 'Medtronic 3389' ) ;

INSERT INTO 
       electrodes VALUES 
     ( 'Abbott SJM 6170' );

CREATE TABLE 
       subjects 
     ( subject_id INTEGER NOT NULL
     , center_name TEXT NOT NULL
     , patient_id_acr TEXT NOT NULL
     , age INTEGER
     , sex TEXT
     , pathology TEXT
     , year_1st_symptom_occ INTEGER
     , disease_duration REAL
     , surgery_date TEXT
     , PRIMARY KEY (subject_id)
     , UNIQUE (patient_id_acr)
     );

CREATE TABLE 
       files 
     ( file_id TEXT NOT NULL
     , subject_id INTEGER
     , electrode_id INTEGER
     , file_path TEXT NOT NULL
     , file_type TEXT NOT NULL
     , source_id INTEGER
     , transformation_id INTEGER
     , CONSTRAINT subjects_images FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , CONSTRAINT fk_images_images_1 FOREIGN KEY (file_id) REFERENCES files (source_id)
     , CONSTRAINT fk_electrodes_images_1 FOREIGN KEY (electrode_id) REFERENCES electrodes (electrode_name)
     , PRIMARY KEY (file_id)
     , UNIQUE (file_path)
     );

CREATE TABLE 
       bids 
     ( file_id TEXT NOT NULL
     , modality TEXT
     , protocol_name TEXT
     , stereotactic TEXT
     , dicom_image_type TEXT
     , acquisition_date_time TEXT
     , relative_sidecar_path TEXT
     , bids_subject TEXT NOT NULL
     , bids_session TEXT NOT NULL
     , bids_extension TEXT NOT NULL
     , bids_datatype TEXT NOT NULL
     , bids_acquisition TEXT NOT NULL
     , bids_suffix TEXT NOT NULL
     , PRIMARY KEY (file_id)
     , UNIQUE (file_id)
     , CONSTRAINT fk_bids_files_1 FOREIGN KEY (file_id) REFERENCES files (file_id)
     );

CREATE TABLE 
       labels 
     ( file_id TEXT NOT NULL
     , hemisphere TEXT NOT NULL
     , structure TEXT NOT NULL
     , color TEXT
     , comment TEXT
     , PRIMARY KEY (file_id)
     , UNIQUE (file_id)
     , CONSTRAINT fk_labels_files_1 FOREIGN KEY (file_id) REFERENCES files (file_id)
     );

CREATE TABLE 
       transformations 
     ( transformation_id INTEGER PRIMARY KEY AUTOINCREMENT
     , identity TEXT
     , target_id TEXT NOT NULL
     , transform_id TEXT NOT NULL
     , CONSTRAINT fk_transformations_images_2 FOREIGN KEY (target_id) REFERENCES files (file_id)
     , CONSTRAINT fk_transformations_transformations_1 FOREIGN KEY (transform_id) REFERENCES files (file_id)
     , UNIQUE (target_id, transform_id)
     );

CREATE TABLE 
       medications 
     ( subject_id INTEGER NOT NULL
     , session_name TEXT NOT NULL
     , acquisition_date TEXT NOT NULL
     , dose_primidone REAL
     , dose_propranolol REAL
     , dose_gabapentin REAL
     , dose_rivotril_clonazepam REAL
     , dose_topamax REAL
     , dose_ledd REAL
     , additional_medication TEXT
     , additonal_session_notes TEXT
     , PRIMARY KEY (subject_id, session_name)
     , CONSTRAINT subjects_medication FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , UNIQUE (subject_id, session_name)
     );

CREATE TABLE 
       clinical_data_other_evals 
     ( subject_id INTEGER NOT NULL
     , session_name TEXT NOT NULL
     , date_neurological_eval INTEGER
     , hoehn_yahr INTEGER
     , adl_scale_pd INTEGER
     , adl_scale_dyskinesia INTEGER
     , epworth_sleepiness_sc INTEGER
     , moca_total INTEGER
     , send_pd_1_psych_sympt INTEGER
     , send_pd_2_mood INTEGER
     , send_pd_3_impulse INTEGER
     , send_pd_sum INTEGER
     , aed_informant INTEGER
     , beck_depr_inventory INTEGER
     , beck_anx_inventory INTEGER
     , min_mental_state INTEGER
     , delirium_screening INTEGER
     , glasgow_coma_scale INTEGER
     , arch_spiral_l INTEGER
     , arch_spiral_r INTEGER
     , date_npi_q INTEGER
     , npi_q_severity INTEGER
     , npi_q_distress INTEGER
     , dyskinesia INTEGER
     , dysarthria INTEGER
     , dystonia INTEGER
     , disturbed_vision INTEGER
     , dizziness INTEGER
     , mood_changes INTEGER
     , paresthesia INTEGER
     , ataxia INTEGER
     , date_neuropsych_eval INTEGER
     , phonem_verbal_fl INTEGER
     , semantic_verbal_fl INTEGER
     , stroop_color_naming INTEGER
     , stroop_word_naming INTEGER
     , stroop_color_word_naming INTEGER
     , boston_naming_test INTEGER
     , corsi_blocks_forward INTEGER
     , corsi_blocks_backward INTEGER
     , constructive_praxis INTEGER
     , tmt_ba INTEGER
     , basel_verbal_learning_test INTEGER
     , five_point_test INTEGER
     , wisconsin_card_sorting INTEGER
     , rey_osterrieth_copy INTEGER
     , rey_osterrieth_immediate INTEGER
     , rey_osterrieth_delayed INTEGER
     , tap_div_attention INTEGER
     , digit_span_forward INTEGER
     , digit_span_backward INTEGER
     , PRIMARY KEY (subject_id, session_name)
     , CONSTRAINT subject_clindata_oe FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , UNIQUE (subject_id, session_name)
     );

CREATE TABLE 
       clinical_data_updrs3 
     ( subject_id INTEGER NOT NULL
     , session_name TEXT NOT NULL
     , stimulation_status TEXT NOT NULL
     , date_updrs TEXT
     , updrs3_18 INTEGER
     , updrs3_19 INTEGER
     , updrs3_20_face INTEGER
     , updrs3_20_hand_l INTEGER
     , updrs3_20_hand_r INTEGER
     , updrs3_20_foot_l INTEGER
     , updrs3_20_foot_r INTEGER
     , updrs3_21_l INTEGER
     , updrs3_21_r INTEGER
     , updrs3_22_neck INTEGER
     , updrs3_22_lue INTEGER
     , updrs3_22_rue INTEGER
     , updrs3_22_lle INTEGER
     , updrs3_22_rle INTEGER
     , updrs3_23_l INTEGER
     , updrs3_23_r INTEGER
     , updrs3_24_l INTEGER
     , updrs3_24_r INTEGER
     , updrs3_25_l INTEGER
     , updrs3_25_r INTEGER
     , updrs3_26_l INTEGER
     , updrs3_26_r INTEGER
     , updrs3_27 INTEGER
     , updrs3_28 INTEGER
     , updrs3_29 INTEGER
     , updrs3_30 INTEGER
     , updrs3_31 INTEGER
     , updrs3_sum INTEGER
     , PRIMARY KEY (subject_id, session_name, stimulation_status)
     , CONSTRAINT subjects_updrs3 FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , CONSTRAINT stimulation_status CHECK (stimulation_status IN ('on', 'off'))
     , UNIQUE(subject_id, session_name, stimulation_status)
     );

CREATE TABLE 
       clinical_data_updrs4 
     ( subject_id INTEGER NOT NULL
     , session_name TEXT NOT NULL
     , updrs4_32 INTEGER
     , updrs4_33 INTEGER
     , updrs4_34 INTEGER
     , updrs4_35 INTEGER
     , updrs4_36 INTEGER
     , updrs4_37 INTEGER
     , updrs4_38 INTEGER
     , updrs4_39 INTEGER
     , updrs4_40 INTEGER
     , updrs4_41 INTEGER
     , updrs4_42 INTEGER
     , PRIMARY KEY (subject_id, session_name)
     , CONSTRAINT subjects_updrs4 FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , UNIQUE(subject_id, session_name)
     );

CREATE TABLE 
       implanted_position 
     ( subject_id INTEGER NOT NULL
     , hemisphere TEXT NOT NULL
     , trajectory_type TEXT
     , position_on_trajectory REAL
     , lead_contact TEXT
     , contact_border TEXT
     , PRIMARY KEY (subject_id, hemisphere)
     , CONSTRAINT subjects_position FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , UNIQUE(subject_id, hemisphere)
     );

CREATE TABLE 
       mer_session 
     ( subject_id INTEGER NOT NULL
     , hemisphere TEXT NOT NULL
     , session_name TEXT NOT NULL
     , bengun_config TEXT
     , nr_stimulation_positions INTEGER
     , mer_1_traj_test_id INTEGER
     , mer_2_traj_test_id INTEGER
     , mer_3_traj_test_id INTEGER
     , mer_4_traj_test_id INTEGER
     , mer_5_traj_test_id INTEGER
     , PRIMARY KEY (subject_id, hemisphere)
     , CONSTRAINT subjects_mer FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , CONSTRAINT mer5_session FOREIGN KEY (mer_5_traj_test_id) REFERENCES micro_electrode_recording (mer_traj_test_id)
     , CONSTRAINT mer1_session FOREIGN KEY (mer_1_traj_test_id) REFERENCES micro_electrode_recording (mer_traj_test_id)
     , CONSTRAINT mer4_session FOREIGN KEY (mer_4_traj_test_id) REFERENCES micro_electrode_recording (mer_traj_test_id)
     , CONSTRAINT mer3_session FOREIGN KEY (mer_3_traj_test_id) REFERENCES micro_electrode_recording (mer_traj_test_id)
     , CONSTRAINT mer2_session FOREIGN KEY (mer_2_traj_test_id) REFERENCES micro_electrode_recording (mer_traj_test_id)
     , UNIQUE(subject_id, hemisphere)
     );

CREATE TABLE 
       mer_trajectory_range 
     ( mer_trajectory_range_id INTEGER PRIMARY KEY AUTOINCREMENT
     , min_position REAL NOT NULL
     , max_position REAL NOT NULL
     , brain_structure TEXT
     , UNIQUE(min_position, max_position, brain_structure)
     );

CREATE TABLE 
       micro_electrode_recording 
     ( mer_traj_test_id INTEGER PRIMARY KEY AUTOINCREMENT
     , trajectory_type TEXT NOT NULL
     , mer_traj_1_range_id INTEGER NOT NULL
     , mer_traj_2_range_id INTEGER
     , mer_traj_3_range_id INTEGER
     , notes TEXT
     , CONSTRAINT range2_traj FOREIGN KEY (mer_traj_2_range_id) REFERENCES mer_trajectory_range (mer_trajectory_range_id)
     , CONSTRAINT range3_traj FOREIGN KEY (mer_traj_3_range_id) REFERENCES mer_trajectory_range (mer_trajectory_range_id)
     , CONSTRAINT range1_traj FOREIGN KEY (mer_traj_1_range_id) REFERENCES mer_trajectory_range (mer_trajectory_range_id)
     , UNIQUE(trajectory_type, mer_traj_1_range_id, mer_traj_2_range_id, mer_traj_3_range_id, notes)
     );

CREATE TABLE 
       chronic_stim_parameters 
     ( chronic_stim_parameter_id INTEGER PRIMARY KEY AUTOINCREMENT
     , subject_id INTEGER NOT NULL
     , hemisphere TEXT NOT NULL
     , stimulation_mode TEXT NOT NULL
     , stimulation_polarity TEXT
     , CONSTRAINT subjects_chr_stim FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , CONSTRAINT stimulation_polarity CHECK (stimulation_polarity IN ('Monopolar', 'Bipolar'))
     , CONSTRAINT hemisphere CHECK (hemisphere IN ('Left', 'Right'))
     , CONSTRAINT stimulation_mode CHECK (stimulation_mode IN ('Current', 'Voltage'))
     , UNIQUE(subject_id, hemisphere)
     );

CREATE TABLE 
       contact_setup 
     ( contact_setup_id INTEGER PRIMARY KEY AUTOINCREMENT
     , contact_config TEXT NOT NULL
     , pulse_width REAL
     , frequency REAL
     , amplitude REAL
     , CONSTRAINT contact_config CHECK (contact_config IN ('+', '-', 'ø'))
     , UNIQUE(contact_config, pulse_width, frequency, amplitude)
     );

CREATE TABLE 
       contacts 
     ( chronic_stim_parameter_id INTEGER NOT NULL
     , contact_setup_id INTEGER NOT NULL
     , contact_number TEXT NOT NULL
     , CONSTRAINT fk_contacts_chronic_stim_parameters_1 FOREIGN KEY (chronic_stim_parameter_id) REFERENCES chronic_stim_parameters (chronic_stim_parameter_id)
     , CONSTRAINT fk_contacts_contact_setup_1 FOREIGN KEY (contact_setup_id) REFERENCES contact_setup (contact_setup_id)
     , PRIMARY KEY (chronic_stim_parameter_id, contact_setup_id, contact_number)
     , UNIQUE(chronic_stim_parameter_id, contact_setup_id, contact_number)
     );

CREATE TABLE 
       stimulation_evaluations 
     ( stimulation_eval_id INTEGER PRIMARY KEY AUTOINCREMENT
     , amplitude INTEGER NOT NULL
     , stimulation_mode TEXT NOT NULL
     , rigidity TEXT
     , rigidity_tremor TEXT
     , tremor TEXT
     , tremor_lower TEXT
     , tremor_upper TEXT
     , ataxia TEXT
     , akinesia_thumb TEXT
     , akinesia_foot TEXT
     , comments TEXT
     , CONSTRAINT stimulation_mode CHECK (stimulation_mode IN ('Current', 'Voltage'))
     , UNIQUE(amplitude, stimulation_mode, rigidity, rigidity_tremor, tremor, tremor_lower, tremor_upper, ataxia, akinesia_thumb, akinesia_foot, comments)
     );

CREATE TABLE 
       stimulation_sessions 
     ( stim_session_id INTEGER PRIMARY KEY AUTOINCREMENT
     , subject_id INTEGER NOT NULL
     , hemisphere TEXT NOT NULL
     , session_name TEXT NOT NULL
     , trajectory_type TEXT
     , position_on_trajectory REAL
     , contact TEXT
     , CONSTRAINT subject_stimulation FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , CONSTRAINT hemisphere CHECK (hemisphere IN ('Left', 'Right'))
     , UNIQUE(subject_id, hemisphere, session_name, trajectory_type, position_on_trajectory, contact)
     );

CREATE TABLE 
       stimulations 
     ( stimulation_id INTEGER PRIMARY KEY AUTOINCREMENT
     , stim_session_id INTEGER NOT NULL
     , stimulation_eval_id INTEGER NOT NULL
     , CONSTRAINT fk_stimulations_stimulation_sessions_1 FOREIGN KEY (stim_session_id) REFERENCES stimulation_sessions (stim_session_id)
     , CONSTRAINT fk_stimulations_stimulation_evaluations_1 FOREIGN KEY (stimulation_eval_id) REFERENCES stimulation_evaluations (stimulation_eval_id)
     , UNIQUE(stim_session_id, stimulation_eval_id)
     );

CREATE TABLE 
       side_effect_types 
     ( side_effect TEXT NOT NULL
     , PRIMARY KEY (side_effect)
     , UNIQUE(side_effect)
     ) ;

CREATE TABLE 
       occurred_side_effects 
     ( side_effect_types TEXT NOT NULL
     , stimulation_id INTEGER NOT NULL
     , PRIMARY KEY (stimulation_id, side_effect_types)
     , CONSTRAINT fk_occurred_side_effects_stimulations_1 FOREIGN KEY (stimulation_id) REFERENCES stimulations (stimulation_id)
     , CONSTRAINT fk_occurred_side_effects_side_effect_types_1 FOREIGN KEY (side_effect_types) REFERENCES side_effect_types (side_effect)
     , UNIQUE(side_effect_types, stimulation_id)
     );

CREATE TABLE 
       targeting_info 
     ( targeting_info_id INTEGER PRIMARY KEY AUTOINCREMENT
     , subject_id INTEGER NOT NULL
     , bilateral_implant TEXT
     , implanted_1st_hemisphere TEXT NOT NULL
     , electrode_name TEXT NULL
     , brain_structure TEXT NOT NULL
     , is_intraop_meas_available TEXT
     , iplan_data_available TEXT
     , CONSTRAINT subject_target FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
     , CONSTRAINT fk_targeting_info_electrodes_1 FOREIGN KEY (electrode_name) REFERENCES electrodes (electrode_name)
     , CONSTRAINT hemisphere CHECK (implanted_1st_hemisphere IN ('Left', 'Right'))
     , UNIQUE(subject_id)
     );

CREATE TABLE 
       targeting_setup 
     ( targeting_info_id INTEGER NOT NULL
     , hemisphere TEXT NOT NULL
     , arc_type TEXT
     , mounting TEXT
     , x_a2_a1 REAL
     , y_b2 REAL
     , z_c REAL
     , angle1_d1 REAL
     , angle2_e REAL
     , angle3_f_roll TEXT
     , PRIMARY KEY (targeting_info_id, hemisphere)
     , CONSTRAINT target_info_setup FOREIGN KEY (targeting_info_id) REFERENCES targeting_info (targeting_info_id)
     , UNIQUE(targeting_info_id, hemisphere, arc_type, mounting, x_a2_a1, y_b2, z_c, angle1_d1, angle2_e, angle3_f_roll)
     );