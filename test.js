$(document).ready(function () {
    function success(data) {
        for (var i = 0; i < data.failures.length; i++) {
            $('ol#failures').append($('<li />').text(data.failures[i]));
        }

        $('#status').text('Java tests done.');
    }

    function error(jqXHR, textStatus, errorThrown) {
        $('#status').html(textStatus);
    }

    $.ajax({
        url:'json.jsp?test',
        dataType:'json',
        success:success,
        error:error
    });
});
