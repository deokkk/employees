<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
	<div class="col-xl-3"></div>
	<div class="6">
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarSupportedContent">
		    <ul class="navbar-nav mr-auto">
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath() %>/index.jsp"><i class="fas fa-home"></i> Home</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath() %>/about.jsp"><i class="fas fa-address-card"></i> About</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath() %>/departments/departmentsList.jsp"><i class="fas fa-building"></i> Departments</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath() %>/employees/employeesList.jsp"><i class="fas fa-user"></i> Employees</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp"><i class="fas fa-user-tag"></i> DeptEmp</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath() %>/deptManager/deptManagerList.jsp"><i class="fas fa-user-cog"></i> DeptManager</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath() %>/titles/titlesList.jsp"><i class="fas fa-book"></i> Titles</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath() %>/salaries/salariesList.jsp"><i class="fas fa-money-check-alt"></i> Salaries</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath() %>/qna/qnaList.jsp"><i class="fas fa-question-circle"></i> QnA</a>
				</li>
		    </ul>
		</div>
	</div>
	<div class="col-xl-3"></div>
</nav>

<%-- <%System.out.println(request.getContextPath()); %> --%>