<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="gd.emp.*"%>
<!-- 날짜/시간 구하기 -->
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%
 	request.setCharacterEncoding("utf-8");
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	System.out.println(qnaNo + " <--qnaNo");
	String qnaTitle = request.getParameter("qnaTitle");
	String qnaContent = request.getParameter("qnaContent");
	String qnaUser = request.getParameter("qnaUser");
	String qnaPw = request.getParameter("qnaPw");
	// 오늘날짜받아오기
	//SimpleDateFormat forma
	
	if(qnaTitle.equals("") || qnaContent.equals("") || qnaUser.equals("") || qnaPw.equals("")){
		response.sendRedirect(request.getContextPath() + "/qna/updateQnaForm.jsp?ck=fail");
		return;	//코드 진행을 끝낸다. 명령X
	}
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	PreparedStatement stmt = conn.prepareStatement("update qna set qna_title=?, qna_content=?, qna_user=?, qna_date=now() where qna_no=? and qna_pw=?");
	stmt.setString(1, qnaTitle);
	stmt.setString(2, qnaContent);
	stmt.setString(3, qnaUser);
	stmt.setInt(4, qnaNo);
	stmt.setString(5, qnaPw);
	System.out.println(stmt + " <--stmt");
	int row = stmt.executeUpdate();
	if(row==0) {
		response.sendRedirect(request.getContextPath() + "/qna/updateQnaForm.jsp?qnaNo=" + qnaNo);
	} else {
		response.sendRedirect(request.getContextPath() + "/qna/qnaList.jsp");
	}
%>