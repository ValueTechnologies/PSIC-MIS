<?php
if (!function_exists("GetSQLValueString")) {
	function GetSQLValueString($theValue, $theType, $theDefinedValue = "", $theNotDefinedValue = "") 
	{
		if (PHP_VERSION < 6) {
			$theValue = get_magic_quotes_gpc() ? stripslashes($theValue) : $theValue;
		}
	
		$theValue = function_exists("mysql_real_escape_string") ? mysql_real_escape_string($theValue) : mysql_escape_string($theValue);
	
		switch ($theType) {
			case "text":
			  $theValue = ($theValue != "") ? "'" . $theValue . "'" : "NULL";
			  break;    
			case "long":
			case "int":
			  $theValue = ($theValue != "") ? intval($theValue) : "NULL";
			  break;
			case "double":
			  $theValue = ($theValue != "") ? doubleval($theValue) : "NULL";
			  break;
			case "date":
			  $theValue = ($theValue != "") ? "'" . $theValue . "'" : "NULL";
			  break;
			case "defined":
			  $theValue = ($theValue != "") ? $theDefinedValue : $theNotDefinedValue;
			  break;
		}
		
		return $theValue;
	}
}

##################################
# Date and Time
ini_set('date.timezone', 'Asia/Karachi');  // to handle dates correctly
$gOffset=5*60*60; //converting 5 hours to seconds. 
$gDateFormat="y-m-d H:i:s"; 
//$gCurrentDate=gmdate($gDateFormat, time()+$gOffset); 
$gCurrentDate=date($gDateFormat);
###################################

##################################
# Website Global Variables
$gCompanyName = 'Punjab Small Industries Corporation (PSIC)';
$gAppName = 'PSIC ATTENDANCE MANAGEMENT SYSTEM (HTMS)';
$gPageTitle = 'HTMS - PSIC';
###################################


?>