<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="gd.emp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
	<!-- jQuery library -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<!-- Popper JS -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<!-- Latest compiled JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
<title>qnaUpdate</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	PreparedStatement stmt = conn.prepareStatement("select qna_title, qna_content, qna_user, qna_pw from qna where qna_no=?");
	stmt.setInt(1, qnaNo);
	ResultSet rs = stmt.executeQuery();
	
	QnA qna = new QnA();
	if(rs.next()) {
		qna.qnaTitle = rs.getString("qna_title");
		qna.qnaContent = rs.getString("qna_content");
		qna.qnaUser = rs.getString("qna_user");
		qna.qnaPw = rs.getString("qna_pw");
	}
%>
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-3"></div>
		<div class="col-xl-6">
			<h1>수정폼</h1>
			<form method="post" action="<%=request.getContextPath() %>/qna/updateQnaAction.jsp" style="margin-top: 30px;">
				<input type="hidden" name="qnaNo" value="<%=qnaNo %>">
				<!-- QnA 제목 -->
				<div class="form-group row">
					<label for="qnaTitle" class="col-sm-2 col-form-label">qna_title</label>
					<div class="col-sm-10">
						<input type="text" class="form-control" value="<%=qna.qnaTitle %>" name="qnaTitle">
					</div>
				</div>
				<!-- QnA 내용 -->
				<div class="form-group row">
					<label for="qnaContent" class="col-sm-2 col-form-label">content</label>
					<div class="col-sm-10">
						<textarea type="text" class="form-control" name="qnaContent"><%=qna.qnaContent %></textarea>
					</div>
				</div>
				<!-- QnA 글쓴이 -->
				<div class="form-group row">
					<label for="qnaUser" class="col-sm-2 col-form-label">qna_user</label>
					<div class="col-sm-10">
						<input type="text" class="form-control" value="<%=qna.qnaUser %>" name="qnaUser">
					</div>
				</div>
				<!-- QnA 비밀번호 -->
				<div class="form-group row">
					<label for="qnaPw" class="col-sm-2 col-form-label">qna_password 확인</label>
					<div class="col-sm-10">
						<input type="password" class="form-control" name="qnaPw">
					</div>
				</div>
				<div style="text-align: right;">
					<button type="submit" class="btn btn-secondary btn-sm">입력</button>
				</div>
			</form>
		<div class="col-xl-3"></div>
		</div>
	</div>
</div>
</body>
</html>