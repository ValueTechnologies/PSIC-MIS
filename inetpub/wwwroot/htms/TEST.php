<?php

// Data fetch from table
$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 
require_once('functions.php');

// SEARCH


$selSQL = sprintf('SELECT  * FROM CHECKINOUT ');
$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());
?>
<table border="1" align="center" >
<h2 align="center"><?php echo $gAppName; ?></h2>
<tr  bgcolor="#999999">
<td>Name</td>
<td>Date</td>
<td>Time in</td>
<td>Time Out</td>
<td>Status</td>
</tr>
<?php
while (odbc_fetch_row($dbRS)) {

	
		$dept = odbc_result($dbRS, 'USERID');
		$checktime=odbc_result($dbRS, 'CHECKTIME');
		$result = substr($checktime, 0, 10);
		$time=substr($checktime, 11, 20);
		$datecurrent= date("Y-m-d");




//User Name

$empname = sprintf("SELECT  Name FROM USERINFO WHERE USERID = $dept ");
$emnRS = odbc_exec($gDBConn, $empname) or die('SQL Error: ' . odbc_error());
while (odbc_fetch_row($emnRS)){
$employname = odbc_result($emnRS, 'Name');
}
//End Username	

	
		if($datecurrent==$result){
		?>
      
      <tr>
      <td> <?php echo "$employname"; ?></td>
      <td> <?php echo "$result"; ?></td>
      <td> <?php echo "$time"; ?></td>
      <td></td>
      <?php if ($time <= '08:31:00'){ echo ("<td bgcolor=#339900>Present");} elseif ($time >= '08:32:00'){ echo("<td bgcolor=#FF0000>Late");} ?></td>
      </tr>
        
		
		
<?php
		}
}
		
?>
</table>