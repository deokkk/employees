<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	System.out.println(qnaNo + " <--qnaNo");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	PreparedStatement stmt = conn.prepareStatement("delete from qna_comment where comment_no=? and comment_pw=?");
	stmt.setInt(1, commentNo);
	stmt.setString(2, commentPw);
	System.out.println(stmt);
	int row = stmt.executeUpdate();
	System.out.println(row + " <--row");
	
	if(row==0) {
		response.sendRedirect(request.getContextPath() + "/qna/deleteCommentForm.jsp?commentNo=" + commentNo + "&qnaNo=" + qnaNo);
	} else {
		response.sendRedirect(request.getContextPath() + "/qna/selectQna.jsp?qnaNo=" + qnaNo);
	}
%>