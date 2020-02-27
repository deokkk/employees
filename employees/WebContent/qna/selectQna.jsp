<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="gd.emp.*" %>
<%@ page import="java.util.ArrayList" %>
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
<style>
	.detail {
		background-color: #e9ecef;
		width: 20%
	}
	.commentDate {
		font-size: 10pt;
		font-weight: normal;
	}
	.page-item.active .page-link {
		background-color: #000000;
		border-color: #000000;
	}
	.page-link {
		color: #000000;
	}
</style>
<title>selectQna</title>
</head>
<body>
<%
	// 선택된 qna로 데이터가져오기
	request.setCharacterEncoding("utf-8");
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	System.out.println(qnaNo+ "<--qnaNo");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	System.out.println(conn + "<--conn");
	PreparedStatement stmt1 = conn.prepareStatement("select qna_no, qna_title, qna_content, qna_user, qna_date from qna where qna_no=?");
	stmt1.setInt(1, qnaNo);
	System.out.println(stmt1 + "<--stmt");
	ResultSet rs1 = stmt1.executeQuery();
	System.out.println(rs1 + "<--rs");
	
	QnA qna = new QnA();
	if(rs1.next()) {
		qna.qnaNo = rs1.getInt("qna_no");
		qna.qnaTitle = rs1.getString("qna_title");
		qna.qnaContent = rs1.getString("qna_content");
		qna.qnaUser = rs1.getString("qna_user");
		qna.qnaDate = rs1.getString("qna_date");
	}
	qna.qnaDate = qna.qnaDate.substring(0, 16);
	System.out.println(qna.qnaDate);
	
	// 댓글목록
	// select comment_no, comment from qna_comment where qna_no =? limit ?,?
	int currentPage = 1;
	int rowPerPage = 5;
	int totalRow = 0;
	int lastPage = 0;
	int pageGroup = 5;
	int prevPageGroup = 0;
	int nextPageGroup = 0;
	int lastPageGroup = 0;
	if(request.getParameter("currentPage")!=null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + " <--currentPage");
	int beginRow = (currentPage-1)*rowPerPage;
	PreparedStatement stmt2 = conn.prepareStatement("select comment_user, comment_no, comment, comment_date from qna_comment where qna_no=? limit ?,?");
	stmt2.setInt(1, qnaNo);
	stmt2.setInt(2, beginRow);
	stmt2.setInt(3, rowPerPage);
	System.out.println(stmt2 + " <--stmt2");
	ResultSet rs2 = stmt2.executeQuery();
	
	// 페이지당 댓글 저장
	ArrayList<QnAComment> list = new ArrayList<QnAComment>();
	while(rs2.next()) {
		QnAComment comment = new QnAComment();
		comment.commentUser = rs2.getString("comment_user");
		comment.commentNo = rs2.getInt("comment_no");
		comment.comment = rs2.getString("comment");
		comment.commentDate = rs2.getString("comment_date");
		list.add(comment);
	}
	System.out.println(list.size() + " <--list.size()");
	
	// 전체 댓글 수, 페이지수
	PreparedStatement stmt3 = conn.prepareStatement("select count(*) from qna_comment where qna_no=?");
	stmt3.setInt(1, qnaNo);
	ResultSet rs3 = stmt3.executeQuery();
	if(rs3.next()) {
		totalRow = rs3.getInt("count(*)");
	}
	System.out.println(totalRow + " <--totalRow");
	lastPage = totalRow/rowPerPage;
	System.out.println(lastPage + " <--lastPage");
	if(totalRow%rowPerPage!=0) {
		lastPage+=1;
	}
	System.out.println(totalRow%rowPerPage + " <--totalRow%rowPerPage");
	lastPageGroup = lastPage-(lastPage%pageGroup);
	System.out.println(lastPageGroup + " <--lastPageGroup");
%>
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-2"></div>
		<div class="col-xl-8">
			<h1>QnA 상세보기</h1>
			<!-- qna -->
			<table class="table">
				<tr>
					<th class="detail">qna_no</th>
					<td><%=qna.qnaNo %></td>
				</tr>
				<tr>
					<th class="detail">qna_title</th>
					<td><%=qna.qnaTitle %></td>
				</tr>
				<tr>
					<th class="detail">qna_content</th>
					<td><%=qna.qnaContent %></td>
				</tr>
				<tr>
					<th class="detail">qna_user</th>
					<td><%=qna.qnaUser %></td>
				</tr>
				<tr>
					<th class="detail">qna_date</th>
					<td><%=qna.qnaDate %></td>
				</tr>
			</table>
			<!-- 수정, 삭제, qna목록 -->
			<div style="text-align: right;">
				<!-- 수정, 삭제 -->
				<a class="btn btn-sm btn-secondary" href="<%=request.getContextPath() %>/qna/updateQnaForm.jsp?qnaNo=<%=qnaNo %>">수정</a>
				<a class="btn btn-sm btn-secondary" href="<%=request.getContextPath() %>/qna/deleteQnaForm.jsp?qnaNo=<%=qnaNo %>">삭제</a>
				<!-- 목록으로가기 링크 -->
				<a class="btn btn-sm btn-secondary" href="<%=request.getContextPath() %>/qna/qnaList.jsp">목록으로</a>
			</div>
			<!-- 댓글 목록 -->
			<table class="table" style="margin-top: 30px;">
				<%for(QnAComment c : list) {%>
					<tr>
						<th>
							<div class="row">
								<div class="col">
									<span><%=c.commentUser %></span>
									<span class="commentDate"><%=c.commentDate %></span>
								</div>
								<div class="col" style="text-align: right;">
									<a href="<%=request.getContextPath() %>/qna/updateCommentForm.jsp?commentNo=<%=c.commentNo %>&qnaNo=<%=qnaNo %>" class="btn btn-sm btn-secondary">수정</a>
									<a href="<%=request.getContextPath() %>/qna/deleteCommentForm.jsp?commentNo=<%=c.commentNo %>&qnaNo=<%=qnaNo %>" class="btn btn-sm btn-secondary">삭제</a>
								</div>
							</div>
						</th>
					</tr>
					<tr>
						<td><%=c.comment %></td>
					</tr>
				<%} %>
			</table>
			<!-- 페이징 -->
			<nav aria-label="Page navigation example">
				<ul class="pagination" style="justify-content: center;">
					<% for(int i=0; i<lastPage; i+=pageGroup) {
						if(currentPage>i && currentPage<=i+5){
							prevPageGroup = currentPage-5;
							nextPageGroup = currentPage+5;
							if(currentPage>5){%>
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/qna/selectQna.jsp?qnaNo=<%=qnaNo %>&currentPage=<%=1%>" aria-label="First">
										<i class="fas fa-angle-double-left"></i>
									</a>
								</li>
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/qna/selectQna.jsp?qnaNo=<%=qnaNo %>&currentPage=<%=prevPageGroup%>" aria-label="Prev">
										<i class="fas fa-angle-left"></i>
									</a>
								</li>
							<%}
							for(int j=i+1; j<=i+pageGroup; j+=1){
								if(j==currentPage){%>
									<li class="page-item active"><span class="page-link"><%=j %><span class="sr-only">(current)</span></span></li>
									<%System.out.println(j+"if"); %>
								<%} else { %>
									<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/qna/selectQna.jsp?qnaNo=<%=qnaNo %>&currentPage=<%=j%>"><%=j %></a></li>
									<%System.out.println(j+"else"); %>
								<%}
								if(j==lastPage) {
									System.out.println(lastPage+"lastPage");
									break;
								}
							}
							if(currentPage<=lastPageGroup-4) {%>
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/qna/selectQna.jsp?qnaNo=<%=qnaNo %>&currentPage=<%=nextPageGroup%>" aria-label="Next">
										<i class="fas fa-angle-right"></i>
									</a>
								</li>
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath()%>/qna/selectQna.jsp?qnaNo=<%=qnaNo %>&currentPage=<%=lastPage%>" aria-label="Next">
										<i class="fas fa-angle-double-right"></i>
									</a>
								</li>
							<%}
						}
					}%>
				</ul>
			</nav>
			<!-- 댓글 작성폼 -->
			<div>
				<form method="post" action="<%=request.getContextPath() %>/qna/insertCommentAction.jsp">
					<input type="hidden" name="qnaNo" value="<%=qna.qnaNo %>">
					<div class="row">
						<div class="form-group col">
							<label for="commentUser">User:</label>
							<input type="text" class="form-control" id="commentUser" name="commentUser">
						</div>
						<div class="form-group col">
							<label for="commentPw">Password:</label>
							<input type="password" class="form-control" id="commentPw" name="commentPw">
						</div>
					</div>
					<div class="form-group">
						<label for="comment">Comment:</label>
						<textarea class="form-control" rows="2" id="comment" name="comment"></textarea>
					</div>
					<div style="text-align: right;">
						<button type="submit" class="btn btn-sm btn-secondary">댓글입력</button>
					</div>
				</form>
			</div>
		</div>
		<div class="col-xl-2"></div>
	</div>
</div>
</body>
</html>