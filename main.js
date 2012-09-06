$(document).ready(function () {
    function setCurrentTime() {
        var date = new Date();
        $('#now').html(date.toTimeString().substring(0, 8));
        var now = date.getTime();
        $('#millis').html(now);
        $('tr').each(function () {
            var millis = $(this).children('td.millis').html();
            $(this).children('td.countdown').html(millis - now);
        });
    }

    function success(data) {
        $('#name').html(data.name);
        $('#updated').html(data.updated);
        setCurrentTime();

        for (var i = 0; i < data.departures.length; i++) {
            $('#departures').append(createTableRow(data.departures[i]));
        }

        setInterval(setCurrentTime, 1000);

        function createTableRow(departure) {
            var row = $('<tr />');

            row.append(createTableCell().text(departure.time));
            row.append(createTableCell().text(departure.absolute));
            row.append(createTableCell().text(departure.relative));
            row.append(createTableCell().text(departure.millis).addClass('millis'));
            row.append(createTableCell().text(departure.millis).addClass('countdown'));
            row.append(createTableCell().text(departure.destination));

            return row;

            function createTableCell() {
                return $('<td />');
            }
        }
    }

    function error(jqXHR, textStatus, errorThrown) {
        $('#updated').html(textStatus);
        $('#name').html(errorThrown);
    }

    $.ajax({
        url:'json.jsp',
        dataType:'json',
        success:success,
        error:error
    });

    $('#name').html('laddar...');

    setCurrentTime();
});
