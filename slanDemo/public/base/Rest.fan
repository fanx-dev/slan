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
  Str index()
  {
    setContentType("html")
    return Str<|
                <html>
                  <head>
                    <title>REST</title>
                    <style>
                      form input{
                        width: 80px;
                      }
                    </style>
                    <script src="/javascript/ajax.js" type="text/javascript"></script>

                    <script type="text/javascript">

                      function put()
                      {
                        ajax(
                        {
                          url: "/base/Rest/1",
                          type: "PUT",
                          data: "json",
                          onSuccess: function(msg)
                          {
                            alert(msg);
                          }
                        });
                      }

                      function del()
                      {
                        ajax(
                        {
                          url: "/base/Rest/1",
                          type: "DELETE",
                          data: "json",
                          onSuccess: function(msg)
                          {
                            alert(msg);
                          }
                        });
                      }

                      </script>

                  </head>
                  <body>

                   <form name="form" method="get" action="/base/Rest/1">
                     <input type="submit" value="Get" />
                   </form>

                   <form name="form" method="post" action="/base/Rest">
                     <input type="submit" value="Post" />
                   </form>

                   <button type="button" onclick="put();">Put</button>

                   <button type="button" onclick="del();">Delete</button>

                  </body>
                </html>
       |>
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