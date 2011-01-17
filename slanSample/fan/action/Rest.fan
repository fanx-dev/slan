//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanWeb

**
** RESTful example
**
class Rest : SlanWeblet
{
  @WebGet
  Void index()
  {
    render
  }

  @WebGet
  Str get()
  {
    echo(req.method)
    return "get: $stashId"
  }

  @WebPost
  Str post()
  {
    "post"
  }

  @WebPut
  Str put()
  {
    echo("put")
    return "put: $stashId"
  }

  @WebDelete
  Str delete()
  {
    echo("delete")
    return "delete: $stashId"
  }
}