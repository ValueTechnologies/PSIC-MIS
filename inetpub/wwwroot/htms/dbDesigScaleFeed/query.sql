SELECT e.Emp_Id AS Employee_Id, e.Emp_CName AS Employee_Name, d.code AS Department_Id, d.name AS Department_Name, "" AS Designation, "" AS Pay_Scale
FROM Emp e, Dept d
WHERE e.Dep_Id = d.code
ORDER BY d.code, e.Emp_CName


