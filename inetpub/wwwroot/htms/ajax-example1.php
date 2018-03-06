

<?php 

$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 
require_once('functions.php');
	

$box = $_GET['box'];
	// Escape User Input to help prevent SQL Injection

$box = mysql_real_escape_string($box);
	//build query
$query = sprintf("SELECT * FROM USERINFO WHERE DEFAULTDEPTID = $box");
//if(is_numeric($age))
//	$query .= " AND age <= $age";
//if(is_numeric($wpm))
	//$query .= " AND wpm <= $wpm";
	//Execute query
$emnRS = odbc_exec($gDBConn, $query) or die('SQL Error: ' . odbc_error());

	//Build Result String

  echo("<select id=textboxid name=City >");
   while (odbc_fetch_row($emnRS)){
	   $eMname = odbc_result($emnRS, 'Name');
	   $UID = odbc_result($emnRS, 'USERID');
   echo(" <option>");
       echo ("$UID"." "."$eMname"); //echo $UID;
    echo("</option>");
	
     }
echo("</select>");     
     
      
// Insert a new row in the table for each person returned





?>


