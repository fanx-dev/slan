//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   11 Apr 08  Brian Frank  Creation
//

using web

const class UploadHelper : Weblet
{
  const |Str,handler| handler

  new make(|Str,handler| handler)
  {
    this.handler = handler
  }

  override Void onPost()
  {
    // get boundary string
    mime := MimeType(req.headers["Content-Type"])
    boundary := mime.params["boundary"] ?: throw IOErr("Missing boundary param: $mime")

    // process each multi-part
    WebUtil.parseMultiPart(req.in, boundary) |headers, in|
    {
      // pick one of these (but not both!)
      //echoPart(headers, in)
      savePartToFile(headers, in)
    }
  }

  private Void savePartToFile(Str:Str headers, InStream in)
  {
    disHeader := headers["Content-Disposition"]
    Str? name := null
    if (disHeader != null) name = MimeType.parseParams(disHeader)["filename"]
    if (name == null || name.size < 3)
    {
      echo("SKIP $disHeader")
      in.readAllBuf  // drain stream
      return
    }

    echo("## savePart: $name")
    handler(name, in)
  }

  static Str newName(Str oldName)
  {
    ext := oldName.toUri.ext
    snap := DateTime.nowUnique.toStr
    name := (ext == null) ? snap : snap + "." + ext
    return name
  }

  static Void saveToFile(InStream in, File file)
  {
    out := file.out
    try
      in.pipe(out)
    finally
      out.close
  }
}