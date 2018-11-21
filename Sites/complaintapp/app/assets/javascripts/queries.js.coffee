$(document).on "turbolinks:load", -> 

    $('#start_date').datepicker({
        dateFormat: 'mm/dd/yy',
        showOn: 'both',
        changeMonth: true,
        changeYear: true,
        defaultDate: new Date(2011, 12 - 1, 1),
        minDate: new Date(2011, 12 - 1, 1),
        maxDate: new Date(2018, 9 - 1, 5)
    });

    $('#end_date').datepicker({
        dateFormat: 'mm/dd/yy',
        showOn: 'both',
        changeMonth: true,
        changeYear: true,
        defaultDate: new Date(2018, 9 - 1, 5),
        minDate: new Date(2011, 12 - 1, 1),
        maxDate: new Date(2018, 9 - 1, 5)
    });

