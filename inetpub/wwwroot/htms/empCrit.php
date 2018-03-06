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
<meta charset="utf-8">
  <title>jQuery UI Datepicker - Default functionality</title>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
  <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
  <link rel="stylesheet" href="/resources/demos/style.css">
<script language="javascript" type="text/javascript">
<!-- 
//Browser Support Code
function ajaxFunction(){
 var ajaxRequest;  // The variable that makes Ajax possible!
	
 try{
   // Opera 8.0+, Firefox, Safari
   ajaxRequest = new XMLHttpRequest();
 }catch (e){
   // Internet Explorer Browsers
   try{
      ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
   }catch (e) {
      try{
         ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
      }catch (e){
         // Something went wrong
         alert("Your browser broke!");
         return false;
      }
   }
 }
 // Create a function that will receive data 
 // sent from the server and will update
 // div section in the same page.
 ajaxRequest.onreadystatechange = function(){
   if(ajaxRequest.readyState == 4){
      var ajaxDisplay = document.getElementById('ajaxDiv');
      ajaxDisplay.innerHTML = ajaxRequest.responseText;
   }
 }
 // Now get the value from user and pass it to
 // server script.

 var box = document.getElementById('box').value;
 var queryString = "?age=" + box ;
 queryString +=  "&box=" + box;
 ajaxRequest.open("GET", "ajax-example1.php" + 
                              queryString, true); 
 ajaxRequest.send(null); 
}

$(function() {
    $( "#datepicker" ).datepicker({ dateFormat: 'dd/mm/yy' });
	
  });

$(function() {
    $( "#datepicker2" ).datepicker({ dateFormat: 'dd/mm/yy' });
  });


</script>


</head>

<body>
<h1 align="center"><?php echo($gCompanyName) ?></h1>
<h3 align="center"><?php echo($gAppName) ?></h3>
<p>&nbsp;</p>


<form id="form1" name="form1" method="post" action="Dtewise.php" >
  <table width="600" height="142" border="0" align="center" bgcolor="#CDFFFF">
<tr>
<td colspan="2" align="center" class="gStyle5"><?php //echo($pageItem . ' - ' . $pageFor); ?></td>
</tr>
<tr>
<td colspan="2"><?php //echo($tabTitle); ?></td>
 </tr>
  <tr>
    <td width="219" height="43">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Directorate Wise Daily Report:</td>
    <td width="371"><select name="deptID" id="deptID" style="width: 150px" >
	   <option value="5">--A & C--</option>
       <option value="4">--F & A--</option>
       <option value="2">--C & M--</option>
       <option value="8">--IA--</option>
       <option value="10">--PEN--</option>
       <option value="7">--H & D--</option>
       <option value="6">--DMD Cell--</option>
       <option value="9">--MD Cell--</option>
       <option value="11">--EMW--</option>
	
		</select></td>
  </tr>
  
  
  <tr>
  <td height="75" colspan="2" align="center" bgcolor="#669900">
		<input name="flg" type="hidden" id="flg" value="<?php echo($_POST['flg']) ?>"/>

		&nbsp;&nbsp;<input type="button" name="main" value="Main Menu" onClick="javascript: window.location = 'main.php';" class="btnStyle" style="background-color:#CCFFCC" tabindex="100"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="clear" value="Clear" class="btnStyle" style="background-color:#FC3" onClick="resetForm()" tabindex="95"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="submit" name="showReport" value="Show Report" class="btnStyle" style="background-color:#6F3" tabindex="90"/>	
    </td>
  </tr>
</table>

</form>
========================================================================================================================================================================


<form id="fo" name="fo" method="post" action="singleemploy.php" >
  <table width="694" height="142" border="0" align="center" bgcolor="#CDFFFF">
<tr>
<td colspan="2" align="center" class="gStyle5"><?php //echo($pageItem . ' - ' . $pageFor); ?></td>
</tr>
<tr>
<td colspan="2"><?php //echo($tabTitle); ?></td>
 </tr>
  <tr>
    <td width="205" height="43">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Select Directorate :</td>
    <td width="421"><select name="Province" id="box" style="width: 150px"  onChange="ajaxFunction()" >
	   <option value="5">--Select Directorate--</option>
       <option value="5">--A & C--</option>
       <option value="4">--F & A--</option>
       <option value="2">--C & M--</option>
       <option value="8">--IA--</option>
       <option value="10">--PEN--</option>
       <option value="7">--H & D--</option>
       <option value="6">--DMD Cell--</option>
       <option value="9">--MD Cell--</option>
       <option value="11">--EMW--</option>
	
		</select></td>
  </tr>
  
  <tr>
    <td width="205" height="43">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Select Employee:</td>
    <td width="421"><div id='ajaxDiv'></div></td>
  </tr>
  <tr>
    <td width="205" height="43">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Select Date:</td>
    <td width="421">From: <input type="text" name="fromdate" id="datepicker" required> To Date: <input type="text" id="datepicker2" name="todate" required></td>
  </tr>
  <tr>
  <td height="75" colspan="2" align="center" bgcolor="#669900">
		<input name="flg" type="hidden" id="flg" value="<?php echo($_POST['flg']) ?>"/>

		&nbsp;&nbsp;<input type="button" name="main" value="Main Menu" onClick="javascript: window.location = 'main.php';" class="btnStyle" style="background-color:#CCFFCC" tabindex="100"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="clear" value="Clear" class="btnStyle" style="background-color:#FC3" onClick="resetForm()" tabindex="95"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="submit" name="showReport" value="Show Report" class="btnStyle" style="background-color:#6F3" tabindex="90"/>	
    </td>
  </tr>
</table>

</form>

===========================================================================================================================================================================
===========================================================================================================================================================================
<form id="fo" name="fo" method="post" action="singleemploy.php" >
  <table width="698" height="142" border="0" align="center" bgcolor="#CDFFFF">
<tr>
<td colspan="2" align="center" class="gStyle5"><?php //echo($pageItem . ' - ' . $pageFor); ?></td>
</tr>
<tr>
<td colspan="2"><?php //echo($tabTitle); ?></td>
 </tr>
  <tr>
    <td width="183" height="43">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Select Directorate :</td>
    <td width="407"><select name="Province" id="box" style="width: 150px"  onChange="ajaxFunction()" >
	   <option value="5">--Select Directorate--</option>
       <option value="5">--A & C--</option>
       <option value="4">--F & A--</option>
       <option value="2">--C & M--</option>
       <option value="8">--IA--</option>
       <option value="10">--PEN--</option>
       <option value="7">--H & D--</option>
       <option value="6">--DMD Cell--</option>
       <option value="9">--MD Cell--</option>
       <option value="11">--EMW--</option>
	
		</select></td>
  </tr>
  
  
  <tr>
  <td height="75" colspan="2" align="center" bgcolor="#669900">
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
</script>

<?php if (isset($msg)) { ?>

<?php } ?>

</body>
</html>
