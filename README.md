# NeuroDataManagementSystem

The NeuroDataManagementSystem is an integrated solution designed to streamline and enhance the management of neuroimaging and clinical data.

## Overview

The folder **NeuroDMS** represents the final NeuroDataManagementSystem and contains the SQLite database and the BIDS organized imaging data. The **BIDS** folder contains the imaging data organized according to the BIDS standard. The **DMS.db** file is the SQLite database that stores the clinical and imaging metadata.

The folders **CLINICALDATA** and **IMAGEDATA** contain respectively clinical and imaging data of 4 fictitious patients, simulating the clinical data extracted from REDCap and the imaging (raw and processed) files saved in a file system. The folder **SQLite** contains the database structure.

## Building the NeuroDataManagementSystem

The NeuroDataManagementSystem is system build of 3 components: REDCAP, BIDS and a SQLite database. Using a simple filesystem as a data storage, the NeuroDataManagementSystem is designed to manage clinical and imaging data. To combine the components, the NeuroDataManagementSystem uses the REDCap2SQLite and Image2BIDS2SQLite pipelines. These pipelines are developed in the following repositories:

- REDCap2SQLite: **REDCap2SQLite** (https://github.com/IM2Neuroing/REDCap2SQLite.git)
- Image2BIDS2SQLite: **Image2BIDS2SQLite** (https://github.com/IM2Neuroing/Image2BIDS2SQLite.git)

By running the pipeline **REDCap2SQLite** (https://github.com/IM2Neuroing/REDCap2SQLite/releases/tag/v1.0.0) a DMS.db can be populated with the collected clinical data. The **Image2BIDS2SQLite** (https://github.com/IM2Neuroing/Image2BIDS2SQLite.git) repository stores the pipeline used to organize the imaging files according to the BIDS standard (File2BIDS) and to store metadata and references to those files in the DMS.db. The output of File2BIDS is stored in NeuroDMS/BIDS.

## Prerequisite REDCap (only for data collection)

REDCap (Research Electronic Data Capture) is a secure web application for building and managing online surveys and databases. While REDCap is not open source, it is freely available to non-profit organizations and institutions involved in academic, non-profit, or government research. To collect new data from clinicians or other participants, you need access to a running REDCap instance. Here are your options:

### 1. Accessing an Existing REDCap Instance

- **Check with Your Institution:** Many universities and research institutions already have a REDCap instance. Contact your institution's IT or research department to see if you can access it.
- **Request an Account:** If your institution has a REDCap instance, request an account from the administrator.

### 2. Setting Up Your Own REDCap Instance

If your institution does not have a REDCap instance, you can set up your own. Here's how:

- **Join & Get REDCap:** You can apply for a REDCap license through the [REDCap website](https://projectredcap.org/partners/join/).
- **Download REDCap:** Once approved, you can request the 'redcapx.y.z.zip' installation file from your institution's REDCap administrator or download it from the official source if provided.
- **Install REDCap Locally:** Use the following repository to set up a local REDCap instance:
  - [REDCap Docker Compose](https://github.com/123andy/redcap-docker-compose?tab=readme-ov-file#quick-start): This GitHub repository provides instructions and scripts to quickly set up a REDCap instance using Docker. Follow the steps in the repository's README for detailed setup instructions.

### 3. Project Setup and API Token Request

Once you have access to a REDCap instance, you can proceed with setting up your project:

- **Create a New Project:** In your REDCap instance, create a new project or use an existing one as a template.
- **Request an API Token:** For data integration and automation, request an API token from your REDCap administrator. This token is necessary for accessing the REDCap API, which allows for programmatic interactions with your project.

By following these steps, you can set up and access a REDCap instance to collect data for your research project. If you need further assistance, refer to the [REDCap documentation](https://projectredcap.org/resources/) or contact your institution's REDCap support team.

## Usage

To install the other parts of the NeuroDataManagementSystem, you need to have Docker and Docker Compose installed on your machine. If you don't have Docker and Docker Compose installed, you can follow the instructions below:
    - To install Docker, you can follow the instructions on the official Docker website: https://docs.docker.com/get-docker/
    - To install Docker Compose, you can follow the instructions on the official Docker Compose website: https://docs.docker.com/compose/install/

### NeuroDataManagementSystem setup Steps

To install the final NeuroDataManagementSystem, you need to follow the steps below:

#### Docker and Docker Compose version

```bash
# Make sure you have Docker and Docker Compose installed
docker --version
docker-compose --version

```

#### Create NeuroDataManagementSystem & BIDS folder

```bash
# Create the NeuroDataManagementSystem folder
mkdir NeuroDMS
# Create the BIDS folder
mkdir NeuroDMS/BIDS
# (optional) Create the setup folder
mkdir NeuroDMS/setup
```

#### Use FILE2BIDS to organize the imaging data

Download our os corresponding release of the FILE2BIDS GUI from the following link:

- [**File2BIDS Executable for Windows**](https://github.com/IM2Neuroing/Image2BIDS2SQLite/releases/download/v1.0.0/File2BIDS-windows-exe.zip)
- [**File2BIDS Executable for macOS**](https://github.com/IM2Neuroing/Image2BIDS2SQLite/releases/download/v1.0.0/File2BIDS-macos-exe.zip)
- [**File2BIDS Executable for Linux**](https://github.com/IM2Neuroing/Image2BIDS2SQLite/releases/download/v1.0.0/File2BIDS-linux-exe.zip)

Extract the downloaded zip file, make the file executable and run the `convert_to_BIDS` executable . The GUI will guide you through the process of organizing your imaging data according to the BIDS standard.

#### Configuration files

Adjust the configuration file to your setup for the REDCap2SQLite pipeline: **REDCap2SQLite_config.json**

```json
    {    
        "__comment-MAIN__": "MAIN-part:",
        "__comment-EXTRACT__": "Extract-part:",
        "extract_redcap": false,                                # set to true if you want to extract data from REDCap
        "redcap_api_address": "https://redcap.com//api/",       # REDCap API address / not needed if extract_redcap is false and csv file is provided
        "redcap_project": "DBSDatabase",                        # REDCap project name / not needed if extract_redcap is false
        "redcap_api_token": "NOT4YOU",                          # REDCap API token / not needed if extract_redcap is false        
        "extraction_path": "setup/DATA.csv",                    # path within the docker container to the extracted data
        "__comment-TRANSFORM__": "Transform-part:",
        "transform_data" : true,                                # set to true if you want to transform the data into SQL queries
         "data_path": "data_setup/",                            # path within the docker container to where the transformed data should be stored
        "mapping_path":"setup/mappingtables/",                  # path within the docker container to the mapping tables
        "__comment-LOAD__": "Load-part:",                                           
        "db_creation": true,                                    # set to true if you want to create a new database
        "db_wipe":false,                                        # set to true if you want to wipe the database before loading the data
        "db_path": "NeuroDMS/DMS.db",                           # path within the docker container to the database
        "db_schema": "setup/sqlite_schema.sql",                 # path within the docker container to the schema file
        "db_load_data": true                                    # set to true if you want to load the data into the database
    }
```

Adjust the configuration file to your setup for the Image2BIDS2SQLite pipeline: **Image2BIDS2SQLite_config.json**

```json
    {   
        "__MAIN__config" : "version 1.0",
        "datasystem_root": "NeuroDMS",                          # path within the docker container to the root folder of the data system
        "bids_dir_path": "NeuroDMS/BIDS",                       # path within the docker container to the BIDS folder
        "__EXTRACT__config": "1.0",
        "skip_extraction": false,                               # set to true if you want to skip the extraction
        "extraction_path" : "setup",                            # path within the docker container to the extraction folder
        "__TRANSFORM__config": "1.0",
        "skip_transformation": false,                           # set to true if you want to skip the transformation into SQL queries    
        "skip_db_creation" : true,                              # set to true if you want to skip the creation of the database
        "db_schema": "sqlite_schema.sql",                       # path within the docker container to the schema file (needed if skip_db_creation is false)
        "__LOAD__config": "1.0",
        "skip_loading": false,                                  # set to true if you want to skip the loading of the data into the database
        "db_path": "NeuroDMS/DMS.db",                           # path within the docker container to the database
        "__IMAGE_CLEANING__config": "1.0",
        "skip_image_cleaning" : false,                          # set to true if you want to skip the image cleaning
        "__BACKPROPAGATION__config":"1.0",
        "skip_backpropagation": false                           # set to true if you want to skip the backpropagation
    }
```

*The configuration files, need maybe some minor adjustments to fit your setup, but keep in mind that the configuration file is already set up for docker-compose.*

#### Docker Compose file

Adjust the docker-compose.yml file to your setup for the NeuroDataManagementSystem:

```yaml
    version: '3.8'

    services:
    redcap2sqlite:
        image: ghcr.io/im2neuroing/redcap2sqlite:main
        volumes:
        # folders to mount
        - ./NeuroDMS/:/app/NeuroDMS/
        # files to mount needed for the configuration
        - ./REDCap2SQLite_config.json:/app/config.json:ro

        # (optional) mount the raw data csv file (if extraction is skipped - see example)
        - ./CLINICALDATA/Data/DBS_DATA.csv:/app/setup/DATA.csv:ro
        # mount the entire mappingtables directory
        - ./CLINICALDATA/mappingTables:/app/setup/mappingtables:ro
        # mount the sqlite schema file
        - ./SQLite/sqlite_schema.sql:/app/setup/sqlite_schema.sql:ro
        environment:
        - PYTHONUNBUFFERED=1

    image2sqlite:
        image: ghcr.io/im2neuroing/image2bids2sqlite:main-BIDS2SQLite
        volumes:
        # folder to mount
        - ./NeuroDMS/:/app/NeuroDMS/ #Image management System folder which contains the BIDS folder
        # file to mount needed for the configuration
        - ./Image2BIDS2SQLite_config.json:/app/config.json:ro
        # file to mount needed for the schema (optional)
        - ./SQLite/sqlite_schema.sql:/app/sqlite_schema.sql:ro

        # OPTIONAL: if you want to mount the output folder
        - ./NeuroDMS/setup/:/app/setup/  #    "extraction_path" : "/setup" to see the steps of the pipeline
        environment:
        # set the environment variables
        - PYTHONUNBUFFERED=1
```

#### Docker Compose

```bash
# Run the Docker Compose
docker-compose up
```

## Example Usage

In this repository, we provide an example of a NeuroDataManagementSystem setup. To build the example, you need to follow the steps below:

1. Clone the repository

    ```bash
    git clone https://github.com/IM2Neuroing/NeuroDataManagementSystem.git
    ```

2. Create a new NeuroDMS folder, together with the setup folder

    ```bash
    mkdir newNeuroDMS
    mkdir newNeuroDMS/setup
    ```

3. Copy the `BIDS` imaging data from the `NeuroDMS/BIDS` folder to the `newNeuroDMS` folder

    ```bash
    cp -r NeuroDMS/BIDS newNeuroDMS/
    ```

3. (Optional) Instead of copying the `BIDS` imaging data, you can use the `FILE2BIDS` GUI to organize the imaging data according to the BIDS standard.

    For that you first create a BIDS folder in the `newNeuroDMS` folder:

    ```bash
    mkdir newNeuroDMS/BIDS
    ```

    Then you can download the `FILE2BIDS` GUI and then run the `convert_to_BIDS` executable to organize the imaging data. The GUI will guide you through the process of organizing your imaging data according to the BIDS standard. Try to organize the imaging data from `IMAGEDATA/4BIDS` in the `newNeuroDMS/BIDS` folder.

4. Run the Docker Compose file to build the NeuroDataManagementSystem

    ```bash
    docker-compose up -d
    ```

## License

This project is licensed under the MIT License. This means you are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software, under the conditions that you include the following:

1. A copy of the original MIT License in any redistributed copies or substantial portions of the software.
2. A clear acknowledgement of the original source of the software.

For more details, please see the [LICENSE](LICENSE) file in the project root.

## Contributing

Contributions, issues, and feature requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

***Enjoy your data efficiently and reliably!***
