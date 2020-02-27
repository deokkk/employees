<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="gd.emp.Departments" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	// 열 : dept_no, dept_name
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// dept_no 구하는 알고리즘
	// select max(dept_no) from departments
	PreparedStatement stmt1 = conn.prepareStatement("select dept_no from departments order by dept_no desc limit 0,1");
	ResultSet rs1 = stmt1.executeQuery();
	
	String deptNo = "";
	if(rs1.next()) {
		// deptNo = rs.getString("max(dept_no)");
		deptNo = rs1.getString("dept_no");
	}
	//System.out.println(deptNo);
	String deptNo2 = deptNo.substring(1);
	//System.out.println(deptNo2);
	int deptNo3 = Integer.parseInt(deptNo2);
	//System.out.println(deptNo3);
	int nextDeptNo = deptNo3 + 1;
	//System.out.println(nextDeptNo);
	
	String nextDeptNo2 = "";
	if(nextDeptNo/100 > 0) {
		nextDeptNo2 = "d"+nextDeptNo;
	} else if(nextDeptNo/10 > 0) {
		nextDeptNo2 = "d0"+nextDeptNo;
	} else if(nextDeptNo/10 == 0) {
		nextDeptNo2 = "d00"+nextDeptNo;
	}
	//System.out.println(nextDeptNo2);
	
	// dept_name
	String deptName = request.getParameter("deptName");
	
	PreparedStatement stmt2 = conn.prepareStatement("insert into departments(dept_no, dept_name) values(?,?)");
	stmt2.setString(1, nextDeptNo2);
	stmt2.setString(2, deptName);
	stmt2.executeUpdate();
	
	response.sendRedirect(request.getContextPath()+"/departments/departmentsList.jsp");
%>
</body>
</html>