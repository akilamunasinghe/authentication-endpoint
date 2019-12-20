<!--
* Copyright (c) 2015, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
* WSO2 Inc. licenses this file to you under the Apache License,
* Version 2.0 (the "License"); you may not use this file except
* in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied. See the License for the
* specific language governing permissions and limitations
* under the License.
-->

<%@ page import="org.owasp.encoder.Encode" %>
<%@ page
        import="org.wso2.carbon.identity.application.authentication.endpoint.util.UserRegistrationAdminServiceClient" %>
<%@ page import="org.wso2.carbon.identity.user.registration.stub.dto.UserFieldDTO" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.Constants" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="localize.jsp" %>

<%
    String errorCode = request.getParameter("errorCode");
    String failedPrevious = request.getParameter("failedPrevious");

    UserRegistrationAdminServiceClient registrationClient = new UserRegistrationAdminServiceClient();
    UserFieldDTO[] userFields = new UserFieldDTO[0];
    List<UserFieldDTO> fields = new ArrayList<UserFieldDTO>();

    boolean isFirstNameInClaims = false;
    boolean isFirstNameRequired = false;
    boolean isLastNameInClaims = false;
    boolean isLastNameRequired = false;
    boolean isEmailInClaims = false;
    boolean isEmailRequired = false;

    try {
        userFields = registrationClient
                .readUserFieldsForUserRegistration(Constants.UserRegistrationConstants.WSO2_DIALECT);
        for(UserFieldDTO userFieldDTO : userFields) {
            if (StringUtils.equals(userFieldDTO.getFieldName(), Constants.UserRegistrationConstants.FIRST_NAME)) {
                isFirstNameInClaims = true;
                isFirstNameRequired = userFieldDTO.getRequired();
                fields.add(userFieldDTO);
            }
            if (StringUtils.equals(userFieldDTO.getFieldName(), Constants.UserRegistrationConstants.LAST_NAME)) {
                isLastNameInClaims = true;
                isLastNameRequired = userFieldDTO.getRequired();
                fields.add(userFieldDTO);
            }
            if (StringUtils.equals(userFieldDTO.getFieldName(), Constants.UserRegistrationConstants.EMAIL_ADDRESS)) {
                isEmailInClaims = true;
                isEmailRequired = userFieldDTO.getRequired();
                fields.add(userFieldDTO);
            }
        }
    } catch (Exception e) {
        failedPrevious = "true";
        errorCode = e.getMessage();
    }
%>
    <html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%=AuthenticationEndpointUtil.i18n(resourceBundle, "wso2.identity.server")%></title>

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

    <script>
        function setCookie() {
            var locale = document.getElementById("lnkChangeLanguage").getAttribute("lang");
            document.cookie = "lang=" + locale + "; path=/;";
            location.reload();
        }

        function setCookieByParam() {
            var urlParams = new URLSearchParams(window.location.search);
            var locale = urlParams.get("lang");
            document.cookie = "lang=" + locale + "; path=/;";
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

<%--                    <h1><em><%=AuthenticationEndpointUtil.i18n(resourceBundle, "identity.server")%> </em></h1>--%>
                </a>
            </div>
        </div>
    </header>

    <!-- page content -->
    <div class="container-fluid body-wrapper">

        <div class="row">
            <!-- content -->
            <div class="background-blue col-xs-12 col-sm-10 col-md-8 col-lg-5 col-centered wr-login">
                <form action="../registration.do" method="post" id="register">
                    <h2 class="section__title_joule wr-title uppercase padding-double white margin-none">
                        <%=AuthenticationEndpointUtil.i18n(resourceBundle, "create.an.account")%>
                    </h2>
                    <hr class="hr">
                    <div class="clearfix"></div>
                    <div class="boarder-all ">

                        <% if (failedPrevious != null && failedPrevious.equals("true")) { %>
                            <div class="alert alert-danger" id="server-error-msg">
                                <%= Encode.forHtmlContent(errorCode) %>
                            </div>
                        <% } %>

                        <div class="alert alert-danger" id="error-msg" hidden="hidden">
                        </div>

                        <div class="padding-double font-large">
                            <%=AuthenticationEndpointUtil.i18n(resourceBundle,
                                    "enter.required.fields.to.complete.registration")%>
                        </div>
                        <!-- validation -->
                        <div class="padding-double">
                            <div id="regFormError" class="alert alert-danger" style="display:none"></div>
                            <div id="regFormSuc" class="alert alert-success" style="display:none"></div>

                            <% if(isFirstNameInClaims) { %>
                            <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6 form-group required">
                                <label class="control-label">
                                    <%=AuthenticationEndpointUtil.i18n(resourceBundle, "first.name")%>
                                </label>
                                <input type="text" name="First Name"
                                       data-claim-uri="http://wso2.org/claims/givenname"
                                       class="form-control"
                                       <% if (isFirstNameRequired) {%> required <%}%>>
                            </div>
                            <%}%>

                            <% if(isLastNameInClaims) { %>
                            <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6 form-group required">
                                <label class="control-label">
                                    <%=AuthenticationEndpointUtil.i18n(resourceBundle, "last.name")%>
                                </label>
                                <input type="text" name="Last Name" data-claim-uri="http://wso2.org/claims/lastname"
                                       class="form-control  required null"
                                       <% if (isLastNameRequired) {%> required <%}%>>
                            </div>
                            <%}%>

                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group required">
                                <label class="control-label"><%=AuthenticationEndpointUtil.i18n(resourceBundle,
                                        "username")%></label>
                                <input id="reg-username" name="reg_username" type="text"
                                       class="form-control required usrName usrNameLength" required>
                            </div>

                            <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6 form-group required">
                                <label class="control-label"><%=AuthenticationEndpointUtil.i18n(resourceBundle,
                                        "password")%></label>
                                <input id="reg-password" name="reg_password" type="password"
                                       class="form-control" required>
                            </div>

                            <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6 form-group required">
                                <label class="control-label"><%=AuthenticationEndpointUtil.i18n(resourceBundle,
                                        "confirm.password")%></label>
                                <input id="reg-password2" name="reg-password2" type="password" class="form-control"
                                       data-match="reg-password" required>
                            </div>

                            <% if(isEmailInClaims) { %>
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group required">
                                <label <% if (isEmailRequired) {%> class="control-label" <%}%>>
                                    <%=AuthenticationEndpointUtil.i18n(resourceBundle,
                                        "email")%></label>
                                <input type="email" name="Email" data-claim-uri="http://wso2.org/claims/emailaddress"
                                       class="form-control" data-validate="email"
                                       <% if (isEmailRequired) {%> required <%}%>>
                            </div>
                            <%}%>

                            <% for (UserFieldDTO userFieldDTO : userFields) {
                                if (userFieldDTO.getSupportedByDefault() &&
                                        !StringUtils.equals(userFieldDTO.getFieldName(), "Username") &&
                                        !StringUtils.equals(userFieldDTO.getFieldName(), "Last Name") &&
                                        !StringUtils.equals(userFieldDTO.getFieldName(), "First Name") &&
                                        !StringUtils.equals(userFieldDTO.getFieldName(), "Email")) {
                            %>
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group required">
                                            <label <% if (userFieldDTO.getRequired()) {%> class="control-label" <%}%>><%= Encode.forHtmlContent(userFieldDTO.getFieldName()) %></label>
                                            <input name="<%= Encode.forHtmlAttribute(userFieldDTO.getFieldName()) %>"
                                             data-claim-uri="<%= Encode.forHtmlAttribute(userFieldDTO.getClaimUri()) %>"
                                             class="form-control"
                                             <% if (userFieldDTO.getRequired()) {%> required <%}%>>
                                        </div>
                            <%          fields.add(userFieldDTO);
                                    }
                                }
                                session.setAttribute("fields", fields);
                            %>

                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
                                <input type="hidden" name="sessionDataKey" value='<%=Encode.forHtmlAttribute
            (request.getParameter("sessionDataKey"))%>'/>
                            </div>

                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
                                <br><br>
                                <button id="registrationSubmit"
                                        class="wr-btn grey-bg col-xs-12 col-md-12 col-lg-12 uppercase font-extra-large"
                                        type="submit"><%=AuthenticationEndpointUtil.i18n(resourceBundle,"register")%>
                                </button>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
                                <span class="margin-top padding-top-double font-large">
                                    <%=AuthenticationEndpointUtil.i18n(resourceBundle,"have.account")%>
                                </span>
                                <a href="../dashboard/index.jag" id="signInLink" class="font-large">
                                    <%=AuthenticationEndpointUtil.i18n(resourceBundle,"login")%>
                                </a>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <!-- /content/body -->

    </div>

    <!-- footer -->
    <footer class="footer" style="position: relative">
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
    <script type="text/javascript">

        $(document).ready(function () {

            $("#register").submit(function(e) {

                var password = $("#reg-password").val();
                var password2 = $("#reg-password2").val();
                var error_msg = $("#error-msg");

                if(password != password2) {
                    error_msg.text("<%=AuthenticationEndpointUtil.i18n(resourceBundle, "password.mismatch")%>.");
                    error_msg.show();
                    $("html, body").animate({ scrollTop: error_msg.offset().top }, 'slow');
                    return false;
                }

                $.ajax("registration.do", {
                    async: false,
                    data: { is_validation: "true", reg_username: $("#reg-username").val() },
                    success: function(data) {
                        if($.trim(data) === "User Exist") {
                            error_msg.text("<%=AuthenticationEndpointUtil.i18n(resourceBundle, "user.exists")%>");
                            error_msg.show();
                            $("html, body").animate({ scrollTop: error_msg.offset().top }, 'slow');
                            e.preventDefault();
                        } else if ($.trim(data) === "Ok") {
                            return true;
                        } else {
                            var doc = document.open("text/html", "replace");
                            doc.write(data);
                            doc.close();
                            e.preventDefault();
                        }
                    },
                    error: function() {
                        error_msg.val("<%=AuthenticationEndpointUtil.i18n(resourceBundle, "unknown.error")%>");
                        error_msg.show();
                        e.preventDefault();
                    }
                });
                return true;
            });
        });
    </script>
    </body>
    </html>
