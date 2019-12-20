<%@ page import="java.util.ResourceBundle" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.AuthenticationEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.EncodedControl" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.Locale" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%

    String BUNDLE = "org.wso2.carbon.identity.application.authentication.endpoint.i18n.Resources";
    ResourceBundle resourceBundle = ResourceBundle.getBundle(BUNDLE, request.getLocale(), new EncodedControl(StandardCharsets.UTF_8.toString())); ;

    String lang = null;
    String lang_param = null;
    String langCode = "en";
    String countryCode = "GB";

    Cookie[] cookies = request.getCookies();
    lang_param = request.getParameter("lang");

    if (cookies != null && cookies.length != 0){
        for (int i = 0; i < cookies.length; i++) {
            String name = cookies[i].getName();
            String value = cookies[i].getValue();
            if (name.equals("lang")){
                lang = value;
            } else if(lang_param != null) {
                lang = lang_param;
            }
        }
    } else if (lang_param != null) {
        lang = lang_param;
    }



    if (lang != null && !lang.trim().equals("") && lang.indexOf("_") != -1){
        String[] langArray = lang.split("_");
        if(langArray.length == 2){
            langCode = langArray[0];
            countryCode = langArray[1];
            Locale local = new Locale(langCode);
            resourceBundle = ResourceBundle.getBundle(BUNDLE, local, new EncodedControl(StandardCharsets.UTF_8.toString()));
        }
    } else {
        resourceBundle = ResourceBundle.getBundle(BUNDLE, request.getLocale(), new EncodedControl(StandardCharsets.UTF_8.toString()));
    }

//    String BUNDLE = "org.wso2.carbon.identity.application.authentication.endpoint.i18n.Resources";
//    ResourceBundle resourceBundle = ResourceBundle.getBundle(BUNDLE, request.getLocale(), new EncodedControl(StandardCharsets.UTF_8.toString()));
%>
