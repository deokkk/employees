<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<title>About</title>
<style>
	.cell-center {
		text-align: center;
	}
	.cell-right {
		text-align: right;
	}
	.cell-middle {
		vertical-align: middle;
	}
	th {
		background-color: #e9ecef;
	}
</style>
</head>
<body>
<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	<div class="col-xl-1"> </div>
	<div class="container-fluid col-xl-10" style="margin-top: 80px;">
		<h1>이력서</h1>
		<!-- 1. 기본정보 -->
		<table class="table table-bordered" style="margin-top: 30px;">
			<tbody>
				<tr>
					<td rowspan="3" style="width: 10%;"><img src="<%=request.getContextPath() %>/imgs/"></td>
					<th rowspan="2" class="cell-center" style="width: 5%; vertical-align: middle;">성 명</th>
					<td class="cell-middle" style="width: 40%; vertical-align: middle;">김경덕</td>
					<th class="cell-center" style="width: 8%; vertical-align: middle;">생년월일</th>
					<td style="width: 37%; vertical-align: middle;">1995년 9월 5일</td>
				</tr>
				<tr>
					<!-- <td>사	진</td> -->
					<!-- <td>성 명</td> -->
					<td style="vertical-align: middle;">Kim GyeongDeok</td>
					<th class="cell-center" style="vertical-align: middle;">휴 대 폰</th>
					<td style="vertical-align: middle;">010-6865-0340</td>
				</tr>
				<tr>
					<!-- <td>사	진</td> -->
					<th class="cell-center" style="vertical-align: middle;">현주소</th>
					<td style="vertical-align: middle;">서울시 강동구 천호1동 구천면로 68나길 16, 101호</td>
					<th class="cell-center" style="vertical-align: middle;">이메일</th>
					<td style="vertical-align: middle;">kims18@nate.com</td>
				</tr>
			</tbody>
		</table>
		
		<!-- 2. 학력사항 -->
		<table class="table table-bordered">
			<tbody>
				<tr class="cell-center">
					<th rowspan="4" style="width: 5%; vertical-align: middle;">학력사항</th>
					<th style="width: 20%">졸업일</th>
					<th style="width: 30%">학교명</th>
					<th style="width: 15%">전공</th>
					<th style="width: 10%">졸업여부</th>
					<th style="width: 10%">소재지</th>
					<th style="width: 10%">성적</th>
				</tr>
				<tr>
					<td class="cell-right"> 2014년 2월</td>
					<td class="cell-right">광문고등학교</td>
					<td>&nbsp;</td>
					<td class="cell-center">졸업</td>
					<td>&nbsp;</td>
					<td class="cell-center"> / </td>
				</tr>
				<tr>
					<td class="cell-right"> 2020년 02월</td>
					<td class="cell-right">한국교통대학교</td>
					<td class="cell-right">전자공학</td>
					<td class="cell-center">졸업</td>
					<td>충북 충주</td>
					<td class="cell-center">3.9 / 4.5</td>
				</tr>
				<tr>
					<td class="cell-right"> 년 월</td>
					<td class="cell-right">대학원</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td class="cell-center"> / </td>
				</tr>
			</tbody>
		</table>
		
		<!-- 3. 경력사항 -->
		<table class="table table-bordered">
			<tbody>
				<tr class="cell-center">
					<th rowspan="4" style="width: 5%; vertical-align: middle;">경력사항</th>
					<th style="width: 30%;">근 무 기 간</th>
					<th style="width: 20%;">회 사 명</th>
					<th style="width: 10%;">직 위</th>
					<th style="width: 20%;">담 당 업 무</th>
					<th style="width: 15%;">퇴사사유</th>
				</tr>
				<tr>
					<td class="cell-center">-</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="cell-center">-</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="cell-center">-</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
			</tbody>
		</table>
		<!-- 4. 기타사항 -->
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th class="cell-center" rowspan="6" style="width: 5%; vertical-align: middle;">기타사항</th>
					<th class="cell-center">신 장</th>
					<td class="cell-right">cm</td>
					<th class="cell-center">체 중</th>
					<td class="cell-right">kg</td>
					<th class="cell-center">시 력</th>
					<td class="cell-center"> / </td>
				</tr>
				<tr>
					<th class="cell-center">취 미</th>
					<td>&nbsp;</td>
					<th class="cell-center">특 기</th>
					<td>&nbsp;</td>
					<th class="cell-center">종 교</th>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<th class="cell-center" rowspan="4" style="vertical-align: middle;">전산능력</th>
					<th class="cell-center">프로그램명</th>
					<th class="cell-center">활용도</th>
					<th class="cell-center" colspan="3">자격증 보유 현황</th>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td colspan="3">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xl-1"> </div>
</body>
</html>