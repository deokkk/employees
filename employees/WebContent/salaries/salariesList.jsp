<%@page import="gd.emp.SalariesTotal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="gd.emp.Salaries" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>salariesList</title>
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
	// page
	int currentPage = 1;
	int rowPerPage = 10;
	int lastPage = 0;
	int totalRow = 0;
	int pageGroup = 5;
	int prevPageGroup = 0;
	int nextPageGroup = 0;
	int lastPageGroup = 0;
	request.setCharacterEncoding("utf-8");
	if(request.getParameter("currentPage")!=null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	//System.out.println(currentPage);
	int beginRow = (currentPage-1)*rowPerPage;
	
	// database
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 한 페이지 data
	ArrayList<SalariesTotal> list = new ArrayList<SalariesTotal>();
	PreparedStatement stmt1 = null;
	
	String searchWord = "";
	String searchValue = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
		searchValue = request.getParameter("searchValue");
	}
	System.out.println(searchWord + " <--searchWord");
	System.out.println(searchValue + " <--searchValue");
	
	// 검색폼에서 데이터가 넘어오면
	if(searchWord.equals("")) {
		// select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, s.salary, s.from_date, s.to_date from employees e inner join salaries s on e.emp_no = s.emp_no order by e.emp_no asc limit ?,?
		stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, s.salary, s.from_date, s.to_date from employees e inner join salaries s on e.emp_no = s.emp_no order by e.emp_no asc, s.from_date asc limit ?,?");
	} else {
		stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, s.salary, s.from_date, s.to_date from employees e inner join salaries s on e.emp_no = s.emp_no where " + searchValue + " like '%" + searchWord + "%' order by e.emp_no asc, s.from_date asc limit ?,?");
	}
	stmt1.setInt(1, beginRow);
	stmt1.setInt(2, rowPerPage);
	System.out.println(stmt1 + " <--stmt1");
	ResultSet rs1 = stmt1.executeQuery();
	while(rs1.next()) {
		SalariesTotal s = new SalariesTotal();
		s.empNo = rs1.getInt("e.emp_no");
		s.birthDate = rs1.getString("e.birth_date");
		s.firstName = rs1.getString("e.first_name");
		s.lastName = rs1.getString("e.last_name");
		s.gender = rs1.getString("e.gender");
		s.hireDate = rs1.getString("e.hire_date");
		s.salary = rs1.getInt("s.salary");
		s.fromDate = rs1.getString("s.from_date");
		s.toDate = rs1.getString("s.to_date");
		list.add(s);
	}
	//System.out.println(list.size());
	
	PreparedStatement stmt2 = null;
	if(searchWord.equals("")) {
		// 전체 data
		// select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, s.salary, s.from_date, s.to_date from employees e inner join salaries s on e.emp_no = s.emp_no order by e.emp_no asc limit ?,?
		stmt2 = conn.prepareStatement("select count(*) from employees e inner join salaries s on e.emp_no = s.emp_no");
	} else {
		stmt2 = conn.prepareStatement("select count(*) from employees e inner join salaries s on e.emp_no = s.emp_no where " + searchValue + " like '%" + searchWord + "%'");
	}

	ResultSet rs2 = stmt2.executeQuery();
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	
	lastPage = totalRow/rowPerPage;
	if(totalRow%rowPerPage!=0) {
		lastPage+=1;
	}
	System.out.println(lastPage);
	lastPageGroup = lastPage-(lastPage%pageGroup);
	System.out.println(lastPageGroup);
%>
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-2"></div>
		<div class="col-xl-8">
			<h1>Salaries List</h1>
			<!-- 검색폼 -->
			<div style="text-align: right;">
				<form method="post" action="<%=request.getContextPath() %>/salaries/salariesList.jsp">
					<select name="searchValue" style="border-radius: 0.25em; height: 30px;">
						<option value="e.emp_no">emp_no</option>
						<option value="e.birth_date">birth_date</option>
						<option value="e.first_name">first_name</option>
						<option value="e.last_name">last_name</option>
						<option value="e.gender">gender</option>
						<option value="e.hire_date">hire_date</option>
						<option value="s.salary">salary</option>
						<option value="s.from_date">from_date</option>
						<option value="s.to_date">to_date</option>
					</select>
					<input type="text" name="searchWord" style="border-radius: 0.25em;">
					<button type="submit" class="btn btn-sm btn-secondary">Search</button>
				</form>
			</div>
			<div class="container" style="text-align: center; margin-top: 30px;">
				<table class="table table-hover">
					<thead class="thead-dark">
						<tr>
							<th scope="col">emp_no</th>
							<th scope="col">birth_date</th>
							<th scope="col">first_name</th>
							<th scope="col">last_name</th>
							<th scope="col">gender</th>
							<th scope="col">hire_date</th>
							<th scope="col">salary</th>
							<th scope="col">from_date</th>
							<th scope="col">to_date</th>
						</tr>
					</thead>
					<tbody>
						<%for(SalariesTotal s : list) {%>
							<tr>
								<th scope="col"><%=s.empNo %></th>
								<td><%=s.birthDate %></td>
								<td><%=s.firstName %></td>
								<td><%=s.lastName %></td>
								<td><%=s.gender %></td>
								<td><%=s.hireDate %></td>
								<td><%=s.salary %></td>
								<td><%=s.fromDate %></td>
								<td><%=s.toDate %></td>
							</tr>
						<%} %>
					</tbody>
				</table>
			</div>
			<div style="text-align: right;">
				<!-- 추가 버튼 -->
				<a href="<%=request.getContextPath() %>/salaries/insertSalariesForm.jsp" class="btn btn-sm btn-secondary" style="margin: 15px; ">부서 입력</a>
			</div>
			<nav aria-label="Page navigation example">
				<ul class="pagination" style="justify-content: center;">
					<% for(int i=0; i<lastPage; i+=pageGroup) {
						if(currentPage>i && currentPage<=i+5){
							prevPageGroup = currentPage-5;
							nextPageGroup = currentPage+5;
							if(currentPage>5){ %>
									<li class="page-item">
										<%if(searchWord.equals("")) { %>
											<a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=1%>" aria-label="First">
										<%} else {%>
											<a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=1%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>" aria-label="First">
										<%} %>
											<i class="fas fa-angle-double-left"></i>
										</a>
									</li>
									<li class="page-item">
										<%if(searchWord.equals("")) { %>
											<a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=prevPageGroup%>" aria-label="Prev">
										<%} else {%>
											<a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=prevPageGroup%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>" aria-label="Prev">
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
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=j%>"><%=j %></a></li>
									<%} else { %>
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=j%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>"><%=j %></a></li>
									<%}	
								}
								if(j==lastPage) {
									break;
								}
							}
							if(currentPage<=lastPageGroup-4){%>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=nextPageGroup%>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=nextPageGroup%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>" aria-label="Next">
									<%} %>
										<i class="fas fa-angle-right"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=lastPage%>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/salaries/salariesList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord %>&searchValue=<%=searchValue %>" aria-label="Next">
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