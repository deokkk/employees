<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
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
	.carousel-inner img {
      width: 100%;
      height: 100%;
  	}
  	.carousel-control-prev-icon {
  		background-color: black;
  	}
  	.carousel-control-next-icon {
  		background-color: black;
  	}
  	.carousel-indicators li {
  		background-color: grey;
  	}
</style>
</head>
<body>
<div>
	<!-- navBar -->
	<!-- include 다른페이지 못가져와서 page속성안에 주소에 
	request.getContextPath() 이거 자동으로 붙어서 생략가능 -->
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div class="container-fluid" style="margin-top: 80px;">
	<div class="row">
		<div class="col-xl-2"></div>
		<div class="col-xl-8">
			<h1>Index</h1>
			<div id="demo" class="carousel slide" data-ride="carousel" style="margin-top: 30px;">
				<!-- Indicators -->
				<ul class="carousel-indicators">
					<li data-target="#demo" data-slide-to="0" class="active"></li>
					<li data-target="#demo" data-slide-to="1"></li>
					<li data-target="#demo" data-slide-to="2"></li>
					<li data-target="#demo" data-slide-to="3"></li>
					<li data-target="#demo" data-slide-to="4"></li>
					<li data-target="#demo" data-slide-to="5"></li>
				</ul>
				<!-- The slideshow -->
				<div class="carousel-inner">
					<div class="carousel-item">
						<img src="./imgs/departments.jpg">
					</div>
					<div class="carousel-item">
					<img src="./imgs/employees.jpg">
					</div>
					<div class="carousel-item">
						<img src="./imgs/dept_emp.jpg">
					</div>
					<div class="carousel-item active">
						<img src="./imgs/dept_manager.jpg">
					</div>
					<div class="carousel-item">
						<img src="./imgs/titles.jpg"">
					</div>
					<div class="carousel-item">
						<img src="./imgs/salaries.jpg">
					</div>
				</div>
				<!-- Left and right controls -->
				<a class="carousel-control-prev" href="#demo" data-slide="prev">
					<span class="carousel-control-prev-icon"></span>
				</a>
				<a class="carousel-control-next" href="#demo" data-slide="next">
					<span class="carousel-control-next-icon"></span>
				</a>
			</div>
		</div>
		<div class="col-xl-2"></div>
	</div>
</div>
</body>
</html>