<?php
//session_start();
include ("../classes/PHPExcel.php");

$gReportTitle = "EMPLOYEES ATTENDANCE REPORT"; // report title
$gPoweredBy = "Powered by PSIC - ITMIS"; // footer center message
$gFontName = "Helvetica"; // font for whole report
$gFontSize = 9; // font size of detail
$gCols = 7; // total columns in report
$gColChar = chr(64 + $gCols); // till column  
$gPCols = 7; // total columns in a single page
$gPColsChar = chr(64 + $gPCols); //till column in a single 
$gRow = 1; // starting Row - 1 for heading
$gStRow = $gRow;
$gRowsPerPage = 0; // rows to be printed on a single page - 0 for no constraint - does not work for pdf
$gLogo = "images/psicLogoColor.gif"; // logo path
$gLogoHeight = 100; // in pixel
$gOrientation = PHPExcel_Worksheet_PageSetup::ORIENTATION_PORTRAIT; // LANDSCAPE or PORTRAIT 
$gPaperSize = PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4; // A4 or LEGAL
$gBorderColor = "B7B7B7B7"; //CCCCFFFF
$gMargin = 1; // in inches - half in pdf format
$gFitToPage = true; // true or false

$gExpFlg = isset($_SESSION['rptFormat']) && $_SESSION['rptFormat'] != '' ? $_SESSION['rptFormat'] : "html"; // "excel" or "pdf" or "html"
$gExport = ($gExpFlg == 'excel') ? $gExpFlg : 'pdf';

if ($gExport == "pdf") {
	$gLogoHeight = floor($gLogoHeight * 2 / 3);
	$gRowsPerPage = 0;
	$gMargin = $gMargin / 2;
	$gRow = 6; // prior rows for page heading
	$gStRow = $gRow;
}

$excel = new PHPExcel();

// Set the Excel file properties
$excel->getProperties()->setCreator("PSIC - ITMIS")
					 ->setLastModifiedBy("PSIC - ITMIS")
					 ->setTitle("PUNJAB SMALL INDUSTRIES CORPORATION") // used as company title
					 ->setSubject("ATTENDANCE MANAGEMENT SYSTEM") // used as sub company title
					 ->setDescription("PSIC Report, generated using PHP classes.")
					 ->setKeywords("psic htms")
					 ->setCategory("report");

// Get the active sheet and assign to a variable
$sheet = $excel->getActiveSheet();
$sheet->getDefaultStyle()->getFont()->setName($gFontName);
$sheet->getDefaultStyle()->getFont()->setSize($gFontSize);
$sheet->setTitle($excel->getProperties()->getCategory());

// add column headers, set the title and make the text bold
/*$tmpColChar = chr(64 + $gCols - 1); // till column  
$sheet->mergeCells("A$gRow:$tmpColChar$gRow");
$sheet->getStyle("A$gRow:$tmpColChar$gRow")->getFont()->setSize(11)->setBold(true)->setUnderline(true);
$sheet->setCellValue("A$gRow", "Directorate Name - Attendance Date");
$gRow++;
*/

// Following condition is needed so memory error does not occur for pdf export
if ($gExport == "excel") $sheet->getPageSetup()->setRowsToRepeatAtTopByStartAndEnd(1, 1);

// Set the column widths
$sheet->getColumnDimension("A")->setWidth(5);
$sheet->getColumnDimension("B")->setWidth(30);
$sheet->getColumnDimension("C")->setWidth(30);
$sheet->getColumnDimension("D")->setWidth(12);
$sheet->getColumnDimension("E")->setWidth(12);
$sheet->getColumnDimension("F")->setWidth(12);
$sheet->getColumnDimension("G")->setWidth(20);

// Formatting
$sheet->getStyle('A')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
$sheet->getStyle('B')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);

$fDt = $_SESSION['fromDt'];
$tDt = $_SESSION['toDt'];

// Data fetch from table
$gDatabase = 'HAMS_' . date('Y', strtotime($fDt)) . '.mdb';
require_once('conn.php'); 
require_once('functions.php');

while ($fDt <= $tDt) {
	// SEARCH
	$selCrit = '';
	if (isset($_SESSION['deptID']) && $_SESSION['deptID'] != '') {
		$selCrit = $selCrit . sprintf (' AND d.code = %s ', GetSQLValueString($_SESSION['deptID'], "text"));
	} 
	
	if (isset($_SESSION['Emp_Id']) && $_SESSION['Emp_Id'] != '') {
		//$_SESSION['aname'] = '%' . $_SESSION['aname'] . '%';
		$selCrit = $selCrit . sprintf (' AND e.Emp_Id = %s ', GetSQLValueString($_SESSION['Emp_Id'], "text"));
	} 

	$eventCrit = sprintf (' AND eventDate = %s ', GetSQLValueString(str_replace('-', '/', $fDt), "text"));

	//$joinType = $_SESSION['aType'] == 2 ? ' INNER ' : ' LEFT OUTER '; // PRESENT ONLY
	if ($_SESSION['aType'] == 2 ) // present only
		$selCrit = $selCrit . 'AND p.eventDate IS NOT NULL';
	else if ($_SESSION['aType'] == 3 ) // absent only
		$selCrit = $selCrit . 'AND p.eventDate IS NULL';
	
$aDB = $gHostname . 'HAMS.mdb';
$selSQL = sprintf('SELECT e.Dep_Id AS deptID, d.name AS deptName, e.Emp_Id, e.Emp_No, e.Emp_CName AS personName, ed.Designation, ed.PayScale,
			IIF(ISNULL(p.eventDate), \'%s\', p.eventDate) AS eventDt, 
			(SELECT MIN(s.eventTime) FROM PubEvent s WHERE s.personID = e.Emp_Id AND s.eventDate = p.eventDate) as tIn, 
			(SELECT MAX(s.eventTime) FROM PubEvent s WHERE s.personID = e.Emp_Id AND s.eventDate = p.eventDate) as tOut,
			(SELECT MAX(s.eventRemark) FROM [DATABASE=%s;].empRem AS s WHERE s.Emp_Id = e.Emp_Id %s) as rem
			FROM ((([DATABASE=%s;].emp AS e LEFT OUTER JOIN (SELECT * FROM [DATABASE=%s;].EmpDet) ed ON e.Emp_Id = ed.Emp_Id)
			LEFT OUTER JOIN (SELECT personID, eventDate FROM PubEvent WHERE personID = personID %s GROUP BY personID, eventDate) p ON e.Emp_Id = p.personID) 
			INNER JOIN  [DATABASE=%s;].dept AS d ON e.Dep_Id = d.code) WHERE e.Dep_Id = e.Dep_Id %s
			ORDER BY d.name, ed.PayScale DESC, ed.JobNature, ed.Designation, e.Emp_CName, IIF(ISNULL(p.eventDate), \'%s\', p.eventDate), e.Emp_CName', 
			str_replace('-', '/', $fDt), $aDB, $eventCrit, $aDB, $aDB, $eventCrit, $aDB, $selCrit, str_replace('-', '/', $fDt));
//echo $selSQL;
$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());
$recCnt = 0;
$dept = '';
$aDt = '';
$depti = 0;
// To show Total of a particular Directorate
$totLate = 0;
$totNoIn = 0;
$totNoOff = 0;
$totAbsent = 0;
while (odbc_fetch_row($dbRS)) {
	$depti++;

	if ($gRowsPerPage > 0) { 
		if ($gRow > 1 && $gRow % $gRowsPerPage == 0)
			$sheet->setBreak("A$gRow", PHPExcel_Worksheet::BREAK_ROW);
	}

	if (odbc_result($dbRS, 'deptID') != $dept || odbc_result($dbRS, 'eventDt') != $aDt) {

		if ($dept != '') {
			// Summary Row
			$summ = 'Total: ' . ($depti-1) . ", Absent: " . $totAbsent . ", Late: " . $totLate . ", No Time Off: " . $totNoOff; 
			$sheet->mergeCells("A$gRow:$gColChar$gRow");
			$sheet->getStyle("A$gRow:$gColChar$gRow")->getFont()->setSize(10)->setBold(true);
			$sheet->setCellValue("A$gRow", $summ);
			$gRow+=2;

			$totLate = 0;
			$totNoIn = 0;
			$totNoOff = 0;
			$totAbsent = 0;
		}
		
		$dept = odbc_result($dbRS, 'deptID');
		$aDt = odbc_result($dbRS, 'eventDt');
		$grp1 = odbc_result($dbRS, 'deptName') . ' - ' . date('l jS \of F Y', strtotime(odbc_result($dbRS, 'eventDt')));
		//(odbc_result($dbRS, 'director') != '' ? ' - ' : '') . odbc_result($dbRS, 'director') . (odbc_result($dbRS, 'phone') != '' ? ', ' : '') . odbc_result($dbRS, 'phone');

		$tmpColChar = chr(64 + $gCols - 1); // till column  
		$sheet->mergeCells("A$gRow:$tmpColChar$gRow");
		$sheet->getStyle("A$gRow:$tmpColChar$gRow")->getFont()->setSize(11)->setBold(true)->setUnderline(true);
		$sheet->setCellValue("A$gRow", $grp1);

		$sheet->mergeCells("$gColChar$gRow:$gColChar$gRow");
		$depti = 1;
		$gRow+=2;

		$sheet->setCellValue("A$gRow", "Sr#")
		->setCellValue("B$gRow", "Employee Name")
		->setCellValue("C$gRow", "Designation")
		->setCellValue("D$gRow", "Time In")
		->setCellValue("E$gRow", "Time Off")
		->setCellValue("F$gRow", "Duration")
		->setCellValue("G$gRow", "Remarks")
		->getStyle("A$gRow:" . $gColChar . $gRow)->getFont()->setSize(10)->setBold(true);
		$gRow++;
	}

	$tIn = odbc_result($dbRS, 'tIn') == '' ? 0 : strtotime (odbc_result($dbRS, 'tIn'));
	$tOut = (odbc_result($dbRS, 'tOut') == '' || odbc_result($dbRS, 'tIn') == odbc_result($dbRS, 'tOut')) ? 0 : strtotime (odbc_result($dbRS, 'tOut'));
	$tDiff = 0;
	if ($tIn != 0 && $tOut != 0) {
		$tDiff = $tOut - $tIn;
		$tHour = ($tDiff / 3600) % 24;
		$tMin = $tDiff % 3600;
		$tMin = round($tMin / 60, 0);
		$tDiff = str_pad($tHour, 2, '0', STR_PAD_LEFT) . ':' . str_pad($tMin, 2, '0', STR_PAD_LEFT);
	}
	$desig = odbc_result($dbRS, 'Designation') . '-' . odbc_result($dbRS, 'PayScale');
	
	$sheet->setCellValue("A$gRow", $depti)
		->setCellValue("B$gRow", odbc_result($dbRS, 'personName'))
		->setCellValue("C$gRow", $desig)
		->setCellValue("D$gRow", $tIn == 0 ? '' : odbc_result($dbRS, 'tIn'))
		->setCellValue("E$gRow", $tOut == 0 ? '' : odbc_result($dbRS, 'tOut'))
		->setCellValue("F$gRow", $tOut == '0' ? '' : $tDiff);

	$rem = '';
	if (odbc_result($dbRS, 'rem') != '') {
		$rem = $rem . odbc_result($dbRS, 'rem') . ', ';
		$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("8888FF00");
		++$totLate;
		
	} else {
	
		if (odbc_result($dbRS, 'tIn') >= '08:31') {
			$rem = $rem . 'Late, ';
			$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("FFFFCC00");
			++$totLate;
			
		}
		if ($tIn == 0 && $tOut != 0) {
			$rem = $rem . 'No Time In, ';
			$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("9999FF00");
			++$totNoIn;
			
		}
		if ($tIn != 0 && $tOut == 0 && odbc_result($dbRS, 'eventDt') < date('Y/m/d')) { // no time off and record event date is not of today
			$rem = $rem . 'No Time Off, ';
			$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("0000FFFF");
			++$totNoOff;
			
		}
		if ($tIn == 0 && $tOut == 0 && $_SESSION['aType'] == 1) { // both present and absent
			$rem = $rem . 'Absent, ';
			$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("FFFF6600");
			++$totAbsent;
		}
	}
	
	// EXCEPTION: no remarks for MD or Scale 20
	if (odbc_result($dbRS, 'PayScale') >= 20) {
		$rem = '';
		$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("FFFFFFFF");
	}
		
	$rem = rtrim ($rem, ', ');
	$sheet->setCellValue("G$gRow", $rem);
	$gRow++;
}

$fDt = date('Y-m-d', strtotime("+1 days", strtotime($fDt)));
}
// Summary Row
//$gRow++;
$summ = 'Total: ' . $depti . ", Absent: " . $totAbsent . ", Late: " . $totLate . ", No Time Off: " . $totNoOff; 
$sheet->mergeCells("A$gRow:$gColChar$gRow");
$sheet->getStyle("A$gRow:$gColChar$gRow")->getFont()->setSize(10)->setBold(true);
$sheet->setCellValue("A$gRow", $summ);

// Bordering
if ($gExport == "excel") {
	$sheet->getStyle("A1:$gColChar$gRow")->getBorders()->getAllBorders()->getColor()->setARGB($gBorderColor);
	$sheet->getStyle("A1:$gColChar$gRow")->getBorders()->getAllBorders()->setBorderStyle(PHPExcel_Style_Border::BORDER_HAIR);
	$sheet->getStyle("A1:" . $gColChar . 1)->getBorders()->getAllBorders()->setBorderStyle(PHPExcel_Style_Border::BORDER_THIN);
	$sheet->getStyle("A1:$gColChar$gRow")->getBorders()->getOutline()->setBorderStyle(PHPExcel_Style_Border::BORDER_THIN);
} else { // pdf
	$gRow = $gRow + 2;
	$sheet->getStyle("A1:$gPColsChar$gRow")->getBorders()->getAllBorders()->getColor()->setARGB($gBorderColor);
	$sheet->getStyle("A1:$gPColsChar$gRow")->getBorders()->getAllBorders()->setBorderStyle(PHPExcel_Style_Border::BORDER_THIN);
	$sheet->getStyle("A1:$gPColsChar".($gStRow-1))->getBorders()->getAllBorders()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_WHITE);
	$sheet->getStyle(chr(ord($gColChar) + 1) . $gStRow . ":$gPColsChar" . ($gRow-2))->getBorders()->getAllBorders()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_WHITE);
	$sheet->getStyle("A" . ($gRow - 1). ":$gPColsChar$gRow")->getBorders()->getAllBorders()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_WHITE);
	$sheet->getStyle("A" . ($gRow - 1) . ":" . $gColChar . ($gRow - 1))->getBorders()->getTop()->getColor()->setARGB($gBorderColor);

	$sheet->getStyle(chr(ord($gColChar) + 1) . $gStRow . ":$gPColsChar" . ($gRow-2))->getBorders()->getLeft()->getColor()->setARGB($gBorderColor);
}

// Set page margins
$pageMargins = $sheet->getPageMargins();
// margin is set in inches
$pageMargins->setTop($gMargin + ($gMargin / 2));
$pageMargins->setBottom($gMargin);
$pageMargins->setLeft($gMargin - ($gMargin / 4));
$pageMargins->setRight($gMargin - ($gMargin / 4));

// Report Footer for pdf format only
if ($gExport == "pdf") {
	$sheet->mergeCells("A$gRow:B$gRow");
	$sheet->setCellValue("A$gRow", "Printed on: " . date ('d/m/Y H:i'));
	$sheet->getStyle("A$gRow:B$gRow")->getFont()->setSize(8)->setBold(true)->setItalic(true);

	$sheet->mergeCells("C$gRow:" . chr(ord($gPColsChar) - 0) . "$gRow");
	$sheet->setCellValue("C$gRow", $gPoweredBy);
	$sheet->getStyle("C$gRow:" . chr(ord($gPColsChar) - 0) . "$gRow")->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
	$sheet->getStyle("C$gRow:C$gRow")->getFont()->setSize(8);
}

// Report Header for pdf format only
if ($gExport == "pdf") {
	if ($gStRow > 1) {
		$sheet->mergeCells("C1:$gPColsChar" . 1);
		$sheet->setCellValue("C1", $excel->getProperties()->getTitle());
		$sheet->getStyle("C1:$gPColsChar" . 1)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->getStyle("C1:$gPColsChar" . 1)->getFont()->setSize(14)->setBold(true);

		$sheet->mergeCells("C2:$gPColsChar" . 2);
		$sheet->setCellValue("C2", $excel->getProperties()->getSubject());
		$sheet->getStyle("C2:$gPColsChar" . 2)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->getStyle("C2:$gPColsChar" . 2)->getFont()->setSize(12)->setBold(true)->setItalic(true);

		$sheet->mergeCells("C4:$gPColsChar" . 4);
		$sheet->setCellValue("C4", $gReportTitle);
		$sheet->getStyle("C4:$gPColsChar" . 4)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->getStyle("C4:$gPColsChar" . 4)->getFont()->setSize(14)->setBold(true)->setUnderline(true);

		// for logo
		$sheet->mergeCells("A1:B4");

		$drawing = new PHPExcel_Worksheet_Drawing();
		$drawing->setName('logo');
		$drawing->setPath($gLogo);
		$drawing->setHeight($gLogoHeight);
		$drawing->setCoordinates('A1');
		$drawing->setOffsetX(10);
		$drawing->setWorksheet($sheet);
	}

} else { // for Excel -- since pdf do not print Header / Footer yet
	// Set header and footer. When no different headers for odd/even are used, odd header is assumed.
	$sheet->getHeaderFooter()->setOddHeader("&L&G" . "&C&H&16&B " . $excel->getProperties()->getTitle() . "\n" . "&12&B&I " . $excel->getProperties()->getSubject() . "\n\n" . "&\"$gFontName,Regular\"" . "&16&B&U" . $gReportTitle);
	$sheet->getHeaderFooter()->setOddFooter("&L &8" . "&\"$gFontName,Regular\"" . " Printed on: &B&I &D &T" . "&C &8&B $gPoweredBy" . "&RPage &P of &N");
	
	if ($gLogo != "") {
		// Add a drawing to the header
		$drawing = new PHPExcel_Worksheet_HeaderFooterDrawing();
		$drawing->setName('logo');
		$drawing->setPath($gLogo);
		$drawing->setHeight($gLogoHeight);
		$sheet->getHeaderFooter()->addImage($drawing, PHPExcel_Worksheet_HeaderFooter::IMAGE_HEADER_LEFT);
	}
}

// Set page orientation and size
$sheet->getPageSetup()->setOrientation($gOrientation);
$sheet->getPageSetup()->setPaperSize($gPaperSize);
if ($gFitToPage) {
	$sheet->getPageSetup()->setFitToPage(true);
	$sheet->getPageSetup()->setFitToWidth(1);
	$sheet->getPageSetup()->setFitToHeight(0);
}

//Set the active sheet to the first sheet before outputting. This is only needed if you want to ensure the file is opened on the first sheet.
$excel->setActiveSheetIndex(0);

//Output the generated excel file so that the user can save or open the file.
if ($gExport == "pdf") {
	if ($gExpFlg == "pdf") {
		header("Content-Type: application/pdf");
		header("Content-Disposition: attachment;filename=\"" . $gReportTitle . "_" . date('YmdHi') . ".pdf\"");
		header("Cache-Control: max-age=0");
		$objWriter = PHPExcel_IOFactory::createWriter($excel, "PDF");

	} else if ($gExpFlg == "html") {
		$objWriter = PHPExcel_IOFactory::createWriter($excel, "HTML");
	}
} else {
	header("Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	header("Content-Disposition: attachment; filename=\"" . $gReportTitle . "_" . date('YmdHi') . ".xlsx\"");
	header("Cache-Control: max-age=0");
	$objWriter = PHPExcel_IOFactory::createWriter($excel, "Excel2007");
}

$objWriter->save("php://output");
?>
