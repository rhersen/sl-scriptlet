<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>Jasmine Spec Runner</title>
    <script type="text/javascript" src="jquery.js"></script>

    <link rel="stylesheet" type="text/css" href="lib/jasmine-1.2.0/jasmine.css">
    <script type="text/javascript" src="lib/jasmine-1.2.0/jasmine.js"></script>
  <script type="text/javascript" src="lib/jasmine-1.2.0/jasmine-html.js"></script>

  <script type="text/javascript" src="js-tests.js"></script>

  <script type="text/javascript" src="index.js"></script>

  <script type="text/javascript" src="test.js"></script>

  <script type="text/javascript">
    (function() {
      var jasmineEnv = jasmine.getEnv();
      jasmineEnv.updateInterval = 1000;

      var htmlReporter = new jasmine.HtmlReporter();

      jasmineEnv.addReporter(htmlReporter);

      jasmineEnv.specFilter = function(spec) {
        return htmlReporter.specFilter(spec);
      };

      var currentWindowOnload = window.onload;

      window.onload = function() {
        if (currentWindowOnload) {
          currentWindowOnload();
        }
        execJasmine();
      };

      function execJasmine() {
        jasmineEnv.execute();
      }

    })();
  </script>

</head>

<body>
<ol id="failures"></ol>

<div id="status">
    running...
</div>
</body>
</html>
