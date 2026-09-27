{ unit uFunctions

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

unit uFunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, MAPI, Windows;

function MAPILogon(
  ulUIParam: ULONG_PTR;
  lpszProfileName: LPSTR;
  lpszPassword: LPSTR;
  flFlags:FLAGS;
  ulReserved: ULONG;
  lplhSession: LPLHANDLE): ULONG; stdcall;

function MAPISendMail(
  lhSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  lpMessage: lpMapiMessage;
  flFlags: FLAGS;
  ulReserved: ULONG): ULONG; stdcall;

function MAPISendMailW(
  lhSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  lpMessage: lpMapiMessageW;
  flFlags: FLAGS;
  ulReserved: ULONG): ULONG; stdcall;

function MAPISendDocuments(
  ulUIParam: ULONG_PTR;
  lpszDelimChar: LPSTR;
  lpszFullPaths: LPSTR;
  lpszFileNames: LPSTR;
  ulReserved: ULONG): ULONG; stdcall;

function MAPIReadMail(
  lhSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  lpszMessageID: LPSTR;
  flFlags: FLAGS;
  ulReserved: ULONG;
  lppMessage: PlpMapiMessage): ULONG; stdcall;

function MAPIFindNext(
  lhSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  lpszMessageType: LPSTR;
  lpszSeedMessageID: LPSTR;
  flFlags: FLAGS;
  ulReserved: ULONG;
  lpszMessageID: LPSTR): ULONG; stdcall;

function MAPIResolveName(
  lhSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  lpszName: LPSTR;
  flFlags:FLAGS;
  ulReserved: ULONG;
  lppRecip: PlpMapiRecipDesc): ULONG; stdcall;

function MAPIAddress(
  lhSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  lpszCaption: LPSTR;
  nEditFields: ULONG;
  lpszLabels: LPSTR;
  nRecips: ULONG;
  lpRecips: lpMapiRecipDesc;
  flFlags: FLAGS;
  ulReserved: ULONG;
  lpnNewRecips: LPULONG;
  lppNewRecips: PlpMapiRecipDesc): ULONG; stdcall;

function MAPIFreeBuffer(lpv: LPVOID): ULONG; stdcall;

function MAPIDetails(
  lhSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  lpRecip: lpMapiRecipDesc;
  flFlags: FLAGS;
  ulReserved: ULONG): ULONG; stdcall;

function MAPISaveMail(
  lhSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  lpszMessage: lpMapiMessage;
  flFlags: FLAGS;
  ulReserved: ULONG;
  lpszMessageID: LPSTR): ULONG; stdcall;

function MAPIDeleteMail(
  lpSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  lpszMessageID: LPSTR;
  flFlags: FLAGS;
  ulReserved: ULONG): ULONG; stdcall;

function MAPILogoff(
  lhSession: LHANDLE;
  ulUIParam: ULONG_PTR;
  flFlags: FLAGS;
  ulReserved: ULONG): ULONG; stdcall;

function SMCListProfiles(
  flFlags: ULONG;
  lpnProfiles: LPULONG;
  lppProfiles: PLPSTR): ULONG; stdcall;

function SMCListProfilesW(
  flFlags: ULONG;
  lpnProfiles: LPULONG;
  lppProfiles: LPPWSTR): ULONG; stdcall;

function SMCLoadLibrary(
  lpszLibraryFile: LPSTR;
  flFlags: ULONG): ULONG; stdcall;

function SMCLoadLibraryW(
  lpszLibraryFile: LPWSTR;
  flFlags: ULONG): ULONG; stdcall;

function SMCGetLoadedLibraryName(
  flFlags: ULONG;
  lpszLibraryFile: PLPSTR): ULONG; stdcall;

function SMCGetLoadedLibraryNameW(
  flFlags: ULONG;
  lpszLibraryFile: PLPWSTR): ULONG; stdcall;

implementation

uses
  SMAPICOM_1_0_TLB, uMapiUtils, ActiveX, ComObj, Variants;

type
  TContentType = (ctMessage, ctRecipt, ctRecipts, ctProfiles, ctProfilesW,
    ctStr, ctStrW);

  PStructContainer = ^TStructContainer;
  TStructContainer = packed record
    MagicNumber: Integer;
    WhatType: TContentType;
    Count: Integer;
  end;

const
  MAGIC_NUMBER = $56127834;

var
  Lib: ISMapiLibrary = nil;
  MemList: TFPList = nil;

function NewMem(AType: TContentType; ADataSize: Integer;
  ACount: Integer = 0): Pointer; inline;
var
  Header: PStructContainer;
begin
  Header := AllocMem(SizeOf(TStructContainer) + ADataSize);
  FillByte(Header^, SizeOf(TStructContainer) + ADataSize, 0);
  Header^.MagicNumber := MAGIC_NUMBER;
  Header^.WhatType := AType;
  Header^.Count := ACount;
  Result := Pointer(Pointer(Header) + SizeOf(TStructContainer));
  MemList.Add(Result);
end;

function CheckComLib: Boolean;
begin
  if not Assigned(Lib) then
  begin
    try
      Lib := CoSMapiLibrary.Create;
      Lib.LoadLibrary('');
    except
      Lib := nil;
    end;
  end;
  Result := Assigned(Lib);
end;

function ExceptionToMapiError(E: Exception): ULONG;
begin
  if E is EOleSysError then
  begin
    with E as EOleSysError do
      if Failed(ErrorCode) and (ResultFacility(ErrorCode) = FACILITY_ITF) and (ResultCode(ErrorCode) > $200) then
        Result := ResultCode(ErrorCode) - $200;
  end
  else
    Result := MAPI_E_FAILURE;
end;

function MAPILogon(ulUIParam: ULONG_PTR; lpszProfileName: LPSTR;
  lpszPassword: LPSTR; flFlags: FLAGS; ulReserved: ULONG; lplhSession: LPLHANDLE
  ): ULONG; stdcall;
begin
  if not CheckComLib then
    Exit(MAPI_E_FAILURE);
  try
    lplhSession^ := Lib.Logon(ulUIParam, WideString(String(lpszProfileName)),
      WideString(String(lpszPassword)), flFlags, ulReserved);
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPISendMail(lhSession: LHANDLE; ulUIParam: ULONG_PTR;
  lpMessage: lpMapiMessage; flFlags: FLAGS; ulReserved: ULONG): ULONG; stdcall;
var
  MapiMsg: ISMapiMessage;
begin
  if (not CheckComLib) or (lpMessage = nil) then
    Exit(MAPI_E_FAILURE);
  try
    MapiMsg := CoSMapiMessage.Create;
    MapiMessageToIntf(lpMessage^, MapiMsg, lpMessage^.ulReserved = CP_UTF8);
    Lib.SendMail(lhSession, ulUIParam, MapiMsg, flFlags, ulReserved, True);
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPISendMailW(lhSession: LHANDLE; ulUIParam: ULONG_PTR;
  lpMessage: lpMapiMessageW; flFlags: FLAGS; ulReserved: ULONG): ULONG; stdcall;
var
  MapiMsg: ISMapiMessage;
begin
  if not CheckComLib then
    Exit(MAPI_E_FAILURE);
  try
    MapiMsg := CoSMapiMessage.Create;
    MapiMessageWToIntf(lpMessage^, MapiMsg);
    Lib.SendMail(lhSession, ulUIParam, MapiMsg, flFlags, ulReserved, False);
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPISendDocuments(ulUIParam: ULONG_PTR; lpszDelimChar: LPSTR;
  lpszFullPaths: LPSTR; lpszFileNames: LPSTR; ulReserved: ULONG): ULONG;
  stdcall;
begin
  if not CheckComLib then
    Exit(MAPI_E_FAILURE);
  try
    Lib.SendDocuments(ulUIParam, WideString(String(lpszDelimChar)),
      WideString(String(lpszFullPaths)), WideString(String(lpszFileNames)),
      ulReserved);
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPIReadMail(lhSession: LHANDLE; ulUIParam: ULONG_PTR;
  lpszMessageID: LPSTR; flFlags: FLAGS; ulReserved: ULONG;
  lppMessage: PlpMapiMessage): ULONG; stdcall;
var
  SMapiMsg: ISMapiMessage;
  TmpMsg: PMapiMessage;
begin
  if (not CheckComLib) or (lppMessage = nil) then
    Exit(MAPI_E_FAILURE);
  try
    SMapiMsg := Lib.ReadMail(lhSession, ulUIParam, WideString(String(lpszMessageID)),
      flFlags, ulReserved);
    TmpMsg := PMapiMessage(NewMem(ctMessage, SizeOf(MapiMessage)));
    IntfToMapiMessage(SMapiMsg, TmpMsg^, False);
    lppMessage^ := TmpMsg;
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPIFindNext(lhSession: LHANDLE; ulUIParam: ULONG_PTR;
  lpszMessageType: LPSTR; lpszSeedMessageID: LPSTR; flFlags: FLAGS;
  ulReserved: ULONG; lpszMessageID: LPSTR): ULONG; stdcall;
var
  S: AnsiString;
begin
  if (not CheckComLib) or (lpszMessageID = nil) then
    Exit(MAPI_E_FAILURE);
  try
    S := String(Lib.FindNext(lhSession, ulUIParam, WideString(String(lpszMessageType)),
      WideString(String(lpszSeedMessageID)), flFlags, ulReserved));
    Move(S[1], lpszMessageID^, Length(S) + 1);
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPIResolveName(lhSession: LHANDLE; ulUIParam: ULONG_PTR;
  lpszName: LPSTR; flFlags: FLAGS; ulReserved: ULONG; lppRecip: PlpMapiRecipDesc
  ): ULONG; stdcall;
var
  SMapiRecip: ISMapiRecipDesc;
  TmpRecipt: PMapiRecipDesc;
begin
  if (not CheckComLib) or (lppRecip = nil) then
    Exit(MAPI_E_FAILURE);
  try
    SMapiRecip := Lib.ResolveName(lhSession, ulUIParam, WideString(String(lpszName)),
      flFlags, ulReserved);
    TmpRecipt := PMapiRecipDesc(NewMem(ctRecipt, SizeOf(MapiRecipDesc)));
    IntfToMapiRecipDesc(SMapiRecip, TmpRecipt^);
    lppRecip^ := TmpRecipt;
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPIAddress(lhSession: LHANDLE; ulUIParam: ULONG_PTR;
  lpszCaption: LPSTR; nEditFields: ULONG; lpszLabels: LPSTR; nRecips: ULONG;
  lpRecips: lpMapiRecipDesc; flFlags: FLAGS; ulReserved: ULONG;
  lpnNewRecips: LPULONG; lppNewRecips: PlpMapiRecipDesc): ULONG; stdcall;
var
  Recips, NewRecips: ISMapiCollection;
  Recip: ISMapiRecipDesc;
  I: Integer;
  TmpRecipts: PMapiRecipDesc;
begin
  if (not CheckComLib) or (lppNewRecips = nil) or (lpnNewRecips = nil) then
    Exit(MAPI_E_FAILURE);
  try
    Recips := CoSMapiCollection.Create;
    for I := 0 to nRecips - 1 do
    begin
      Recip := CoSMapiRecipDesc.Create;
      MapiRecipDescToIntf(lpRecips[I], Recip);
      Recips.Add(Recip);
    end;
    NewRecips := Lib.Address(lhSession, ulUIParam, WideString(String(lpszCaption)),
      nEditFields, WideString(String(lpszLabels)), Recips, flFlags, ulReserved);
    if NewRecips.Count > 0 then
    begin
      TmpRecipts := PMapiRecipDesc(NewMem(ctRecipts, SizeOf(MapiRecipDesc) * NewRecips.Count, NewRecips.Count));
      for I := 0 to NewRecips.Count - 1 do
        IntfToMapiRecipDesc(NewRecips.Item[I], TmpRecipts[I]);
      lppNewRecips^ := TmpRecipts;
    end;
    lpnNewRecips^ := NewRecips.Count;
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPIFreeBuffer(lpv: LPVOID): ULONG; stdcall;
var
  I: Integer;
begin
  if lpv <> nil then
  begin
    try
      if MemList.IndexOf(lpv) < 0 then
        Exit(MAPI_E_FAILURE);
      with PStructContainer(lpv - SizeOf(TStructContainer))^ do
      begin
        if MagicNumber <> MAGIC_NUMBER then
          Exit(MAPI_E_FAILURE);
        case WhatType of
          ctMessage: FreeMapiMessage(PMapiMessage(lpv), True);
          ctRecipt: FreeMapiRecipDesc(PMapiRecipDesc(lpv), True);
          ctRecipts: begin
            for I := 0 to Count - 1 do
              FreeMapiRecipDesc(@PMapiRecipDesc(lpv)[I], True);
          end;
          ctProfiles: begin
            for I := 0 to Count - 1 do
              StrDispose(PPAnsiChar(lpv)[I]);
          end;
          ctProfilesW: begin
            for I := 0 to Count - 1 do
              StrDispose(PPWideChar(lpv)[I]);
          end;
          ctStr, ctStrW: ; // Do nothing, string data is part of base data
        end;
      end;
      Freemem(Pointer(lpv - SizeOf(TStructContainer)));
      MemList.Remove(lpv);
      Result := SUCCESS_SUCCESS;
    except
      Result := MAPI_E_FAILURE;
    end;
  end
  else
    Result := MAPI_E_FAILURE;
end;

function MAPIDetails(lhSession: LHANDLE; ulUIParam: ULONG_PTR;
  lpRecip: lpMapiRecipDesc; flFlags: FLAGS; ulReserved: ULONG): ULONG; stdcall;
var
  Recipt: ISMapiRecipDesc;
begin
  if (not CheckComLib) or (lpRecip = nil) then
    Exit(MAPI_E_FAILURE);
  try
    Recipt := CoSMapiRecipDesc.Create;
    MapiRecipDescToIntf(lpRecip^, Recipt);
    Lib.Details(lhSession, ulUIParam, Recipt, flFlags, ulReserved);
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPISaveMail(lhSession: LHANDLE; ulUIParam: ULONG_PTR;
  lpszMessage: lpMapiMessage; flFlags: FLAGS; ulReserved: ULONG;
  lpszMessageID: LPSTR): ULONG; stdcall;
var
  MapiMsg: ISMapiMessage;
  MsgID: String;
begin
  if not CheckComLib then
    Exit(MAPI_E_FAILURE);
  try
    MapiMsg := CoSMapiMessage.Create;
    MapiMessageToIntf(lpszMessage^, MapiMsg, lpszMessage^.ulReserved = CP_UTF8);
    MsgID := String(Lib.SaveMail(lhSession, ulUIParam, MapiMsg, flFlags, ulReserved));
    Move(MsgID[1], lpszMessageID^, Length(MsgID) + 1);
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPIDeleteMail(lpSession: LHANDLE; ulUIParam: ULONG_PTR;
  lpszMessageID: LPSTR; flFlags: FLAGS; ulReserved: ULONG): ULONG; stdcall;
begin
  if not CheckComLib then
    Exit(MAPI_E_FAILURE);
  try
    Lib.DeleteMail(lpSession, ulUIParam, WideString(String(lpszMessageID)),
      flFlags, ulReserved);
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function MAPILogoff(lhSession: LHANDLE; ulUIParam: ULONG_PTR; flFlags: FLAGS;
  ulReserved: ULONG): ULONG; stdcall;
begin
  if not CheckComLib then
    Exit(MAPI_E_FAILURE);
  try
    Lib.Logoff(lhSession, ulUIParam, flFlags, ulReserved);
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function InternalListProfiles(AFlags: ULONG; AOutListCount: LPULONG; AOutList: PPAnsiChar;
  AIsWideChar, AIsUTF8: Boolean): ULONG;
const
  TYPEMAP: array[Boolean] of TContentType = (ctProfiles, ctProfilesW);
var
  List: OleVariant;
  TmpOutList: Pointer;
  I, LI: Integer;
begin
  if (AOutListCount = nil) or (AOutList = nil) then
    Exit(MAPI_E_FAILURE);
  try
    List := CoSMapiLoader.Create.ListProfiles(AFlags);
    if VarIsArray(List) then
    begin
      AOutListCount^ := VarArrayHighBound(List, 1) - VarArrayLowBound(List, 1) + 1;
      TmpOutList := NewMem(TYPEMAP[AIsWideChar], SizeOf(PWideChar) * AOutListCount^,
        AOutListCount^);
      LI := 0;
      for I := VarArrayLowBound(List, 1) to VarArrayHighBound(List, 1) do
      begin
        if AIsWideChar then
          PPWideChar(TmpOutList)[LI] := StrNew(PWideChar(WideString(List[I])))
        else
          PPAnsiChar(TmpOutList)[LI] := WStrToAnsi(WideString(List[I]), AIsUTF8);
        Inc(LI);
      end;
      AOutList^ := TmpOutList;
    end;
    Result := SUCCESS_SUCCESS;
  except
    on E: Exception do
      Result := ExceptionToMapiError(E);
  end;
end;

function SMCListProfiles(flFlags: ULONG; lpnProfiles: LPULONG;
  lppProfiles: PLPSTR): ULONG; stdcall;
begin
  Result := InternalListProfiles(flFlags, lpnProfiles, lppProfiles, False, flFlags and SMF_UTF8 <> 0);
end;

function SMCListProfilesW(flFlags: ULONG; lpnProfiles: LPULONG;
  lppProfiles: LPPWSTR): ULONG; stdcall;
begin
  Result := InternalListProfiles(flFlags, lpnProfiles, LPPSTR(lppProfiles), True, False);
end;

function SMCLoadLibrary(lpszLibraryFile: LPSTR; flFlags: ULONG): ULONG; stdcall;
begin
  try
    Lib := nil;
    Lib := CoSMapiLoader.Create.LoadLibrary(AnsiToWStr(lpszLibraryFile, flFlags and SMF_UTF8 <> 0));
    if Lib <> nil then
      Result := SUCCESS_SUCCESS
    else
      Result := MAPI_E_FAILURE;
  except
    Result := MAPI_E_FAILURE;
  end;
end;

function SMCLoadLibraryW(lpszLibraryFile: LPWSTR; flFlags: ULONG): ULONG; stdcall;
begin
  try
    Lib := nil;
    Lib := CoSMapiLoader.Create.LoadLibrary(WideString(lpszLibraryFile));
    if Lib <> nil then
      Result := SUCCESS_SUCCESS
    else
      Result := MAPI_E_FAILURE;
  except
    Result := MAPI_E_FAILURE;
  end;
end;

function SMCGetLoadedLibraryName(flFlags: ULONG; lpszLibraryFile: PLPSTR): ULONG;
  stdcall;
var
  S: RawByteString;
begin
  try
    if Assigned(Lib) then
    begin
      if flFlags and SMF_UTF8 <> 0 then
        S := UTF8String(Lib.LibraryFile)
      else
        S := String(Lib.LibraryFile);
      if S <> '' then
      begin
        lpszLibraryFile^ := NewMem(ctStr, Length(S) + 1);
        Move(S[1], lpszLibraryFile^^, Length(S) + 1);
      end
      else
        lpszLibraryFile^ := nil;
    end;
    Result := SUCCESS_SUCCESS;
  except
    Result := MAPI_E_FAILURE;
  end;
end;

function SMCGetLoadedLibraryNameW(flFlags: ULONG; lpszLibraryFile: PLPWSTR
  ): ULONG; stdcall;
var
  S: WideString;
begin
  try
    if Assigned(Lib) then
    begin
      S := Lib.LibraryFile;
      if S <> '' then
      begin
        lpszLibraryFile^ := NewMem(ctStrW, (Length(S) + 1) * 2);
        Move(S[1], lpszLibraryFile^^, (Length(S) + 1) * 2);
      end;
    end
    else
      lpszLibraryFile^ := nil;
  except
   Result := MAPI_E_FAILURE;
  end;
end;

procedure CleanUp;
var
  TmpMem: Pointer;
begin
  if Assigned(MemList) then
  begin
    while MemList.Count > 0 do
    begin
      TmpMem := MemList.Last;
      if MAPIFreeBuffer(TmpMem) <> SUCCESS_SUCCESS then
        MemList.Remove(TmpMem);
    end;
    FreeAndNil(MemList);
  end;
end;

initialization
  MemList := TFPList.Create;

finalization
  CleanUp;

end.

