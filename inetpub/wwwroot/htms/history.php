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

<script type="text/javascript" src="date.js"></script>
<script language="javascript">
function nextRecord () {
	document.getElementById('nextRec').value = 'true';
	document.forms['form1'].submit();
}

function ShowOrHideDiv (itm) {
	var corp = document.getElementById('corporate_setup');
	var ele = document.getElementById(itm);

	if (corp.value == 1) 
		ele.style.display = "block";
	else {
		ele.style.display = "none";

		var frmElems = document.forms['form1'].elements;
		for (i = 0; i < frmElems.length; i++) {
			switch (frmElems[i].name.substr(0, 4)) {
				case "pnam": // pname
				case "psha": // pshare
				case "pgpa": // pgpa
				case "pcni": // pcnic
				case "pcon": // pcontact
					frmElems[i].value = "";
					break;
			}
		}
	}
}

function resetForm () {
	var frmElems = document.forms['form1'].elements;
	var flg = document.getElementById('flg').value;
	
	for (i = 0; i < frmElems.length; i++) {

		var fieldType = frmElems[i].type.toLowerCase();
		
		if (frmElems[i].name == "sno") {
			continue;
		}

		if (frmElems[i].name == "flg") {
			continue;
		}

		switch (fieldType) {
			case "text":
			case "password":
			case "textarea":
			case "hidden":
				frmElems[i].value = "";
				break;
				
			case "radio":
			case "checkbox":
				if (frmElems[i].checked) {
					frmElems[i].checked = false;
				}
				break;

			case "select-one":
			case "select-multi":
				frmElems[i].selectedIndex = -1;
				break;
				
			default:
			break;
		}
	}
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

<?php 
require_once('conn.php'); 

mysql_select_db($gDatabase, $gDBConn);

// ADD IS FROM 'PLOT STATUS' SCREEN

if (strpos($_POST['flg'], 'Edit') !== false && isset($_POST['save']) && $_POST['save'] != '' && isset($_POST['nextRec']) && $_POST['nextRec'] == 'false') { 

	// TRIMMING VALUES
	foreach ($_POST as $pn => $pv)
		$_POST[$pn] = trim($pv);
	
	// ADD RECORD IN DATABASE TABLE OF CHANGE ONLY
	$selSQL = sprintf("SELECT * FROM history WHERE plot_id = %s AND sno = %s", $_SESSION['userPlot'], $_POST['sno']);
	$dbRS = mysql_query($selSQL, $gDBConn) or die(mysql_error());
	$row = mysql_fetch_assoc ($dbRS);

	$upd = '';

	foreach ($_POST as $pn => $pv) {
		// handle exceptions
		if ($pn == 'save' || $pn == 'flg' || $pn == 'nextRec')
			continue;
		 
		if (strcmp($_POST[$pn], $row[$pn]) != 0) 
			$upd = $upd . sprintf ('%s = %s', $pn, GetSQLValueString($pv, 'text')) . ', ';
	}
	$upd = trim ($upd, ', ');

	if ($upd != '') { // UPDATE IN HISTORY
		$updateSQL = sprintf("UPDATE history SET %s WHERE plot_id = %s AND sno = %s", $upd, $_SESSION['userPlot'], $_POST['sno']);
		$dbRS = mysql_query($updateSQL, $gDBConn) or die(mysql_error());

		$msg = "alert('Plot History Updated Successfully');";

	} else { // NOTHING TO SAVE
		$msg = "alert('No changes were made hence not saved.');";
	}

} else if (strpos($_POST['flg'], 'Edit') !== false && isset($_POST['del']) && $_POST['del'] != '') { 

	$updateSQL = sprintf("DELETE FROM history WHERE plot_id = %s AND sno = %s;",
			  $_SESSION['userPlot'], GetSQLValueString($_POST['sno'], "int"));

	$dbRS = mysql_query($updateSQL, $gDBConn) or die(mysql_error());

	foreach ($_POST as $pn => $pv) {
		// handle exceptions
		if ($pn == 'save' || $pn == 'flg' || $pn == 'delete' || $pn == 'nextRec') 
			continue;
		$_POST[$pn] = '';		 
	}
	
	$msg = "alert('Plot Selected History Record Deleted Successfully');";

} else if (strpos($_POST['flg'], 'Edit') !== false && !isset($_POST['save']) || (isset($_POST['nextRec']) && $_POST['nextRec'] == 'true')) { 

	$selCrit = ' ';
	$orderBy = '';
	$sno = '';
	if (!isset($_POST['sno'])) 
		$sno = sprintf("(SELECT MAX(sno) FROM history WHERE plot_id = %s)", $_SESSION['userPlot']);
	else
		$sno = GetSQLValueString($_POST['sno'], "int");

	$selCrit = $selCrit . sprintf (' AND sno = %s', $sno);
	$orderBy = $orderBy . ($orderBy != '' ? ', ' : ' ORDER BY ') . 'sno DESC';

	$selSQL = sprintf ("SELECT * FROM history WHERE plot_id = %s %s %s", $_SESSION['userPlot'], $selCrit, $orderBy);
	//echo ('$selSQL:' . $selSQL);
	$dbRS = mysql_query($selSQL, $gDBConn) or die(mysql_error());
	$numRows = mysql_num_rows ($dbRS);

	if ($numRows == 0) {
		$_POST['flg'] = 'Edit'; 
		$msg = "<script type=\"text/javascript\">\n";
		$msg = $msg . "alert('No history found of this plot');\n";
		$msg = $msg . "window.location = 'main.php';\n";
		$msg = $msg . "</script>\n";
		echo($msg);
		return;

	} else { // FOUND
		$_POST['flg'] = 'Edit';
		$row = mysql_fetch_assoc ($dbRS);

		foreach ($row as $pn => $pv) {
			// handle exceptions
			if ($pn == 'plot_id') 
				continue;
			$_POST[$pn] = $row[$pn];
		}
	}
}

$pageItem = 'Plot History - Edit';

$selSQL = sprintf("SELECT * FROM plot WHERE plot_id = %s", $_SESSION['userPlot']);
$dbRS = mysql_query($selSQL, $gDBConn) or die(mysql_error());
$row = mysql_fetch_assoc ($dbRS);
$pageItem = $pageItem . ': ' . ($_SESSION['userArea'] == 0 ? $row['area_name'] . ' - ' : '') . $row['plot_no'] . ' - ' . $row['category'] . ' - ' . $row['unit_name'] . ' - ' . $row['owner_name'] . ' -  ' . $row['contact_no'];
?>

<form id="form1" name="form1" method="post">
<table width="1000" height="250" border="0" align="center" bgcolor="#CDFFFF">
<tr>
<td colspan="4" align="center" class="gStyle5"><?php echo($pageItem); ?></td>
</tr>
<tr><td colspan="4" align="center">
	<table border="0" align="center">
	<tr>
<td>&nbsp;&nbsp;History ID:</td><td><select name="sno" id="sno" style="width: 50px" onChange="nextRecord()">
	<?php 
		$selSQL = sprintf("SELECT * FROM history WHERE plot_id = %s ORDER BY sno DESC", $_SESSION['userPlot']);
		$dbRS = mysql_query($selSQL, $gDBConn) or die(mysql_error());
		$i = 1;
		while ($row = mysql_fetch_assoc ($dbRS)) {
			echo ('<option value="' . $row['sno'] . '"' . (isset($_POST['sno']) && $_POST['sno'] == $row['sno'] ? ' selected' : '') . '>' . $i . '</option>' . "\n");
			$i++;
		}
	?>
		</select></td>
<td>&nbsp;&nbsp;Unit Name:</td><td><input name="unit_name" type="text" id="unit_name" value="<?php echo($_POST['unit_name']) ?>" size="25" /></td>
<td>&nbsp;&nbsp;Owner Name:</td><td><input name="owner_name" type="text" id="owner_name" value="<?php echo($_POST['owner_name']) ?>" size="25" /></td>
<td>&nbsp;&nbsp;Contact #:</td><td><input name="contact_no" type="text" id="contact_no" value="<?php echo($_POST['contact_no']) ?>" size="10" /></td>
<td>&nbsp;&nbsp;Corporate Setup:</td><td><select name="corporate_setup" id="corporate_setup" style="width: 100px" onChange="ShowOrHideDiv('divCorp')">
	   <option value="" <?php echo(is_null($_POST['corporate_setup']) ? ' selected' : '') ?>></option>
	   <option value="0" <?php echo($_POST['corporate_setup'] == '0' ? ' selected' : '') ?>>Solo Proprietorship</option>
	   <option value="1" <?php echo($_POST['corporate_setup'] == '1' ? ' selected' : '') ?>>Partnership</option>
		</select></td>
	</tr>
	</table>
</td></tr>
<tr><td colspan="4" align="center">
	<div id="divCorp" style="display:<?php echo($_POST['corporate_setup'] == '1' ? 'block' : 'none') ?>">
	<table border="0" align="center" style="border:outset">
	<tr><td>&nbsp;&nbsp;<b>Sr#</b></td><td>&nbsp;&nbsp;<b>Partner Name</b></td><td>&nbsp;&nbsp;<b>Shares %age</b></td><td>&nbsp;&nbsp;<b>GPA</b></td><td>&nbsp;&nbsp;<b>CNIC</b></td><td>&nbsp;&nbsp;<b>Contact #</b></td></tr>
	<tr>
	<td>1</td>
	<td><input name="pname1" type="text" id="pname1" value="<?php echo($_POST['pname1']) ?>" size="30" /></td>
	<td><input name="pshare1" type="text" id="pshare1" value="<?php echo($_POST['pshare1']) ?>" size="7" /></td>
	<td><input name="pgpa1" type="text" id="pgpa1" value="<?php echo($_POST['pgpa1']) ?>" size="30" /></td>
	<td><input name="pcnic1" type="text" id="pcnic1" value="<?php echo($_POST['pcnic1']) ?>" size="15" /></td>
	<td><input name="pcontact1" type="text" id="pcontact1" value="<?php echo($_POST['pcontact1']) ?>" size="15" /></td>
	</tr>
	<tr>
	<td>2</td>
	<td><input name="pname2" type="text" id="pname2" value="<?php echo($_POST['pname2']) ?>" size="30" /></td>
	<td><input name="pshare2" type="text" id="pshare2" value="<?php echo($_POST['pshare2']) ?>" size="7" /></td>
	<td><input name="pgpa2" type="text" id="pgpa2" value="<?php echo($_POST['pgpa2']) ?>" size="30" /></td>
	<td><input name="pcnic2" type="text" id="pcnic2" value="<?php echo($_POST['pcnic2']) ?>" size="15" /></td>
	<td><input name="pcontact2" type="text" id="pcontact2" value="<?php echo($_POST['pcontact2']) ?>" size="15" /></td>
	</tr>
	<tr>
	<td>3</td>
	<td><input name="pname3" type="text" id="pname3" value="<?php echo($_POST['pname3']) ?>" size="30" /></td>
	<td><input name="pshare3" type="text" id="pshare3" value="<?php echo($_POST['pshare3']) ?>" size="7" /></td>
	<td><input name="pgpa3" type="text" id="pgpa3" value="<?php echo($_POST['pgpa3']) ?>" size="30" /></td>
	<td><input name="pcnic3" type="text" id="pcnic3" value="<?php echo($_POST['pcnic3']) ?>" size="15" /></td>
	<td><input name="pcontact3" type="text" id="pcontact3" value="<?php echo($_POST['pcontact3']) ?>" size="15" /></td>
	</tr>
	<tr>
	<td>4</td>
	<td><input name="pname4" type="text" id="pname4" value="<?php echo($_POST['pname4']) ?>" size="30" /></td>
	<td><input name="pshare4" type="text" id="pshare4" value="<?php echo($_POST['pshare4']) ?>" size="7" /></td>
	<td><input name="pgpa4" type="text" id="pgpa4" value="<?php echo($_POST['pgpa4']) ?>" size="30" /></td>
	<td><input name="pcnic4" type="text" id="pcnic4" value="<?php echo($_POST['pcnic4']) ?>" size="15" /></td>
	<td><input name="pcontact4" type="text" id="pcontact4" value="<?php echo($_POST['pcontact4']) ?>" size="15" /></td>
	</tr>
	<tr>
	<td>5</td>
	<td><input name="pname5" type="text" id="pname5" value="<?php echo($_POST['pname5']) ?>" size="30" /></td>
	<td><input name="pshare5" type="text" id="pshare5" value="<?php echo($_POST['pshare5']) ?>" size="7" /></td>
	<td><input name="pgpa5" type="text" id="pgpa5" value="<?php echo($_POST['pgpa5']) ?>" size="30" /></td>
	<td><input name="pcnic5" type="text" id="pcnic5" value="<?php echo($_POST['pcnic5']) ?>" size="15" /></td>
	<td><input name="pcontact5" type="text" id="pcontact5" value="<?php echo($_POST['pcontact5']) ?>" size="15" /></td>
	</tr>
	<tr>
	<td>6</td>
	<td><input name="pname6" type="text" id="pname6" value="<?php echo($_POST['pname6']) ?>" size="30" /></td>
	<td><input name="pshare6" type="text" id="pshare6" value="<?php echo($_POST['pshare6']) ?>" size="7" /></td>
	<td><input name="pgpa6" type="text" id="pgpa6" value="<?php echo($_POST['pgpa6']) ?>" size="30" /></td>
	<td><input name="pcnic6" type="text" id="pcnic6" value="<?php echo($_POST['pcnic6']) ?>" size="15" /></td>
	<td><input name="pcontact6" type="text" id="pcontact6" value="<?php echo($_POST['pcontact6']) ?>" size="15" /></td>
	</tr>
	</table>
	</div>
</td></tr>
  <tr>
    <td width="25%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Allotment Date:(ddmmyy)</td>
    <td width="25%"> <input name="allot_dt" type="text" id="allot_dt" value="<?php echo($_POST['allot_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="51" /></td>
    <td width="25%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Building Completion Date:</td>
    <td width="25%"> <input name="building_comp_dt" type="text" id="building_comp_dt" value="<?php echo($_POST['building_comp_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="63" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Allotment Area:</td>
    <td> <input name="allot_area" type="text" id="allot_area" value="<?php echo($_POST['allot_area']) ?>" size="10" tabindex="52" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Partnership Deed Date:</td>
    <td> <input name="partnership_deed_dt" type="text" id="partnership_deed_dt" value="<?php echo($_POST['partnership_deed_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="64" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Excess Area Alloted:</td>
    <td> <input name="excess_area" type="text" id="excess_area" value="<?php echo($_POST['excess_area']) ?>" size="10" tabindex="53" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Dissolution Deed Date:</td>
    <td> <input name="dissolution_deed_dt" type="text" id="dissolution_deed_dt" value="<?php echo($_POST['dissolution_deed_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="65" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total Area:</td>
    <td> <input name="total_area" type="text" id="total_area" value="<?php echo($_POST['total_area']) ?>" size="10" tabindex="54" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Transfer of Project Date:</td>
    <td> <input name="project_transfer_dt" type="text" id="project_transfer_dt" value="<?php echo($_POST['project_transfer_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="66" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Covered Area:</td>
    <td> <input name="covered_area" type="text" id="covered_area" value="<?php echo($_POST['covered_area']) ?>" size="10" tabindex="55" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Transfer of Project To:</td>
    <td> <input name="project_transfer_to" type="text" id="project_transfer_to" value="<?php echo($_POST['project_transfer_to']) ?>" size="30" tabindex="66" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LOP Approval Date:</td>
    <td> <input name="lop_approval_dt" type="text" id="lop_approval_dt" value="<?php echo($_POST['lop_approval_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="56" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sale Deed Date:</td>
    <td> <input name="sale_deed_dt" type="text" id="sale_deed_dt" value="<?php echo($_POST['sale_deed_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="67" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Line of Prod. Approved:</td>
    <td> <input name="lop_approved" type="text" id="lop_approved" value="<?php echo($_POST['lop_approved']) ?>" size="20" tabindex="57" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Transformer Size:</td>
    <td> <input name="transformer_size" type="text" id="transformer_size" value="<?php echo($_POST['transformer_size']) ?>" size="10" tabindex="68" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Line of Prod. Unapproved:</td>
    <td> <input name="lop_not_approved" type="text" id="lop_not_approved" value="<?php echo($_POST['lop_not_approved']) ?>" size="20" tabindex="58" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sewer Turbine Size:</td>
    <td> <input name="sewer_turbine_size" type="text" id="sewer_turbine_size" value="<?php echo($_POST['sewer_turbine_size']) ?>" size="10" tabindex="69" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Product:</td>
    <td> <input name="lop_product" type="text" id="lop_product" value="<?php echo($_POST['lop_product']) ?>" size="20" tabindex="59" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Court Case:</td>
    <td> <input name="court_case" type="text" id="court_case" value="<?php echo($_POST['court_case']) ?>" size="30" tabindex="70" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Possession Date:</td>
    <td> <input name="possession_dt" type="text" id="possession_dt" value="<?php echo($_POST['possession_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="60" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Audit Para:</td>
    <td> <input name="audit_para" type="text" id="audit_para" value="<?php echo($_POST['audit_para']) ?>" size="30" tabindex="71" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Lease Deed Date:</td>
    <td> <input name="lease_deed_dt" type="text" id="lease_deed_dt" value="<?php echo($_POST['lease_deed_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="61" /></td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;NOC For Bank Loan:</td>
    <td> <input name="bank_noc_obtained" type="text" id="bank_noc_obtained" value="<?php echo($_POST['bank_noc_obtained']) ?>" size="10" tabindex="72" /></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Exec. of Agree. to Sell Date:</td>
    <td> <input name="exec_agree_sell_dt" type="text" id="exec_agree_sell_dt" value="<?php echo($_POST['exec_agree_sell_dt']) ?>" size="15" onBlur="checkDate(this)" tabindex="62" />    
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Project Status:</td>
	<td><select name="project_status" id="project_status" style="width: 150px" tabindex="73" >
	   <option value="1" <?php echo($_POST['project_status'] == '1' ? ' selected' : '') ?>>Functional</option>
	   <option value="0" <?php echo($_POST['project_status'] == '0' ? ' selected' : '') ?>>Nonfunctional</option>
		</select></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td>&nbsp;</td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Dispute:(if any)</td>
    <td> <input name="dispute" type="text" id="dispute" value="<?php echo($_POST['dispute']) ?>" size="30" tabindex="74" /></td>
  </tr>
  <tr>
  <td colspan="4" align="center" bgcolor="#669900">
		<input name="flg" type="hidden" id="flg" value="<?php echo($_POST['flg']) ?>"/>
		<input name="nextRec" type="hidden" id="nextRec" value="false"/>

		&nbsp;&nbsp;<input type="button" name="main" value="Main Menu" onClick="javascript: window.location = 'main.php';" class="btnStyle" style="background-color:#CCFFCC" tabindex="100"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="clear" value="Clear" class="btnStyle" style="background-color:#FC3" onClick="resetForm()" tabindex="95"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <?php if (strpos($_POST['flg'], 'Edit') !== false) { ?>
		<input type="submit" name="save" value="Save" class="btnStyle" style="background-color:#6F3" onClick="return validateForm()" tabindex="90"/>	
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" name="del" value="Delete" class="btnStyle" style="background-color:#FF6633" onClick="return confirm('Are you sure to delete?')" tabindex="91"/>			
		<?php } ?>
    </td>
  </tr>
</table>
</form>

<script type="text/javascript">
	var elem = document.getElementById('sno');
	if (elem.disabled == false)
		elem.focus();
	else
		document.getElementById('aname').focus();
</script>

<?php if (isset($msg)) { ?>
<script type="text/javascript"> 
	<?php echo($msg); ?> 
</script>
<?php } ?>

</body>
</html>
