<%
    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(request.getServletContext());
    RuleServicePublisher ruleServicePublisher = context.getBean("ruleServicePublisher", RuleServicePublisher.class);
    String services = new ObjectMapper().writeValueAsString(PublisherUtils.getServicesInfo(ruleServicePublisher));
%>
<%@ page import="org.openl.rules.ruleservice.servlet.PublisherUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.openl.rules.ruleservice.publish.RuleServicePublisher" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>OpenL Tablets Web Services</title>
    <base href="${pageContext.request.contextPath}/"/>
    <style>
        body {
            margin: 0;
            color: #444;
            font-family: verdana, helvetica, arial, sans-serif;
            font-size: 12px;
        }

        h2 {
            font-weight: normal;
            font-size: 16px;
            color: #28b;
            margin: 29px 0 16px;
        }

        h3 {
            font-weight: normal;
            font-size: 14px;
            display: inline;
        }

        a {
            color: #0078D0;
            margin-right: 10px;
        }

        #header {
            border-bottom: 1px solid #ccc;
            font-family: georgia, verdana, helvetica, arial, sans-serif;
            font-size: 20px;
            color: #777;
            padding: 11px 15px;
        }

        #main {
            padding: 0 20px 40px;
            color: #444;
            white-space: nowrap;
        }

        #footer {
            border-top: 1px solid #ccc;
            font-size: 11px;
            color: #666;
            padding: 11px;
            text-align: center;
            background: #fff;
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
        }

        #footer a {
            color: #666;
            text-decoration: none;
        }

        .note {
            color: #9a9a9a;
            font-size: 10px;
            margin: 3px 0;
        }

        #main > div {
            border-bottom: #cccccc dotted 1px;
            padding: 10px 0;

        }

        #main > div:last-child {
            border: 0;
        }

        .expand-button, .collapse-button {
            margin: 0;
            cursor: pointer;
            width: 16px;
            height: 16px;
            display: inline-block;
            vertical-align: bottom;
        }

        .expand-button {
            background: url('data:image/gif;base64,R0lGODlhCQAJAOMOAAAAAN/c1enn4+vp5e3r5+/t6vDv7PLx7vTz8fb18/j39fn5+Pv7+v39/P///////yH5BAEKAA8ALAAAAAAJAAkAAAQmMMhJXWNLJSTvAtshYQqAHIb0ASxQSBoCGAUhhS4xSCetC5RgIAIAOw==') no-repeat center;
        }

        .collapse-button {
            background: url('data:image/gif;base64,R0lGODlhCQAJAOMOAAAAAN/c1enn4+vp5e3r5+/t6vDv7PLx7vTz8fb18/j39fn5+Pv7+v39/P///////yH5BAEKAA8ALAAAAAAJAAkAAAQjMMhJXWNLJSRv3oeEachhSAugqoVEmgUhgUY8SGVNDALlBxEAOw==') no-repeat center;
        }

        .methods {
            margin-top: 2px;
            display: none;
        }

        .methods > li {
            margin-top: 2px;
            font-size: 11px;
        }

        .collapse-button ~ .methods {
            display: block;
        }
    </style>
</head>

<body>
<div id="header">OpenL Tablets Web Services</div>
<div id="main"></div>
<div id="footer">&#169; 2018 <a href="http://openl-tablets.org" target="_blank">OpenL Tablets</a></div>
<script>
    // Get JSON of available services
    var services = <%= services %>;

    // The block for rendering of the available services
    var mainBlock = document.getElementById("main");

    if (Array.isArray(services) && services.length > 0) {
        mainBlock.innerHTML = "<h2>Available services:</h2>";
        services.forEach(function (service) {
            var html = createServiceHtml(service);
            var el = document.createElement("DIV");
            el.innerHTML = html;
            mainBlock.appendChild(el);
        });
        mainBlock.addEventListener('click', function (event) {
            var button = event.target || event.srcElement;
            if (button.className == "expand-button") {
                // Expand the node
                button.className = "collapse-button";
            } else if (button.className == "collapse-button") {
                // Collapse the node
                button.className = "expand-button";
            }
        })
    } else {
        mainBlock.innerHTML = "<h2>There are no available services</h2>";
    }

    // Creating innerHTML of one service
    function createServiceHtml(service) {
        var html = "";
        // Name
        html += "<span class='expand-button'></span><h3>" + service.name + "</h3>";

        // Methods
        html += "<ul class='methods'>";
        service.methodNames.forEach(function (methodName) {
            html += "<li>" + methodName + "</li>";
        })
        html += "</ul>";

        // Date and time
        html += "<div class='note'>Started time: " + new Date(service.startedTime).toLocaleString() + "</div>";
        // URLs
        var urls = service.urls;
        Object.keys(urls).forEach(function (name) {
            var url = urls[name];
            if (name == "SOAP") {
                html += "<a href='" + url + "?wsdl'\>WSDL</a>";
            } else if (name == "REST") {
                html += "<a href='" + url + "?_wadl'\>WADL</a>";
                html += "<a href='" + url + "/api-docs/index.html?url=../swagger.json'\>Swagger (UI)</a>";
                html += "<a href='" + url + "/swagger.json'\>Swagger (JSON)</a>";
                html += "<a href='" + url + "/swagger.yaml'\>Swagger (YAML)</a>";
            } else {
                html += "<a href='" + url + "'\>" + name + "</a>";
            }
        });
        return html;
    }
</script>
</body>
</html>
