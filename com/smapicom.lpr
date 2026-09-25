{ library smapicom

  Copyright (C) 2026 GM Systems Michał Gawrycki

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.
}

library smapicom;

{$mode objfpc}{$H+}

uses
  Classes, ComObj, ComServ, uObjects, SMAPICOM_1_0_TLB;

exports
  ComServ.DllGetClassObject,
  ComServ.DllCanUnloadNow,
  uObjects.DllRegisterServer,
  uObjects.DllUnregisterServer;

{$R *.tlb}

begin
  ComServer.IsInteractive := False;
end.

