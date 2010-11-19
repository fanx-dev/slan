//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** prime key 
** 
facet class Id
{
  const Bool? generate := null
}

**
** long string
** 
facet class Text {}

**
** extend extra parameter
** 
facet class Colu
{
  const Int? m
  const Int? d
  const Str? name
}

**
** will mapping to table
** 
facet class Persistent {}