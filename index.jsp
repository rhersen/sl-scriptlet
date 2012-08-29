<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.*" %>
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
        Departures departures1 = readDepartures();
    %>
    <div>
        <%=departures1%>
    </div>
    <%
    for (Departure departure : departures1) {
    %>
    <li>
        <%=departure%>
    </li>
    <% } %>
</ol>

</body>
</html>
<%!
    private final Pattern tr = Pattern.compile("<tr[^>]*>.*?</tr>");
    private final Pattern td = Pattern.compile("<td[^>]*>(.*?)</td>");
    private final Pattern updated = Pattern.compile("Uppdaterat kl ([0-9:]+)");
    private final Pattern name = Pattern.compile("Pendeltåg, (.+)");

    private Departures readDepartures() throws IOException {
        BufferedReader in = new BufferedReader(getReader());
        Departures departures = readDepartures(in);
        in.close();
        return departures;
    }

    private InputStreamReader getReader() throws IOException {
        URL station = new URL("http://mobilrt.sl.se/?tt=TRAIN&ls=&SiteId=9525");
        return new InputStreamReader(station.openStream());
    }

    private Departures readDepartures(BufferedReader in) throws IOException {
        List<String> lines = readLines(in);
        return new Departures(getDepartureList(lines), findMatch(lines, updated), findMatch(lines, name));
    }

    private List<String> readLines(BufferedReader in) throws IOException {
        String line;
        List<String> lines = new ArrayList<String>();

        while ((line = in.readLine()) != null) {
            lines.add(line);
        }
        return lines;
    }

    private List<Departure> getDepartureList(List<String> lines) {
        List<Departure> r = new ArrayList<Departure>();
        for (String line : lines) {
            Matcher trm = tr.matcher(line);
            while (trm.find()) {
                r.add(createDeparture(td.matcher(trm.group())));
            }
        }
        return r;
    }

    private Departure createDeparture(Matcher tdm) {
        List<String> tdl = new ArrayList<String>();

        while (tdm.find()) {
            tdl.add(tdm.group(1));
        }

        return new Departure(tdl.get(1), tdl.get(3));
    }

    private String findMatch(List<String> lines, Pattern pattern) {
        for (String line : lines) {
            String r = match(line, pattern);

            if (r != null) {
                return r;
            }
        }

        return null;
    }

    private String match(String line, Pattern pattern) {
        Matcher matcher = pattern.matcher(line);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    class Departures implements Iterable<Departure> {
        private final Collection<Departure> departures;
        private final String updated;
        public final String name;

        Departures(Collection<Departure> departures, String updated, String name) {
            this.departures = departures;
            this.updated = updated;
            this.name = name;
        }

        public Iterator<Departure> iterator() {
            return departures.iterator();
        }

        public String toString() {
            return "Departures{" +
                    "departures=" + departures +
                    ", updated='" + updated + '\'' +
                    ", name='" + name + '\'' +
                    '}';
        }
    }

    class Departure {
        private final String destination;
        private final String time;

        public Departure(String destination, String time) {
            this.destination = destination;
            this.time = time;
        }

        public String toString() {
            return "Departure{" +
                    "destination='" + destination + '\'' +
                    ", time='" + time + '\'' +
                    '}';
        }
    }
%>
