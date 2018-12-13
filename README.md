# Financial Protection Advisor
This repository is for a web application that aims to provide users with information about the consumer-friendliness of financial institutions, products, and services.  The application was built with Ruby on Rails, Bootstrap, HTML/CSS, Oracle Database, and a hefty amount of SQL.

## Table of Contents
* [Setup](#setup)
    * [Oracle Setup](#oracle-setup)
    * [Ruby on Rails Setup](#ruby-on-rails-setup)
* [Application Features](#application-features)
    * [Landing Page](#landing-page)
    * [Search Directory](#search-directory)
        * [Company Rankings](#company-rankings)
        * [Product Rankings](#product-rankings)
        * [Timeliness Rankings](#timeliness-rankings)
        * [Dispute Rankings](#dispute-rankings)
        * [Company Deep Dive](#company-deep-dive)
        * [Product Deep Dive](#product-deep-dive) 
    * [Custom Search](#custom-search)
        * [Custom Search Form](#custom-search-form)
        * [Custom Search Results](#custom-search-results) 


## Setup
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
This page includes descriptions and links to the results of six predefined queries.  Additionally, the [custom search](#custom-search) feature, which provides users with the ability to filter for specific data, is located at the bottom of the page.
<p align="center"><img src="https://raw.githubusercontent.com/Camoen/Financial-Protection-Advisor/master/readme/search_directory.PNG" alt="Financial Protection Advisor - Search Directory Page" width="80%" height=""></p>

#### Company Rankings
This page is reached by clicking the "Company Rankings" button.  An SQL query is ran to determine the 5 least consumer-friendly companies for each year, as measured by their average monthly number of complaints.  Then, data for all years is gathered for each company that ever appears in this top 5.  Data is returned both as a line graph, allowing for easy visualization of the data, and as a table.  <i>To reduce clutter, every line or bar in the returned graphs can be toggled on or off by clicking its related label.</i>
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/complaint_rankings.png" alt="Financial Protection Advisor - Company Ranking Results" width="80%" height=""></p>


#### Product Rankings
This page is reached by clicking the "Product Rankings" button.  The average monthly number of complaints is computed and returned for each of the financial products and services in the database.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/product_rankings.png" alt="Financial Protection Advisor - Product Ranking Results" width="80%" height=""></p>

#### Timeliness Rankings
This page is reached by clicking the "Timeliness Rankings" button.  There are two sections on this page, both of which return the five worst-performing companies from each year.  The first section ranks companies by their yearly number of untimely responses, and the second section ranks companies by the percentage of their responses that were untimely.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/timeliness_rankings.png" alt="Financial Protection Advisor - Timeliness Ranking Results" width="80%" height=""></p>

#### Dispute Rankings
This page is reached by clicking the "Dispute Rankings" button.  There are two sections on this page, both of which return the five worst-performing companies from each year.  The first section ranks companies by their yearly number of disputed responses, and the second section ranks companies by the percentage of their responses that were disputed.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/dispute_rankings.png" alt="Financial Protection Advisor - Dispute Ranking Results" width="80%" height=""></p>

#### Company Deep Dive
This page is reached by selecting a company (in this case, EQUIFAX, INC.) and clicking the "Company Deep Dive" button.  Note that the dropdown list allows the selection of any company that exists in the database—on the initial page load, this list is dynamically generated from the results of an SQL query.  Monthly counts of complaints received by the selected company are charted for each year of data available in the database.  This feature allows the user to look for trends in an institution's performance over time.  
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/company_deep_dive.png" alt="Financial Protection Advisor - Company Deep Dive Results" width="80%" height=""></p>

#### Product Deep Dive
This page is reached by selecting a product or service (in this case, Credit Reporting) and clicking the "Product Deep Dive" button.  Monthly counts of complaints received about a particular product are charted for each year of data available in the database.  This feature allows the user to look for trends in a product's performance over time.  
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/product_deep_dive.png" alt="Financial Protection Advisor - Product Deep Dive Results" width="80%" height=""></p>


## Custom Search
This feature, located at the bottom of the search directory page, aims to provide users with the ability to filter for results that interest them.  Results may be returned in one of eight different ways, depending on the user's selected categories:

<b>1) Only company selections:</b>  All data, for all selected companies, will be used in the generation of results.  

<b>2) Only product/service selections:</b>  All data, for all selected products or services, will be used in the generation of results.  

<b>3) No selections:</b>  All data will be used in the generation of results, but only the five least consumer-friendly companies for any given year will be returned.  If a company only appears in the "top 5 worst performers" for one year, all of its data (for every year) will still be returned.

<b>4) Both company and product selections:</b>
For every selected company, only complaints about the selected products or services will be used to generate results.  For instance, assume that "Banking", "American Express Company", and "Discover Bank" have all been selected.  When results are generated, the only complaints about American Express and Discover that will be utilized are those related to Banking.  All other complaints that have been lodged about the selected companies (for example, those about credit cards) will be ignored.

<b>Date Range:</b>  Each of these four options can return "dated" or "undated" results, based on the user's selection of a date range—this effectively doubles the number of ways that results may be returned.  Undated results utilize all data in the database, and the returned results include an average monthly complaint number for every year.  Dated results return explicit monthly complaint counts for every month and year represented in the database.

<b>Filters:</b>  The "Complaint Submission Method", "Demographic", and "State Selection" filters narrow down the data used when generating results, but don't lead to any further variation in the way results are returned.  For example, if "E-mail" and "Fax" are selected, only those complaints received via e-mail or fax will be considered.  Note that the "Older American" and "Service Member" demographics overlap, so the "Not Older American" and "Not Service Member" filters are provided in case the user wishes to completely ignore the complaints of either demographic.  The default behavior (when all filters are unselected) is to utilize all data in the database.  This also applies if, for example, submission method and demographic filters are chosen, but a state filter is not selected.  In this scenario, only complaints matching the submission method and demographic filters will be utilized, but data from all states will still be considered.

### Custom Search Form
Similar to the Company Deep Dive dropdown list, the "Company Selection" category is dynamically populated when the page loads, to ensure that every company in the database is represented.  The list is in alphabetical order but, due to the list's size, it's recommended to use `Ctrl+F` to locate a particular company.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/custom_search.png" alt="Financial Protection Advisor - Custom Search Form" width="80%" height=""></p>

### Custom Search Results
For all "dated" results, the full range of dates has been selected.  This range can be narrowed in accordance with the user's specific interests.

#### 1a) Only company selections (undated):
The selected companies are "American Express Company", "Bank of America, National Association", "Discover Bank", "Equifax, Inc.", "Experian Information Solutions Inc.", and "Transunion Intermediate Holdings, Inc."
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/custom_company_only_undated.png" alt="Custom Search Results - Only Company Selections (undated)" width="80%" height=""></p>

#### 1b) Only company selections (dated):
The same companies are selected as in the previous results.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/custom_company_only_dated.png" alt="Custom Search Results - Only Company Selections (dated)" width="80%" height=""></p>

#### 2a) Only product selections (undated):
This is the same as the Product Rankings results, but it includes only the selected products.<br>

#### 2b) Only product selections (dated):
In this example, all products and services have been selected.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/custom_product_only_dated.png" alt="Custom Search Results - Product Only (dated)" width="80%" height=""></p>

#### 3a) No selections (undated):
This is the same as the Company Rankings results.<br>

#### 3b) No selections (dated):
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/custom_no_selections_dated.png" alt="Custom Search Results - No Selections (dated)" width="80%" height=""></p>

#### 4a) Both company and product selections (undated):
The selected companies are "American Express Company", "Bank of America, National Association", "Discover Bank", "Equifax, Inc.", "Experian Information Solutions Inc.", and "Transunion Intermediate Holdings, Inc."  The selected products are "Credit Card" and "Credit Reporting"—only complaints about these two products will be considered in the results.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/custom_both_undated.png" alt="Custom Search Results - Company and Product Selections (undated)" width="80%" height=""></p>

#### 4b) Both company and product selections (dated):
The same companies and products have been chosen as in the previous results.
<p align="center"><img src="https://github.com/Camoen/Financial-Protection-Advisor/blob/master/readme/custom_both_dated.png" alt="Custom Search Results - Company and Product Selections (dated)" width="80%" height=""></p>
