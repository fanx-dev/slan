//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using compiler

**
** if not committed:
** - on GET render view at view/typename/method.html.
** - on POST(or others) just back
**
const class DefaultWeblet : SlanWeblet
{
  **
  ** call method.
  **
  Void execute(Type type, Method method,
             Obj[] constructorParams, Obj[] methodParams)
  {
    //if GET will find the Ctrl#ation.html
    if (req.method == "GET")
    {
      m->defaultView=`$type.name/${method.name}.html`
    }

    //call
    try
    {
      onInvoke(type, method, constructorParams, methodParams)
    }
    catch(TemplateErr e)
    {
      this.res.out.print(e.dump)
    }
    catch(Err e)
    {
      throw Err("Action error : name $type.name#$method.name,
                  on $constructorParams,with $methodParams", e)
    }
  }
  **
  ** call method.
  **
  private Void onInvoke(Type type, Method method, Obj[] constructorParams, Obj[] methodParams)
  {

    obj := type.make(constructorParams)
    method.callOn(obj, methodParams)

    //if not committed to default
    if (!res.isCommitted)
    {
      toDefaultView()
    }
  }

  private Void toDefaultView()
  {
    if (m->defaultView != null)
    {
      writeContentType
      this.render((Uri)(m->defaultView))
    }
    else
    {
      //to back pre view
      back
    }
  }
}