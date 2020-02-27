<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	System.out.println(qnaNo);
%>
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-3"></div>
		<div class="col-xl-6">
			<h1>댓글 삭제</h1>
			<form method="post" action="<%=request.getContextPath() %>/qna/deleteCommentAction.jsp">
				<input type="hidden" name="commentNo" value="<%=commentNo %>">
				<input type="hidden" name="qnaNo" value="<%=qnaNo %>">
				<div class="form-group">
					<label for="commentPw">비밀번호</label>
					<input type="password" class="form-control" id="commentPw" name="commentPw">
				</div>
				<div style="text-align: right;">
					<button type="submit" class="btn btn-sm btn-secondary">삭제</button>
				</div>
			</form>
		</div>
		<div class="col-xl-3"></div>
	</div>
</div>
</body>
</html>