{ library smapicli

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

library smapicli;

{$mode objfpc}{$H+}

uses
  SysUtils, Classes, uFunctions, smapicom_1_0_tlb;

exports
  // Simple MAPI functions
  MAPILogon,
  MAPISendMail,
  MAPISendMailW,
  MAPISendDocuments,
  MAPIReadMail,
  MAPIFindNext,
  MAPIResolveName,
  MAPIAddress,
  MAPIFreeBuffer,
  MAPIDetails,
  MAPISaveMail,
  MAPIDeleteMail,
  MAPILogoff,

  // Extra functions
  SMCListProfiles,
  SMCListProfilesW,
  SMCLoadLibrary,
  SMCLoadLibraryW,
  SMCGetLoadedLibraryName,
  SMCGetLoadedLibraryNameW;

begin

end.

