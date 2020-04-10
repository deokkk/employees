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
<title>Insert Employee</title>
</head>
<body>
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-3"></div>
		<div class="col-xl-6">
			<h1>Insert Employee</h1>
			<form method="post" action="<%=request.getContextPath() %>/employees/insertEmployeesAction.jsp">
				<div class="form-group row">
					<label for="birthDate" class="col-sm-2 col-form-label">birth_date</label>
					<div class="col-sm-10">
						<input type="date" class="form-control" name="birthDate">
					</div>
				</div>
				<div class="form-group row">
					<label for="firstName" class="col-sm-2 col-form-label">first_name</label>
					<div class="col-sm-10">
						<input type="text" class="form-control" placeholder="Enter first_name" name="firstName">
					</div>
				</div>
				<div class="form-group row">
					<label for="lastName" class="col-sm-2 col-form-label">last_name</label>
					<div class="col-sm-10">
						<input type="text" class="form-control" placeholder="Enter last_name" name="lastName">
					</div>
				</div>
				<fieldset class="form-group">
					<div class="row">
						<legend class="col-form-label col-sm-2 pt-0">gender</legend>
						<div class="col-sm-10">
							<div class="form-check form-check-inline">
								<input class="form-check-input" type="radio" name="gender" value="M" checked>
								<label class="form-check-label">
									남
								</label>
							</div>
							<div class="form-check form-check-inline">
								<input class="form-check-input" type="radio" name="gender" value="F">
								<label class="form-check-label">
									여
								</label>
							</div>
						</div>
					</div>
				</fieldset>
				<div class="form-group row">
					<label for="hireDate" class="col-sm-2 col-form-label">hire_date</label>
					<div class="col-sm-10">
						<input type="date" class="form-control" name="hireDate">
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