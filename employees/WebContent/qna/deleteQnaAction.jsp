<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	//System.out.println(qnaNo + " <--qnaNo");
	String qnaPw = request.getParameter("qnaPw");;
	System.out.println(qnaPw + " <--qnaPw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "delete from qna where qna_no=? and qna_pw=?";
	//String sql = "delete from qna where qna_title='aaa'";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, qnaNo);
	stmt.setString(2, qnaPw);
	System.out.println(stmt + " <--stmt");
	int row = stmt.executeUpdate();		// 성공하면 1 실패하면 0
	System.out.println(row + " <--row");
	if(row==0) {	
		response.sendRedirect(request.getContextPath()+"/qna/qnaList.jsp?deleteQnaForm.jsp?qnaNo="+qnaNo);
	} else {
		response.sendRedirect(request.getContextPath()+"/qna/qnaList.jsp");
	}
%>