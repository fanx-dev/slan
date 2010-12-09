//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web

**
** Action Mod
**
** see the uri 'http://localhost:8080/action/Welcome/ad/print/115?i=123&m=bac'
**  it will route to 'action'(dir) and compile 'Welcome.fan'(class),
**  then newInstance 'Welecome' with 'ad'(params).
**  call 'printInfo'(method) with 'i=123,m=bac'(named params)
**  dan set req.stash["id"]=115
**
const class ActionMod : WebMod
{
  private const Uri dir //action directory
  private const ActionRunner actionRunner

  **
  ** dir:action directory
  **
  new make(Uri dir)
  {
    this.dir = dir
    actionRunner = ActionRunner()
  }

  override Void onService()
  {
    //load model change
    ModelKeeper.i.loadChange

    //locate action
    action := ActionLocation(dir)
    if (action.parse(req.modRel.path))
    {
      //run action
      actionRunner.execute(action)
    }
  }
}