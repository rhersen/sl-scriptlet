<%@page contentType="text/html;charset=UTF-8" %>
<%@page pageEncoding="UTF-8" %>
<%@ page session="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-type" content="text/html;charset=ISO-8859-1"/>
    <meta name="HandheldFriendly" content="true"/>
    <title>sl-scriptlet</title>
    <meta name="layout" content="main"/>
    <script type="text/javascript" src="jquery.js"></script>
    <style type="text/css">
        body {
            background: #ccc;
        }

        table {
            border-width: 5px;
            border-style: outset;
            border-spacing: 10px;
        }

        td, th {
            border: 2px inset;
        }
    </style>
</head>
<body>

<table id="departures">
    <tr>
        <th ></th>
        <th id="updated">updated</th>
        <th id="now"></th>
        <th id="millis"></th>
        <th id="name">name</th>
    </tr>
</table>

<script type="text/javascript">
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
            url: 'json.jsp',
            dataType: 'json',
            success: success,
            error: error
        });

        $('#name').html('laddar...');

        setCurrentTime();
    });
</script>

</body>
</html>
