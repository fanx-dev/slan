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
    out.submit("value='Upload!'")
    out.formEnd
    out.bodyEnd.htmlEnd
  }

  @WebPost
  Void saveFile()
  {
    Uri dir := `./`
    UploadHelper helper := UploadHelper()|Str name, InStream in|
    {
      uri := dir.plusName(UploadHelper.newName(name))
      UploadHelper.saveToFile(in, uri.toFile)
      res.out.w("$uri\n")
    }
    setContentType
    res.out.w("save at:\n")
    helper.onService
  }
}