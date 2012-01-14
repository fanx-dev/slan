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
    echo(req.method)
    return "post"
  }

  @WebPut
  Str put()
  {
    echo(req.method)
    return "put: $stashId"
  }

  @WebDelete
  Str delete()
  {
    echo(req.method)
    return "delete: $stashId"
  }
}