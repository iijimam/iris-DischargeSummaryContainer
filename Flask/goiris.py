import sys
sys.path+=['c:\\intersystems\\iris\\mgr\\python','c:\\intersystems\\iris\\lib\\python']

class Encounter():
    EncounterNumber = None
    PatientNumber =None
    DocNumber = None
    StartDate =None
    EndDate =None

    def __init__(self,en,pn,dn,sd,ed):
        self.EncounterNumber=en
        self.PatientNumber=pn
        self.DocNumber=dn
        self.StartDate=sd
        self.EndDate=ed

def getAllData():
    import iris
    rset=iris.sql.exec("select Name,DOB from Sample.Person")
    records=[]
    for cn,reco in enumerate(rset):
        dob=iris.system.SQL.TOCHAR(reco[1],"YYYY-MM-DD")
        reco[1]=dob
        records.append(reco)
    return records

def getEncounter(docid,pid):
    import iris
    sql="select EncounterNumber,StartDate,EndDate from ISJ.Encounter where (DoctorNumber=?) and (PatientNumber=?) order by StartDate desc"
    stmt=iris.sql.prepare(sql)
    rset=stmt.execute(docid,pid)
    records=[]
    for cn,reco in enumerate(rset):
        reco[1]=iris.system.SQL.TOCHAR(reco[1],"YYYY-MM-DD")
        reco[2]=iris.system.SQL.TOCHAR(reco[2],"YYYY-MM-DD")
        enc=Encounter(reco[0],pid,docid,reco[1],reco[2])
        records.append(enc)
    return records

def getMedicationRequest(docid,pid):
    import iris
    sql="SELECT OrderNumber, PatientNumber, DoctorNumber, UnitCode,Unit,"\
        +"SingleDose,DailyNumOfTimes,MedicationOrderDate,TotalAmountDispence, TotalDaysDispence,"\
        +"MedicationCode,MedicationName, Period, StartDate, RouteCode, Route"\
        +" FROM ISJ.MedicationRequest"\
        +" where (DoctorNumber=?) and (PatientNumber=?) and (Category=1) order by StartDate desc"
    stmt=iris.sql.prepare(sql)
    rset=stmt.execute(docid,pid)
    records=[]
    for cn,reco in enumerate(rset):
        reco[7]=iris.system.SQL.TOCHAR(reco[7],"YYYY-MM-DD")
        records.append(reco)
    return records

#list=goiris.getConfirmData('DC001','P0003','EN0003','ORD003')
def getConfirmData(docid,pid,encid,moid):
    import iris
    #Patientの取得
    sql="select LastName,FirstName,PatientNumber from ISJ.Patient Where PatientNumber=?"
    stmt=iris.sql.prepare(sql)
    rset=stmt.execute(pid)
    #plist=[]
    for reco in enumerate(rset):
        plist=reco[1]
    
    #処方データの取得
    sql="select MedicationName,Period,Unit,Route,MedicationOrderDate,SingleDose,DailyNumOfTimes,TotalAmountDispence,OrderNumber FROM ISJ.MedicationRequest where PatientNumber=? AND DoctorNumber=? AND OrderNumber=?"
    stmt=iris.sql.prepare(sql)
    rset=stmt.execute(pid,docid,moid)
    #mlist=[]
    for reco in enumerate(rset):
        reco[1][4]=iris.system.SQL.TOCHAR(reco[1][4],"YYYY-MM-DD")
        mlist=reco[1]

    #Allergyデータの取得
    sql="SELECT AllergyName,ConfirmedState,Category, Criticality,AllergyNumber from ISJ.Allergy where PatientNumber=? AND DoctorNumber=?"
    stmt=iris.sql.prepare(sql)
    rset=stmt.execute(pid,docid)
    alist=[]
    for reco in enumerate(rset):
        alist.append(reco[1])
    
    #Conditionの取得
    sql="SELECT Text, Code,ConditionNumber from ISJ.Condition WHERE EncounterNumber=? And PatientNumber=? and DoctorNumber=?"
    stmt=iris.sql.prepare(sql)
    rset=stmt.execute(encid,pid,docid)
    #clist=[]
    for reco in enumerate(rset):
        clist=reco[1]

    #CarePlanの取得
    sql="SELECT StartDate, Details,CareNumber from ISJ.CarePlan Where EncounterNumber=? and PatientNumber=? and DoctorNumber=?"
    stmt=iris.sql.prepare(sql)
    rset=stmt.execute(encid,pid,docid)
    #carelist=[]
    for reco in enumerate(rset):
        reco[1][0]=iris.system.SQL.TOCHAR(reco[1][0],"YYYY-MM-DD")
        carelist=reco[1]

    #Encounter情報
    sql="select StartDate,EndDate,EncounterNumber from ISJ.Encounter where EncounterNumber=?"
    stmt=iris.sql.prepare(sql)
    rset=stmt.execute(encid)
    #elist=[]
    for reco in enumerate(rset):
        reco[1][0]=iris.system.SQL.TOCHAR(reco[1][0],"YYYY-MM-DD")
        reco[1][1]=iris.system.SQL.TOCHAR(reco[1][1],"YYYY-MM-DD")
        elist=reco[1]

    #まとめる
    records={
        "Patient":plist,
        "MedicationRequest":mlist,
        "Allergy":alist,
        "Condition":clist,
        "CarePlan":carelist,
        "Encounter":elist
    }
    return records