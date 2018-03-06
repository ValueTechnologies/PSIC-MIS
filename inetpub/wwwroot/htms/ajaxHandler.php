<?php session_start(); 
$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 
require_once('functions.php'); 

if (strcmp($_POST['page'], 'absent') == 0) {
	if (strcmp($_POST['item'], 'dept') == 0) {
		echo ('<select name="Emp_Id" id="Emp_Id" style="width: 200px" onChange="changeReportOrder(this)">	   <option value="">--All--</option>');
		if (isset($_POST['id'])) {
		$selSQL = sprintf("SELECT Emp_Id, Dep_Id, Emp_No, Emp_CName, Emp_EName, Emp_Idno, Emp_Birth, Emp_Tel1, Emp_Tel2, Emp_Addr1, Emp_Addr2,
		Emp_Email, Emp_Sex, Emp_Photo, Emp_Password
					FROM Emp
					WHERE IsDelete = '1'
					AND Dep_Id = %s
					ORDER BY Emp_CName", GetSQLValueString($_POST['id'], "text"));
		$rs = odbc_exec ($gDBConn, $selSQL) or die(odbc_error());
		while (odbc_fetch_row($rs)) {
			echo ('<option value="' . odbc_result($rs, 'Emp_Id') . '"' . (isset($_POST['Emp_Id']) && $_POST['Emp_Id'] == odbc_result($rs, 'Emp_Id') ? ' selected' : '') . '>' . odbc_result($rs, 'Emp_CName') . ' ' . odbc_result($rs, 'Emp_EName') . '</option>' . "\n");
		}
		}
		echo ('</select>');
	}
}
?>