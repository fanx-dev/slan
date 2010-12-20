//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using slanWeb

**
** you can delete this file
**
class HelloCtrl : SlanWeblet
{
  //http://localhost:8081/hello/say?name=world
  Void say(Str name)
  {
     m->message = "Hello $name"
     render
  }
}