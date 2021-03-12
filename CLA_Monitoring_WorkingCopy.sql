Select Convert(date, created) As 'Date', Count(*) As 'History'
				Into #History
				From DB.CLA.tb (nolock)
				Where Convert(Date, Created) > Convert(Date, DateAdd(month, -1, SysDateTime()))
				Group By Convert(date, created), Datename(weekday, Created);
			

With Orders as (Select Datename(weekday, Created) As 'Day', Convert(date, Created) As 'Date', Count(*) As 'In Progress'
				From DB.cla.tb (nolock)
				Group By Convert(date, Created), Datename(Weekday, Created)
				),
	
	Unprocessed as (Select Convert(date, created) as 'Date', Count(*) as 'Unprocessed'
					From DB.cla.tb (nolock)
					Where Status = 'READY'
					Group By Convert(date, created)
					),
	Processed as (Select Convert(date, created) as 'Date', Count(*) as 'Processed'
					From DB.cla.tb (nolock)
					Where Status <> 'READY'
					Group By Convert(date, created)),
	Runtime as (
					Select Convert(NVarchar, Created, 101) as 'Date', Datediff(Second, Created, Modified) As 'Runtime' 
					From DB.CLA.tb (nolock)
					Where Status In ('Confirm', 'Reject', 'Deliver')
					      --And Convert(NVarchar, Created, 8) >= '06:02:00'
						  --And Convert(NVarchar, Created, 8) <= '11:59:59'
						  And Datepart(Hour, Created) Between 6 and 12
				),
	Metrics as (
				Select Runtime.Date,
				   Avg(Runtime) As 'Average Runtime', 
				   Max(Runtime) As 'Max', 
				   Min(Runtime) As 'Min', 
				   Round(StDev(Runtime), 2) As 'Standard Deviation'
				From Runtime
				Group By Date
				)



Select a.Day, 
	   a.Date, 
	   (IsNull(a.[In Progress], 0) + IsNull(b.History, 0) ) As 'Total', 
	   c.Unprocessed, 
	   d.Processed + IsNull(b.History, 0) As 'Processed',
	   e.[Average Runtime],
	   e.Max,
	   e.Min,
	   e.[Standard Deviation]
	  
From Orders a
Left Join #History b on a.Date = b.Date
Left Join Unprocessed c on a.Date = c.Date
Left Join Processed d on a.Date = d.Date
Left Join Metrics e on a.Date = e.Date
Order By a.Date Desc;

Drop Table #History;




--
