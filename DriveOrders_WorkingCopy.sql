Use DestinyDB;

--Min epicportallog Record: 2020-07-14 03:54:07.840


With DriveOrders as (
                    Select Convert(date, entrydatetime) as 'Date', Count(*) as 'DriveOrders'
                    From DestinyDB.dbo.epicportallog (nolock)
                    Where applicationname = 'TimerLog'
						and Convert(decimal, Substring(message, 8, Datalength(message) - 7)) /1000 > 30
						and Convert(Date, entrydatetime) > Convert(Date, DateAdd(week, -2, SysDateTime()))
						and source like 'Request Type -DRIVE%'
                    Group By Convert(date, entrydatetime)
                ),
    Runtime as (
                    Select Round(Convert(decimal, Substring(message, 8, Datalength(message) - 7)) / 1000, 1) as 'Runtime', Convert(date, entrydatetime) as 'Date'
                    From DestinyDB.dbo.epicportallog with(nolock)
                    Where applicationname = 'TimerLog'
					    and Convert(Date, entrydatetime) > Convert(Date, DateAdd(week, -2, SysDateTime()))
						and Convert(decimal, Substring(message, 8, Datalength(message) - 7)) /1000 > 30
						and source like 'Request Type -DRIVE%'
                ),
    Metrics as (
                Select Runtime.Date,
                   Cast(Round(Avg(Runtime), 2) as Decimal(18,2)) As 'Average Runtime', 
                   Cast(Round(Max(Runtime), 2) as Decimal(18,2)) As 'Max', 
                   Cast(Round(Min(Runtime), 2) as Decimal(18,2)) As 'Min', 
                   Round(StDev(Runtime), 2) As 'Standard Deviation'
                From Runtime
                Group By Date
                )
Select a.Date,
       a.DriveOrders,
       c.[Average Runtime],
       c.Max,
       c.Min,
       c.[Standard Deviation]
From DriveOrders a
Left Join Metrics c on a.Date = c.Date
Order By a.Date Desc;
    
    

  

