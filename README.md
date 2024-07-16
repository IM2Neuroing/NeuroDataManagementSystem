# NeuroDataManagementSystem
The NeuroDataManagementSystem is an integrated solution designed to streamline and enhance the management of neuroimaging and clinical data. 

The folders **CLINICALDATA** and **IMAGEDATA** contain respectively clinical and imaging data of 4 fictitious patients, simulating the clinical data extracted from REDCap and the imaging (raw and processed) files saved in a file system.

By running the pipeline **REDCap2SQLite** (https://github.com/IM2Neuroing/REDCap2SQLite/releases/tag/v1.0.0) the DMS.db in the NeuroDMS folder is populated with the collected clinical data. The **Image2BIDS2SQLite** (https://github.com/IM2Neuroing/Image2BIDS2SQLite.git) repository stores the pipeline used to organize the imaging files according to the BIDS standard (File2BIDS) and to store metadata and references to those files in the DMS.db. The output of File2BIDS is stored in NeuroDMS/BIDS. 

The folder **SQLite** contains the database structure.