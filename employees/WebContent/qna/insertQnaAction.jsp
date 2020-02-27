<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// request 인코딩 설정
	request.setCharacterEncoding("utf-8");	
	// request 매개값 설정(ip, title, content, user, pw)
	String qnaIp = request.getRemoteAddr();
	String qnaTitle = request.getParameter("qnaTitle");
	String qnaContent = request.getParameter("qnaContent");
	String qnaUser = request.getParameter("qnaUser");
	String qnaPw = request.getParameter("qnaPw");
	
	// 매개값 공백이 있으면 폼으로 되돌려 보낸다 (ck추가....)
	if(qnaTitle.equals("") || qnaContent.equals("") || qnaUser.equals("") || qnaPw.equals("")){
		response.sendRedirect(request.getContextPath() + "/qna/insertQnaForm.jsp?ck=fail");
		return;	//코드 진행을 끝낸다. 명령X
	}
	//System.out.println(qnaIp+" qnaIp");
	//System.out.println(qnaTitle+" qnaTitle");
	//System.out.println(qnaContent+" qnaContent");
	//System.out.println(qnaUser+" qnaUser");
	//System.out.println(qnaPw+" qnaPw");
	
	// qnaNo
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost/employees","root","java1234");
	PreparedStatement stmt1 = conn.prepareStatement("select max(qna_no) from qna");
	//System.out.println(stmt1+"<--stmt");
	ResultSet rs1 = stmt1.executeQuery();
	//System.out.println(rs1+"<--rs1");
	//int nextQnaNo = rs1.getInt("max(qna_no)")+1;
	//System.out.println(nextQnaNo);
	
	//rs1 값이 있으연 qnaNo
	int qnaNo = 1;
	if(rs1.next()) {
		qnaNo = rs1.getInt("max(qna_no)");
	}
	System.out.println(qnaNo +"<-- qnaNo");
	int nextQnaNo = rs1.getInt("max(qna_no)")+1;
			
	// qnaData : sql문에서 now()함수를 사용
	PreparedStatement stmt2 = conn.prepareStatement("insert into qna(qna_no, qna_title, qna_content, qna_user, qna_pw, qna_ip, qna_date) values(?,?,?,?,?,?,now())");
	stmt2.setInt(1, nextQnaNo);
	stmt2.setString(2, qnaTitle);
	stmt2.setString(3, qnaContent);
	stmt2.setString(4, qnaUser);
	stmt2.setString(5, qnaPw);
	stmt2.setString(6, qnaIp);
	stmt2.executeUpdate();	
	
	response.sendRedirect(request.getContextPath() + "/qna/qnaList.jsp");
%>
