/* Group complaint/Service types in views for easier querying. */

/* complaint Type Selections */
select distinct type from complaint;

/* Select Bank Account */
create view bank_account as
select distinct type from complaint
where lower(complaint.type) like '%bank account%' or
lower(complaint.type) like '%checking or savings account%';

/* Select Credit Card */
create view credit_card as
select distinct type from complaint
where complaint.type like 'Credit card%';

/* Select Credit Reporting */
create view credit_reporting as
select distinct type from complaint
where complaint.type like 'Credit reporting%';

/* Select Money Transfer */
create view money_transfer as
select distinct type from complaint
where complaint.type like 'Money transfer%';

/* Select Payday Loan */
create view payday_loan as
select distinct type from complaint
where complaint.type like 'Payday loan%' or
lower(complaint.type) like '%consumer loan%' or
lower(complaint.type) like '%vehicle loan or lease%';

/* Select Prepaid Card */
create view prepaid_card as
select distinct type from complaint
where lower(complaint.type) like '%prepaid card%';

/* Select Virtual Currency */
create view virtual_currency as
select distinct type from complaint
where lower(complaint.type) like '%virtual currency%';

/* Single Products View (single categories only) */
create view single_complaints as
select distinct type from complaint
minus select type from bank_account
minus select type from credit_card
minus select type from credit_reporting
minus select type from money_transfer
minus select type from payday_loan
minus select type from prepaid_card
minus select type from virtual_currency;


/* Create role and grant select permissions to other Oracle users */
create role select_data;
grant select on complaint to select_data;
grant select on complaint to select_data;
grant select on bank_account to select_data;
grant select on credit_card to select_data;
grant select on credit_reporting to select_data;
grant select on money_transfer to select_data;
grant select on payday_loan to select_data;
grant select on prepaid_card to select_data;
grant select on single_complaints to select_data;
grant select on virtual_currency to select_data;

/* Grant the role */
grant select_data to username_here;
