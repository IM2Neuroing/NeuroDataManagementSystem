# DBS Database Model

The schemas and the SQL fiel describe a patient-centric database schema for Deep Brain Stimulation (DBS) studies. Tables are categorized into Clinical Data, Imaging Data, Stimulation Configuration Evaluations, and Targeting, all linked to a central patient table.

Clinical Data tables store clinic visit information. Stimulation Configuration Evaluation tables store data about stimulation settings. Microelectrode Recordings tables contain intraoperative recording data. Targeting tables contain preoperative planning data. Chronic Stimulation Configuration and Implanted Position tables store postoperative data. The Electrodes table stores electrode data.

Imaging data is managed through four tables: Files, Transformations, Bids, and Labels. The Files table stores file paths and types. The Transformations table stores transform data. The Bids and Labels tables store additional file-specific information.