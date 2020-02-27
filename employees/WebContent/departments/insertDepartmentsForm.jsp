<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
<title>Insert Department</title>
</head>
<body>
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-3"></div>
		<div class="col-xl-6">
			<h1>Insert Department</h1>
			<form method="post" action="<%=request.getContextPath() %>/departments/insertDepartmentsAction.jsp" style="margin-top: 30px;">
				<div class="form-group row">
					<label for="deptName" class="col-sm-2 col-form-label">dept_name</label>
					<div class="col-sm-10">
						<input type="text" class="form-control" placeholder="Enter dept_name" name="deptName">
					</div>
				</div>
				<div style="text-align: right;">
					<button type="submit" class="btn btn-secondary btn-sm">입력</button>
				</div>
			</form>
		</div>
		<div class="col-xl-3"></div>
	</div>	
</div>
</body>
</html>