<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="gd.emp.Employees" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	// employees emp_no 최대값 구하기
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	PreparedStatement stmt1 = conn.prepareStatement("select emp_no from employees order by emp_no desc limit 0,1");
	ResultSet rs1 = stmt1.executeQuery();
	
	int empNo = 0;
	if(rs1.next()) {
		empNo = rs1.getInt("emp_no");
	}
	//System.out.println(emp_no);
	int nextEmpNo = empNo+1;
	//System.out.println(nextEmpNo);
	
	// 나머지 값들 database에 저장
	request.setCharacterEncoding("utf-8");
	String birthDate = request.getParameter("birthDate");
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String gender = request.getParameter("gender");
	String hireDate = request.getParameter("hireDate");
	PreparedStatement stmt2 = conn.prepareStatement("insert into employees(emp_no, birth_date, first_name, last_name, gender, hire_date) values(?,?,?,?,?,?)");
	stmt2.setInt(1, nextEmpNo);
	stmt2.setString(2, birthDate);
	stmt2.setString(3, firstName);
	stmt2.setString(4, lastName);
	stmt2.setString(5, gender);
	stmt2.setString(6, hireDate);	
	stmt2.executeUpdate();
	
	response.sendRedirect(request.getContextPath() + "/employees/employeesList.jsp");
%>
</body>
</html>