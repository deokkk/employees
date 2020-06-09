<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="gd.emp.*" %>
<%@ page import="java.util.*" %>
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
<title>Qna List</title>
<style>
	.page-item.active .page-link {
		background-color: #000000;
		border-color: #000000;
	}
	.page-link {
		color: #000000;
	}
</style>
</head>
<body>
<%
	// currentPage 설정
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage=Integer.parseInt(request.getParameter("currentPage"));
	}
	//System.out.println(currentPage + " <-- currentPage");
	
	// 한페이지에 출력할 행수
	int rowPerPage = 10;
	// 출력될 첫번째 행
	int beginRow = (currentPage-1)*rowPerPage;
	int totalRow = 0;
	int lastPage = 0;
	int pageGroup = 5;
	int prevPageGroup = 0;
	int nextPageGroup = 0;
	int lastPageGroup = 0;
	
	// database 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 검색받은값
	request.setCharacterEncoding("utf-8");
	String searchWord = "";
	String searchValue = "";
	String searchValue1 = "";
	String searchValue2 = "";
	String sendUrl = "";
	if(request.getParameter("searchWord")!=null) {
		searchWord = request.getParameter("searchWord");
		searchValue = request.getParameter("searchValue");
		if(searchValue.equals("titleContent")) {
			searchValue1 = "qna_title";
			searchValue2 = "qna_Content";
		}
	}
	
	System.out.println(searchWord + " <--searchWord");
	PreparedStatement stmt1 = null;
	if(searchWord.equals("")) {
		stmt1 = conn.prepareStatement("select qna_no, qna_title, qna_user, qna_date from qna order by qna_no desc limit ?,?");
	} else {
		if(searchValue.equals("titleUser")) {
			stmt1 = conn.prepareStatement("select qna_no, qna_title, qna_user, qna_date from qna where " + searchValue1 + " like '%" + searchWord + "%' or " + searchValue2 + " like '%" + searchWord + "%' order by qna_no desc limit ?,?");
			//sendUrl = "&searchValue="+searchValue1+"&searchValue="+searchValue2;
		} else {
			stmt1 = conn.prepareStatement("select qna_no, qna_title, qna_user, qna_date from qna where " + searchValue + " like '%" + searchWord + "%' order by qna_no desc limit ?,?");
			//sendUrl = "&searchValue="+searchValue;
		}
	}
	// PreparedStatement stmt1 = conn.prepareStatement("select qna_no, qna_title, qna_user, qna_date from qna order by qna_no desc limit ?,?");
	stmt1.setInt(1, beginRow);
	stmt1.setInt(2, rowPerPage);
	System.out.println(stmt1 + "<--stmt1");
	ResultSet rs1 = stmt1.executeQuery();
	
	// qna테이블 값 저장
	ArrayList<QnA> list = new ArrayList<QnA>();
	while(rs1.next()) {
		QnA qna = new QnA();
		qna.qnaNo = rs1.getInt("qna_no");
		qna.qnaTitle = rs1.getString("qna_title");
		qna.qnaUser = rs1.getString("qna_user");
		qna.qnaDate = rs1.getString("qna_date");
		qna.qnaDate = qna.qnaDate.substring(0, 10);
		list.add(qna);
	}
	System.out.println(list.size()+" <--list.size()");
	
	// 전체 행
	PreparedStatement stmt2 = null;
	if(searchWord.equals("")) {
		stmt2 = conn.prepareStatement("select count(*) from qna");
	} else {
		if(searchValue.equals("titleUser")) {
			stmt2 = conn.prepareStatement("select count(*) from qna where " + searchValue1 + " like '%" + searchWord + "%' or "+ searchValue2 + " like '%" + searchWord + "%'");
		} else {
			stmt2 = conn.prepareStatement("select count(*) from qna where " + searchValue + " like '%" + searchWord + "%'");
		}
	}
	ResultSet rs2 = stmt2.executeQuery();
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	System.out.println(totalRow + " <--totalRow");
	lastPage = totalRow/rowPerPage;
	System.out.println(lastPage + " <--lastPage");
	if(totalRow%rowPerPage!=0) {
		lastPage+=1;
	}
	System.out.println(lastPage + " <--lastPage");
	lastPageGroup = lastPage-(lastPage%pageGroup);
	System.out.println(lastPageGroup + " <--lastPageGroup");
%>
<!-- mainmenu -->
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<!-- contents -->
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-2"></div>
		<div class="col-xl-8">
			<h1>QnA List</h1>
			<div style="text-align: right;">
				<form method="post" action="<%=request.getContextPath() %>/qna/qnaList.jsp">
					<select name="searchValue" style="border-radius: 0.25em; height: 30px;">
						<option value="qna_title">제목</option>
						<option value="qna_user">작성자</option>
						<option value="qna_content">내용</option>
						<option value="titleContent">제목 + 내용</option>
					</select>
					<input type="text" name="searchWord" style="border-radius: 0.25em;">
					<button type="submit" class="btn btn-sm btn-secondary">Search</button>
				</form>
			</div>
			<div class="container" style="text-align: center; margin-top: 30px;">
				<table class="table table-hover">
					<thead class="thead-dark">
						<tr>
							<th scope="col" style="width: 10%;">qna_no</th>
							<th scope="col" style="width: 60%;">qna_title</th>
							<th scope="col" style="width: 10%;">qna_user</th>
							<th scope="col" style="width: 20%;">qna_date</th>
						</tr>
					</thead>
					<tbody>
						<%for(QnA q : list) { 
						// db의 문자열 날짜값중 일부를 추출해 문자열로 변경
						String qnaDateSub = q.qnaDate.substring(0, 10);
						//System.out.println(q.qnaDate.substring(0, 10) + " <- qnaDate.substring"); 
						// jsp에서 오늘 날짜값중 일부를 추출해 문자열로 변경
						Calendar today = Calendar.getInstance();
						//System.out.println(today);
						int year = today.get(Calendar.YEAR);
						int month = today.get(Calendar.MONTH)+1;
						//System.out.println(month);
						String month2 = ""+month;
						if(month<10) {
							month2 = "0"+month;
						}
						int day = today.get(Calendar.DATE);
						//System.out.println(day);
						String day2 = ""+day;
						if(day<10) {
							day2 = "0"+day;
						}
						String strToday = year + "-" + month2 + "-" + day;
						//System.out.println(strToday + " <- strToday");
						// 두 날짜 문자열을 비교해서 같으면 badge표시
					 %>
						<tr>
							<th scope="col"><%=q.qnaNo %></th>
							<td>
								<a href="<%=request.getContextPath() %>/qna/selectQna.jsp?qnaNo=<%=q.qnaNo %>"><%=q.qnaTitle %></a>
								<%if(strToday.equals(qnaDateSub)) { %>
									<span class="badge badge-secondary">New</span>
								<%} %>
							</td>
							<td><%=q.qnaUser %></td>
							<td><%=q.qnaDate %></td>
						</tr>
					<%} %>
					</tbody>
				</table>
			</div>
			<div style="text-align: right;">
				<!-- 추가 버튼 -->
				<a href="<%=request.getContextPath() %>/qna/insertQnaForm.jsp" class="btn btn-sm btn-secondary" style="margin: 15px; ">qna입력</a>
			</div>
			<nav aria-label="Page navigation example">
				<ul class="pagination" style="justify-content: center;">
					<% for(int i=0; i<lastPage; i+=pageGroup) {
						if(currentPage>i && currentPage<=i+5){
							prevPageGroup = currentPage-5;
							nextPageGroup = currentPage+5;
							if(currentPage>5){%>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=1%>" aria-label="First">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=1%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>" aria-label="First">
									<%} %>
										<i class="fas fa-angle-double-left"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=prevPageGroup%>" aria-label="Prev">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=prevPageGroup%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>" aria-label="Prev">
									<%} %>	
										<i class="fas fa-angle-left"></i>
									</a>
								</li>
							<%}
							for(int j=i+1; j<=i+pageGroup; j+=1){
								if(j==currentPage){%>
									<li class="page-item active"><span class="page-link"><%=j %><span class="sr-only">(current)</span></span></li>
								<%} else { %>
									<%if(searchWord.equals("")) { %>
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=j%>"><%=j %></a></li>
									<%} else { %>
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=j%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>"><%=j %></a></li>
									<%} %>
								<%}
								if(j==lastPage) {
									break;
								}
							}
							if(currentPage<=lastPageGroup-4) {%>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=nextPageGroup%>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=nextPageGroup%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>" aria-label="Next">
									<%} %>
										<i class="fas fa-angle-right"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=lastPage%>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/qna/qnaList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>" aria-label="Next">
									<%} %>
										<i class="fas fa-angle-double-right"></i>
									</a>
								</li>
							<%}
						}
					}%>
				</ul>
			</nav>
		</div>
		<%-- <form method="post" action="<%=request.getContextPath() %>/qna/qnaList.jsp">
			<input type="text" name="searchWord">
			<button type="submit">검색</button>
		</form> --%>
		<div class="col-xl-2"></div>
	</div>
</div>
</body>
</html>