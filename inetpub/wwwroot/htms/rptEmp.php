<?php
//session_start();
require_once("../classes/PHPExcel.php");

$gReportTitle = "EMPLOYEES REPORT"; // report title
$gPoweredBy = "Powered by PSIC - ITMIS"; // footer center message
$gFontName = "Helvetica"; // font for whole report
$gFontSize = 10; // font size of detail
$gCols = 5; // total columns in report
$gColChar = chr(64 + $gCols); // till column  
$gPCols = 5; // total columns in a single page
$gPColsChar = chr(64 + $gPCols); //till column in a single 
$gRow = 1; // starting Row - 1 for heading
$gStRow = $gRow;
$gRowsPerPage = 30; // rows to be printed on a single page - 0 for no constraint - does not work for pdf
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
					 ->setSubject("HUMAN RESOURCE MANAGEMENT SYSTEM") // used as sub company title
					 ->setDescription("PSIC Report, generated using PHP classes.")
					 ->setKeywords("psic hrms")
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
$sheet->setCellValue("A$gRow", "Directorate Name");
$gRow++;

$sheet->setCellValue("A$gRow", "Sr#")
->setCellValue("B$gRow", "Employee Name")
->setCellValue("C$gRow", "Employee Contact")
->setCellValue("D$gRow", "Employee Address")
->setCellValue("E$gRow", "Employee Email")
->getStyle("A$gRow:" . $gColChar . $gRow)->getFont()->setSize(12)->setBold(true);

// Following condition is needed so memory error does not occur for pdf export
if ($gExport == "excel") $sheet->getPageSetup()->setRowsToRepeatAtTopByStartAndEnd(1, 1);

// Set the column widths
$sheet->getColumnDimension("A")->setWidth(5);
$sheet->getColumnDimension("B")->setWidth(25);
$sheet->getColumnDimension("C")->setWidth(20);
$sheet->getColumnDimension("D")->setWidth(40);
$sheet->getColumnDimension("E")->setWidth(20);

// Formatting
$sheet->getStyle('A')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
$sheet->getStyle('B')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);

// Data fetch from table
$gDatabase = 'HAMS.mdb';
require_once('conn.php'); 
require_once('functions.php');

// SEARCH
$selCrit = '';
if (isset($_SESSION['deptID']) && $_SESSION['deptID'] != '') {
	$selCrit = $selCrit . sprintf (' AND code LIKE %s ', GetSQLValueString($_SESSION['deptID'], "text"));
} 

$selSQL = sprintf('SELECT Emp_Id, Dep_Id, Emp_No, Emp_CName, Emp_EName, Emp_Idno, Emp_Birth, Emp_Tel1, Emp_Tel2, Emp_Addr1, Emp_Addr2,
			Emp_Email, Emp_Sex, Emp_Photo, Emp_Password, d.code, d.name, d.director, d.phone, d.fax, d.address, d.zip
					FROM Dept AS d LEFT OUTER JOIN Emp AS e ON e.Dep_Id = d.code
					WHERE inID = \'0000000001\' %s
					ORDER BY d.name, e.Emp_CName', $selCrit);
$dbRS = odbc_exec($gDBConn, $selSQL) or die('SQL Error: ' . odbc_error());
$recCnt = 0;
$dept = '';
$depti = 0;
while (odbc_fetch_row($dbRS)) {
	$gRow++;
	$depti++;

	if ($gRowsPerPage > 0) { 
		if ($gRow > 1 && $gRow % $gRowsPerPage == 0)
			$sheet->setBreak("A$gRow", PHPExcel_Worksheet::BREAK_ROW);
	}

	if (odbc_result($dbRS, 'code') != $dept) {

		$gRow++; // TO GIVE SPACE OF ONE EMPTY ROW
		$dept = odbc_result($dbRS, 'code');
		$grp1 = odbc_result($dbRS, 'name') . (odbc_result($dbRS, 'director') != '' ? ' - ' : '') . odbc_result($dbRS, 'director') . (odbc_result($dbRS, 'phone') != '' ? ', ' : '') . odbc_result($dbRS, 'phone');

		$tmpColChar = chr(64 + $gCols - 1); // till column  
		$sheet->mergeCells("A$gRow:$tmpColChar$gRow");
		$sheet->getStyle("A$gRow:$tmpColChar$gRow")->getFont()->setSize(11)->setBold(true)->setUnderline(true);
		$sheet->setCellValue("A$gRow", $grp1);

		$sheet->mergeCells("$gColChar$gRow:$gColChar$gRow");
		$depti = 1;
		$gRow++;
	}

	if ($depti == 1 && is_null(odbc_result($dbRS, 'Emp_CName'))) {
		$sheet->setCellValue("A$gRow", 'No employee record available for this directorate');
		$sheet->mergeCells("A$gRow:$gColChar$gRow");
	} else {
		$sheet->setCellValue("A$gRow", $depti)
			->setCellValue("B$gRow", odbc_result($dbRS, 'Emp_CName') . ' ' . odbc_result($dbRS, 'Emp_EName'))
			->setCellValue("C$gRow", odbc_result($dbRS, 'Emp_Tel1') . (odbc_result($dbRS, 'Emp_Tel2') != '' ? ', ' : '') . odbc_result($dbRS, 'Emp_Tel2'))
			->setCellValue("D$gRow", odbc_result($dbRS, 'Emp_Addr1') . (odbc_result($dbRS, 'Emp_Addr2') != '' ? ', ' : '') . odbc_result($dbRS, 'Emp_Addr2'))
			->setCellValue("E$gRow", odbc_result($dbRS, 'Emp_Email'));
	}
	if ($gRow % 2) 
		$sheet->getStyle("A$gRow:$gColChar$gRow")->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID)->getStartColor()->setARGB("CCCCFFFF");
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
