# Financial-Protection-Advisor
This repository is for a webapp that aims to provide users with information about the consumer-friendliness of financial institutions, products, and services.  The application was built with Ruby on Rails, Bootstrap, HTML/CSS, Oracle Database, and a hefty amount of SQL.

### Oracle Setup

1. The `database.yml` file (located at `setup/database.yml`) must include valid credentials for an Oracle database.  Drop this file in `Sites/complaintapp/config`.
2. The data required for the database is provided on [Data.gov](https://catalog.data.gov/dataset/consumer-complaint-database) by the Bureau of Consumer Financial Protection. After pre-processing the data, and then importing it into the Oracle database, the following table was obtained. Note that, within the app's code, the table is referred to as `camoen.complaint`, so that all Oracle users with permission were able access to the data.<br><img src="https://raw.githubusercontent.com/Camoen/Financial-Protection-Advisor/master/setup/complaint_table.PNG" alt="Complaint Table with 18 Attributes" width="" height="">
3. For easier querying, product and service types in the database were grouped into views. The `setup/oracle_setup.sql` file contains the setup of these views, as well as the commands required to create and grant permissions for other Oracle users.<br><img src="https://raw.githubusercontent.com/Camoen/Financial-Protection-Advisor/master/setup/views.PNG" alt="Product and Service Views" width="" height="">

### Ruby on Rails Setup

1. Download [Oracle Instant Client (32 bit)](https://www.oracle.com/technetwork/database/database-technologies/instant-client/downloads/index.html) and add it to the system PATH variables.
2. Install Rails.  The [Ruby 2.3 Installer](http://railsinstaller.org/en) worked well.
3. [Node.js](https://nodejs.org/en/download/) may also be required.
4. Once all setup is complete, the server can be started via using the `rails s` command from Command Prompt or Git Bash (while inside the local directory).
