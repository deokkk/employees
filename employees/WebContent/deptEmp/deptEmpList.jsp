<%@page import="gd.emp.DeptEmpTotal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="gd.emp.DeptEmp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deptEmpList</title>
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
	// 1. page
	int currentPage = 1;
	int lastPage = 0;
	int rowPerPage = 10;
	int pageGroup = 5;
	int prevPageGroup = 0;
	int nextPageGroup = 0;
	int lastPageGroup = 0;
	
	request.setCharacterEncoding("utf-8");
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int beginRow = (currentPage-1)*rowPerPage;
	// 2. database
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 3. 1페이지 당 data
	PreparedStatement stmt1 = null;
	ArrayList<DeptEmpTotal> list = new ArrayList<DeptEmpTotal>();
	String searchWord = "";
	String[] searchValue = new String[]{};
	String sendUrl = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
		searchValue = request.getParameterValues("searchValue");
	}
	if(searchWord.equals("")) {
		// select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, d.dept_no, d.dept_name, de.from_date, de.to_date from employees e inner join departments d inner join dept_emp de on e.emp_no = de.emp_no and d.dept_no = de.dept_no order by e.emp_no ASC LIMIT ?,?
		stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, d.dept_no, d.dept_name, de.from_date, de.to_date from employees e inner join departments d inner join dept_emp de on e.emp_no = de.emp_no and d.dept_no = de.dept_no order by e.emp_no asc limit ?,?");
	} else {
		//stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, d.dept_no, d.dept_name, de.from_date, de.to_date from employees e inner join departments d inner join dept_emp de on e.emp_no = de.emp_no and d.dept_no = de.dept_no where " + searchValue + " like '%" + searchWord + "%' order by e.emp_no asc limit ?,?");
		
		String sql1 = "select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, d.dept_no, d.dept_name, de.from_date, de.to_date from employees e inner join departments d inner join dept_emp de on e.emp_no = de.emp_no and d.dept_no = de.dept_no where ";
		String order = "%' order by e.emp_no asc limit ?,?";
		//"%' or " + searchValue[1] + " like '%" + searchWord + 
		//" + searchValue[0] + " like '%" + searchWord + / /"%' order by e.emp_no asc limit ?,?");
		
		/* select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, d.dept_no, d.dept_name, de.from_date, de.to_date 
		from employees e inner join departments d inner join dept_emp de on e.emp_no = de.emp_no and d.dept_no = de.dept_no 
		where " + searchValue + " like '%" + searchWord + "%' order by e.emp_no asc limit ?,? */
		
		for(int i=0; i<searchValue.length; i+=1) {
			if(i==0){
				sql1 = sql1 + searchValue[0] + " like '%" + searchWord;
				sendUrl = "&searchValue="+searchValue[0];
			} else {
				sql1 = sql1 + "%' or " + searchValue[i] + " like '%" + searchWord;
				sendUrl = sendUrl + "&searchValue=" + searchValue[i];
			}
		}
		sql1 = sql1 + order;
		stmt1 = conn.prepareStatement(sql1);
		
	}
	stmt1.setInt(1, beginRow);
	stmt1.setInt(2, rowPerPage);
	//System.out.println(stmt1);
	ResultSet rs1 = stmt1.executeQuery();
	while(rs1.next()){
		DeptEmpTotal d = new DeptEmpTotal();
		d.deptNo = rs1.getString("d.dept_no");
		d.deptName = rs1.getString("d.dept_name");
		d.empNo = rs1.getInt("e.emp_no");
		d.birthDate = rs1.getString("e.birth_date");
		d.firstName = rs1.getString("e.first_name");
		d.lastName = rs1.getString("e.last_name");
		d.gender = rs1.getString("e.gender");
		d.hireDate = rs1.getString("e.hire_date");
		d.fromDate = rs1.getString("de.from_date");
		d.toDate = rs1.getString("de.to_date");
		list.add(d);
	}
	
	// 4. 전체 data
	int totalRow = 0;
	PreparedStatement stmt2 = null;
	if(searchWord.equals("")) {
		stmt2 = conn.prepareStatement("select count(*) from employees e inner join departments d inner join dept_emp de on e.emp_no = de.emp_no and d.dept_no = de.dept_no");
	} else {
		//stmt2 = conn.prepareStatement("select count(*) from employees e inner join departments d inner join dept_emp de on e.emp_no = de.emp_no and d.dept_no = de.dept_no where " + searchValue + " like '%" + searchWord + "%'");
		String sql2 = "select count(*) from employees e inner join departments d inner join dept_emp de on e.emp_no = de.emp_no and d.dept_no = de.dept_no where ";
		// + "%'"
		for(int i=0; i<searchValue.length; i+=1) {
			if(i==0) {
				sql2 = sql2 + searchValue[0] + " like '%" + searchWord;
			} else {
				sql2 = sql2 + "%' or " + searchValue[i] + " like '%" + searchWord;
			}
		}
		sql2 = sql2 + "%'";
		stmt2 = conn.prepareStatement(sql2);
		System.out.println(stmt2 + " <--stmt2");
	}
	ResultSet rs2 = stmt2.executeQuery();
	if(rs2.next()){
		totalRow = rs2.getInt("count(*)");
	}
	lastPage = totalRow/rowPerPage;
	if(totalRow%rowPerPage!=0) {
		lastPage+=1;
	}
	System.out.println(lastPage);
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
			<h1>DeptEmp List</h1>
			<div>
				<form method="post" action="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp">
					<div class="row" style="margin-left: 10px;">
						<span class="col">
							<input type="checkbox" class="form-check-input" id="dept_no" value="d.dept_no" name="searchValue">
							<label class="form-check-label" for="dept_no">dept_no</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="dept_name" value="d.dept_name" name="searchValue">
							<label class="form-check-label" for="dept_name">dept_name</label>
						</span>
						<span class="col">
							<input type="checkbox" class="form-check-input" id="emp_no" value="e.emp_no" name="searchValue">
							<label class="form-check-label" for="emp_no">emp_no</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="birth_date" value="e.birth_date" name="searchValue">
							<label class="form-check-label" for="birth_date">birth_date</label>
						</span>
						<span class="col">
							<input type="checkbox" class="form-check-input" id="first_name" value="e.first_name" name="searchValue">
							<label class="form-check-label" for="first_name">first_name</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="last_name" value="e.last_name" name="searchValue">
							<label class="form-check-label" for="last_name">last_name</label>
						</span>
						<span class="col">
							<input type="checkbox" class="form-check-input" id="gender" value="e.gender" name="searchValue">
							<label class="form-check-label" for="gender">gender</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="hire_date" value="e.hire_date" name="searchValue">
							<label class="form-check-label" for="hire_date">hire_date</label>
						</span>
						<span class="col">
							<input type="checkbox" class="form-check-input" id="from_date" value="de.from_date" name="searchValue">
							<label class="form-check-label" for="from_date">from_date</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="to_date" value="de.to_date" name="searchValue">
							<label class="form-check-label" for="to_date">to_date</label>
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
			<div class="container" style="text-align: center; margin-top: 30px;">
				<table class="table table-hover">
					<thead class="thead-dark">
						<tr>
							<th>dept_no</th>
							<th>dept_name</th>
							<th>emp_no</th>
							<th>birth_date</th>
							<th>first_name</th>
							<th>last_name</th>
							<th>gender</th>
							<th>hire_date</th>
							<th>from_date</th>
							<th>to_date</th>
						</tr>
					</thead>
					<tbody>
						<%for(DeptEmpTotal d : list) {%>
							<tr>
								<th scope="col"><%=d.deptNo %></th>
								<td><%=d.deptName %></td>
								<td><%=d.empNo %></td>
								<td><%=d.birthDate %></td>
								<td><%=d.firstName %></td>
								<td><%=d.lastName %></td>
								<td><%=d.gender %></td>
								<td><%=d.hireDate %></td>
								<td><%=d.fromDate %></td>
								<td><%=d.toDate %></td>
							</tr>
						<%} %>
					</tbody>
				</table>
			</div>
			<div style="text-align: right;">
				<!-- 추가 버튼 -->
				<a href="<%=request.getContextPath() %>/deptEmp/insertDeptEmpForm.jsp" class="btn btn-sm btn-secondary" style="margin: 15px; ">부서 입력</a>
			</div>
			<nav aria-label="Page navigation example">
				<ul class="pagination" style="justify-content: center;">
					<% for(int i=0; i<lastPage; i+=pageGroup) {
						if(currentPage>i && currentPage<=i+5){
							prevPageGroup = currentPage-5;
							nextPageGroup = currentPage+5;
							if(currentPage>5){%>
								<li class="page-item">
									<%if(searchWord.equals("")) {%>
										<a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=1%>" aria-label="First">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=1%><%=sendUrl %>&searchWord=<%=searchWord %>" aria-label="First">
									<%} %>
										<i class="fas fa-angle-double-left"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) {%>
										<a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=prevPageGroup%>" aria-label="Prev">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=prevPageGroup%><%=sendUrl %>&searchWord=<%=searchWord %>" aria-label="Prev">
									<%} %>
										<i class="fas fa-angle-left"></i>
									</a>
								</li>
							<%}
							for(int j=i+1; j<=i+pageGroup; j+=1){
								if(j==currentPage){%>
									<li class="page-item active"><span class="page-link"><%=j %><span class="sr-only">(current)</span></span></li>
								<%} else { %>
									<%if(searchWord.equals("")) {%>
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=j%>"><%=j %></a></li>
									<%} else { %>
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=j%><%=sendUrl %>&searchWord=<%=searchWord %>"><%=j %></a></li>
									<%} %>
								<%}
								if(j==lastPage) {
									break;
								}
							}
							if(currentPage<=lastPageGroup-4) {%>
								<li class="page-item">
									<%if(searchWord.equals("")) {%>
										<a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=nextPageGroup%>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=nextPageGroup%><%=sendUrl %>&searchWord=<%=searchWord %>" aria-label="Next">
									<%} %>
										<i class="fas fa-angle-right"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) {%>
										<a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%><%=sendUrl %>&searchWord=<%=searchWord %>" aria-label="Next">
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