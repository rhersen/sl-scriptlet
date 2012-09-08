<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.*" %>
<%@page contentType="application/json;charset=UTF-8" %>
<%@page pageEncoding="UTF-8" %>
<%@ page session="false" %>

<%
    if (request.getParameter("test") == null) {
        Departures d = readDepartures();
%>
{
"name": "<%=d.name%>",
"updated": "<%=d.updated%>",
"departures": [
<%
    for (int i = 0; i < d.elements().size(); i++) {
        Departure departure = d.elements().get(i);
%>
{
"destination": "<%=departure.destination%>",
"time": "<%=departure.time%>",
"absolute": "<%=departure.getAbsolute(d.updated)%>",
"relative": "<%=departure.getRelative(d.updated)%> min",
"millis": "<%=System.currentTimeMillis() + ONE_MINUTE * departure.getRelative(d.updated)%>"
}
<% if (i < d.elements().size() - 1) { %>
,
<% }
} %>
]
}
<% } else { %>
{
"failures":
[
<%
    boolean comma = false;
    for (String failure : getTestFailures()) {
        if (comma) {
%>
    ,
<%
    } else {
        comma = true;
    }
%>
    "<%= failure %>"
<%
    }
%>
]
}
<% } %>

<%! public static final int ONE_MINUTE = 60000;

    private Iterable<String> getTestFailures() {
        Collection<String> failures = new ArrayList<String>();
        if (!getDepartureList(Collections.<String>emptyList()).isEmpty()) {
            failures.add("getDepartureList not empty");
        }

        return failures;
    }

    private final Pattern tr = Pattern.compile("<tr[^>]*>.*?</tr>");
    private final Pattern td = Pattern.compile("<td[^>]*>(.*?)</td>");
    private final Pattern updated = Pattern.compile("Uppdaterat kl ([0-9:]+)");
    private final Pattern name = Pattern.compile("Pendeltåg, (.+)");
    private final Pattern relative = Pattern.compile("([0-9]+) min");
    private final Pattern absolute = Pattern.compile("([0-9]+):([0-9]+)");

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

    private List<Departure> getDepartureList(Iterable<String> lines) {
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

    private String findMatch(Iterable<String> lines, Pattern pattern) {
        for (String line : lines) {
            String r = match(line, pattern);

            if (r != null) {
                return r;
            }
        }

        return null;
    }

    private String match(CharSequence line, Pattern pattern) {
        Matcher matcher = pattern.matcher(line);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    class Departures {
        private final List<Departure> departures;
        private final String updated;
        public final String name;

        Departures(Collection<Departure> departures, String updated, String name) {
            this.departures = new ArrayList<Departure>(departures);
            this.updated = updated;
            this.name = name;
        }

        public List<Departure> elements() {
            return departures;
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
        public static final int ONE_HOUR = 60;
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

        public String getAbsolute(CharSequence updated) {
            Matcher rel = relative.matcher(time);
            if (!rel.matches()) {
                return time;
            }

            Matcher abs = absolute.matcher(updated);
            if (!abs.matches()) {
                return "?";
            }

            int hour = Integer.valueOf(abs.group(1));
            int minute = Integer.valueOf(abs.group(2)) + Integer.valueOf(rel.group(1));
            return hour + ":" + minute;
        }

        public int getRelative(CharSequence updated) {
            if (time.equals("Nu")) {
                return 0;
            }

            Matcher abs = absolute.matcher(time);
            if (!abs.matches()) {
                Matcher rel = relative.matcher(time);
                if (!rel.matches()) {
                    return -1;
                } else {
                    return Integer.valueOf(rel.group(1));
                }
            }

            Matcher now = absolute.matcher(updated);
            if (!now.matches()) {
                return -1;
            }

            int r = Integer.valueOf(abs.group(2)) - Integer.valueOf(now.group(2));
            if (r < 0) {
                r += ONE_HOUR;
            }

            return r;
        }

    }
%>
