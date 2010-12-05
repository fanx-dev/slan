//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using compiler

**
** Execute the action.
** m->defaultView is typename/method.html
**
internal const class DefaultWeblet : SlanWeblet
{
  **
  ** call method.
  **
  Void execute(ActionLocation loc)
  {
    //m->defaultView is typename/method.html, you can overwrite this
    m->defaultView = `$loc.type.name/${loc.method.name}.html`

    //call
    try
    {
      onInvoke(loc.type, loc.method, loc.constructorParams, loc.methodParams)
    }
    catch(SlanCompilerErr e)
    {
      throw e
    }
    catch(Err e)
    {
      throw Err("Action error : name $loc.type.name#$loc.method.name,
                  on $loc.constructorParams,with $loc.methodParams", e)
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
  }
}