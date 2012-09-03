$(document).ready(function () {
    function setCurrentTime() {
        var now = new Date();
        $('#now').html(now.toTimeString().substring(0, 8));
        $('#millis').html(now.getTime());
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
                '<td>' + data.departures[i].millis + '</td>' +
                '<td>' + data.departures[i].destination + '</td>' +
                '</tr>');
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
