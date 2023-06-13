<%@page import="java.net.URLEncoder"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.SecureRandom"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%-- /naversearch/src/main/webapp/naverlogin.jsp 
    	
    --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>네이버 로그인</title>
</head>
<body>
<%
String clientId = "H5OOG6wmI8ivpoz44F3v"; // 애플리케이션 클라이언트 아이디값;
String redirectURI = URLEncoder.encode // 로그인 완료시 보여줄 페이지 
	("http://localhost:8080/naversearch/loginsuccess.jsp","UTF-8");
SecureRandom random = new SecureRandom();
String state = new BigInteger(130, random).toString();
String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
apiURL += "&client_id=" + clientId;
apiURL += "&redirect_uri=" + redirectURI;
apiURL += "&state=" + state;
session.setAttribute("state", state);
%>
<a href="<%=apiURL%>">
	<img height="50" src="http://static.nid.naver.com/oauth/small_g_in.PNG"/>
</a>
</body>
</html>