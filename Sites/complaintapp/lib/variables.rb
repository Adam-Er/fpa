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
    Company_dates = "select Ranking, name, mnth as Month, cnt as Month_Count, yr as Year from "

    
    # Return all results when no date range is selected
    Company_no_dates = "select Ranking, name, mnth as Month, cnt as Month_Count, yr as Year, yr_total, mnthly_avg from "
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
    (select count(distinct extract(month from date_received)) from camoen.complaint 
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
        new_query = "select type as Product, yr as Year, cnt as Count, monthly_complaint_avg as Monthly_Average from
        (select type, yr, cnt, monthly_complaint_avg from
            (select type, yr, cnt, monthly_complaint_avg from
               (select 'Banking' as type, 
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.bank_account)
                group by extract(year from date_received)
            union
                select 'Credit Card' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.credit_card)
                group by extract(year from date_received)
            union
                select 'Credit Reporting' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.credit_reporting)
                group by extract(year from date_received)
            union
                select 'Money Transfer' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query  
        new_query += "
                where type in (select type from camoen.money_transfer)
                group by extract(year from date_received)
            union
                select 'Consumer Loan' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.payday_loan)
                group by extract(year from date_received)
            union
                select 'Prepaid Card' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.prepaid_card)
                group by extract(year from date_received)
            union
                select 'Virtual Currency' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.virtual_currency)
                group by extract(year from date_received)
            union
                select type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/12,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.single_products)
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
                where type in (select type from camoen.bank_account)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Credit Card' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.credit_card)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Credit Reporting' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.credit_reporting)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Money Transfer' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.money_transfer)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Consumer Loan' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.payday_loan)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Prepaid Card' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.prepaid_card)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select 'Virtual Currency' as type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.virtual_currency)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received)
            union
                select type,
                extract(year from date_received) as yr, count(*) as cnt,
                round(count(*)/8,1) as monthly_complaint_avg from "
        new_query += query
        new_query += "
                where type in (select type from camoen.single_products)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by type, extract(year from date_received)
                order by type, yr desc) all_data
            where all_data.yr = 2018)) 
        "

        # Ensure that unselected types don't show up in results
        if (!params[:type].blank?)
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
        end

        return new_query
    end

    def product_query_builder_dated(params, query)
        new_query = "select type as Product, yr as Year, mnth as Month, mnth_cnt as Month_Count from
        (select type, yr, mnth, cnt as mnth_cnt from
            (select type, yr, mnth, cnt from
               (select 'Banking' as type, 
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.bank_account)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Credit Card' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.credit_card)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Credit Reporting' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.credit_reporting)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Money Transfer' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query  
        new_query += "
                where type in (select type from camoen.money_transfer)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Consumer Loan' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.payday_loan)
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Prepaid Card' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.prepaid_card)
                group by extract(year from date_received), extract(month from date_received), extract(month from date_received)
            union
                select 'Virtual Currency' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.virtual_currency)
                group by extract(year from date_received), extract(month from date_received)
            union
                select type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.single_products)
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
                where type in (select type from camoen.bank_account)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Credit Card' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.credit_card)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Credit Reporting' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.credit_reporting)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Money Transfer' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.money_transfer)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Consumer Loan' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.payday_loan)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Prepaid Card' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.prepaid_card)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select 'Virtual Currency' as type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.virtual_currency)
                and date_received < to_date('09/01/2018', 'MM/DD/YYYY')
                group by extract(year from date_received), extract(month from date_received)
            union
                select type,
                extract(year from date_received) as yr,
                extract(month from date_received) as mnth, count(*) as cnt from "
        new_query += query
        new_query += "
                where type in (select type from camoen.single_products)
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

    Refine_results = "
    select Row_Number() over (partition by Year order by Monthly_Average desc) as Ranking, Name, Year, Monthly_Average from
        (select distinct name as Name, Year, mnthly_avg as Monthly_Average from ( "
    Refine_results2 = ")) order by Year desc, Monthly_Average desc"

    # For Predefined Query #1
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
        refined_query = Refine_results
        refined_query += query + Refine_results2
        return refined_query
    end

    # For Predefined Query #3 (Response Timeliness)
    def timely_query(partition)
        query = "
        select Ranking, name, yr as Year, yes_cnt as Timely, no_cnt as Untimely, untimely_pct as Percent_Untimely from
            (select Row_Number() over (partition by yr order by "
        # Partition selects "total untimely response count" or "untimely response percentage"
        query += partition
        query += " desc)
            as Ranking,
            name, yr, yes_cnt, no_cnt, round(no_cnt/(no_cnt+yes_cnt),2)*100 as untimely_pct from
                (select name as name,
                 extract(year from date_received) as yr, count(*) as yes_cnt from camoen.complaint
                 where response_timely = 'Yes'
                 group by name, extract(year from date_received))
            natural join
                (select name as name,
                 extract(year from date_received) as yr, count(*) as no_cnt from camoen.complaint
                 where response_timely = 'No'
                 group by name, extract(year from date_received)))
        where Ranking < 6   /* Choose only top 5 worst performers from each year */
        order by yr desc, ranking
        "
        return query
    end

    # For Predefined Query #4 (Disputed Resolutions)
    def dispute_query(partition)
        query = "
        select Ranking, name, yr as Year, yes_cnt as Disputed, no_cnt as Undisputed, disputed_pct as Percent_Disputed from
            (select Row_Number() over (partition by yr order by "
        # Partition selects "total untimely response count" or "untimely response percentage"
        query += partition
        query += " desc) as Ranking,
            name, yr, yes_cnt, no_cnt, round(yes_cnt/(no_cnt+yes_cnt),2)*100 as disputed_pct from
                (select name as name,
                 extract(year from date_received) as yr, count(*) as yes_cnt from camoen.complaint
                 where resolution_disputed = 'Yes'
                 group by name, extract(year from date_received))
            natural join
                (select name as name,
                 extract(year from date_received) as yr, count(*) as no_cnt from camoen.complaint
                 where resolution_disputed = 'No'
                 group by name, extract(year from date_received)))
        where Ranking < 6   /* Choose only top 5 worst performers from each year */
        order by yr desc, ranking
        "
        return query
    end

    # For custom queries with only filters
    def default_custom_query(dated, query, daterange, where)
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
        query += ") "
        #query += "and " + daterange + ")"
        query += "and " + where.last(-6) + ")"
        # Get ranking results
        query = dated + Company_query_1 + query + Company_query_2 + Company_query_num + Company_query_3 + query + Company_query_4 + query + Company_query_5
        return query
    end

    # For company and product deep dive
    def dive_query(query)
        newquery = "
        select  extract(month from date_received) as Month,
                extract(year from date_received) as Year,
                count(*) as Count from camoen.complaint "

        newquery += query
        newquery += "
        and not (date_received < to_date('01/01/2012', 'MM/DD/YYYY') or date_received > to_date('08/31/2018', 'MM/DD/YYYY'))
        group by extract(year from date_received), extract(month from date_received)
        order by Year desc, Month desc
        "
        return newquery
    end

    Products = {
        "Banking" => "type in (select type from camoen.bank_account) ",
        "Consumer Loan" => "type in (select type from camoen.payday_loan) ",
        "Credit Card" => "type in (select type from camoen.credit_card) ",
        "Credit Reporting" => "type in (select type from camoen.credit_reporting) ",
        "Debt Collection" => "type = 'Debt collection' ",
        "Money Transfer" => "type in (select type from camoen.money_transfer) ",
        "Mortgage" => "type = 'Mortgage' ",
        "Prepaid Card" => "type in (select type from camoen.prepaid_card) ",
        "Student Loan" => "type = 'Student loan' ",
        "Virtual Currency" => "type in (select type from camoen.virtual_currency) ",
        "Other" => "type = 'Other financial service' ",
        }

    Products_Reverse = {
        "type in (select type from camoen.bank_account) " => "Banking",
        "type in (select type from camoen.payday_loan) " => "Consumer Loan",
        "type in (select type from camoen.credit_card) " => "Credit Card",
        "type in (select type from camoen.credit_reporting) " => "Credit Reporting",
        "type = 'Debt collection' " => "Debt Collection",
        "type in (select type from camoen.money_transfer) " => "Money Transfer",
        "type = 'Mortgage' " => "Mortgage",
        "type in (select type from camoen.prepaid_card) " => "Prepaid Card",
        "type = 'Student loan' " => "Student Loan",
        "type in (select type from camoen.virtual_currency) " => "Virtual Currency",
        "type = 'Other financial service' " => "Other",
        }

    Colors = ["#4286f4", "#f47741", "#e8d833", "#71cc2c", "#2bcc86", "#7d29c6", 
              "#c11ba8", "#a8142a", "#1499a8", "#291463", "#a9bc54", "#594020",
              "#1f211c", "#16ffc8", "#ff16c1"]

    def get_color(index)
        if index >= Colors.size
            color = "#" + ("%06x" % (rand * 0xffffff))
        else
            color = Colors[index]
        end
        return color
    end

    def get_dive_data(results)
        # Make datasets for chart.js
        year = results[0]["year"]
        years = [year]
        results.each do |row|
            if row["year"] != year
                years << row["year"]
                year = row["year"]
            end
        end

        datasets = []
        years = years.reverse
        for i in years do
            year_set = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            results.each do |row|
                if row["year"] == i
                    year_set[row["month"]-1] = row["count"]
                end
            end
            datasets << year_set
        end
        
        # At this point, datasets is two-dimensional array
        # Each internal array includes the data for each year
        # [[1, 2, 3, 4, 5,... ], [1, 2, 3, ...]] 
        # First array is 2012, months 1-12, second array is 2013, etc.

        # Generate the data blocks
        datablocks = [];
        years_index = 0;
        for i in datasets do
            block = {}
            block["data"] = i
            block["label"] = years[years_index].to_s
            block["borderColor"] = get_color(years_index);
            block["fill"] = false
            datablocks << block
            years_index += 1
        end
        puts datablocks
        return datablocks
    end

    # Process custom query data for graphs, products only
    def custom_prod(results)
        # Get years for the x-axis labels
        year = results[0]["year"]
        years = [year]
        results.each do |row|
            years |= [row["year"]]
        end
        x_axis = years.reverse.collect{|i| i.to_s}

        # Get product labels
        products = []
        results.each do |row|
            # Uniquely appends each product type
            products |= [row["product"]]
        end

        # Get empty array with enough room for each unique year
        year_set = []
        for x in x_axis do
            year_set << 0
        end

        datasets = []
        for i in products do
            ind = 0
            data = []
            data += year_set
            results.each do |row|
                if row["product"] == i
                    while (ind < years.size-1 && row["year"] != years[ind])
                        data[ind] = 0
                        ind += 1
                    end
                    if row["year"] == years[ind]
                        # Convert to float to prevent "BigDecimal" values
                        # BigDecimals aren't accepted by Chart.js
                        data[ind] = row["monthly_average"].to_f
                    end
                    ind += 1
                end
            end
            datasets << data.reverse
        end
        
        # At this point, datasets is two-dimensional array
        # Each internal array includes the data for each product
        # [[1, 2, 3,...], [1, 2, 3,...]] 
        # First array is Product A, years 1, 2, 3,...; second array is Product B, etc.

        # Generate the data blocks
        datablocks = [];
        products_index = 0;
        for i in datasets do
            block = {}
            block["data"] = i
            block["label"] = products[products_index]
            block["borderColor"] = get_color(products_index)
            block["fill"] = false
            block["x_axis"] = x_axis
            datablocks << block
            products_index += 1
        end
        puts datablocks
        return datablocks
    end


    # Process custom query data for graphs, products only (with date selection)
    def custom_prod_dated(results)
        # Get months and years for x-axis labels
        labels = []
        results.each do |row|
            month = row["month"]
            year = row["year"]
            label = month.to_s + "/" + year.to_s[-2..-1]
            labels |= [label]
        end

        # Get product labels
        products = []
        results.each do |row|
            # Uniquely appends each product type
            products |= [row["product"]]
        end

        # Get empty array with enough room for each unique month/year
        date_set = []
        for x in labels do
            date_set << 0
        end

        datasets = []
        for i in products do
            ind = 0
            data = []
            data += date_set
            results.each do |row|
                if row["product"] == i
                    # While month or year are not the same (and still in range of labels)
                    while (ind < labels.size-1 &&
                        (row["year"].to_s[-2..-1] != labels[ind][-2..-1] ||
                        row["month"].to_s != labels[ind].split("/")[0]))
                            data[ind] = 0
                            ind += 1
                    end
                    if (row["year"].to_s[-2..-1] == labels[ind][-2..-1] &&
                        row["month"].to_s == labels[ind].split("/")[0])
                            data[ind] = row["month_count"]
                    end
                    ind += 1
                end
            end
            datasets << data.reverse
        end
        # Put labels in chronological order
        labels = labels.reverse

        # At this point, datasets is two-dimensional array
        # Each internal array includes the data for each product
        # [[1, 2, 3,...], [1, 2, 3,...]] 
        # First array is Product A, month/year combination 1, 2, 3,...;
        # Second array is Product B, etc.
        
        # Generate the data blocks
        datablocks = [];
        products_index = 0;
        for i in datasets do
            block = {}
            block["data"] = i
            block["label"] = products[products_index]
            block["borderColor"] = get_color(products_index)
            block["fill"] = false
            block["x_axis"] = labels
            datablocks << block
            products_index += 1
        end
        puts datablocks
        return datablocks
    end

    def get_data_grouped_by_year(results, attr) 
        years = []

        results.reverse.each do |row|
            years |= [row["year"]]
        end
        
        companies = {}

        results.each do |row|
            if (companies[row["name"]] == NIL)
                companies[row["name"]] = Array.new(years.length, 0)
            end
            companies[row["name"]][row["year"]-years[0]] = row[attr]
        end

        datablocks = []
        companies.keys.each_with_index do |key, i| 
            block = {}
            block["data"] = companies[key]
            block["x_axis"] = years
            block["label"] = key
            block["borderColor"] = get_color(i)
            datablocks << block

        end
        return datablocks
    end


    # Process custom query data for graphs, companies only
    def custom_comp(results)
        # Get years for the x-axis labels
        year = results[0]["year"]
        years = [year]
        results.each do |row|
            if row["year"] != year
                years << row["year"]
                year = row["year"]
            end
        end
        x_axis = years.reverse.collect{|i| i.to_s}

        # Get company labels
        companies = []
        results.each do |row|
            # Uniquely appends each company name
            companies |= [row["name"]]
        end

        # Get empty array with enough room for each unique year
        year_set = []
        for x in x_axis do
            year_set << 0
        end

        datasets = []
        for i in companies do
            ind = 0
            data = []
            data += year_set
            results.each do |row|
                if row["name"] == i
                    while (ind < years.size-1 && row["year"] != years[ind])
                        data[ind] = 0
                        ind += 1
                    end
                    if row["year"] == years[ind]
                        # Convert to float to prevent "BigDecimal" values
                        # BigDecimals aren't accepted by Chart.js
                        data[ind] = row["monthly_average"].to_f
                    end
                    ind += 1
                end
            end
            datasets << data.reverse
        end
        
        # At this point, datasets is two-dimensional array
        # Each internal array includes the data for each company
        # [[1, 2, 3,...], [1, 2, 3,...]] 
        # First array is Company A, years 1, 2, 3,...; second array is Company B, etc.

        # Generate the data blocks
        datablocks = [];
        companies_index = 0;
        for i in datasets do
            block = {}
            block["data"] = i
            block["label"] = companies[companies_index]
            block["borderColor"] = get_color(companies_index)
            block["fill"] = false
            block["x_axis"] = x_axis
            datablocks << block
            companies_index += 1
        end
        puts datablocks
        return datablocks
    end

    # Process custom query data for graphs, companies only (with date selection)
    def custom_comp_dated(results)
        # Get months and years for x-axis labels
        labels = []
        results.each do |row|
            month = row["month"]
            year = row["year"]
            label = month.to_s + "/" + year.to_s[-2..-1]
            labels |= [label]
        end

        # Get company labels
        companies = []
        results.each do |row|
            # Uniquely appends each company name
            companies |= [row["name"]]
        end

        # Get empty array with enough room for each unique month/year
        date_set = []
        for x in labels do
            date_set << 0
        end

        datasets = []
        for i in companies do
            ind = 0
            data = []
            data += date_set
            results.each do |row|
                if row["name"] == i
                    # While month or year are not the same (and still in range of labels)
                    while (ind < labels.size-1 &&
                        (row["year"].to_s[-2..-1] != labels[ind][-2..-1] ||
                        row["month"].to_s != labels[ind].split("/")[0]))
                            data[ind] = 0
                            ind += 1
                    end
                    if (row["year"].to_s[-2..-1] == labels[ind][-2..-1] &&
                        row["month"].to_s == labels[ind].split("/")[0])
                            data[ind] = row["month_count"]
                    end
                    ind += 1
                end
            end
            datasets << data.reverse
        end
        # Put labels in chronological order
        labels = labels.reverse

        # At this point, datasets is two-dimensional array
        # Each internal array includes the data for each company
        # [[1, 2, 3,...], [1, 2, 3,...]] 
        # First array is Company A, month/year combination 1, 2, 3,...;
        # Second array is Company B, etc.
        
        # Generate the data blocks
        datablocks = [];
        companies_index = 0;
        for i in datasets do
            block = {}
            block["data"] = i
            block["label"] = companies[companies_index]
            block["borderColor"] = get_color(companies_index)
            block["fill"] = false
            block["x_axis"] = labels
            datablocks << block
            companies_index += 1
        end
        puts datablocks
        return datablocks
    end

end
