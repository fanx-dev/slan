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
  const Uri[] host := [,]

  ** Constructor.
  new make()
  {
    proxyHost := this.typeof.pod.config("proxyHost", "http://localhost:8080")
    this.host = proxyHost.split(',').map { it.toUri }
    echo("proxy: $host")
  }

  ** ** Invoked prior to serviceing the current request.
  virtual Void beforeService() {}

  override Void onService()
  {
    // check pods
    beforeService

    dummy := req.session

    // proxy request
    c := WebClient()
    c.followRedirects = false
    c.reqUri = `${host.random}${req.uri.relToAuth}`
    c.reqMethod = req.method
    req.headers.each |v,k|
    {
      if (k == "Host") return
      if (k == "Content-Type" && req.method == "GET") return
      c.reqHeaders[k] = v
    }
    c.writeReq

    is100Continue := c.reqHeaders["Expect"] == "100-continue"

    if (req.method == "POST" && ! is100Continue)
      c.reqOut.writeBuf(req.in.readAllBuf).flush

    // proxy response
    c.readRes
    if (is100Continue && c.resCode == 100)
    {
      c.reqOut.writeBuf(req.in.readAllBuf).flush
      c.readRes // final response after the 100continue
    }

    res.statusCode = c.resCode
    c.resHeaders.each |v,k|
    {
      // we don't re-gzip responses
      if (k == "Content-Encoding" && v == "gzip") return
      if (k == "Content-Length") return
      res.headers[k] = v
    }

    if (c.resHeaders["Transfer-Encoding"] != null || c.resHeaders["Content-Length"] != null) {
      buf := c.resIn.readAllBuf

      if (c.resHeaders["Transfer-Encoding"] == null) {
        res.headers["Content-Length"] = buf.size.toStr
      }
      res.out.writeBuf(buf).flush
    }
    c.close
  }
}