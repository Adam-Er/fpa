$(document).on "turbolinks:load", -> 

    $('#start_date').datepicker({
        dateFormat: 'mm/dd/yy',
        showOn: 'both',
        changeMonth: true,
        changeYear: true,
        defaultDate: new Date(2011, 12 - 1, 1),
        minDate: new Date(2011, 12 - 1, 1),
        maxDate: new Date(2018, 9 - 1, 5),
        onSelect: (date) ->
            `var date`
            date_start = $('#start_date').datepicker('getDate')
            date = new Date(Date.parse(date_start))
            date.setDate date.getDate() + 1
            date_lim = date.toDateString()
            date_lim = new Date(Date.parse(date_lim))
            $('#end_date').datepicker 'option', 'minDate', date_lim
            return
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

