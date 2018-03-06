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
<!DOCTYPE html>
<html id="home" lang="en">
<head>
<meta charset=utf-8 />
<title><?php echo($gPageTitle) ?></title>
<link rel="shortcut icon" href="images/company.ico" /> 
<link rel="stylesheet" type="text/css" href="main.css" />

<script src="ajax.js" type="text/javascript"></script>
<script src="date.js" type="text/javascript"></script>
<script language="JavaScript">
function nextRecord () {
	document.getElementById('nextRec').value = 'true';
	document.forms['form1'].submit();
}

function validateForm () {
	var frmElems = document.forms['form1'].elements;
	
	//for (i = 0; i < frmElems.length; i++) {

	//	var elem = frmElems[i]; 
		
		//if (elem.name == "aname" && elem.value == "") {
		//	alert('Recovery Account Head is required');
		//	elem.focus();
		//	return false;

		//}
	//}
	return true;
}
</script>
</head>

<body>
<h1 align="center"><?php echo($gCompanyName) ?></h1>
<h3 align="center"><?php echo($gAppName) ?></h3>
<p>&nbsp;</p>

<?php 
if (strpos($_POST['flg'], 'Edit') !== false && isset($_POST['save']) && $_POST['save'] != '' && isset($_POST['nextRec']) && $_POST['nextRec'] == 'false') { 

	// TRIMMING VALUES
	foreach ($_POST as $pn => $pv)
		$_POST[$pn] = trim($pv);
}

$pageItem = 'Employee';
$tabTitle = 'Please edit Employee record:';
$pageFor = 'Edit';
?>

<form id="form1" name="form1" method="post">
  <table width="600" height="250" border="0" align="center" bgcolor="#CDFFFF">
<tr>
<td colspan="2" align="center" class="gStyle5"><?php echo($pageItem . ' - ' . $pageFor); ?></td>
</tr>
<tr>
<td colspan="2"><?php echo($tabTitle); ?></td>
 </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Directorate:</td>
    <td><select name="deptID" id="deptID" style="width: 150px" onChange="sendRequest('page=absent&item=dept&id='+this.value, 'empDiv')">
	   <option value="">--All--</option>
	<?php 
		$gDatabase = 'HAMS.mdb';
		require_once('conn.php'); 
		$selSQL = "SELECT code AS deptID, name, director, phone, fax, address, zip, isDelete 
					FROM dept 
					WHERE inID = '0000000001' 
					AND isDelete = '1'
					ORDER BY name";
		$rs = odbc_exec ($gDBConn, $selSQL) or die(odbc_error());
		while (odbc_fetch_row($rs)) {
			echo ('<option value="' . odbc_result($rs, 'deptID') . '"' . (isset($_POST['deptID']) && $_POST['deptID'] == odbc_result($rs, 'deptID') ? ' selected' : '') . '>' . odbc_result($rs, 'name') . '</option>' . "\n");
		}
	?>
		</select></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Employee:</td>
    <td><div id="empDiv"><select name="Emp_Id" id="Emp_Id" style="width: 200px" onChange="changeReportOrder(this)">
	   <option value="">--All--</option>
		</select></div></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Attendance Type:</td>
    <td><select name="aType" id="aType" style="width: 100px">
	   <option value="1">--All--</option>
	   <option value="2" <?php echo(isset($_POST['aType']) && $_POST['aType'] == '2' ? ' selected' : '') ?>>Present Only</option>
	   <option value="3" <?php echo(isset($_POST['aType']) && $_POST['aType'] == '3' ? ' selected' : '') ?>>Absent Only</option>
		</select></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Report Order Wise:</td>
    <td><select name="rptOrder" id="rptOrder" style="width: 150px">
	   <option value="1" <?php echo(isset($_POST['rptOrder']) && $_POST['rptOrder'] == '1' ? ' selected' : '') ?>>Date Wise</option>
	   <option value="2" <?php echo(isset($_POST['rptOrder']) && $_POST['rptOrder'] == '2' ? ' selected' : '') ?>>Employee Wise</option>
		</select></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;From Date: (yyyy-mm-dd) </td>
    <td><input name="fromDt" id="fromDt" type="text" maxlength="10" size="15" value="<?php echo(isset($_POST['fromDt']) ? $_POST['fromDt'] : date("Y-m-d")) ?>" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To Date: (yyyy-mm-dd) </td>
    <td><input name="toDt" id="toDt" type="text" maxlength="10" size="15" value="<?php echo(isset($_POST['toDt']) ? $_POST['toDt'] : date("Y-m-d")) ?>" /></td>
  </tr>
  <?php if (strpos($_POST['flg'], 'Report') !== false) { ?>
      <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Report Format: </td>
        <td><select name="rptFormat" id="rptFormat">
	   <option value="html" <?php echo(isset($_POST['rptFormat']) && $_POST['rptFormat'] == "html" ? 'selected' : '') ?>>HTML</option>
	   <option value="pdf" <?php echo(isset($_POST['rptFormat']) && $_POST['rptFormat'] == "pdf" ? 'selected' : '') ?>>PDF</option>
	   <option value="excel" <?php echo(isset($_POST['rptFormat']) && $_POST['rptFormat'] == "excel" ? 'selected' : '') ?>>Excel</option>
		</select></td>
      </tr>
  <?php } ?>
  <tr><td colspan="2">&nbsp;</td></tr>
  <tr>
  <td colspan="2" align="center" bgcolor="#669900">
		<input name="flg" type="hidden" id="flg" value="<?php echo($_POST['flg']) ?>"/>

		&nbsp;&nbsp;<input type="button" name="main" value="Main Menu" onClick="javascript: window.location = 'main.php';" class="btnStyle" style="background-color:#CCFFCC" tabindex="100"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="clear" value="Clear" class="btnStyle" style="background-color:#FC3" onClick="resetForm()" tabindex="95"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="submit" name="showReport" value="Show Report" class="btnStyle" style="background-color:#6F3" tabindex="90"/>	
    </td>
  </tr>
</table>
</form>

<script type="text/javascript">
	var elem = document.getElementById('deptID');
	if (elem.disabled == false)
		elem.focus();
	else
		document.getElementById('Emp_Id').focus();
</script>

<?php if (isset($msg)) { ?>
<script type="text/javascript"> 
	<?php echo($msg); ?> 
</script>
<?php } ?>

</body>
</html>
