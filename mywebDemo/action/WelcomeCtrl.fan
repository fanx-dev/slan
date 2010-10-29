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
class WelcomeCtrl : SlanWeblet
{
  Void get()
  {
    req.stash["name"]=m->id
    compileJs(`hello.fwt`)
  }

  @WebGet
  Void welcome(){
    req.stash["name"]=m->id
  }
  
  Void fwt(){
    renderFwt(`hello.fwt`)
  }

  Void printInfo(Int i,Str? m){
    writeContentType
    res.out.w("$i,$m")
  }

  @WebPost
  Void printInfo3(Int i,Str m){
    writeContentType
    res.out.w("$i,$m")
  }
}