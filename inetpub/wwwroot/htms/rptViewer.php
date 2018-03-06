<?php

// Data fetch from table
$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 
require_once('functions.php');

// SEARCH
?>
<h2 align="center"><?php echo $gAppName; ?></h2>
<h2 align="center"><?php echo date("Y-m-d"); //echo $gHostname; ?></h2>
<table border="1" align="center" >

<tr  bgcolor="#999999">
<td>Sr. No</td>
<td>Name</td>
<td>Date</td>
<td>Time in</td>
<td>Time Out</td>
<td>Status</td>

</tr>

<?php
//User Name
$total = 0;
//$DEPTID=2;
$departid = $_POST['deptID'];
$empname = sprintf("SELECT * FROM USERINFO WHERE DEFAULTDEPTID = $departid");
$emnRS = odbc_exec($gDBConn, $empname) or die('SQL Error: ' . odbc_error());
while (odbc_fetch_row($emnRS)){
$employname = odbc_result($emnRS, 'Name');
$userid_userinfo= odbc_result($emnRS, 'USERID');
$total= $total + 1;
//End Username	

$selSQL = sprintf("SELECT  * FROM CHECKINOUT WHERE USERID = $userid_userinfo");
$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());

//if(isset($dbRS)){ echo "no record found<br>";}

?>
<tr>
<td> <?php echo "$total"; ?></td>
      <td> <?php echo "$employname"; ?></td>
<?php
while (odbc_fetch_row($dbRS)) {

	
		$dept = odbc_result($dbRS, 'USERID');
		$dept2 = odbc_result($dbRS, 'USERID');
		
		$checktime=odbc_result($dbRS, 'CHECKTIME');
		$result = substr($checktime, 0, 10);
		$time=substr($checktime, 11, 20);
		$datecurrent= date("Y-m-d");

							if($datecurrent==$result){
										?>
									  
									  
									  <td> <?php echo "$result"; ?></td>
									  <td> <?php echo "$time"; ?></td>
									  <td></td>
                                      
									 
																	  <?php if ($time <= '09:00:00'){ echo ("<td bgcolor=#339900>Present");} elseif ($time >= '09:00:01'){ echo("<td bgcolor=#FF0000>Late");} ?></td></tr>
																	  				
																		<?php
														} ?>
						
			


			

<?php		}
							
}
?>
</table>

