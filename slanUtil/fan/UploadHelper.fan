//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   11 Apr 08  Brian Frank  Creation
//

using web

class UploadHelper : Weblet
{
  private Uri tempDir
  Str:Obj params := Str:Obj[:]

  new make(Uri dir := `./temp/`) {
    tempDir = dir
    file := tempDir.toFile
    if (!file.exists) file.create
  }

  override Void onPost()
  {
    // get boundary string
    mime := MimeType(req.headers["Content-Type"])
    boundary := mime.params["boundary"] ?: throw IOErr("Missing boundary param: $mime")

    // process each multi-part
    WebUtil.parseMultiPart(req.in, boundary) |headers, in|
    {
      extractPart(headers, in)
    }
  }

  virtual Void dispose() {
    params.each |v, k| {
      if (v is File) {
        try {
          v->delete
        } catch {}
      }
    }
  }

  protected virtual Void extractPart([Str:Str] headers, InStream in)
  {
    disHeader := headers["Content-Disposition"]
    if (disHeader == null) {
      in.readAllBuf  // drain stream
      return
    }
    mimeParam := MimeType.parseParams(disHeader)
    Str name := mimeParam["name"]
    mime := MimeType(headers["Content-Type"] ?: "text/plain")
    if (mime.mediaType == "text")
    {
      this.params[name] = in.readAllStr
    }
    else
    {
      Str? fileName := mimeParam["filename"]
      if (fileName == null || fileName.size < 3) {
        in.readAllBuf  // drain stream
        return
      } else {
        this.params[name] = saveToFile(in, fileName)
      }
    }
  }

  protected virtual File saveToFile(InStream in, Str name)
  {
    File file := `$tempDir${name}.tmp`.toFile
    out := file.out
    try {
      in.pipe(out)
    }
    catch (Err e) {
      out.close
      file.delete
      throw e
    }
    finally {
      out.close
    }

    return file
  }
}