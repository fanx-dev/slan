// To change this License template, choose Tools / Templates
// and edit Licenses / FanDefaultLicense.txt
//
// History:
//   2010-6-26 yangjiandong Creation
//
using web
using slanweb
**
** welcome
**
class Welcome : SlanWeblet
{
  Str id
  new make(Str id){
    this.id=id
  }
  override Void onGet()
  {
    writeContentType
    req.stash["name"]=id
    compileJs(`fwt/hello.fwt`)
    render(`view/body.html`)
  }

  @WebGet
  Void welcome(){
    writeContentType
    req.stash["name"]=id
    render(`view/welcome.html`)
  }
  
  Void fwt(){
    writeContentType
    renderFwt(`fwt/hello.fwt`)
  }

  Void printInfo(Int i,Str? m){
    writeContentType
    res.out.w("$id,$i,$m")
  }

  @WebPost
  Void printInfo3(Int i,Str m){
    writeContentType
    res.out.w("$id,$i,$m")
  }
}