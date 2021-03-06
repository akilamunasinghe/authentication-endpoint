<%--
  ~ Copyright (c) 2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@include file="localize.jsp" %>
<%@include file="init-url.jsp" %>

<%
    String[] profiles = request.getParameterValues("profile");
    String[] claimTags = request.getParameterValues("claimTag");
    String[] claimValues = request.getParameterValues("claimValue");
    String openidreturnto = request.getParameter("openid.return_to");
    String openididentity = request.getParameter("openid.identity");
    if (openidreturnto != null && openidreturnto.indexOf("?") > 0) {
        openidreturnto = openidreturnto.substring(0, openidreturnto.indexOf("?"));
    }
%>

    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%=AuthenticationEndpointUtil.i18n(resourceBundle, "openid2.profile")%></title>

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

        <script type="text/javascript">
            function submitProfileSelection() {
                document.profileSelection.submit();
            }

            function approved() {
                document.getElementById("hasApprovedAlways").value = "false";
                document.profile.submit();
            }

            function approvedAlways() {
                document.getElementById("hasApprovedAlways").value = "true";
                document.profile.submit();
            }
        </script>

    </head>

    <body onload="setCookieByParam();">

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
    <!-- header -->
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

    <div class="container-fluid body-wrapper">

        <div class="row">
            <div class="background-blue col-md-12">

                <!-- content -->
                <div class="container col-xs-12 col-sm-10 col-md-7 col-lg-5 ol-centered wr-content wr-login col-centered">

                    <div class="boarder-all ">
                        <div>
                            <h2 class="section__title_joule wr-title uppercase padding-double white margin-none">
                                <%=AuthenticationEndpointUtil.i18n(resourceBundle, "openid.user.claims")%>
                            </h2>
                        </div>
                        <div class="clearfix"></div>

                        <div class="padding-double login-form">
                            <div>
                                <form action="<%=openidServerURL%>" id="profile" name="profile" class="form-horizontal">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 control-group">
                                        <div class="controls" style="margin-left: 0px !important;">

                                            <%
                                                if (claimTags != null && claimTags.length > 0) { %>
                                            <table class="table table-striped table-bordered">
                                                <tr>
                                                    <th><%=AuthenticationEndpointUtil.i18n(resourceBundle,
                                                            "claim.uri")%></th>
                                                    <th><%=AuthenticationEndpointUtil.i18n(resourceBundle,
                                                            "claim.value")%></th>
                                                </tr>
                                                <%
                                                    for (int i = 0; i < claimTags.length; i++) {
                                                        String claimTag = claimTags[i];
                                                        if ("MultiAttributeSeparator" .equals(claimTag)) {
                                                            continue;
                                                        }
                                                %>
                                                <tr>
                                                    <td><%=Encode.forHtmlContent(claimTag)%>
                                                    </td>
                                                    <td><%=Encode.forHtmlContent(claimValues[i])%>
                                                    </td>
                                                </tr>
                                                <%
                                                    } %>
                                            </table>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>

                                    <div style="text-align:left;">
                                        <input type="button" class="btn  btn-primary" id="approve" name="approve"
                                               onclick="javascript: approved(); return false;"
                                               value="<%=AuthenticationEndpointUtil.i18n(resourceBundle,
                                                    "approve")%>"/>
                                        <input type="button" class="btn" id="chkApprovedAlways"
                                               onclick="javascript: approvedAlways();"
                                               value="<%=AuthenticationEndpointUtil.i18n(resourceBundle,
                                                    "approve.always")%>"/>
                                        <input type="hidden" id="hasApprovedAlways" name="hasApprovedAlways"
                                               value="false"/>
                                        <input class="btn" type="reset"
                                               value="<%=AuthenticationEndpointUtil.i18n(resourceBundle,"cancel")%>"
                                               onclick="javascript:document.location.href='<%=Encode.forJavaScript(openidreturnto)%>'"/>
                                    </div>
                                </form>

                            </div>
                            <div class="clearfix"></div>
                        </div>

                    </div>
                </div>
                <!-- /content -->

            </div>
        </div>
        <!-- /content/body -->

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
<%--        <div class="container-fluid">--%>
<%--            <p><%=AuthenticationEndpointUtil.i18n(resourceBundle, "wso2.identity.server")%> | &copy;--%>
<%--                <script>document.write(new Date().getFullYear());</script>--%>
<%--                <a href="<%=AuthenticationEndpointUtil.i18n(resourceBundle, "business.homepage")%>" target="_blank"><i class="icon fw fw-wso2"></i>--%>
<%--                    <%=AuthenticationEndpointUtil.i18n(resourceBundle, "inc")%>--%>
<%--                </a>. <%=AuthenticationEndpointUtil.i18n(resourceBundle, "all.rights.reserved")%>--%>
<%--            </p>--%>
<%--        </div>--%>
    </footer>

    <script src="libs/jquery_1.11.3/jquery-1.11.3.js"></script>
    <script src="libs/bootstrap_3.3.5/js/bootstrap.min.js"></script>
    </body>
    </html>
