<?php

// Data fetch from table
$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 
require_once('functions.php');

// SEARCH
?>
<h2 align="center"><?php echo $gAppName; ?></h2>
<h2 align="center"><?php echo "5 May, 2015"; //echo $gHostname; ?></h2>
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

$selSQL = sprintf("SELECT  * FROM CHECKINOUT WHERE USERID = $userid_userinfo AND CHECKTIME LIKE '5/7/2015')");
$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());





?>
<tr>
<td> <?php echo "$total"; ?></td>
      <td> <?php echo "$employname"; ?></td>
<?php
while (odbc_fetch_row($dbRS)) {

	    
		$dept = odbc_result($dbRS, 'USERID');
		$dept2 = odbc_result($dbRS, 'USERID');
		
		$checktime=odbc_result($dbRS, 'CHECKTIME');
		$date = substr($checktime, 0, 10);
		$time=substr($checktime, 11, 20);
		$datecurrent= date("m/d/Y");
		
		/*Count Total # OF order
$total_or = mysql_query("select count() FROM shipping_detail") or die(mysql_error());
$row = mysql_fetch_array($total_or);
$total_order = $row[0];*/

							if($datecurrent==$date)
							{
	
										?>
									  
									  
									  <td> <?php echo "$date"; ?></td>
									  <td> <?php echo "$time"; ?></td>
									  <td></td>
	<?php if ($time <= '08:31:00')
	{
		 echo ("<td bgcolor=#339900>Present");
	} 
	elseif ($time >= '08:32:00')
	{ echo("<td bgcolor=#FF0000>Late");} ?></td>
																	  </tr>					
																		<?php
														}
						
			


			

		}
							
}
?>
</table>