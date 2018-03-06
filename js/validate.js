
    function  confirmation(a) 
    {
	var answer = confirm("Do you want to delete ?")
	
	if (answer)
	{
		return answer;
	}
	else
	{
		return answer;
	}

}
 
    
    function  confirmation_edit(a) 
    {
	var answer = confirm("Do you want to edit")
	
	if (answer)
	{
		return answer;
	}
	else
	{
		return answer;
	}
     
    }
    
    function Validate_Age(Element_Id)
    {
        Obj=document.getElementById(Element_Id);
        if(Obj.value!="")
        {
             if((Obj.value-0)!= Obj.value)
                {
                    alert("Only Integer Are Allowed");
                    document.getElementById(Element_Id).focus();
                    return false;
                }
            else if((Obj.value >= 1) &&  (Obj.value <= 150))
                { 
                }
            else
                {
                    alert("Enter Correct Age");
                    document.getElementById(Element_Id).focus();
                    return false;
                }
        }
    }
    