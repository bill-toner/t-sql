-- Get all loans that are funded or purchased
Select Distinct loanid, loanrecordid
Into #Funded_Purchased
From DB.dbo.tb a (nolock)
Where a.statusid in (54, 114);

-- Get all loans that have notes
Select loanrecordid_int
Into #Loans_With_Notes
From DB.dbo.vw (nolock)
Where DocTypeSchemaId = 201103;

-- Get all loans that are funded or puchased and have notes
Select b.loanrecordid
Into #Funded_Purchased_With_Notes
From #Loans_With_Notes a
Join #Funded_Purchased b
On a.loanrecordid_int = b.loanrecordid;

-- Get all loans that are funded or purchased and do not have notes
Select a.loanid
From #Funded_Purchased a
Left Join #Funded_Purchased_With_Notes b
On a.loanrecordid = b.loanrecordid
Where b.loanrecordid Is Null;

Drop Table #Funded_Purchased
Drop Table #Loans_With_Notes
Drop Table #Funded_Purchased_With_Notes
