<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="gd.emp.Departments" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>departmentList</title>
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
	<!-- 부가적인 테마 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
	<!-- jQuery library -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<!-- Popper JS -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<!-- Latest compiled JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
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
	// 1. 페이지
	int currentPage = 1;	// default값 (currentPage값 null이면 1)
	int pageGroup = 5;
	int prevPageGroup = 0;
	int nextPageGroup = 0;
	int lastPageGroup = 0;
	request.setCharacterEncoding("utf-8");
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5;
	int beginRow = (currentPage-1)*rowPerPage;
	
	// 2.0 database
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2. 현재페이지의 departments 테이블 행들
	ArrayList<Departments> list = new ArrayList<Departments>();	// Departments 배열 만들기
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	// 검색된데이터
	request.setCharacterEncoding("utf-8");
	String searchWord = "";
	String[] searchValue = new String[]{};
	String sendUrl = "";
	if(request.getParameter("searchValue") != null) {
		searchWord = request.getParameter("searchWord");
		searchValue = request.getParameterValues("searchValue");
	}
	System.out.println(searchWord + " <--searchWord");

	// 검색폼에서 데이터가 넘어오면
	if(searchWord.equals("")){
		stmt1 = conn.prepareStatement("select dept_no, dept_name from departments order by dept_no asc limit ?,?");
	} else {
		if(searchValue.length==2) {
			stmt1 = conn.prepareStatement("select dept_no, dept_name from departments where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' order by dept_no limit ?,?");
			sendUrl = "&searchValue="+searchValue[0] + "&searchValue="+searchValue[1];
		} else if(searchValue.length==1) {
			stmt1 = conn.prepareStatement("select dept_no, dept_name from departments where " + searchValue[0] + " like '%" +searchWord + "%' order by dept_no limit ?,?");
			sendUrl = "&searchValue="+searchValue[0];
		}
	}
	stmt1.setInt(1, beginRow);
	stmt1.setInt(2, rowPerPage);
	System.out.println(stmt1 + " <--stmt1");
	rs1 = stmt1.executeQuery();	// -> ArrayList<Departments> list 여기로
	while(rs1.next()) {
		Departments d = new Departments();
		d.deptNo = rs1.getString("dept_no");
		d.deptName = rs1.getString("dept_name");
		list.add(d);
	}
	// System.out.println(list.size());
	
	int totalRow = 0;
	int lastPage = 0;

	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	if(searchWord.equals("")) {
		// 3. departments 테이블 전체행의 수
		stmt2 = conn.prepareStatement("select count(*) from departments");	
	} else {
		if(searchValue.length==2) {
			stmt2 = conn.prepareStatement("select count(*) from departments where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord +"%'");	
		} else if(searchValue.length==1) {
			stmt2 = conn.prepareStatement("select count(*) from departments where " + searchValue[0] + " like '%" + searchWord + "%'");
		}
	}
	rs2 = stmt2.executeQuery();
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	} 
	lastPage = totalRow/rowPerPage;
	if(totalRow%rowPerPage!=0){
		lastPage+=1;
	}
	//System.out.println(lastPage);
	lastPageGroup = lastPage-(lastPage%pageGroup);
	//System.out.println(lastPageGroup);
	
%>
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-2"></div>
		<div class="col-xl-8">
			<h1>Departments List</h1>
			<div>
				<form method="post" action="<%=request.getContextPath() %>/departments/departmentsList.jsp">
					<div class="row" style="margin-left: 10px;">
						<span class="col">
							<input type="checkbox" class="form-check-input" id="dept_no" value="dept_no" name="searchValue">
							<label class="form-check-label" for="dept_no">dept_no</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="dept_name" value="dept_name" name="searchValue">
							<label class="form-check-label" for="dept_name">dept_name</label>
						</span>
					</div>
					<div class="form-group" style="margin-top: 10px;">
						<input type="text" class="form-control" id="searchWord" name="searchWord">
					</div>
					<div style="text-align: right;">
						<button class="btn btn-sm btn-secondary" type="submit">Search</button>
					</div>
				</form>
			</div>
			<!-- Departments List -->
			<div class="container" style="text-align: center; margin-top: 30px;">
				<table class="table table-hover">
					<thead class="thead-dark">
						<tr>
							<th scope="col">dept_no</th>
							<th scope="col">dept_name</th>
						</tr>
					</thead>
					<tbody>
						<% for(Departments d : list) { %>
								<tr>
									<th scope="col"><%=d.deptNo %></td>
									<td><%=d.deptName %></td>
								</tr>
							<%} %>
					</tbody>
				</table>
			</div>
			<div style="text-align: right;">
				<!-- 추가 버튼 -->
				<a href="<%=request.getContextPath() %>/departments/insertDepartmentsForm.jsp" class="btn btn-sm btn-secondary" style="margin: 15px; ">부서 입력</a>
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
										<a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=1%>" aria-label="First">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=1%>&searchWord=<%=searchWord %><%=sendUrl %>" aria-label="First">
									<%} %>
										<i class="fas fa-angle-double-left"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=prevPageGroup%>" aria-label="Prev">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=prevPageGroup%>&searchWord=<%=searchWord %><%=sendUrl %>" aria-label="Prev">
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
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=j%>"><%=j %></a></li>
									<%} else {%>
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=j%>&searchWord=<%=searchWord %><%=sendUrl %>"><%=j %></a></li>
									<%} %>
								<%}
								if(j==lastPage) {
									break;
								}
							}
							if(currentPage<=lastPageGroup-4) {%>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=nextPageGroup%>" aria-label="Next">
									<%} else {%>
										<a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=nextPageGroup%>&searchWord=<%=searchWord %><%=sendUrl %>" aria-label="Next">
									<%} %>
										<i class="fas fa-angle-right"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=lastPage%>" aria-label="Next">
									<%} else {%>
										<a class="page-link" href="<%=request.getContextPath()%>/departments/departmentsList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord %><%=sendUrl %>" aria-label="Next">
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
		<div class="col-xl-2"></div>
	</div>
</div>
</body>
</html>

