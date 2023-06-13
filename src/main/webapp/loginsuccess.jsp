<%@page import="java.net.URL"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%-- /naversearch/src/main/webapp/loginsuccess.jsp
    네이버 로그인 시스템에서 호출되는 콜백 URL(페이지) : 네이버가 호출
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
String clientSecret="h6HTq4xdti";		// 애플리케이션 클라이언트 시크릿값;
String code = request.getParameter("code");
String state = request.getParameter("state");
String redirectURI = URLEncoder.encode("YOUR_CALLBACK_URL","UTF-8");
String apiURL ;
apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
apiURL += "client_id="+clientId;
apiURL += "&client_secret="+clientSecret;
apiURL += "&redirect_uri="+redirectURI;
apiURL += "&code="+code; // 네이버가 전달해준 파라미터값
apiURL += "&state="+state; // 네이버가 전달해준 파라미터값. 초기에는 로그인 시작시 개발자가 전달한 임의의 수
System.out.println("code = "+code+", state = "+state);
String access_token ="";
String refresh_token ="";
StringBuffer res = new StringBuffer();
System.out.println("apiURL="+apiURL);
try{
	URL url = new URL(apiURL);
	// 네이버에 접속. => 토큰 전달
	HttpURLConnection con = (HttpURLConnection)url.openConnection();
	con.setRequestMethod("GET");
	int responseCode = con.getResponseCode();
	BufferedReader br;
	System.out.println("responseCode = "+ responseCode);
	if(responseCode ==200){ //정상호출
		br = new BufferedReader(new InputStreamReader(con.getInputStream()));
	}else { // 에러발생
		br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
	}
	String inputLine;
	while((inputLine = br.readLine())!= null ){
		res.append(inputLine);
	}
	br.close();
	// res : JSON 형태의 문자열
			// {"access_token":"AAAAN_NFHtU...
	if(responseCode == 200){
		System.out.println("\n================res 1 :");// 네이버에서 첫번째 요청에 대한 응답 메세지
		System.out.println("res : " + res.toString());
	}
}catch( Exception e){
	e.printStackTrace();
}
// JSON 형태의 문자열 데이터 => JSON 객체로 변경하기 위한 객체 생성
JSONParser parser = new JSONParser(); // pom.xml=> json-simple-1.1.1.jar 파일 설정 필요
// 네이버 응답 데이터를 json 객체로 생성.
JSONObject json = (JSONObject)parser.parse(res.toString());
//정상적인 로그인 요청인 경우 네이버가 발생한 코드값
String token = (String)json.get("access_token");
System.out.println("\n=========token : "+ token);
String header = "Bearer "+token; // Bearer 다음에 공백 추가
try{
	apiURL = "https://openapi.naver.com/v1/nid/me"; // 2번째 요청 URL. 토큰값 전송
	URL url = new URL(apiURL);
	HttpURLConnection con = (HttpURLConnection)url.openConnection();
	con.setRequestMethod("GET");
	con.setRequestProperty("Authorization", header); // 헤더값에 인증정보
	int responseCode = con.getResponseCode();
	BufferedReader br;
	res = new StringBuffer();
	if(responseCode==200){ //정상호출
		System.out.println("로그인 정보 정상 수신");
		br = new BufferedReader(new InputStreamReader(con.getInputStream()));
	}else { // 에러발생
		System.out.println("로그인 정보 오류 수신");
		br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
	}
	String inputLine;
	while((inputLine = br.readLine()) != null){
		res.append(inputLine);
	}
	br.close();
	System.out.println(res.toString());
}catch(Exception e){
	e.printStackTrace();
}
json = (JSONObject)parser.parse(res.toString());
System.out.println(json); // 네이버 사용자의 정보 수신.
JSONObject jsondetail = (JSONObject)json.get("response");
%>
<%=jsondetail.get("id") %> <br> 
<%=jsondetail.get("email") %><br>
</body>
</html>