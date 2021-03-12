With LP5000 as (Select Convert(Date, requestdate) as [Date], Count(*) as 'LP in 5000'
			From DB.dbo.tb (nolock)
			Where serverid = 340 
				and statusid = 5000
				and Convert(Date, requestdate) >= Convert(Date, GetDate() - 30)
			Group By Convert(Date, requestdate)),
	LP6000 as (Select Convert(Date, requestdate) as [Date], Count(*) as 'LP in 6000'
			From DB.dbo.tb (nolock)
			Where serverid = 340 
				and statusid = 6000
				and Convert(Date, requestdate) >= Convert(Date, GetDate() - 30)
			Group By Convert(Date, requestdate))

Select a.Date, a.[LP in 5000], b.[LP in 6000], Round(((Cast(a.[LP in 5000] as Float) / (a.[LP in 5000] + b.[LP in 6000]))),2) as [Success Ratio]
From LP5000 a
Join LP6000 b
  on a.Date = b.Date
Order By a.Date Desc;

