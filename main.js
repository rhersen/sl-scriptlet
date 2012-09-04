$(document).ready(function () {
    function setCurrentTime() {
        var now = new Date();
        $('#now').html(now.toTimeString().substring(0, 8));
        $('#millis').html(now.getTime());
        $('tr').each(function () {
            var millis = $(this).children('td.millis');
            console.log(millis.html());
            $(this).children('td.countdown').html(millis.html() - now.getTime());
        });
    }

    function success(data) {
        $('#name').html(data.name);
        $('#updated').html(data.updated);
        setCurrentTime();
        for (var i = 0; i < data.departures.length; i++) {
            $('#departures').append('<tr>' +
                '<td>' + data.departures[i].time + '</td>' +
                '<td>' + data.departures[i].absolute + '</td>' +
                '<td>' + data.departures[i].relative + '</td>' +
                '<td class="millis">' + data.departures[i].millis + '</td>' +
                '<td class="countdown">' + data.departures[i].millis + '</td>' +
                '<td>' + data.departures[i].destination + '</td>' +
                '</tr>');
        }

        setInterval(setCurrentTime, 1000);
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
