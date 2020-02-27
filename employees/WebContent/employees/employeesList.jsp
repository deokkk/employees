<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="gd.emp.Employees" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>employeesList</title>
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
	// 1. 페이지
	int currentPage = 1;	// 현재페이지
	int lastPage = 0;		// 마지막페이지
	int pageGroup = 5;
	int nextPageGroup = 0;
	int prevPageGroup = 0;
	request.setCharacterEncoding("utf-8");
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;	// 한 페이지에 출력할 행 수
	if(request.getParameter("rowPerPage")!=null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	int beginRow = (currentPage-1)*rowPerPage;	// 출력시작할 행
	
	// 2. database
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 3. 현재 페이지의 employees테이블 행들
	PreparedStatement stmt1 = null;
	ArrayList<Employees> list = new ArrayList<Employees>();
	String searchValue[] = new String[]{};
	String searchWord = "";
	String sendUrl = "";	// searchValue 넘길 문자열
	if(request.getParameter("searchWord") != null) {
		searchValue = request.getParameterValues("searchValue");
		searchWord = request.getParameter("searchWord");
	}
	if(searchWord.equals("")) {
		stmt1 = conn.prepareStatement("select emp_no, birth_date, first_name, last_name, gender, hire_date from employees order by emp_no asc limit ?,?");
	} else {
		/* if(searchValue.length==6) {
			stmt1 = conn.prepareStatement("select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' or " + searchValue[4] + " like '%" + searchWord + "%' or " + searchValue[5] + " like '%" + searchWord + "%' order by emp_no asc limit ?,?");
			sendUrl = "&searchValue="+searchValue[0]+"&searchValue="+searchValue[1]+"&searchValue="+searchValue[2]+"&searchValue="+searchValue[3]+"&searchValue="+searchValue[4]+"&searchValue="+searchValue[5];
		} else if(searchValue.length==5) {
			stmt1 = conn.prepareStatement("select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' or " + searchValue[4] + " like '%" + searchWord + "%' order by emp_no asc limit ?,?");
			sendUrl = "&searchValue="+searchValue[0]+"&searchValue="+searchValue[1]+"&searchValue="+searchValue[2]+"&searchValue="+searchValue[3]+"&searchValue="+searchValue[4];
		} else if(searchValue.length==4) {
			stmt1 = conn.prepareStatement("select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' order by emp_no asc limit ?,?");
			sendUrl = "&searchValue="+searchValue[0]+"&searchValue="+searchValue[1]+"&searchValue="+searchValue[2]+"&searchValue="+searchValue[3];
		} else if(searchValue.length==3) {
			stmt1 = conn.prepareStatement("select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' order by emp_no asc limit ?,?");
			sendUrl = "&searchValue="+searchValue[0]+"&searchValue="+searchValue[1]+"&searchValue="+searchValue[2];
		} else if(searchValue.length==2) {
			stmt1 = conn.prepareStatement("select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' order by emp_no asc limit ?,?");
			sendUrl = "&searchValue="+searchValue[0]+"&searchValue="+searchValue[1];
		} else if(searchValue.length==1){
			stmt1 = conn.prepareStatement("select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where " + searchValue[0] + " like '%" + searchWord + "%' order by emp_no asc limit ?,?");
			sendUrl = "&searchValue="+searchValue[0];
		} */
		String sql1 = "select emp_no, birth_date, first_name, last_name, gender, hire_date from employees where ";
		String order = "%' order by emp_no asc limit ?,?";
		for(int i=0; i<searchValue.length; i+=1) {
			if(i==0) {
				sql1 = sql1 + searchValue[0] + " like '%" + searchWord;
				sendUrl = "&searchValue=" + searchValue[0];
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
	System.out.println(stmt1 + " <--stmt1");
	ResultSet rs1 = stmt1.executeQuery();
	while(rs1.next()){		//각 행들 list에 저장
		Employees e = new Employees();
		e.empNo = rs1.getInt("emp_no");
		e.birthDate = rs1.getString("birth_date");
		e.firstName = rs1.getString("first_name");
		e.lastName = rs1.getString("last_name");
		e.gender = rs1.getString("gender");
		e.hireDate = rs1.getString("hire_date");
		list.add(e);
	}
	
	// 4. employees 전체 행
	int totalRow = 0;		// 전체 행 수
	PreparedStatement stmt2 = null;
	if(searchWord.equals("")) {
		stmt2 = conn.prepareStatement("select count(*) from employees");
	} else {
		/* if(searchValue.length==6) {
			stmt2 = conn.prepareStatement("select count(*) from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' or " + searchValue[4] + " like '%" + searchWord + "%' or " + searchValue[5] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==5) {
			stmt2 = conn.prepareStatement("select count(*) from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' or " + searchValue[4] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==4) {
			stmt2 = conn.prepareStatement("select count(*) from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==3) {
			stmt2 = conn.prepareStatement("select count(*) from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==2) {
			stmt2 = conn.prepareStatement("select count(*) from employees where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==1){
			stmt2 = conn.prepareStatement("select count(*) from employees where " + searchValue[0] + " like '%" + searchWord + "%'");
		} */
		String sql2 = "select count(*) from employees where ";
		for(int i=0; i<searchValue.length; i+=1) {
			if(i==0) {
				sql2 = sql2 + searchValue[0] + " like '%" + searchWord;
			} else {
				sql2 = sql2 + "%' or " + searchValue[i] + " like '%" + searchWord;
			}
		}
		sql2 = sql2 + "%'";
		stmt2 = conn.prepareStatement(sql2);
	}
	ResultSet rs2 = stmt2.executeQuery();
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	lastPage = totalRow/rowPerPage;
	if(totalRow%lastPage != 0) {
		lastPage+=1;
	}
	//System.out.println(lastPage);
	int lastPageGroup = lastPage-(lastPage%pageGroup);
	System.out.println(lastPageGroup);
	// page갯수 5개씩 보여주고
	// 6개 이상이면 <버튼 이전 5개 페이지나오게, >버튼 다음 5개페이지, >>버튼 마지막페이지
	
%>
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-2"></div>
		<div class="col-xl-8">
			<h1>Employees List</h1>
			<div>
				<form method="post" action="<%=request.getContextPath() %>/employees/employeesList.jsp">
					<div class="row" style="margin-left: 10px;">
						<span class="col">
							<input type="checkbox" class="form-check-input" id="emp_no" value="emp_no" name="searchValue">
							<label class="form-check-label" for="emp_no">emp_no</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="birth_date" value="birth_date" name="searchValue">
							<label class="form-check-label" for="birth_date">birth_date</label>
						</span>
						<span class="col">
							<input type="checkbox" class="form-check-input" id="first_name" value="first_name" name="searchValue">
							<label class="form-check-label" for="first_name">first_name</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="last_name" value="last_name" name="searchValue">
							<label class="form-check-label" for="last_name">last_name</label>
						</span>
						<span class="col">
							<input type="checkbox" class="form-check-input" id="gender" value="gender" name="searchValue">
							<label class="form-check-label" for="gender">gender</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="hire_date" value="hire_date" name="searchValue">
							<label class="form-check-label" for="hire_date">hire_date</label>
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
			<div style="text-align: right; margin-top: 15px;">
				<form method="get" action="<%=request.getContextPath() %>/employees/employeesList.jsp">
					<select name="rowPerPage">
						<option value="10">10개씩 보기</option>
						<option value="20">20개씩 보기</option>
						<option value="30">30개씩 보기</option>
					</select>
					<button class="btn btn-sm btn-secondary" type="submit">확인</button>
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
						</tr>
					</thead>
					<tbody>
						<%for(Employees e : list) { %>
							<tr>
								<th scope="col"><%=e.empNo %></th>
								<td><%=e.birthDate %></td>
								<td><%=e.firstName %></td>
								<td><%=e.lastName %></td>
								<td><%=e.gender %></td>
								<td><%=e.hireDate %></td>
							</tr>
						<%} %>
					</tbody>
				</table>
			</div>
			<div style="text-align: right;">
				<!-- 추가 버튼 -->
				<a href="<%=request.getContextPath() %>/employees/insertEmployeesForm.jsp" class="btn btn-sm btn-secondary" style="margin: 15px; ">부서 입력</a>
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
										<a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=1%>&rowPerPage=<%=rowPerPage %>" aria-label="First">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=1%>&rowPerPage=<%=rowPerPage %><%=sendUrl %>&searchWord=<%=searchWord %>" aria-label="First"> 
									<%} %>
										<i class="fas fa-angle-double-left"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) {%>
										<a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=prevPageGroup%>&rowPerPage=<%=rowPerPage %>" aria-label="Prev">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=prevPageGroup%>&rowPerPage=<%=rowPerPage %><%=sendUrl %>&searchWord=<%=searchWord %>" aria-label="Prev">
									<%} %>
										<i class="fas fa-angle-left"></i>
									</a>
								</li>
							<%}
							for(int j=i+1; j<=i+pageGroup; j+=1){
								if(j==currentPage){%>
									<li class="page-item active"><span class="page-link"><%=j %><span class="sr-only">(current)</span></span></li>
								<%} else { 
									if(searchWord.equals("")) {%>
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=j%>&rowPerPage=<%=rowPerPage %>"><%=j %></a></li>
									<%} else { %>
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=j%>&rowPerPage=<%=rowPerPage %><%=sendUrl %>&searchWord=<%=searchWord %>"><%=j %></a></li>
									<%} %>
								<%}
								if(j==lastPage) {
									break;
								}
							}
							if(currentPage<=lastPageGroup-4) {%>
								<li class="page-item">
									<%if(searchWord.equals("")) {%>
										<a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=nextPageGroup%>&rowPerPage=<%=rowPerPage %>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=nextPageGroup%>&rowPerPage=<%=rowPerPage %><%=sendUrl %>&searchWord=<%=searchWord %>" aria-label="Next">
									<%} %>
										<i class="fas fa-angle-right"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) {%>
										<a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=lastPage%>&rowPerPage=<%=rowPerPage %>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/employees/employeesList.jsp?currentPage=<%=lastPage%>&rowPerPage=<%=rowPerPage %><%=sendUrl %>&searchWord=<%=searchWord %>" aria-label="Next"> 
									<%} %>
										<i class="fas fa-angle-double-right"></i>
									</a>
								</li>
							<%}
						}
					}%>
				</ul>
			</nav>
			<div class="container" style="text-align: center;">
				<form method="get" action="./employeesList.jsp">
					<label>이동 : </label>
					<input type="text" name="currentPage" placeholder="Page Number">
					<button type="submit" class="btn btn-secondary btn-sm"">이동</button>
				</form>
			</div>
		</div>
		<div class="col-xl-2"></div>
	</div>
</div>
</body>
</html>