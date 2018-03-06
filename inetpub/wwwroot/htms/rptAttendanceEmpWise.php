<?php
//session_start();
include ("../classes/PHPExcel.php");

$gReportTitle = "EMPLOYEE WISE ATTENDANCE REPORT"; // report title
$gPoweredBy = "Powered by PSIC - ITMIS"; // footer center message
$gFontName = "Helvetica"; // font for whole report
$gFontSize = 10; // font size of detail
$gCols = 6; // total columns in report
$gColChar = chr(64 + $gCols); // till column  
$gPCols = 6; // total columns in a single page
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
$tmpColChar = chr(64 + $gCols - 1); // till column  
$sheet->mergeCells("A$gRow:$tmpColChar$gRow");
$sheet->getStyle("A$gRow:$tmpColChar$gRow")->getFont()->setSize(11)->setBold(true)->setUnderline(true);
$sheet->setCellValue("A$gRow", "Directorate - Employee");
$gRow++;

$sheet->setCellValue("A$gRow", "Sr#")
->setCellValue("B$gRow", "Date")
->setCellValue("C$gRow", "Time In")
->setCellValue("D$gRow", "Time Off")
->setCellValue("E$gRow", "Duration")
->setCellValue("F$gRow", "Remarks")
->getStyle("A$gRow:" . $gColChar . $gRow)->getFont()->setSize(11)->setBold(true);

// Following condition is needed so memory error does not occur for pdf export
if ($gExport == "excel") $sheet->getPageSetup()->setRowsToRepeatAtTopByStartAndEnd(1, 1);

// Set the column widths
$sheet->getColumnDimension("A")->setWidth(5);
$sheet->getColumnDimension("B")->setWidth(15);
$sheet->getColumnDimension("C")->setWidth(15);
$sheet->getColumnDimension("D")->setWidth(15);
$sheet->getColumnDimension("E")->setWidth(15);
$sheet->getColumnDimension("F")->setWidth(25);

// Formatting
$sheet->getStyle('A')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
$sheet->getStyle('B')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);

$fDt = $_SESSION['fromDt'];
$tDt = $_SESSION['toDt'];

// Data fetch from table
$gDatabase = 'HAMS_' . date('Y', strtotime($fDt)) . '.mdb';
include ('conn.php'); 
include ('functions.php');

// SEARCH
$selCrit = '';
if (isset($_SESSION['deptID']) && $_SESSION['deptID'] != '') {
	$selCrit = $selCrit . sprintf (' AND d.code LIKE %s ', GetSQLValueString($_SESSION['deptID'], "text"));
} 

if (isset($_SESSION['Emp_Id']) && $_SESSION['Emp_Id'] != '') {
	//$_SESSION['aname'] = '%' . $_SESSION['aname'] . '%';
	$selCrit = $selCrit . sprintf (' AND e.Emp_Id LIKE %s ', GetSQLValueString($_SESSION['Emp_Id'], "text"));
} 

$aDB = $gHostname . 'HAMS.mdb';
$selSQL = sprintf('SELECT e.Dep_Id AS deptID, d.name AS deptName, e.Emp_Id, e.Emp_CName AS personName
			FROM [DATABASE=%s;].emp AS e, [DATABASE=%s;].dept AS d
			WHERE e.Dep_Id = d.code %s
			ORDER BY d.name, e.Emp_CName', $aDB, $aDB, $selCrit);
//echo $selSQL;
$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());
$emps = array ();
while (odbc_fetch_row($dbRS)) {
 $emps[] = json_encode (array('deptID' => odbc_result($dbRS, 'deptID'), 'deptName' => odbc_result($dbRS, 'deptName'), 
	 		'Emp_Id' => odbc_result($dbRS, 'Emp_Id'), 'personName' => odbc_result($dbRS, 'personName')), 
			JSON_FORCE_OBJECT);
}
/*foreach ($emps as $empl) {
	$jRes = json_decode($empl);
}*/

$dept = '';
$depti = 0;
$emp = '';
$empi = 0;

foreach ($emps as $empl) {
	$jRes = json_decode ($empl);
	
	if ($gRowsPerPage > 0) { 
		if ($gRow > 1 && $gRow % $gRowsPerPage == 0)
			$sheet->setBreak("A$gRow", PHPExcel_Worksheet::BREAK_ROW);
	}

	if ($jRes->deptID != $dept || $jRes->Emp_Id != $emp) {

		if ($jRes->deptID != $dept) {
			if ($dept != '')
				$gRow+=3;
			else
				$gRow++;

			$dept = $jRes->deptID;
			$depti = 0;

			$tmpColChar = chr(64 + $gCols - 1); // till column  
			$sheet->mergeCells("A$gRow:$tmpColChar$gRow");
			$sheet->getStyle("A$gRow:$tmpColChar$gRow")->getFont()->setSize(11)->setBold(true)->setUnderline(true);
			$sheet->setCellValue("A$gRow", $jRes->deptName);
		}

		if ($jRes->Emp_Id != $emp) {
			$gRow+=2;

			$emp = $jRes->Emp_Id;
			$empi = 0;
			$depti++;

			$tmpColChar = chr(64 + $gCols - 1); // till column  
			$sheet->mergeCells("B$gRow:$tmpColChar$gRow");
			$sheet->getStyle("B$gRow:$tmpColChar$gRow")->getFont()->setSize(10)->setBold(true)->setUnderline(true);
			$sheet->setCellValue("B$gRow", $depti . '. ' . $jRes->personName);
		}
	}

	// SEARCH
	$selCrit = '';
	$selCrit = $selCrit . sprintf (' AND personID = %s ', GetSQLValueString($jRes->Emp_Id, "text"));
	$selCrit = $selCrit . sprintf (' AND eventDate >= %s ', GetSQLValueString(str_replace('-', '/', $fDt), "text"));
	$selCrit = $selCrit . sprintf (' AND eventDate <= %s ', GetSQLValueString(str_replace('-', '/', $tDt), "text"));

	// ADD ABSENT ROWS
	$gapF = $fDt;
	$gapT = '';
$selSQL = sprintf('SELECT p.eventDate, 
			(SELECT MIN(s.eventTime) FROM PubEvent s WHERE s.personID = p.personID AND s.eventDate = p.eventDate) as tIn, 
			(SELECT MAX(s.eventTime) FROM PubEvent s WHERE s.personID = p.personID AND s.eventDate = p.eventDate) as tOut
			FROM (SELECT personID, eventDate FROM PubEvent WHERE personID = personID %s GROUP BY personID, eventDate) p
			ORDER BY p.eventDate', $selCrit);
$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());
while (odbc_fetch_row($dbRS)) {
	$gRow++;
	$empi++;
	
	$gapT = date('Y-m-d', strtotime(odbc_result($dbRS, 'eventDate')));
	while ($gapF < $gapT) {
		if (date('D', strtotime($gapF)) == 'Sun') { // ignore sunday
			$sheet->setCellValue("A$gRow", $empi)
				->setCellValue("B$gRow", date('d-m-Y D', strtotime($gapF)));
		} else {
			$sheet->setCellValue("A$gRow", $empi)
				->setCellValue("B$gRow", date('d-m-Y D', strtotime($gapF)))
				->setCellValue("C$gRow", '')
				->setCellValue("D$gRow", '')
				->setCellValue("E$gRow", '')
				->setCellValue("F$gRow", ' Absent / N/A');
	
			if ($_SESSION['aType'] == 1)  // both present and absent
				$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("FFFFFF00");
		}
		$gapF = date('Y-m-d', strtotime($gapF . ' +1 days'));
		$gRow++;
		$empi++;
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

	$sheet->setCellValue("A$gRow", $empi)
		->setCellValue("B$gRow", date('d-m-Y D', strtotime(odbc_result($dbRS, 'eventDate'))))
		->setCellValue("C$gRow", $tIn == 0 ? ' Absent / N/A' : odbc_result($dbRS, 'tIn'))
		->setCellValue("D$gRow", $tOut == 0 ? '' : odbc_result($dbRS, 'tOut'))
		->setCellValue("E$gRow", $tDiff == 0 ? '' : $tDiff);

	$rem = '';
	if (odbc_result($dbRS, 'tIn') > '09:00')
		$rem = $rem . ' Late, ';
	if ($tOut == 0)
		$rem = $rem . ' No Time Off, ';
	$rem = rtrim ($rem, ', ');
	$sheet->setCellValue("F$gRow", $rem);

	$gapF = date('Y-m-d', strtotime(odbc_result($dbRS, 'eventDate') . ' +1 days'));
	if ($gRow % 2) 
		$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("CCCCFFFF");
}
	
	$gapT = date('Y-m-d', strtotime($tDt));
	while ($gapF <= $gapT) {
		$gRow++;
		$empi++;
		if (date('D', strtotime($gapF)) == 'Sun') { // ignore sunday
			$sheet->setCellValue("A$gRow", $empi)
				->setCellValue("B$gRow", date('d-m-Y D', strtotime($gapF)));
		} else {
			$sheet->setCellValue("A$gRow", $empi)
				->setCellValue("B$gRow", date('d-m-Y D', strtotime($gapF)))
				->setCellValue("C$gRow", '')
				->setCellValue("D$gRow", '')
				->setCellValue("E$gRow", '')
				->setCellValue("F$gRow", ' Absent / N/A');
	
			if ($_SESSION['aType'] == 1)  // both present and absent
				$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("FFFFFF00");
		}
		$gapF = date('Y-m-d', strtotime($gapF . ' +1 days'));
	}

}

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
