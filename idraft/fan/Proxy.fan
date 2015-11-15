//
// Copyright (c) 2011, Andy Frank
// Licensed under the MIT License
//
// History:
//   6 Jun 2011  Andy Frank  Creation
//   2011-11-20  Jed Young
//

using web

**
** Proxy
**
const class Proxy : WebMod
{
  ** Target port to proxy requests to.
  const Int port

  ** Constructor.
  new make(Int port := 8080)
  {
    this.port = port
  }

  ** ** Invoked prior to serviceing the current request.
  virtual Void beforeService() {}

  override Void onService()
  {
    // check pods
    beforeService

    // proxy request
    c := WebClient()
    c.followRedirects = false
    c.reqUri = `http://localhost:${port}${req.uri.relToAuth}`
    c.reqMethod = req.method
    req.headers.each |v,k|
    {
      if (k == "Host") return
      c.reqHeaders[k] = v
    }
    c.writeReq
    if (req.method == "POST")
      c.reqOut.writeBuf(req.in.readAllBuf).flush

    // proxy response
    c.readRes
    res.statusCode = c.resCode
    c.resHeaders.each |v,k| { res.headers[k] = v }
    res.headers["Content-Encoding"] = ""

    if (c.resHeaders["Content-Type"]   != null ||
        c.resHeaders["Content-Length"] != null) {
      c.resIn.pipe(res.out)
    }
    c.close
  }
}