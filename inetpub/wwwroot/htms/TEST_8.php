<?php

// Data fetch from table
$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 
require_once('functions.php');

// SEARCH
?>
<h2 align="center"><?php echo $gAppName; ?></h2>
<h2 align="center"><?php echo "8 May, 2015"; //echo $gHostname; ?></h2>
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
$empname = sprintf("SELECT * FROM USERINFO ");
$emnRS = odbc_exec($gDBConn, $empname) or die('SQL Error: ' . odbc_error());
while (odbc_fetch_row($emnRS)){
$employname = odbc_result($emnRS, 'Name');
$userid_userinfo= odbc_result($emnRS, 'USERID');
$total= $total + 1;
//End Username	

$selSQL = sprintf("SELECT  LAST(CHECKTIME) AS FirstCustomer FROM CHECKINOUT WHERE USERID = $userid_userinfo AND CHECKTYPE = 'I' ");
$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());


?>
<tr>
<td> <?php echo "$total"; ?></td>
      <td> <?php echo "$employname"; ?></td>
<?php
while (odbc_fetch_row($dbRS)) {

	
		
		
		$checktime=odbc_result($dbRS, 'FirstCustomer');
		echo "$checktime.....";
		$result = substr($checktime, 0, 10);
		$time=substr($checktime, 11, 20);
		$datecurrent= date("Y-m-d");

							if($datecurrent==$result){
										?>
									  
									  
									  <td> <?php echo "$result"; ?></td>
									  <td> <?php echo "$time"; ?></td>
									  <td></td>
																	  <?php if ($time <= '08:31:00'){ echo ("<td bgcolor=#339900>Present");} elseif ($time >= '08:32:00'){ echo("<td bgcolor=#FF0000>Late");} ?></td>
																	  </tr>					
																		<?php
														}
						
			


			

		}
							
}
?>
</table>