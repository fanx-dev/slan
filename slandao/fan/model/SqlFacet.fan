//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//

**
** prime key 
** 
facet class Id
{
  const Bool auto:=false
}

**
** extend parameter
** 
facet class Colu
{
  const Int? m
  const Int? d
  const Str? name
}

**
** Ignore the type in Context#createTables
** 
facet class Ignore{
}