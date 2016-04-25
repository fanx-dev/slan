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
class Upload : SlanWeblet
{
  @WebGet
  Void upload()
  {
    res.statusCode = 200
    res.headers["Content-Type"] = "text/html; charset=utf-8"
    out := res.out
    out.html.body
    out.w("<a href='/'>Index</a>").hr
    out.form("method='post' action='saveFile' enctype='multipart/form-data'")
    out.p.w("Chooose files to upload:").pEnd
    out.p.w("Upload File 1: ").input("type='file' name='file1'").br
    out.p.w("Upload File 2: ").input("type='file' name='file2'").br
    out.p.w("Upload File 3: ").input("type='file' name='file3'").br
    out.p.w("Name: ").input("type='text' name='name'").br
    out.submit("value='Upload!'")
    out.formEnd
    out.bodyEnd.htmlEnd
  }

  @WebPost
  Void saveFile()
  {
    Uri dir := `./temp/`
    helper := UploadHelper(dir)
    try {
      helper.onService
      setContentType
      helper.params.each |v, k| {
        res.out.w("$k:$v\n")
      }
    } finally {
      helper.dispose
    }
  }
}