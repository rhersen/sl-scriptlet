<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.ArrayDeque" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collection" %>
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
</head>
<body>

<ol>
    <%
        for (Departure departure : readDepartures()) {
    %>
    <li>
        <%=departure%>
    </li>
    <%
        }
    %>
</ol>

</body>
</html>
<%!
    private final Pattern tr = Pattern.compile("<tr[^>]*>.*?</tr>");
    private final Pattern td = Pattern.compile("<td[^>]*>(.*?)</td>");

    private Iterable<Departure> readDepartures() throws IOException {
        BufferedReader in = new BufferedReader(getReader());
        Iterable<Departure> departures = readDepartures(in);
        in.close();
        return departures;
    }

    private InputStreamReader getReader() throws IOException {
        URL station = new URL("http://mobilrt.sl.se/?tt=TRAIN&ls=&SiteId=9525");
        return new InputStreamReader(station.openStream());
    }

    private Collection<Departure> readDepartures(BufferedReader in) throws IOException {
        String line;
        Collection<Departure> departures = new ArrayDeque<Departure>();

        while ((line = in.readLine()) != null) {
            add(departures, tr.matcher(line));
        }

        return departures;
    }

    private void add(Collection<Departure> departures, Matcher trm) {
        while (trm.find()) {
            departures.add(createDeparture(td.matcher(trm.group())));
        }
    }

    private Departure createDeparture(Matcher tdm) {
        List<String> tdl = new ArrayList<String>();

        while (tdm.find()) {
            tdl.add(tdm.group(1));
        }

        return new Departure(tdl.get(1), tdl.get(3));
    }

    static class Departure {
        private final String destination;
        private final String time;

        public Departure(String destination, String time) {
            this.destination = destination;
            this.time = time;
        }

        @Override
        public String toString() {
            return "Departure{" +
                    "destination='" + destination + '\'' +
                    ", time='" + time + '\'' +
                    '}';
        }
    }
%>
