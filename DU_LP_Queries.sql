-- DU in queue
Select a.requestid, a.statusid, a.requestdate, a.loanrecordid, b.loanid,
   Case When b.forceoldurlaflag = 1 Then '3.2' Else '3.4' End as [URLA]
From DB.dbo.loan_comrequest a (nolock)
Join DB.dbo.loan_main b (nolock) 
	on a.loanrecordid = b.loanrecordid
Where a.serverid = 600
  And a.statusid < 5000
Order By requestdate Desc;

-- LP in queue 
Select a.requestid, a.statusid, a.requestdate, a.loanrecordid, b.loanid, 
	Case When b.forceoldurlaflag = 1 Then '3.2' Else '3.4' End as [URLA]
From DB.dbo.loan_comrequest a (nolock)
Join DB.dbo.loan_main b (nolock) 
	on a.loanrecordid = b.loanrecordid
Where a.serverid = 340
  And a.statusid < 5000
Order By requestdate Desc;

-- DU Request by status
Select Count(*) as 'DU', statusid
From DB.dbo.loan_comrequest (nolock)
Where serverid = 600
  And Convert(Date, requestdate) = Convert(Date, GetDate())
Group By statusid
Order By Statusid;

-- LP Request by status
Select Count(*) as 'LP', statusid
From DB.dbo.loan_comrequest (nolock)
Where serverid = 340
  And Convert(Date, requestdate) = Convert(Date, GetDate())
Group By statusid
Order By Statusid;

-- Get loanid
Select loanrecordid, loanid
From DB.dbo.loan_main (nolock)
Where loanrecordid = 1731794;

-- How many calls and what is the status? 
Select requestid, statusid, requestdate, loanrecordid
From DB.dbo.loan_comrequest (nolock)
Where loanrecordid = 1570844
Order By requestdate Desc;

-- How many calls per loanrecordid with more than one
Select Count(*), loanrecordid --, requestid, requestdate, acknowledged, statusid
From DB.dbo.loan_comrequest nolock
Where serverid = 340
	and statusid = 5999
	and Convert(Date, requestdate) = Convert(Date, GetDate())
Group By loanrecordid
Having Count(*) > 1
Order By 1 Desc;

/*
Update DB.dbo.loan_comrequest
Set statusid = 9000
Where requestid in ('202103090002961', '202103090002897', '202103080002950');

Select * 
From DB.dbo.loan_comrequest (nolock)
Where requestid in ('202103090002961', '202103090002897', '202103080002950');
*/

/*
     URLA 3.2 forceoldurlaflag = 1
	 URLA 3.4 forceoldurlaflag = 0
*/
