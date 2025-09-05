# General Information

## Overview
The **DBS Database Model** is a patient-centric database schema designed for Deep Brain Stimulation (DBS) studies. It serves as a structured repository for clinical, imaging, and stimulation-related data, supporting research and analysis in the field of neuromodulation.

The database consists of multiple schemas that categorize data into:
- **Clinical Data**: Stores information about patient visits, neurological evaluations, and medication history.
- **Imaging Data**: Manages imaging files, transformations, and metadata necessary for DBS targeting and analysis.
- **Stimulation Configuration Evaluations**: Stores details about intraoperative and chronic stimulation settings, side effects, and session evaluations.
- **Targeting Information**: Contains preoperative planning and surgical targeting data.

All data is linked to a central **patients table**, ensuring consistency and traceability across different data types.

## Purpose and Scope
The primary purpose of the **DBS Database Model** is to:
- Facilitate **longitudinal patient tracking** in DBS studies.
- Provide a structured storage solution for **heterogeneous data sources**, including clinical assessments, imaging data, and stimulation parameters.
- Enable **efficient querying and retrieval** of relevant data for research and analysis.
- Support **machine learning applications** by providing well-structured, standardized data.

The database is **optimized for research applications** rather than real-time clinical use. It ensures data integrity through enforced relationships, foreign key constraints, and unique indexes.

# Data Model Overview

The DBS database schema is designed to manage and store data related to Deep Brain Stimulation (DBS) studies. The schema is structured around a **central patient table (`subjects`)**, which connects various other data categories. These categories include Clinical Data, Imaging Data, Stimulation Configuration Evaluations, Targeting, and Microelectrode Recordings. The database ensures referential integrity through foreign key constraints and employs normalization to avoid data redundancy.

### **1. Core Entities and Relationships**
- **`subjects`**: The central table storing patient-related data, including demographics, medical history, and surgery details.
- **`electrodes`**: Stores different types of electrodes used in DBS procedures.
- **`files`**: Manages paths and metadata of stored imaging files, linked to subjects and electrodes.
- **`transformations`**: Stores transformations applied to imaging data.
- **`bids`** and **`labels`**: Hold additional information about imaging data, such as modality, protocol names, and anatomical labels.

### **2. Clinical Data**
- **`medications`**: Records medication dosages and additional notes for each patient session.
- **`clinical_data_other_evals`**: Stores results from various neurological and psychological evaluations.
- **`clinical_data_updrs3`** and **`clinical_data_updrs4`**: Contain Unified Parkinson’s Disease Rating Scale (UPDRS) evaluations for motor and dyskinesia assessments.

### **3. Imaging Data**
The imaging-related tables store different types of neuroimaging data:
- **`files`**: Stores paths and metadata of imaging files.
- **`transformations`**: Contains transformation operations applied to images.
- **`bids`** and **`labels`**: Provide additional imaging metadata, such as modality and segmentation information.

### **4. Targeting Data**
Targeting data is crucial for DBS procedures, as it assists in planning and guiding electrode placement:
- **`targeting_info`**: Stores preoperative targeting data.
- **`targeting_setup`**: Holds detailed positioning parameters used in preoperative planning.

### **5. Stimulation Configuration and Evaluations**
- **`chronic_stim_parameters`**: Stores parameters of chronic stimulation settings.
- **`contact_setup`** and **`contacts`**: Manage electrode contact configurations and associated electrical parameters.
- **`stimulation_evaluations`**: Holds data regarding stimulation effects and their impact on clinical outcomes.
- **`stimulation_sessions`** and **`stimulations`**: Store session-based stimulation data linked to evaluations.

### **6. Microelectrode Recordings (MER)**
Microelectrode recordings provide intraoperative electrophysiological data:
- **`mer_session`**: Stores MER sessions for different hemispheres.
- **`mer_trajectory_range`**: Defines recording range and associated brain structures.
- **`micro_electrode_recording`**: Links MER trajectory tests to recorded brain structures.

### **7. Implanted Position Tracking**
- **`implanted_position`**: Stores actual postoperative electrode positions relative to preoperative targeting data.

### **8. Side Effects Management**
- **`side_effect_types`**: Defines known side effects.
- **`occurred_side_effects`**: Links side effects to specific stimulation sessions.

### **Schema Relationships and Referential Integrity**
The DBS database schema enforces referential integrity through well-defined **foreign key constraints**, ensuring that data relationships remain consistent. The **normalization** process reduces data redundancy and optimizes data retrieval.

### **Indexes and Optimization**
Several primary and unique keys ensure efficient queries and enforce data uniqueness. Additional indexes may be required for performance tuning depending on query patterns.

This database schema provides a structured, scalable, and secure foundation for managing data related to Deep Brain Stimulation (DBS) studies. Future expansions may include real-time data streaming or integration with additional analytical tools.

# Table Descriptions

### **Electrodes Table**
The `electrodes` table stores information about different types of electrodes used in DBS procedures.

| Column Name      | Data Type | Constraints  | Description |
|-----------------|-----------|-------------|-------------|
| electrode_name  | TEXT      | PRIMARY KEY, NOT NULL | Unique identifier for each electrode type. As for example: 'Abbott SJM 6170'|

### **Subjects Table**
The `subjects` table contains demographic and medical information about patients enrolled in DBS studies.

| Column Name           | Data Type | Constraints  | Description |
|----------------------|-----------|-------------|-------------|
| subject_id          | INTEGER   | PRIMARY KEY, NOT NULL | Unique identifier for each patient. |
| center_name        | TEXT      | NOT NULL    | Name of the medical center where the patient is treated. |
| patient_id_acr      | TEXT      | UNIQUE, NOT NULL | Anonymized patient identifier. |
| age                 | INTEGER   | NULLABLE    | Age of the patient. |
| sex                 | TEXT      | NULLABLE    | Gender of the patient. |
| pathology           | TEXT      | NULLABLE    | Diagnosis of the patient. |
| year_1st_symptom_occ | INTEGER  | NULLABLE    | Year when the first symptom appeared. |
| disease_duration    | REAL      | NULLABLE    | Duration of the disease in years. |
| surgery_date        | TEXT      | NULLABLE    | Date of the DBS surgery. |

### **Files Table**
The `files` table manages imaging and related files associated with DBS studies.

| Column Name      | Data Type | Constraints  | Description |
|-----------------|-----------|-------------|-------------|
| file_id        | TEXT      | PRIMARY KEY, NOT NULL, UNIQUE | Unique identifier for each file. |
| subject_id     | INTEGER   | FOREIGN KEY REFERENCES `subjects`(subject_id) | The subject associated with the file. |
| electrode_id   | INTEGER   | FOREIGN KEY REFERENCES `electrodes`(electrode_name) | The electrode used in the study. |
| file_path      | TEXT      | UNIQUE, NOT NULL | Location of the file in the storage system. |
| file_type      | TEXT      | NOT NULL | Type of the file (e.g., MRI, CT, DICOM). |
| source_id      | INTEGER   | FOREIGN KEY REFERENCES `files`(file_id) | Source file ID if applicable. |
| transformation_id | INTEGER | FOREIGN KEY REFERENCES `transformations`(transformation_id) | Associated transformation data. |

### **BIDS Table**
The `bids` table stores metadata related to imaging data following the BIDS standard.

| Column Name         | Data Type | Constraints  | Description |
|--------------------|-----------|-------------|-------------|
| file_id           | TEXT      | PRIMARY KEY, FOREIGN KEY REFERENCES `files`(file_id), UNIQUE | Reference to the associated file. |
| modality          | TEXT      | NULLABLE | Imaging modality (e.g., MRI, CT). |
| protocol_name     | TEXT      | NULLABLE | Name of the acquisition protocol. |
| stereotactic      | TEXT      | NULLABLE | Stereotactic imaging details. |
| dicom_image_type  | TEXT      | NULLABLE | DICOM-specific image type. |
| acquisition_date_time | TEXT | NULLABLE | Date and time of acquisition. |
| relative_sidecar_path | TEXT | NULLABLE | Relative path to sidecar file. |
| bids_subject      | TEXT      | NOT NULL | BIDS subject identifier. |
| bids_session      | TEXT      | NOT NULL | BIDS session identifier. |
| bids_extension    | TEXT      | NOT NULL | File extension (e.g., .nii, .json). |
| bids_datatype     | TEXT      | NOT NULL | BIDS data type (e.g., anat, func). |
| bids_acquisition  | TEXT      | NOT NULL | Acquisition identifier. |
| bids_suffix       | TEXT      | NOT NULL | File suffix (e.g., _bold, _T1w). |

### **Labels Table**
The `labels` table stores additional annotation data related to imaging files.

| Column Name  | Data Type | Constraints  | Description |
|-------------|-----------|-------------|-------------|
| file_id     | TEXT      | PRIMARY KEY, FOREIGN KEY REFERENCES `files`(file_id), UNIQUE | Associated file identifier. |
| hemisphere  | TEXT      | NOT NULL | Hemisphere associated with the label. |
| structure   | TEXT      | NOT NULL | Brain structure annotated. |
| color       | TEXT      | NULLABLE | Color code for annotation. |
| comment     | TEXT      | NULLABLE | Additional comments. |

### **Transformations Table**
The `transformations` table tracks transformations applied to imaging data.

| Column Name      | Data Type | Constraints  | Description |
|-----------------|-----------|-------------|-------------|
| transformation_id | INTEGER | PRIMARY KEY, AUTOINCREMENT | Unique identifier for each transformation. |
| identity        | TEXT      | NULLABLE | Identity of transformation if applicable. |
| target_id      | TEXT      | FOREIGN KEY REFERENCES `files`(file_id), NOT NULL | Target file ID. |
| transform_id   | TEXT      | FOREIGN KEY REFERENCES `files`(file_id), NOT NULL | Transformation file ID. |

### **Medications Table**
The `medications` table contains details on patients’ medication use during the study.

| Column Name                | Data Type | Constraints  | Description |
|---------------------------|-----------|-------------|-------------|
| subject_id               | INTEGER   | PRIMARY KEY, FOREIGN KEY REFERENCES `subjects`(subject_id), NOT NULL | Patient identifier. |
| session_name             | TEXT      | PRIMARY KEY, NOT NULL | Name of the session. |
| acquisition_date         | TEXT      | NOT NULL | Date of medication record. |
| dose_primidone           | REAL      | NULLABLE | Dose of Primidone in mg. |
| dose_propranolol         | REAL      | NULLABLE | Dose of Propranolol in mg. |
| dose_gabapentin          | REAL      | NULLABLE | Dose of Gabapentin in mg. |
| dose_rivotril_clonazepam | REAL      | NULLABLE | Dose of Clonazepam in mg. |
| dose_topamax             | REAL      | NULLABLE | Dose of Topamax in mg. |
| dose_ledd                | REAL      | NULLABLE | Levodopa Equivalent Daily Dose. |
| additional_medication    | TEXT      | NULLABLE | Additional medication details. |
| additional_session_notes | TEXT      | NULLABLE | Notes for the session. |

#### `clinical_data_other_evals`
| Column Name                  | Data Type  | Constraints | Description |
|------------------------------|-----------|-------------|-------------|
| `subject_id`                 | INTEGER   | NOT NULL, PRIMARY KEY, FOREIGN KEY (subjects) | Unique identifier for the subject. |
| `session_name`               | TEXT      | NOT NULL, PRIMARY KEY | Name of the clinical session. |
| `date_neurological_eval`     | INTEGER   |  | Date of the neurological evaluation. |
| `hoehn_yahr`                 | INTEGER   |  | Hoehn and Yahr scale score for Parkinson’s disease severity. |
| `adl_scale_pd`               | INTEGER   |  | Activities of daily living scale for Parkinson’s Disease. |
| `adl_scale_dyskinesia`       | INTEGER   |  | Activities of daily living scale for dyskinesia. |
| `epworth_sleepiness_sc`      | INTEGER   |  | Epworth Sleepiness Scale score. |
| `moca_total`                 | INTEGER   |  | Total score of the Montreal Cognitive Assessment. |
| `send_pd_sum`                | INTEGER   |  | Sum of the Send-PD questionnaire scores. |
| `beck_depr_inventory`        | INTEGER   |  | Beck Depression Inventory score. |
| `beck_anx_inventory`         | INTEGER   |  | Beck Anxiety Inventory score. |
| `min_mental_state`           | INTEGER   |  | Mini-Mental State Examination score. |
| `digit_span_forward`         | INTEGER   |  | Digit span test (forward). |
| `digit_span_backward`        | INTEGER   |  | Digit span test (backward). |

#### `clinical_data_updrs3`
| Column Name                  | Data Type  | Constraints | Description |
|------------------------------|-----------|-------------|-------------|
| `subject_id`                 | INTEGER   | NOT NULL, PRIMARY KEY, FOREIGN KEY (subjects) | Unique identifier for the subject. |
| `session_name`               | TEXT      | NOT NULL, PRIMARY KEY | Name of the clinical session. |
| `stimulation_status`         | TEXT      | NOT NULL, PRIMARY KEY, CHECK (IN ('on', 'off')) | Whether stimulation was on or off. |
| `date_updrs`                 | TEXT      |  | Date of the UPDRS assessment. |
| `updrs3_18`                  | INTEGER   |  | Unified Parkinson’s Disease Rating Scale (UPDRS) Part III, item 18. |
| `updrs3_19`                  | INTEGER   |  | UPDRS Part III, item 19. |
| `updrs3_22_neck`             | INTEGER   |  | UPDRS Part III, item 22 (neck). |
| `updrs3_23_l`                | INTEGER   |  | UPDRS Part III, item 23 (left side). |
| `updrs3_23_r`                | INTEGER   |  | UPDRS Part III, item 23 (right side). |
| `updrs3_27`                  | INTEGER   |  | UPDRS Part III, item 27. |
| `updrs3_31`                  | INTEGER   |  | UPDRS Part III, item 31. |
| `updrs3_sum`                 | INTEGER   |  | Total UPDRS Part III score. |

#### `clinical_data_updrs4`
| Column Name                  | Data Type  | Constraints | Description |
|------------------------------|-----------|-------------|-------------|
| `subject_id`                 | INTEGER   | NOT NULL, PRIMARY KEY, FOREIGN KEY (subjects) | Unique identifier for the subject. |
| `session_name`               | TEXT      | NOT NULL, PRIMARY KEY | Name of the clinical session. |
| `updrs4_32`                  | INTEGER   |  | UPDRS Part IV, item 32. |
| `updrs4_33`                  | INTEGER   |  | UPDRS Part IV, item 33. |
| `updrs4_36`                  | INTEGER   |  | UPDRS Part IV, item 36. |
| `updrs4_40`                  | INTEGER   |  | UPDRS Part IV, item 40. |
| `updrs4_42`                  | INTEGER   |  | UPDRS Part IV, item 42. |

#### `implanted_position`
| Column Name                  | Data Type  | Constraints | Description |
|------------------------------|-----------|-------------|-------------|
| `subject_id`                 | INTEGER   | NOT NULL, PRIMARY KEY, FOREIGN KEY (subjects) | Unique identifier for the subject. |
| `hemisphere`                 | TEXT      | NOT NULL, PRIMARY KEY | Hemisphere where the DBS lead is implanted. |
| `trajectory_type`            | TEXT      |  | Type of surgical trajectory used. |
| `position_on_trajectory`     | REAL      |  | Position along the planned trajectory. |
| `lead_contact`               | TEXT      |  | Contact used for stimulation. |
| `contact_border`             | TEXT      |  | Border of the contact area. |

### **mer_session**
| Column Name           | Data Type | Constraints                        | Description |
|-----------------------|-----------|------------------------------------|-------------|
| subject_id           | INTEGER   | NOT NULL, FOREIGN KEY references subjects(subject_id) | Identifier of the subject associated with the session |
| hemisphere          | TEXT      | NOT NULL                           | Hemisphere (Left/Right) where the session took place |
| session_name        | TEXT      | NOT NULL                           | Name of the microelectrode recording session |
| bengun_config       | TEXT      |                                    | Configuration settings for the session |
| nr_stimulation_positions | INTEGER  |                                    | Number of stimulation positions tested |
| mer_1_traj_test_id  | INTEGER   | FOREIGN KEY references micro_electrode_recording(mer_traj_test_id) | Identifier for the first trajectory test |
| mer_2_traj_test_id  | INTEGER   | FOREIGN KEY references micro_electrode_recording(mer_traj_test_id) | Identifier for the second trajectory test |
| mer_3_traj_test_id  | INTEGER   | FOREIGN KEY references micro_electrode_recording(mer_traj_test_id) | Identifier for the third trajectory test |
| mer_4_traj_test_id  | INTEGER   | FOREIGN KEY references micro_electrode_recording(mer_traj_test_id) | Identifier for the fourth trajectory test |
| mer_5_traj_test_id  | INTEGER   | FOREIGN KEY references micro_electrode_recording(mer_traj_test_id) | Identifier for the fifth trajectory test |

---

### **mer_trajectory_range**
| Column Name          | Data Type | Constraints                        | Description |
|----------------------|-----------|------------------------------------|-------------|
| mer_trajectory_range_id | INTEGER | PRIMARY KEY AUTOINCREMENT         | Unique identifier for the trajectory range |
| min_position        | REAL      | NOT NULL                           | Minimum position along the trajectory |
| max_position        | REAL      | NOT NULL                           | Maximum position along the trajectory |
| brain_structure     | TEXT      |                                    | Brain structure associated with this range |

### **micro_electrode_recording**
| Column Name         | Data Type | Constraints                        | Description |
|---------------------|-----------|------------------------------------|-------------|
| mer_traj_test_id   | INTEGER   | PRIMARY KEY AUTOINCREMENT         | Unique identifier for the trajectory test |
| trajectory_type    | TEXT      | NOT NULL                           | Type of trajectory used in the recording |
| mer_traj_1_range_id | INTEGER  | NOT NULL, FOREIGN KEY references mer_trajectory_range(mer_trajectory_range_id) | Identifier for the first trajectory range |
| mer_traj_2_range_id | INTEGER  | FOREIGN KEY references mer_trajectory_range(mer_trajectory_range_id) | Identifier for the second trajectory range |
| mer_traj_3_range_id | INTEGER  | FOREIGN KEY references mer_trajectory_range(mer_trajectory_range_id) | Identifier for the third trajectory range |
| notes              | TEXT      |                                    | Additional notes regarding the recording |

### **chronic_stim_parameters**
| Column Name            | Data Type | Constraints                        | Description |
|------------------------|-----------|------------------------------------|-------------|
| chronic_stim_parameter_id | INTEGER | PRIMARY KEY AUTOINCREMENT         | Unique identifier for the chronic stimulation parameters |
| subject_id            | INTEGER   | NOT NULL, FOREIGN KEY references subjects(subject_id) | Identifier of the subject receiving the stimulation |
| hemisphere           | TEXT      | NOT NULL, CHECK (hemisphere IN ('Left', 'Right')) | Hemisphere where stimulation is applied |
| stimulation_mode     | TEXT      | NOT NULL, CHECK (stimulation_mode IN ('Current', 'Voltage')) | Type of stimulation mode applied |
| stimulation_polarity | TEXT      | CHECK (stimulation_polarity IN ('Monopolar', 'Bipolar')) | Polarity configuration for the stimulation |

**Table Descriptions**

### **contact_setup**
| Column Name      | Data Type | Constraints                | Description |
|-----------------|-----------|----------------------------|-------------|
| contact_setup_id | INTEGER   | PRIMARY KEY AUTOINCREMENT | Unique identifier for the contact setup. |
| contact_config  | TEXT      | CHECK (contact_config IN ('+', '-', 'ø')) | Configuration of the contact polarity. |
| pulse_width     | REAL      | -                          | Pulse width of the stimulation. |
| frequency       | REAL      | -                          | Frequency of the stimulation. |
| amplitude       | REAL      | -                          | Amplitude of the stimulation. |

### **contacts**
| Column Name               | Data Type | Constraints | Description |
|---------------------------|-----------|-------------|-------------|
| chronic_stim_parameter_id | INTEGER   | FOREIGN KEY REFERENCES chronic_stim_parameters (chronic_stim_parameter_id) | Reference to the chronic stimulation parameters. |
| contact_setup_id          | INTEGER   | FOREIGN KEY REFERENCES contact_setup (contact_setup_id) | Reference to the contact setup configuration. |
| contact_number            | TEXT      | PRIMARY KEY (chronic_stim_parameter_id, contact_setup_id, contact_number) | Identifier for the specific contact. |

### **stimulation_evaluations**
| Column Name       | Data Type | Constraints | Description |
|------------------|-----------|-------------|-------------|
| stimulation_eval_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for the stimulation evaluation. |
| amplitude        | INTEGER   | NOT NULL    | Stimulation amplitude value. |
| stimulation_mode | TEXT      | CHECK (stimulation_mode IN ('Current', 'Voltage')) | Defines the mode of stimulation. |
| rigidity        | TEXT      | -           | Evaluation of rigidity improvement. |
| rigidity_tremor | TEXT      | -           | Tremor evaluation related to rigidity. |
| tremor          | TEXT      | -           | General tremor evaluation. |
| tremor_lower    | TEXT      | -           | Evaluation of tremor in the lower body. |
| tremor_upper    | TEXT      | -           | Evaluation of tremor in the upper body. |
| ataxia         | TEXT      | -           | Assessment of ataxia symptoms. |
| akinesia_thumb  | TEXT      | -           | Evaluation of akinesia in the thumb. |
| akinesia_foot   | TEXT      | -           | Evaluation of akinesia in the foot. |
| comments        | TEXT      | -           | Additional notes on stimulation effects. |

### **stimulation_sessions**
| Column Name          | Data Type | Constraints | Description |
|---------------------|-----------|-------------|-------------|
| stim_session_id    | INTEGER   | PRIMARY KEY AUTOINCREMENT | Unique identifier for the stimulation session. |
| subject_id         | INTEGER   | FOREIGN KEY REFERENCES subjects (subject_id) | Reference to the subject. |
| hemisphere        | TEXT      | CHECK (hemisphere IN ('Left', 'Right')) | Defines the hemisphere of the stimulation. |
| session_name      | TEXT      | NOT NULL    | Name of the stimulation session. |
| trajectory_type   | TEXT      | -           | Type of trajectory used in the session. |
| position_on_trajectory | REAL | -           | Position on the stimulation trajectory. |
| contact          | TEXT      | -           | Contact point used for stimulation. |

### **stimulations**
| Column Name         | Data Type | Constraints | Description |
|--------------------|-----------|-------------|-------------|
| stimulation_id    | INTEGER   | PRIMARY KEY AUTOINCREMENT | Unique identifier for a stimulation entry. |
| stim_session_id   | INTEGER   | FOREIGN KEY REFERENCES stimulation_sessions (stim_session_id) | Reference to the stimulation session. |
| stimulation_eval_id | INTEGER  | FOREIGN KEY REFERENCES stimulation_evaluations (stimulation_eval_id) | Reference to the stimulation evaluation. |

**Table Descriptions**

### **side_effect_types**
| Column Name | Data Type | Constraints | Description |
|-------------|-----------|--------------|-------------|
| side_effect | TEXT | PRIMARY KEY, UNIQUE | Name of the side effect. Each side effect has a unique identifier. |

### **occurred_side_effects**
| Column Name | Data Type | Constraints | Description |
|------------------|-----------|--------------|-------------|
| side_effect_types | TEXT | NOT NULL, FOREIGN KEY REFERENCES side_effect_types (side_effect) | The specific type of side effect that occurred. |
| stimulation_id | INTEGER | NOT NULL, FOREIGN KEY REFERENCES stimulations (stimulation_id), PRIMARY KEY (stimulation_id, side_effect_types) | The associated stimulation event where the side effect occurred. |

### **targeting_info**
| Column Name | Data Type | Constraints | Description |
|--------------------|-----------|--------------|-------------|
| targeting_info_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for the targeting information entry. |
| subject_id | INTEGER | NOT NULL, FOREIGN KEY REFERENCES subjects (subject_id) | The patient associated with this targeting information. |
| bilateral_implant | TEXT | - | Indicates if bilateral implantation was performed. |
| implanted_1st_hemisphere | TEXT | NOT NULL, CHECK (implanted_1st_hemisphere IN ('Left', 'Right')) | The hemisphere where the first implant was placed. |
| electrode_name | TEXT | NULL, FOREIGN KEY REFERENCES electrodes (electrode_name) | The name of the electrode used for implantation. |
| brain_structure | TEXT | NOT NULL | The targeted brain structure for the electrode placement. |
| is_intraop_meas_available | TEXT | - | Indicates whether intraoperative measurements are available. |
| iplan_data_available | TEXT | - | Indicates if iPlan data is available for this subject. |

### **targeting_setup**
| Column Name | Data Type | Constraints | Description |
|-----------------|-----------|--------------|-------------|
| targeting_info_id | INTEGER | NOT NULL, FOREIGN KEY REFERENCES targeting_info (targeting_info_id) | The corresponding targeting information entry. |
| hemisphere | TEXT | NOT NULL | The hemisphere for which the targeting setup was configured. |
| arc_type | TEXT | - | Type of arc used in the targeting setup. |
| mounting | TEXT | - | Description of the mounting method used. |
| x_a2_a1 | REAL | - | X-coordinate in the targeting setup. |
| y_b2 | REAL | - | Y-coordinate in the targeting setup. |
| z_c | REAL | - | Z-coordinate in the targeting setup. |
| angle1_d1 | REAL | - | First angular parameter for the targeting setup. |
| angle2_e | REAL | - | Second angular parameter for the targeting setup. |
| angle3_f_roll | TEXT | - | Third angular parameter describing roll orientation. |

# Table Relationships in the DBS Database Model

The DBS database model is structured around a central `subjects` table, linking different categories of data including clinical data, imaging data, stimulation evaluations, targeting information, and electrode configurations. Below is a detailed description of the relationships between key tables:

### **1. Patient-Centric Relationships**
- **`subjects` (Primary Table)**: Central to the database, linking to multiple clinical, imaging, and stimulation-related records.
- **`clinical_data_other_evals`, `clinical_data_updrs3`, `clinical_data_updrs4`, and `medications`**:
  - These tables store clinical evaluations and medication history.
  - Each references `subject_id` as a foreign key, ensuring patient-specific data association.

### **2. Imaging Data Relationships**
- **`files`**:
  - Stores file metadata including paths and types.
  - Links to `subjects` via `subject_id` to associate files with patients.
  - Links to `electrodes` via `electrode_id` to associate specific electrode configurations with images.
- **`bids` and `labels`**:
  - Reference `files` via `file_id`, allowing structured annotation of imaging files.
- **`transformations`**:
  - Establishes relationships between transformed imaging files by referencing `files` through `target_id` and `transform_id`.

### **3. Stimulation Configuration and Evaluation Relationships**
- **`chronic_stim_parameters`**:
  - Links to `subjects` via `subject_id`, ensuring stimulation settings are patient-specific.
  - `hemisphere` and `stimulation_mode` are constrained to predefined values.
- **`stimulation_sessions`**:
  - Links to `subjects` via `subject_id` to store per-session stimulation details.
- **`stimulations`**:
  - Links `stimulation_sessions` and `stimulation_evaluations`, tracking applied stimulation and recorded outcomes.
- **`contacts`**:
  - Establishes a relationship between `chronic_stim_parameters` and `contact_setup` by referencing `chronic_stim_parameter_id` and `contact_setup_id`, defining electrode contact configurations.

### **4. Microelectrode Recording and Targeting Relationships**
- **`mer_session`**:
  - Links to `subjects` via `subject_id`, storing intraoperative session data.
  - Links to `micro_electrode_recording` through multiple foreign keys (`mer_1_traj_test_id`, etc.).
- **`micro_electrode_recording`**:
  - Links to `mer_trajectory_range` through multiple trajectory range foreign keys, defining precise intraoperative measurements.
- **`targeting_info`**:
  - References `subjects` via `subject_id` to store targeting information per patient.
  - Links to `electrodes` via `electrode_name`, storing planned electrode placement.
- **`targeting_setup`**:
  - Links to `targeting_info` through `targeting_info_id` to define specific targeting parameters for implantation.

### **5. Side Effect Relationships**
- **`side_effect_types`**:
  - Defines possible side effects as unique entries.
- **`occurred_side_effects`**:
  - Links `side_effect_types` to `stimulations` via `side_effect` and `stimulation_id`, allowing for structured reporting of adverse effects.

### **6. Integrity Constraints and Data Validations**
- **Foreign Key Constraints**:
  - Ensure referential integrity between linked tables (e.g., `subjects_medication`, `fk_bids_files_1`, `fk_transformations_images_2`).
- **Unique Constraints**:
  - Prevent duplicate records where necessary (e.g., `UNIQUE(subject_id, hemisphere, session_name)`).
- **Check Constraints**:
  - Enforce valid values for specific fields (e.g., `hemisphere CHECK (hemisphere IN ('Left', 'Right'))`).

### **Summary**
The DBS database model is designed with a strong relational structure ensuring comprehensive tracking of patient clinical data, imaging data, stimulation settings, and surgical targeting. By maintaining well-defined foreign keys, unique constraints, and validation checks, the model provides a robust foundation for Deep Brain Stimulation research and analysis.