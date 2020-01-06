<%--
  ~ Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~ WSO2 Inc. licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file except
  ~ in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied. See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.AuthContextAPIClient" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.Constants" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.TemplateMgtAPIClient" %>
<%@ page import="org.wso2.carbon.identity.core.util.IdentityUtil" %>
<%@ page import="org.wso2.carbon.identity.template.mgt.model.Template" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="localize.jsp" %>
<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>
<jsp:directive.include file="init-url.jsp"/>
<jsp:directive.include file="template-mapper.jsp"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String templateId = request.getParameter("templateId");
    String promptId = request.getParameter("promptId");
    String tenantDomain = request.getParameter("tenantDomain");
    
    String authAPIURL = application.getInitParameter(Constants.AUTHENTICATION_REST_ENDPOINT_URL);
    if (StringUtils.isBlank(authAPIURL)) {
        authAPIURL = IdentityUtil.getServerURL("/api/identity/auth/v1.1/", true, true);
    }
    if (!authAPIURL.endsWith("/")) {
        authAPIURL += "/";
    }
    authAPIURL += "context/" + request.getParameter("promptId");
    String contextProperties = AuthContextAPIClient.getContextProperties(authAPIURL);


    Gson gson = new Gson();
    Map data = gson.fromJson(contextProperties, Map.class);
    String templatePath = templateMap.get(templateId);
%>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=AuthenticationEndpointUtil.i18n(resourceBundle, "wso2.identity.server")%>
    </title>
    <link rel="icon" href="images/favicon.png" type="image/x-icon"/>
    <link href="libs/bootstrap_3.3.5/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/Roboto.css" rel="stylesheet">
    <link href="css/custom-common.css" rel="stylesheet">
    <link href="css/joule-custom.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://use.fontawesome.com/releases/v5.11.2/css/all.css" integrity="sha384-KA6wR/X5RY4zFAHpv/CnoG2UW1uogYfdnP67Uv7eULvTveboZJg0qUpmJZb5VqzN" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.min.css">
    <!--[if lt IE 9]>
    <script src="js/html5shiv.min.js"></script>
    <script src="js/respond.min.js"></script>
    <![endif]-->
</head>
<body onload="setCookieByParam();">
<script type="text/javascript">
    var data = JSON.parse("<%=Encode.forJavaScript(contextProperties)%>");
    var prompt_id = "<%=promptId%>";
</script>

<script>
    function setCookie() {
            var locale = document.getElementById("lnkChangeLanguage").getAttribute("lang");
            document.cookie = "lang=" + locale + "; path=/;";
            location.reload();
        }

        function setCookieByParam() {
            var urlParams = new URLSearchParams(window.location.search);
            var locale = urlParams.get("lang");
            if (locale) {
                document.cookie = "lang=" + locale + "; path=/;";
            }
        }


</script>

<header class="header header-default">
    <div class="header__bar">
        <nav class="align-right horizontal nav nav--utility">
            <ul class="nav__menu nav__menu--social">
                <li class="icon-utility horizontal"><a href="https://twitter.com/CMA_Docs"><i class="icon-color fab fa-twitter" aria-hidden="true"></i><span class="webaim-hidden">on Twitter</span></a></li>
                <li class="icon-utility horizontal"><a href="https://www.linkedin.com/company/canadian-medical-association"><i class="icon-color fab fa-linkedin-in" aria-hidden="true"></i><span class="webaim-hidden">on LinkedIn</span></a></li>
                <li class="icon-utility horizontal"><a href="https://www.instagram.com/cma_docs/"><i class="icon-color fab fa-instagram" aria-hidden="true"></i><span class="webaim-hidden">on Instagram</span></a></li>
                <li class="icon-utility horizontal"><a href="https://www.facebook.com/CanadianMedicalAssociation"><i class="icon-color fab fa-facebook-f" aria-hidden="true"></i><span class="webaim-hidden">on Facebook</span></a></li>
                <li class="icon-utility horizontal"><a href="https://www.youtube.com/user/CanadianMedicalAssoc"><i class="icon-color fab fa-youtube" aria-hidden="true"></i><span class="webaim-hidden">on Youtube</span></a></li>
            </ul>
            <ul class="links nav__menu nav__menu--language">
                <% if (langCode != null && langCode.equals("fr")) { %>
                <li class="horizontal" onclick="setCookie()"><a id="lnkChangeLanguage" lang="en_GB" href="#" class=" icon-color language-link">English</a></li>
                <%} else { %>
                <li class="horizontal" onclick="setCookie()"><a id="lnkChangeLanguage" lang="fr_FR" href="#" class=" icon-color language-link">Français</a></li>
                <% } %>
            </ul>

        </nav>
    </div>
    <div class="container-fluid">
        <div class="pull-left brand float-remove-xs text-center-xs">
            <a href="https://www.cma.ca">
                <img src="images/logo-inverse.png" alt="<%=AuthenticationEndpointUtil.i18n(resourceBundle, "business.name")%>" title="<%=AuthenticationEndpointUtil.i18n(resourceBundle, "business.name")%>" class="logo">
                <%--                <h1><em><%=AuthenticationEndpointUtil.i18n(resourceBundle, "identity.server")%></em></h1>--%>
            </a>
        </div>
    </div>
</header>
<!-- page content -->
<div class="container-fluid body-wrapper">
    
    <div class="row">
        <div class="background-blue col-md-12">
            
            <%
                if (templatePath != null) {
            %>
            <div class="container col-xs-10 col-sm-6 col-md-6 col-lg-4 col-centered wr-content wr-login col-centered">
                            <c:set var="data" value="<%=data%>" scope="request"/>
                            <c:set var="promptId" value="<%=URLEncoder.encode(promptId, StandardCharsets.UTF_8.name())%>"
                            scope="request"/>
                            <jsp:include page="<%=templatePath%>"/>
                        </div>
            
            <%
            } else {
            %>
            <div class="container col-xs-7 col-sm-5 col-md-4 col-lg-3 col-centered wr-content wr-login col-centered">
                <div class="boarder-all">
                    <h2 class="section__title_joule wr-title uppercase padding-double white  margin-none"><%=Encode.forHtmlContent("Incorrect Request")%>
                    </h2>
                    <hr class="hr">
                </div>
                <div class="boarder-all col-lg-12 padding-top-double padding-bottom-double error-alert  ">
                    <div class="font-medium">
                        <strong>
                            <%=AuthenticationEndpointUtil.i18n(resourceBundle, "attention")%> :
                        </strong>
                    </div>
                    <div class="padding-bottom-double">
                        <%=AuthenticationEndpointUtil.i18n(resourceBundle, "no.template.found")%>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        
        </div>
    </div>
</div>

<!-- footer -->
<footer class="footer">
    <div class="grid">
        <div class="col-sm-6">
            <p class="icon-utility"><%=AuthenticationEndpointUtil.i18n(resourceBundle, "copyright.canadian.medical.association")%></p>
        </div>
        <div class="col-sm-6">
            <nav class="nav nav--footer-utility pull-right">

                <ul data-region="utility_footer" class="nav__menu">
                    <% if (langCode != null && langCode.equals("fr")) { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/fr/politiques-de-confidentialite-de-lamc-et-de-ses-filiales"><span class="icon-utility icon-color"><%=AuthenticationEndpointUtil.i18n(resourceBundle, "privacy")%></span></a>
                    </li>
                    <%} else { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/privacy-policies-cma-and-its-subsidiaries"><span class="icon-utility icon-color"><%=AuthenticationEndpointUtil.i18n(resourceBundle, "privacy")%></span></a>
                    </li>
                    <% } %>

                    <% if (langCode != null && langCode.equals("fr")) { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/fr/clauses-et-conditions-legales"><span class="icon-utility icon-color"><%=AuthenticationEndpointUtil.i18n(resourceBundle, "terms.and.conditions")%></span></a>
                    </li>
                    <%} else { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/terms-and-conditions"><span class="icon-utility icon-color"><%=AuthenticationEndpointUtil.i18n(resourceBundle, "terms.and.conditions")%></span></a>
                    </li>
                    <% } %>

                    <% if (langCode != null && langCode.equals("fr")) { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/fr/accessibilite"><span class="icon-utility icon-color"><%=AuthenticationEndpointUtil.i18n(resourceBundle, "accessibility")%></span></a>
                    </li>
                    <%} else { %>
                    <li class="horizontal">
                        <a href="https://www.cma.ca/accessibility"><span class="icon-utility icon-color"><%=AuthenticationEndpointUtil.i18n(resourceBundle, "accessibility")%></span></a>
                    </li>
                    <% } %>

                </ul>
            </nav>
        </div>
    </div>
</footer>

<script src="libs/jquery_1.11.3/jquery-1.11.3.js"></script>
<script src="libs/bootstrap_3.3.5/js/bootstrap.min.js"></script>

</body>
</html>
