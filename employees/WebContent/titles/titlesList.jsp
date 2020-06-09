<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="gd.emp.*" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>titlesList</title>
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
	int totalRow = 0;
	int lastPage = 0;
	int pageGroup = 5;
	int prevPageGroup = 0;
	int nextPageGroup = 0;
	int lastPageGroup = 0;
	request.setCharacterEncoding("utf-8");
	if(request.getParameter("currentPage")!=null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage")!=null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	int beginRow = (currentPage-1)*rowPerPage;
	
	// database
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	PreparedStatement stmt1 = null;
	// 한 페이지 출력 데이터
	//ArrayList<Titles> list = new ArrayList<Titles>();
	ArrayList<TitlesTotal> list = new ArrayList<TitlesTotal>();
	String searchWord = "";
	String[] searchValue = new String[]{};
	String sendUrl = "";
	if(request.getParameter("searchWord") != null) {
		searchWord = request.getParameter("searchWord");
		searchValue = request.getParameterValues("searchValue");
	}
	//String sendSearchValue = URLEncoder.encode(searchValue);
	System.out.println(searchWord + " <--searchWord");
	if(searchWord.equals("")) {
		// select e.emp_no,	e.birth_date, e.first_name,	e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no order by e.emp_no
		stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no order by e.emp_no asc, t.from_date asc limit ?,?");
	} else {
		// select e.emp_no,	e.birth_date, e.first_name,	e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue + "like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?"
		/* if(searchValue.length==9) {
			stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] +" like '%" + searchWord + "%' or " + searchValue[2] +" like '%" + searchWord + "%' or " + searchValue[3] +" like '%" + searchWord + "%' or " + searchValue[4] +" like '%" + searchWord + "%' or " + searchValue[5] +" like '%" + searchWord + "%' or " + searchValue[6] +" like '%" + searchWord + "%' or " + searchValue[7] +" like '%" + searchWord + "%' or " + searchValue[8] +" like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?");
		} else if(searchValue.length==8) {
			stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] +" like '%" + searchWord + "%' or " + searchValue[2] +" like '%" + searchWord + "%' or " + searchValue[3] +" like '%" + searchWord + "%' or " + searchValue[4] +" like '%" + searchWord + "%' or " + searchValue[5] +" like '%" + searchWord + "%' or " + searchValue[6] +" like '%" + searchWord + "%' or " + searchValue[7] +" like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?");
		} else if(searchValue.length==7) {
			stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] +" like '%" + searchWord + "%' or " + searchValue[2] +" like '%" + searchWord + "%' or " + searchValue[3] +" like '%" + searchWord + "%' or " + searchValue[4] +" like '%" + searchWord + "%' or " + searchValue[5] +" like '%" + searchWord + "%' or " + searchValue[6] +" like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?");
		} else if(searchValue.length==6) {
			stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] +" like '%" + searchWord + "%' or " + searchValue[2] +" like '%" + searchWord + "%' or " + searchValue[3] +" like '%" + searchWord + "%' or " + searchValue[4] +" like '%" + searchWord + "%' or " + searchValue[5] +" like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?");
		} else if(searchValue.length==5) {
			stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] +" like '%" + searchWord + "%' or " + searchValue[2] +" like '%" + searchWord + "%' or " + searchValue[3] +" like '%" + searchWord + "%' or " + searchValue[4] +" like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?");
		} else if(searchValue.length==4) {
			stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] +" like '%" + searchWord + "%' or " + searchValue[2] +" like '%" + searchWord + "%' or " + searchValue[3] +" like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?");
		} else if(searchValue.length==3) {
			stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] +" like '%" + searchWord + "%' or " + searchValue[2] +" like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?");
		} else if(searchValue.length==2) {
			stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] +" like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?");
		} else if(searchValue.length==1) {
			stmt1 = conn.prepareStatement("select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' order by e.emp_no asc, from_date asc, title asc limit ?,?");
		} */
		String sql1 = "select e.emp_no, e.birth_date, e.first_name, e.last_name, e.gender, e.hire_date, t.title, t.from_date, t.to_date from employees e inner join titles t on e.emp_no = t.emp_no where ";
		String order = "%' order by e.emp_no asc, from_date asc, title asc limit ?,?";
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
	while(rs1.next()) {
		TitlesTotal t = new TitlesTotal();
		t.empNo = rs1.getInt("e.emp_no");
		t.birthDate = rs1.getString("e.birth_date");
		t.firstName = rs1.getString("e.first_name");
		t.lastName = rs1.getString("e.last_name");
		t.gender = rs1.getString("e.gender");
		t.hireDate = rs1.getString("e.hire_date");
		t.title = rs1.getString("t.title");
		t.fromDate = rs1.getString("t.from_date");
		t.toDate = rs1.getString("t.to_date");
		list.add(t);
	}
	
	// 전체 데이터
	PreparedStatement stmt2 = null;
	if(searchWord.equals("")) {
		stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no");
	} else {
		/* if(searchValue.length==9) {
			stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' or " + searchValue[4] + " like '%" + searchWord + "%' or " + searchValue[5] + " like '%" + searchWord + "%' or " + searchValue[6] + " like '%" + searchWord + "%' or " + searchValue[7] + " like '%" + searchWord + "%' or " + searchValue[8] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==8) {
			stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' or " + searchValue[4] + " like '%" + searchWord + "%' or " + searchValue[5] + " like '%" + searchWord + "%' or " + searchValue[6] + " like '%" + searchWord + "%' or " + searchValue[7] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==7) {
			stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' or " + searchValue[4] + " like '%" + searchWord + "%' or " + searchValue[5] + " like '%" + searchWord + "%' or " + searchValue[6] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==6) {
			stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' or " + searchValue[4] + " like '%" + searchWord + "%' or " + searchValue[5] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==5) {
			stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%' or " + searchValue[4] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==4) {
			stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%' or " + searchValue[3] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==3) {
			stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%' or " + searchValue[2] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==2) {
			stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%' or " + searchValue[1] + " like '%" + searchWord + "%'");
		} else if(searchValue.length==1) {
			stmt2 = conn.prepareStatement("select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where " + searchValue[0] + " like '%" + searchWord + "%'");
		} */
		String sql2 = "select count(*) from employees e inner join titles t on e.emp_no = t.emp_no where ";
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
	System.out.println(stmt2 + " <--stmt2");
	ResultSet rs2 = stmt2.executeQuery();
	if(rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	//System.out.println(totalRow);
	lastPage = totalRow/rowPerPage;
	if(totalRow%rowPerPage!=0) {
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
			<h1>Titles List</h1>
			<div>
				<form method="post" action="<%=request.getContextPath() %>/titles/titlesList.jsp">
					<div class="row" style="margin-left: 10px;">
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
							<input type="checkbox" class="form-check-input" id="title" value="t.title" name="searchValue">
							<label class="form-check-label" for="title">title</label>
						</span>
						<span class="col">
							<input type="checkbox" class="form-check-input" id="from_date" value="t.from_date" name="searchValue">
							<label class="form-check-label" for="from_date">from_date</label>
						</span>
						<span class="col">	
							<input type="checkbox" class="form-check-input" id="to_date" value="t.to_date" name="searchValue">
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
			<div style="text-align: right; margin-top: 15px;">
				<form method="get" action="<%=request.getContextPath() %>/titles/titlesList.jsp">
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
							<th scope="col">title</th>
							<th scope="col">from_date</th>
							<th scope="col">to_date</th>
						</tr>
					</thead>
					<tbody>
						<%for(TitlesTotal t : list) { %>
							<tr>
								<th scope="col"><%=t.empNo %></th>
								<td><%=t.birthDate %></td>
								<td><%=t.firstName %></td>
								<td><%=t.lastName %></td>
								<td><%=t.gender %></td>
								<td><%=t.hireDate %></td>
								<td><%=t.title %></td>
								<td><%=t.fromDate %></td>
								<td><%=t.toDate %></td>
							</tr>
						<%} %>
					</tbody>
				</table>
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
										<a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=1%>&rowPerPage=<%=rowPerPage %>" aria-label="First">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=1%>&searchWord=<%=searchWord %>&rowPerPage=<%=rowPerPage %><%=sendUrl %>" aria-label="First">
									<%} %>
										<i class="fas fa-angle-double-left"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=prevPageGroup%>&rowPerPage=<%=rowPerPage %>" aria-label="Prev">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=prevPageGroup%>&searchWord=<%=searchWord %>&rowPerPage=<%=rowPerPage %><%=sendUrl %>" aria-label="Prev">
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
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=j%>&rowPerPage=<%=rowPerPage %>"><%=j %></a></li>
									<%} else { %>
										<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=j%>&searchWord=<%=searchWord %>&rowPerPage=<%=rowPerPage %><%=sendUrl %>"><%=j %></a></li>
									<%} 
								}
								if(j==lastPage) {
									break;
								}
							}
							if(currentPage<=lastPageGroup-4) {%>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=nextPageGroup%>&rowPerPage=<%=rowPerPage %>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=nextPageGroup%>&searchWord=<%=searchWord %>&rowPerPage=<%=rowPerPage %><%=sendUrl %>" aria-label="Next">
									<%} %>
										<i class="fas fa-angle-right"></i>
									</a>
								</li>
								<li class="page-item">
									<%if(searchWord.equals("")) { %>
										<a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=lastPage%>&rowPerPage=<%=rowPerPage %>" aria-label="Next">
									<%} else { %>
										<a class="page-link" href="<%=request.getContextPath()%>/titles/titlesList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord %>&rowPerPage=<%=rowPerPage %><%=sendUrl %>" aria-label="Next">
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