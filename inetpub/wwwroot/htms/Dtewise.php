<?php 
session_start();
if (!isset($_SESSION['uid']) || $_SESSION['uid'] == '') {
	$_SESSION['errDesc'] = "Invalid user or the session is expired, please login <a href='index.php'>here</a>";
	header ("Location: error.php");
}
if (!isset($_POST['flg']) || $_POST['flg'] == '') {
	$_SESSION['errDesc'] = "Please use the <a href='main.php'>main menu</a> to navigate to this page";
	header ("Location: error.php");
}
require_once('functions.php');
?>
<table align="center">
<tr>
  <td colspan="2" align="center" bgcolor="#669900">
		<input name="flg" type="hidden" id="flg" value="<?php echo($_POST['flg']) ?>"/>

		&nbsp;&nbsp;<input type="button" name="main" value="Main Menu" onClick="javascript: window.location = 'main.php';" class="btnStyle" style="background-color:#CCFFCC" tabindex="100"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="clear" value="" class="btnStyle" style="background-color:#FC3" onClick="resetForm()" tabindex="95"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="submit" name="showReport" value="" class="btnStyle" style="background-color:#6F3" tabindex="90"/>	
    </td>
  </tr>
</table>

<?php

// Data fetch from table
$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 
require_once('functions.php');

// SEARCH
$departid = $_POST['deptID'];
?>
<h2 align="center"><?php echo $gAppName; ?></h2>
<h2 align="center"><?php echo date("d-m-Y"); //echo $gHostname; ?></h2>
<table border="1" align="center" >

<tr  bgcolor="#999999">
<td>Sr. No</td>
<td>Emply Name</td>
<td>Dte. Name</td>
<td>Time in</td>
<td>Time Out</td>


</tr>

<?php
//User Name
$total = 0;
$empname = sprintf("SELECT USERINFO.Name, DEPARTMENTS.DEPTNAME, Format(Tab.CheckINTime,'hh : nn : ss') AS CheckInTIme, Format(Tab.CheckTimeOut,'hh : nn : ss') AS CheckOutTIme
FROM DEPARTMENTS INNER JOIN ((





Select  USERID, max( CheckTimeIn) as CheckINTime , Max(CheckOutTime) as CheckTimeOut

from (
SELECT USERINFO.USERID, Min(CHECKINOUT.CHECKTIME) AS CheckTimeIn, '' AS CheckOutTime
FROM CHECKINOUT INNER JOIN USERINFO ON CHECKINOUT.USERID = USERINFO.USERID
WHERE (((Format([CHECKINOUT].[CHECKTIME],'dd/mmm/yyyy'))=Format(Date(),'dd/mmm/yyyy'))) and (CHECKINOUT.CHECKTYPE = '1' or  CHECKINOUT.CHECKTYPE = 'I')



GROUP BY USERINFO.USERID

union 


SELECT USERINFO.USERID,''  AS CheckTimeIn, Max(CHECKINOUT.CHECKTIME) AS CheckOutTime
FROM CHECKINOUT INNER JOIN USERINFO ON CHECKINOUT.USERID = USERINFO.USERID
WHERE (((Format([CHECKINOUT].[CHECKTIME],'dd/mmm/yyyy'))=Format(Date(),'dd/mmm/yyyy'))) and (CHECKINOUT.CHECKTYPE = '0' or  CHECKINOUT.CHECKTYPE = 'o')

GROUP BY USERINFO.USERID

) as MyFirstTab
group by MyFirstTab.USERID


)  AS tab Right JOIN USERINFO ON tab.USERID = USERINFO.USERID) ON DEPARTMENTS.DEPTID = USERINFO.DEFAULTDEPTID
WHERE (((DEPARTMENTS.DEPTID)=$departid))
ORDER BY USERINFO.Name; ");
$emnRS = odbc_exec($gDBConn, $empname) or die('SQL Error: ' . odbc_error());
while (odbc_fetch_row($emnRS)){
$employname = odbc_result($emnRS, 'Name');
$deptname= odbc_result($emnRS, 'DEPTNAME');
$deptime= odbc_result($emnRS, 'CheckInTIme');
$deptimeout= odbc_result($emnRS, 'CheckOutTIme');
$total= $total + 1;
//End Username	
echo "<tr>";
echo "<td>$total </td>";
echo "<td>$employname </td>";
echo "<td>$deptname</td>";
echo "<td>$deptime </td>";
echo "<td>$deptimeout </td>";

}
?>
</tr>
</table>
<table align="center">
<tr>
  <td colspan="2" align="center" bgcolor="#669900">
		<input name="flg" type="hidden" id="flg" value="<?php echo($_POST['flg']) ?>"/>

		&nbsp;&nbsp;<input type="button" name="main" value="Main Menu" onClick="javascript: window.location = 'main.php';" class="btnStyle" style="background-color:#CCFFCC" tabindex="100"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="clear" value="" class="btnStyle" style="background-color:#FC3" onClick="resetForm()" tabindex="95"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="submit" name="showReport" value="" class="btnStyle" style="background-color:#6F3" tabindex="90"/>	
    </td>
  </tr>
</table>
