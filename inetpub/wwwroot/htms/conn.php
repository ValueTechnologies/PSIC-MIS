<?php 
//$gHostname = '\\\\192.168.0.246\\htms-86\\';
//$gHostname = realpath ('.') . '\\';
$gHostname = realpath ('.') . '\\dbDesigScaleFeed\\';
$gDatabase = $gHostname . $gDatabase;
$gUsername = '';
$gPassword = '';
$gDBConn = odbc_connect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};Dbq=$gDatabase", $gUsername, $gPassword)
				or die("Connection Failed: " . $gDatabase);
?>