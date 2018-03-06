<?php

// Data fetch from table
$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 
require_once('functions.php');

// SEARCH
$datacurrent = date("m/d/Y 00:00:00");
?>

<h2 align="center"><?php echo $gAppName;  ?></h2>
<table border="1" align="center" >

<tr  bgcolor="#999999">
<td>Name</td>
<td>Date</td>
<td>Time in</td>
<td>Time Out</td>
<td>Status</td>
</tr>

<?php
//User Name

$empname = sprintf("SELECT USERINFO.USERID, USERINFO.Name, CHECKINOUT.CHECKTIME FROM USERINFO LEFT JOIN CHECKINOUT ON USERINFO.USERID=CHECKINOUT.USERID ORDER BY CHECKINOUT.CHECKTIME DESC");
$emnRS = odbc_exec($gDBConn, $empname) or die('SQL Error: ' . odbc_error());
while (odbc_fetch_row($emnRS)){
$employname = odbc_result($emnRS, 'Name');
$userinout_userinfo= odbc_result($emnRS, 'CHECKTIME');

//End Username	



?>
<tr  bgcolor="">
<td><?PHP echo "$employname" ;?></td>
<?php
$result = substr($userinout_userinfo, 0, 10);
		$time=substr($userinout_userinfo, 11, 20);
		$datecurrent= date("Y-m-d");

							if($datecurrent==$result){
									?>
									<td><?PHP echo "$userinout_userinfo";?></td>
									<?php  } 
									else
									{
										?>
										<td><?PHP echo "Not Mark";?></td>
									  <?php  
										}
									?>
<td><?PHP echo "$time" ; ?></td>
<td><?PHP ?></td>
<?php if ($time <= '08:31:00'){ echo ("<td bgcolor=#339900>Present");} elseif ($time >= '08:32:00'){ echo("<td bgcolor=#FF0000>Late");} ?></td>
</tr>
<?PHP							
}
?>
</table>