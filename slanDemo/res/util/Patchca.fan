//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using slanWeb
using slanUtil

**
** slanUtil
**
class Patchca : SlanWeblet
{
  @WebGet
  Str patchca() {
    setContentType("html")
    return Str<|
                  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
                  <html>
                    <head>
                      <title>Patchca</title>
                    </head>
                    <body>
                     <h1>input the code</h1>
                     <form name="form" method="post" action="/Patchca/validate">
                       <img src="/util/Patchca/image" style="cursor:pointer;" title="Click to refresh" onclick="this.src='/Patchca/image?d='+Math.random();">
                       <input name="code" type="text">
                       <button type="submit">submit</button>
                     </form>
                     <p><a href="/Index/index">home</a></p>
                    </body>
                  </html>
    |>
  }

  Void image()
  {
    req.session // init session
    res.headers["Content-Type"] = "image/jpg"
    patchca := slanUtil::Patchca{}
    code := patchca.create(res.out)
    req.session["code"] = code
  }

  @WebPost
  Str validate(Str code)
  {
    ocode := req.session["code"]
    if (ocode == null || ocode == "") return "wrong"
    message := code.equalsIgnoreCase(ocode) ? "right" : "wrong"
    return message
  }
}