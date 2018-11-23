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

    Company_query_1 = "select Ranking, name, mnth as Month, cnt as mnth_cnt, yr as Year, yr_total, mnthly_avg from 
    (select Rownumber as Ranking, name, mnth, yr, cnt from 
        (select Row_Number() over (partition by yr, mnth order by cnt desc) 
         as Rownumber, name, mnth, yr, cnt from 
            (select name,  extract(month from date_received) as mnth, extract(year from date_received) as yr, count(*) as cnt from 
            "
    
    Company_query_2 = "
            where not (date_received < to_date('01/01/2012', 'MM/DD/YYYY') or date_received > to_date('08/31/2018', 'MM/DD/YYYY'))
            group by name, extract(year from date_received), extract(month from date_received) 
            order by extract(year from date_received) desc, mnth, count(*) desc) 
         order by yr desc, mnth) 
    where Rownumber < 6) 
    natural join 
    ((select name, yr, yr_total, round(yr_total/12, 1) as mnthly_avg from 
        (select 
            extract(year from date_received) as yr, name, count(*) as yr_total, 
            count(distinct extract(month from date_received)) as mnths 
        from
        " 

    Company_query_3 = "
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

    Company_query_4 ="
        where not (date_received < to_date('01/01/2018', 'MM/DD/YYYY') or date_received > to_date('08/31/2018', 'MM/DD/YYYY'))
        group by extract(year from date_received), name 
        order by extract(year from date_received) desc, count(*) desc))) 
        order by yr desc, mnth desc, cnt desc
        " 

end