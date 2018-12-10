# Financial Protection Advisor
This repository is for a web application that aims to provide users with information about the consumer-friendliness of financial institutions, products, and services.  The application was built with Ruby on Rails, Bootstrap, HTML/CSS, Oracle Database, and a hefty amount of SQL.

### Oracle Setup

1. The `database.yml` file (located at `setup/database.yml`) must include valid credentials for an Oracle database.  Drop this file in `Sites/complaintapp/config`.
2. The data required for the database is provided on [Data.gov](https://catalog.data.gov/dataset/consumer-complaint-database) by the Consumer Financial Protection Bureau. After pre-processing the data, and then importing it into the Oracle database, the following table was obtained. Note that, within the app's code, the table is referred to as `camoen.complaint`, so that all Oracle users with permissions can appropriately access the data.<br><img src="https://raw.githubusercontent.com/Camoen/Financial-Protection-Advisor/master/readme/complaint_table.PNG" alt="Complaint Table with 18 Attributes" width="" height="">
3. For easier querying, product and service types in the database are grouped into views. The `setup/oracle_setup.sql` file contains the setup of these views, as well as the commands required to create and grant permissions for other Oracle users.<br><img src="https://raw.githubusercontent.com/Camoen/Financial-Protection-Advisor/master/readme/views.PNG" alt="Product and Service Views" width="" height="">

### Ruby on Rails Setup

1. Download [Oracle Instant Client (32 bit)](https://www.oracle.com/technetwork/database/database-technologies/instant-client/downloads/index.html) and add it to the system PATH variables.
2. Install Ruby on Rails.  [Ruby 2.3 Installer](http://railsinstaller.org/en) worked well at the time of development.
3. [Node.js](https://nodejs.org/en/download/) may also be required.
4. Once all setup is complete, the server can be started via using the `rails s` command from Command Prompt or Git Bash (while inside the local directory).


## Application Features
### Landing Page
<p align="center"><img src="https://raw.githubusercontent.com/Camoen/Financial-Protection-Advisor/master/readme/landing_page.PNG" alt="Financial Protection Advisor - Landing Page" width="80%" height=""></p>

### Search Directory
This page includes descriptions and links to the results of six predefined queries (numbered 1-6, below).  Additionally, the [custom search](#custom-search) feature, which provides users with the ability to filter for specific data, is located at the bottom of the page.
<p align="center"><img src="https://raw.githubusercontent.com/Camoen/Financial-Protection-Advisor/master/readme/search_directory.PNG" alt="Financial Protection Advisor - Search Directory Page" width="80%" height=""></p>

#### 1. Company Rankings
This page is reached by clicking the "Company Rankings" button.  An SQL query is ran to determine the 5 least consumer-friendly companies for each year, as measured by their average monthly number of complaints.  Then, data for all years is gathered for each company that ever appears in this top 5.  Data is returned both as a line graph, allowing for easy visualization of the data, and as a table.  <i>To reduce clutter, every line or bar in the returned graphs can be toggled on or off by clicking its related label.</i>
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/complaint_rankings.png" alt="Financial Protection Advisor - Company Ranking Results" width="80%" height=""></p>


#### 2. Product Rankings
This page is reached by clicking the "Product Rankings" button.  The average monthly number of complaints is computed and returned for each of the financial products and services in the database.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/product_rankings.png" alt="Financial Protection Advisor - Product Ranking Results" width="80%" height=""></p>

#### 3. Timeliness Rankings
This page is reached by clicking the "Timeliness Rankings" button.  There are two sections on this page, both of which return the five worst-performing companies from each year.  The first section ranks companies by their yearly number of untimely responses, and the second section ranks companies by the percentage of their responses that were untimely.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/timeliness_rankings.png" alt="Financial Protection Advisor - Timeliness Ranking Results" width="80%" height=""></p>

#### 4. Dispute Rankings
This page is reached by clicking the "Dispute Rankings" button.  There are two sections on this page, both of which return the five worst-performing companies from each year.  The first section ranks companies by their yearly number of disputed responses, and the second section ranks companies by the percentage of their responses that were disputed.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/dispute_rankings.png" alt="Financial Protection Advisor - Dispute Ranking Results" width="80%" height=""></p>

#### 5. Company Deep Dive
This page is reached by selecting a company (in this case, EQUIFAX, INC.) and clicking the "Company Deep Dive" button.  Monthly counts of complaints received by the selected company are charted for each year of data available in the database.  This feature allows the user to look for trends in an institution's performance over time.  
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/company_deep_dive.png" alt="Financial Protection Advisor - Company Deep Dive Results" width="80%" height=""></p>

#### 6. Product Deep Dive
This page is reached by selecting a product or service (in this case, Credit Reporting) and clicking the "Product Deep Dive" button.  Monthly counts of complaints received about a particular product are charted for each year of data available in the database.  This feature allows the user to look for trends in a product's performance over time.  
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/product_deep_dive.png" alt="Financial Protection Advisor - Product Deep Dive Results" width="80%" height=""></p>


#### Custom Search
