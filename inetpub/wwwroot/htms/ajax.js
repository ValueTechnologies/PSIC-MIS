function getXMLHTTPRequest() {
	var req = false;
    
	try {
    	//Firefox, Opera 8.0+, Safari
        req = new XMLHttpRequest(); 
    } catch (err) {
		
    	try {
			// for some versions of IE 
			req = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (err) {
			
			try {
				// for some other versions of IE 
				req = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (err) {
				req = false;
			}
		}
	}
	return req;
}
 
function sendRequest(vals, div)
{
	var req = getXMLHTTPRequest();
	req.open('POST', 'ajaxHandler.php', true);
	req.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

	req.onreadystatechange = function() {//Call a function when the state changes.
		 if(req.readyState == 4 && req.status == 200) {
			 //alert(req.responseText);
			 if (div && div !== '')
				document.getElementById(div).innerHTML = req.responseText;
		 }
	}
	req.send(vals);
}
