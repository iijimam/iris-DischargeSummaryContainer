from flask import Flask, render_template, request
import goiris


app = Flask(__name__)
    
class SummaryData():
    DocNumber = None
    PatientNumber =None
    EncounterNumber = None
    OrderNumber =None

    def __init__(self,dn,pn,en,on):
        self.DocNumber=dn
        self.PatientNumber=pn
        self.EncounterNumber=en
        self.OrderNumber=on

@app.route('/',methods=['GET','POST'])
def index():
    if request.method=='GET':
        #records=goiris.getAllData()

        #posts=Post.query.all()
        #posts = Post.query.order_by(Post.due).all() # こちらに変更
        #return render_template("index.html",posts=posts, today=date.today())
        return render_template("patient.html",post="")


@app.route('/psearch/<string:docid>', methods=['POST'])
def patientsearch(docid):
    result=request.form
    post=goiris.getEncounter(docid,result['pid'])
    #print(post)
    return render_template("patient.html",post=post)


@app.route('/msearch/<string:docid>/<string:pid>/<string:encid>', methods=['GET'])
def mordersearch(docid,pid,encid):
    # Summary情報セット
    sumdata=SummaryData(docid,pid,encid,None)
    #　患者番号とDoc番号で処方を検索する
    post=goiris.getMedicationRequest(docid,pid)
    # Summary情報をリストの先頭に入れる
    post.insert(0,sumdata)
    return render_template("medicationorder.html",post=post)

#/select/post[0].PatientNumber/{{post[0].EncounterNumber}}/{{morder[0]}}
@app.route('/select/<string:docid>/<string:pid>/<string:encid>/<string:moid>', methods=['GET'])
def select(docid,pid,encid,moid):
    #全てのIDがわかったので全情報取得する
    #患者名、入院管理番号、入院開始日、処方情報、アレルギー情報、病名管理、CarePlan
    import goiris
    post=goiris.getConfirmData(docid,pid,encid,moid)
    print(post)
    return render_template("confirm.html",post=post)

@app.route('/fhir/<string:pid>/<string:docid>/<string:encid>/<string:moid>', methods=['GET'])
def fhir(pid,docid,encid,moid):
    #IRISに情報を渡す
    import requests

    #メソッド呼出
    url="http://127.0.0.1:52773/facade/document/"+pid+"/"+docid+"/"+encid+"/"+moid
    print(url)
    apihead={"Content-Type":"application/json;charset=utf-8"}
    ret = requests.post(url,headers=apihead)
    #print(ret.json())
    return render_template("end.html",post=ret.json())


if __name__=="__main__":
    #app.run(debug=True,host='0,0,0,0',port="8081")
    app.run(debug=True,host='0,0,0,0',port="5000")