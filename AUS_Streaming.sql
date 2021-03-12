With DU_in_progress as (Select Count(requestid) as [DU in Progress], GetUTCDate() as [Time]
						From DB.dbo.loan_comrequest (nolock)
						Where serverid = 600 
							and statusid < 5000
							and Convert(Date, requestdate) = Convert(Date, GetDate())
							),
	DU_past_ten as (Select Count(*) As [DU Last 10 Minutes]
					From DB.dbo.loan_comrequest (nolock)
					Where serverid = 600 --DU
					  And requestdate >= DateAdd(mi, -10, Current_TimeStamp)
	),
	LPA_in_progress as (Select Count(requestid) as [LPA in Progress]
						From DB.dbo.loan_comrequest (nolock)
						Where serverid = 340 
							and statusid < 5000
							and Convert(Date, requestdate) = Convert(Date, GetDate())
	),
	LPA_past_ten as (Select Count(*) As [LPA Last 10 Minutes]
	From DB.dbo.loan_comrequest (nolock)
	Where serverid = 340 --LP
	  And requestdate >= DateAdd(mi, -10, Current_TimeStamp)
	)

Select a.Time, a.[DU in Progress], b.[DU Last 10 Minutes], c.[LPA in Progress], d.[LPA Last 10 Minutes]
From DU_in_progress a, DU_past_ten b, LPA_in_progress c, LPA_past_ten d


