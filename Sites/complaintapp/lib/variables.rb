module Variables
    States = {
        "Alabama" => "AL",
        "Alaska" => "AK",
        "American Samoa" => "AS",
        "Arkansas" => "AR",
        "Arizona" => "AZ",
        "California" => "CA",
        "Colorado" => "CO",
        "Connecticut" => "CT",
        "Delaware" => "DE",
        "District of Columbia" => "DC",
        "Florida" => "FL",
        "Georgia" => "GA",
        "Guam" => "GU",
        "Hawaii" => "HI",
        "Idaho" => "ID",
        "Illinois" => "IL",
        "Indiana" => "IN",
        "Iowa" => "IA",
        "Kansas" => "KS",
        "Kentucky" => "KY",
        "Louisiana" => "LA",
        "Maine" => "ME",
        "Marshall Islands" => "MH",
        "Maryland" => "MD",
        "Massachusetts" => "MA",
        "Michigan" => "MI",
        "Micronesia" => "FM",
        "Minnesota" => "MN",
        "Mississippi" => "MS",
        "Missouri" => "MO",
        "Montana" => "MT",
        "Nebraska" => "NE",
        "New Hampshire" => "NH",
        "New Jersey" => "NJ",
        "New Mexico" => "NM",
        "New York" => "NY",
        "Nevada" => "NV",
        "North Carolina" => "NC",
        "North Dakota" => "ND",
        "Northern Mariana Islands" => "MP",
        "Ohio" => "OH",
        "Oklahoma" => "OK",
        "Oregon" => "OR",
        "Palau" => "PW",
        "Pennsylvania" => "PA",
        "Puerto Rico" => "PR",
        "Rhode Island" => "RI",
        "South Carolina" => "SC",
        "South Dakota" => "SD",
        "Tennessee" => "TN",
        "Texas" => "TX",
        "U.S. Armed Forces – Americas" => "AA",
        "U.S. Armed Forces – Europe" => "AE",
        "U.S. Armed Forces – Pacific" => "AP",
        "U.S. Minor Outlying Islands" => "UM",
        "Utah" => "UT",
        "Vermont" => "VT",
        "Virgin Islands" => "VI",
        "Virginia" => "VA",
        "Washington" => "WA",
        "West Virginia" => "WV",
        "Wisconsin" => "WI",
        "Wyoming" => "WY"
    }

    # Don't return potentially inaccurate results (year total, monthly average) when date range is selected
    # Note that month counts may be partial, if date range doesn't include a whole month
    Company_dates = "select Ranking, name, mnth as Month, cnt as mnth_cnt, yr as Year from "
    
    # Return all results when no date range is selected
    Company_no_dates = "select Ranking, name, mnth as Month, cnt as mnth_cnt, yr as Year, yr_total, mnthly_avg from "
    Company_query_1 = " 
    (select Rownumber as Ranking, name, mnth, yr, cnt from 
        (select Row_Number() over (partition by yr, mnth order by cnt desc) 
         as Rownumber, name, mnth, yr, cnt from 
            (select name,  extract(month from date_received) as mnth, extract(year from date_received) as yr, count(*) as cnt from 
            "
    
    Company_query_2 = "
            where not (date_received < to_date('01/01/2012', 'MM/DD/YYYY') or date_received > to_date('08/31/2018', 'MM/DD/YYYY'))
            group by name, extract(year from date_received), extract(month from date_received) 
            order by extract(year from date_received) desc, mnth, count(*) desc) 
         order by yr desc, mnth) "

    # Company Only query uses all tuples, as does Company + Product query
    Company_query_num = "where Rownumber > 0) "

    # Limits ranking queries to the top 5 rankings
    # Note, this number can be adjusted if too many results are returned.
    # For some sparse filters (for ex. submission method = Fax), many companies
    # may have appeared at least once in the top 5 rankings.
    Neither_query_num = "where Rownumber < 6) "

    Company_query_3 = "natural join 
    ((select name, yr, yr_total, round(yr_total/12, 1) as mnthly_avg from 
        (select 
            extract(year from date_received) as yr, name, count(*) as yr_total, 
            count(distinct extract(month from date_received)) as mnths 
        from
        " 

    Company_query_4 = "
        where not (date_received < to_date('01/01/2012', 'MM/DD/YYYY') or date_received > to_date('12/31/2017', 'MM/DD/YYYY'))
        group by extract(year from date_received), name 
        order by extract(year from date_received) desc, count(*) desc)) 
    union  
    (select name, yr, yr_total, round(yr_total/ 
    (select count(distinct extract(month from date_received)) from complaint 
    where extract(year from date_received) = 2018 and date_received < to_date('09/01/2018', 'MM/DD/YYYY')), 1) as mnthly_avg from 
        (select 
            extract(year from date_received) as yr, name, count(*) as yr_total, 
            count(distinct extract(month from date_received)) as mnths 
        from
        " 

    Company_query_5 ="
        where not (date_received < to_date('01/01/2018', 'MM/DD/YYYY') or date_received > to_date('08/31/2018', 'MM/DD/YYYY'))
        group by extract(year from date_received), name 
        order by extract(year from date_received) desc, count(*) desc))) 
        order by yr desc, mnth desc, cnt desc, ranking
        " 


    def product_query_builder(params, query)
        new_query = "select * from
        (select type, yr, cnt, monthly_complaint_avg from
            (select type, yr, cnt, monthly_complaint_avg from
               (select 'Banking' as type, 
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from bank_account)
                group by extract(year from date_received)
            union
                select 'Credit Card' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from credit_card)
                group by extract(year from date_received)
            union
                select 'Credit Reporting' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from credit_reporting)
                group by extract(year from date_received)
            union
                select 'Money Transfer' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query  
        new_query += "
                where type in (select type from money_transfer)
                group by extract(year from date_received)
            union
                select 'Consumer Loan' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from payday_loan)
                group by extract(year from date_received)
            union
                select 'Prepaid Card' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from prepaid_card)
                group by extract(year from date_received)
            union
                select 'Virtual Currency' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from virtual_currency)
                group by extract(year from date_received)
            union
                select type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from single_products)
                group by type, extract(year from date_received)
                order by type, yr desc) all_data
            where all_data.yr != 2018 and all_data.yr != 2011)
            union 
            (select type, yr, cnt, monthly_complaint_avg from
               (select 'Banking' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from bank_account)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Credit Card' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from credit_card)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Credit Reporting' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from credit_reporting)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Money Transfer' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from money_transfer)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Consumer Loan' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from payday_loan)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Prepaid Card' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from prepaid_card)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Virtual Currency' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from virtual_currency)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from single_products)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by type, extract(year from date_received)
                order by type, yr desc) all_data
            where all_data.yr = 2018)) 
        "

        # Ensure that unselected types don't show up in results
        prodnum = 0
        product = "where "
        if params[:type].key?("1")
            product += "type = 'Banking' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("2")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Consumer Loan' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("3")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Credit Card' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("4")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Credit Reporting' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("5")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Debt collection' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("6")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Money Transfer' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("7")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Mortgage' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("8")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Prepaid Card' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("9")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Student loan' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("10")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Virtual Currency' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("11")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Other financial service' "
            prodnum = prodnum + 1
        end
        product += "order by type, yr desc"
        new_query += product
        return new_query
    end

    def product_query_builder_dated(params, query)
        new_query = "select * from
        (select type, yr, mnth, cnt as mnth_cnt from
            (select type, yr, mnth, cnt from
               (select 'Banking' as type, 
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from bank_account)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Credit Card' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from credit_card)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Credit Reporting' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from credit_reporting)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Money Transfer' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query  
        new_query += "
                where type in (select type from money_transfer)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Consumer Loan' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from payday_loan)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Prepaid Card' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from prepaid_card)
                group by extract(year from date_received), extract(month from date_received), extract(month from date_received)
            union
                select 'Virtual Currency' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from virtual_currency)
                group by extract(year from date_received), extract(month from date_received)
            union
                select type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from single_products)
                group by type, extract(year from date_received), extract(month from date_received)
                order by type, yr desc, mnth desc) all_data
            where all_data.yr != 2018 and all_data.yr != 2011)
            union 
            (select type, yr, mnth, cnt from
               (select 'Banking' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from bank_account)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Credit Card' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from credit_card)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Credit Reporting' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from credit_reporting)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Money Transfer' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from money_transfer)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Consumer Loan' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from payday_loan)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Prepaid Card' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from prepaid_card)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Virtual Currency' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from virtual_currency)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from single_products)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by type, extract(year from date_received), extract(month from date_received)
                order by type, yr desc, mnth desc) all_data
            where all_data.yr = 2018)) 
        "

        # Ensure that unselected types don't show up in results
        prodnum = 0
        product = "where "
        if params[:type].key?("1")
            product += "type = 'Banking' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("2")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Consumer Loan' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("3")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Credit Card' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("4")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Credit Reporting' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("5")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Debt collection' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("6")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Money Transfer' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("7")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Mortgage' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("8")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Prepaid Card' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("9")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Student loan' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("10")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Virtual Currency' "
            prodnum = prodnum + 1
        end
        if params[:type].key?("11")
            if prodnum > 0
                product += "or "
            end
            product += "type = 'Other financial service' "
            prodnum = prodnum + 1
        end
        product += "order by type, yr desc, mnth desc"
        new_query += product
        return new_query
    end

    # For Predefined Query #1 and custom queries with only filters
    def default_company_query(dated, query)
        # Get names of all companies that appear in the first 5 rankings
        query = dated + Company_query_1 + query + Company_query_2 + Neither_query_num + Company_query_3 + query + Company_query_4 + query + Company_query_5
        getnames = "select distinct name from (" + query + ")"
        names = ApplicationRecord.execQuery(getnames);
        query = "(select * from camoen.complaint where ("
        names.each_with_index do |row, index|
            row.each_with_index do |value, ind|
                query += "name = '" + value[1] + "' or "
            end
        end
        query = query.first(-3)
        query += "))"
        # Get ranking results
        query = dated + Company_query_1 + query + Company_query_2 + Company_query_num + Company_query_3 + query + Company_query_4 + query + Company_query_5
        return query
    end

end
