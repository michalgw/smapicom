{ unit uMapiUtils

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

unit uMapiUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, MAPI, SMAPICOM_1_0_TLB;

procedure MapiFileDescWToIntf(ASrc: MapiFileDescW; ADest: ISMapiFileDesc);
procedure MapiFileDescToIntf(ASrc: MapiFileDesc; ADest: ISMapiFileDesc);
procedure MapiFileTagExtToIntf(ASrc: MapiFileTagExt; ADest: ISMapiFileTagExt);
procedure MapiRecipDescWToIntf(ASrc: MapiRecipDescW; ADest: ISMapiRecipDesc);
procedure MapiRecipDescToIntf(ASrc: MapiRecipDesc; ADest: ISMapiRecipDesc);
procedure MapiMessageWToIntf(ASrc: MapiMessageW; ADest: ISMapiMessage);
procedure MapiMessageToIntf(ASrc: MapiMessage; ADest: ISMapiMessage; AIsUTF8: Boolean);

procedure IntfToMapiFileDescW(ASrc: ISMapiFileDesc; var ADest: MapiFileDescW);
function IntfToMapiFileDescW(ASrc: ISMapiFileDesc): PMapiFileDescW;
procedure IntfToMapiFileDesc(ASrc: ISMapiFileDesc; var ADest: MapiFileDesc);
function IntfToMapiFileDesc(ASrc: ISMapiFileDesc): PMapiFileDesc;
procedure IntfToMapiFileTagExt(ASrc: ISMapiFileTagExt; var ADest: MapiFileTagExt);
function IntfToMapiFileTagExt(ASrc: ISMapiFileTagExt): PMapiFileTagExt;
procedure IntfToMapiRecipDescW(ASrc: ISMapiRecipDesc; var ADest: MapiRecipDescW);
function IntfToMapiRecipDescW(ASrc: ISMapiRecipDesc): PMapiRecipDescW;
procedure IntfToMapiRecipDesc(ASrc: ISMapiRecipDesc; var ADest: MapiRecipDesc);
function IntfToMapiRecipDesc(ASrc: ISMapiRecipDesc): PMapiRecipDesc;
procedure IntfToMapiMessageW(ASrc: ISMapiMessage; var ADest: MapiMessageW);
function IntfToMapiMessageW(ASrc: ISMapiMessage): PMapiMessageW;
procedure IntfToMapiMessage(ASrc: ISMapiMessage; var ADest: MapiMessage; AIsUTF8: Boolean);
function IntfToMapiMessage(ASrc: ISMapiMessage; AIsUTF8: Boolean): PMapiMessage;

procedure FreeMapiFileDesc(ASrc: PMapiFileDesc; AFreeOnlyFields: Boolean = False);
procedure FreeMapiFileDescW(ASrc: PMapiFileDescW; AFreeOnlyFields: Boolean = False);
procedure FreeMapiFileTagExt(ASrc: PMapiFileTagExt);
procedure FreeMapiRecipDesc(ASrc: PMapiRecipDesc; AFreeOnlyFields: Boolean = False);
procedure FreeMapiRecipDescW(ASrc: PMapiRecipDescW);
procedure FreeMapiMessage(ASrc: PMapiMessage; AFreeOnlyFields: Boolean = False);
procedure FreeMapiMessageW(ASrc: PMapiMessageW);

function CreateISMapiCollection: ISMapiCollection; inline;
function CreateISMapiMessage: ISMapiMessage; inline;
function CreateISMapiFileDesc: ISMapiFileDesc; inline;
function CreateISMapiFileTagExt: ISMapiFileTagExt; inline;
function CreateISMapiRecipDesc: ISMapiRecipDesc; inline;

function AnsiToWStr(ASrc: PAnsiChar; AIsUTF8: Boolean): WideString; inline;
function WStrToAnsi(ASrc: WideString; AIsUTF8: Boolean): PAnsiChar; inline;

implementation

uses
  Variants
  {$IFDEF INCOM}
  , uObjects
  {$ENDIF};

function AnsiToWStr(ASrc: PAnsiChar; AIsUTF8: Boolean): WideString; inline;
begin
  if AIsUTF8 then
    Result := WideString(UTF8String(ASrc))
  else
    Result := WideString(String(ASrc));
end;

function WStrToAnsi(ASrc: WideString; AIsUTF8: Boolean): PAnsiChar; inline;
begin
  if AIsUTF8 then
    Result := StrNew(PAnsiChar(UTF8String(ASrc)))
  else
    Result := StrNew(PAnsiChar(String(ASrc)));
end;

function CreateISMapiCollection: ISMapiCollection; inline;
begin
  {$IFDEF INCOM}
  Result := TSMapiCollection.Create as ISMapiCollection;
  {$ELSE}
  Result := CoSMapiCollection.Create;
  {$ENDIF}
end;

function CreateISMapiMessage: ISMapiMessage; inline;
begin
  {$IFDEF INCOM}
  Result := TSMapiMessage.Create as ISMapiMessage;
  {$ELSE}
  Result := CoSMapiMessage.Create;
  {$ENDIF}
end;

function CreateISMapiFileDesc: ISMapiFileDesc; inline;
begin
  {$IFDEF INCOM}
  Result := TSMapiFileDesc.Create as ISMapiFileDesc;
  {$ELSE}
  Result := CoSMapiFileDesc.Create;
  {$ENDIF}
end;

function CreateISMapiFileTagExt: ISMapiFileTagExt; inline;
begin
  {$IFDEF INCOM}
  Result := TSMapiFileTagExt.Create as ISMapiFileTagExt;
  {$ELSE}
  Result := CoSMapiFileTagExt.Create;
  {$ENDIF}
end;

function CreateISMapiRecipDesc: ISMapiRecipDesc; inline;
begin
  {$IFDEF INCOM}
  Result := TSMapiRecipDesc.Create as ISMapiRecipDesc;
  {$ELSE}
  Result := CoSMapiRecipDesc.Create;
  {$ENDIF}
end;

procedure VarArrayToBytes(AArray: OleVariant; var ALen: Cardinal; var ABytes: PByte); inline;
var
  P: Pointer;
begin
  if VarIsArray(AArray) then
  begin
    ALen := VarArrayHighBound(AArray, 1) - VarArrayLowBound(AArray, 1) + 1;
    if ALen > 0 then
    begin
      P := VarArrayLock(AArray);
      ABytes := AllocMem(ALen);
      Move(P^, ABytes^, ALen);
      VarArrayUnlock(AArray);
    end;
  end;
end;

function BytesToVarArray(ALen: Cardinal; ABytes: PByte): OleVariant; inline;
var
  P: Pointer;
begin
  if (ALen > 0) and (ABytes <> nil) then
  begin
    Result := VarArrayCreate([0, ALen - 1], varByte);
    P := VarArrayLock(Result);
    Move(ABytes^, P^, ALen);
    VarArrayUnlock(Result);
  end
  else
    Result := Null;
end;

procedure MapiFileDescWToIntf(ASrc: MapiFileDescW; ADest: ISMapiFileDesc);
begin
  ADest.Reserved := ASrc.ulReserved;
  ADest.Flags := ASrc.flFlags;
  ADest.Position := ASrc.nPosition;
  ADest.PathName := ASrc.lpszPathName;
  ADest.FileName := ASrc.lpszFileName;
  if ASrc.lpFileType <> nil then
  begin
    ADest.FileType := CreateISMapiFileTagExt;
    MapiFileTagExtToIntf(PMapiFileTagExt(ASrc.lpFileType)^, ADest.FileType);
  end;
end;

procedure MapiFileDescToIntf(ASrc: MapiFileDesc; ADest: ISMapiFileDesc);
begin
  ADest.Reserved := ASrc.ulReserved;
  ADest.Flags := ASrc.flFlags;
  ADest.Position := ASrc.nPosition;
  ADest.PathName := ASrc.lpszPathName;
  ADest.FileName := ASrc.lpszFileName;
  if ASrc.lpFileType <> nil then
  begin
    ADest.FileType := CreateISMapiFileTagExt;
    MapiFileTagExtToIntf(PMapiFileTagExt(ASrc.lpFileType)^, ADest.FileType);
  end;
end;

procedure MapiFileTagExtToIntf(ASrc: MapiFileTagExt; ADest: ISMapiFileTagExt);
begin
  ADest.Reserved := ASrc.ulReserved;
  ADest.Tag := BytesToVarArray(ASrc.cbTag, ASrc.lpTag);
  ADest.Encoding := BytesToVarArray(ASrc.cbEncoding, ASrc.lpEncoding);
end;

procedure MapiRecipDescWToIntf(ASrc: MapiRecipDescW; ADest: ISMapiRecipDesc);
begin
  ADest.Reserved := ASrc.ulReserved;
  ADest.RecipClass := ASrc.ulRecipClass;
  ADest.Name := ASrc.lpszName;
  ADest.Address := ASrc.lpszAddress;
  ADest.EntryID := BytesToVarArray(ASrc.ulEIDSize, ASrc.lpEntryID);
end;

procedure MapiRecipDescToIntf(ASrc: MapiRecipDesc; ADest: ISMapiRecipDesc);
begin
  ADest.Reserved := ASrc.ulReserved;
  ADest.RecipClass := ASrc.ulRecipClass;
  ADest.Name := ASrc.lpszName;
  ADest.Address := ASrc.lpszAddress;
  ADest.EntryID := BytesToVarArray(ASrc.ulEIDSize, ASrc.lpEntryID);
end;

procedure MapiMessageWToIntf(ASrc: MapiMessageW; ADest: ISMapiMessage);
var
  I: Integer;
  R: ISMapiRecipDesc;
  F: ISMapiFileDesc;
  C: ISMapiCollection;
begin
  ADest.Reserved := ASrc.ulReserved;
  ADest.Subject := ASrc.lpszSubject;
  ADest.NoteText := ASrc.lpszNoteText;
  ADest.MessageType := ASrc.lpszMessageType;
  ADest.DateReceived := ASrc.lpszDateReceived;
  ADest.ConversationID := ASrc.lpszConversationID;
  ADest.Flags := ASrc.flFlags;
  if ASrc.lpOriginator <> nil then
  begin
    ADest.Originator := CreateISMapiRecipDesc;
    MapiRecipDescWToIntf(ASrc.lpOriginator^, ADest.Originator);
  end;
  if (ASrc.nRecipCount > 0) and (ASrc.lpRecips <> nil) then
  begin
    C := CreateISMapiCollection;
    for I := 0 to ASrc.nRecipCount - 1 do
    begin
      R := CreateISMapiRecipDesc;
      MapiRecipDescWToIntf(ASrc.lpRecips[I], R);
      C.Add(R);
    end;
    ADest.Recips:= C;
  end;
  if (ASrc.nFileCount > 0) and (ASrc.lpFiles <> nil) then
  begin
    C := CreateISMapiCollection;
    for I := 0 to ASrc.nFileCount - 1 do
    begin
      F := CreateISMapiFileDesc;
      MapiFileDescWToIntf(ASrc.lpFiles[I], F);
      C.Add(F);
    end;
    ADest.Files := C;
  end;
end;

procedure MapiMessageToIntf(ASrc: MapiMessage; ADest: ISMapiMessage;
  AIsUTF8: Boolean);
var
  I: Integer;
  R: ISMapiRecipDesc;
  F: ISMapiFileDesc;
  C: ISMapiCollection;
begin
  ADest.Reserved := ASrc.ulReserved;
  ADest.Subject := AnsiToWStr(ASrc.lpszSubject, AIsUTF8);
  ADest.NoteText := AnsiToWStr(ASrc.lpszNoteText, AIsUTF8);
  ADest.MessageType := AnsiToWStr(ASrc.lpszMessageType, AIsUTF8);
  ADest.DateReceived := AnsiToWStr(ASrc.lpszDateReceived, AIsUTF8);
  ADest.ConversationID := AnsiToWStr(ASrc.lpszConversationID, AIsUTF8);
  ADest.Flags := ASrc.flFlags;
  if ASrc.lpOriginator <> nil then
  begin
    ADest.Originator := CreateISMapiRecipDesc;
    MapiRecipDescToIntf(ASrc.lpOriginator^, ADest.Originator);
  end;
  if (ASrc.nRecipCount > 0) and (ASrc.lpRecips <> nil) then
  begin
    C := CreateISMapiCollection;
    for I := 0 to ASrc.nRecipCount - 1 do
    begin
      R := CreateISMapiRecipDesc;
      MapiRecipDescToIntf(ASrc.lpRecips[I], R);
      C.Add(R);
    end;
    ADest.Recips := C;
  end;
  if (ASrc.nFileCount > 0) and (ASrc.lpFiles <> nil) then
  begin
    C := CreateISMapiCollection;
    for I := 0 to ASrc.nFileCount - 1 do
    begin
      F := CreateISMapiFileDesc;
      MapiFileDescToIntf(ASrc.lpFiles[I], F);
      C.Add(F);
    end;
    ADest.Files := C;
  end;
end;

procedure IntfToMapiFileDescW(ASrc: ISMapiFileDesc; var ADest: MapiFileDescW);
begin
  with ADest, ASrc do
  begin
    ulReserved := Reserved;
    flFlags := Flags;
    nPosition := Position;
    lpszPathName := strnew(PWideChar(PathName));
    lpszFileName := strnew(PWideChar(FileName));
    lpFileType := IntfToMapiFileTagExt(FileType);
  end;
end;

function IntfToMapiFileDescW(ASrc: ISMapiFileDesc): PMapiFileDescW;
begin
  if Assigned(ASrc) then
  begin
    Result := AllocMem(SizeOf(MapiFileDescW));
    FillByte(Result^, SizeOf(MapiFileDescW), 0);
    IntfToMapiFileDescW(ASrc, Result^);
  end
  else
    Result := nil;
end;

procedure IntfToMapiFileDesc(ASrc: ISMapiFileDesc; var ADest: MapiFileDesc);
begin
  with ADest, ASrc do
  begin
    ulReserved := Reserved;
    flFlags := Flags;
    nPosition := Position;
    lpszPathName := strnew(PAnsiChar(String(PathName)));
    lpszFileName := strnew(PAnsiChar(String(FileName)));
    lpFileType := IntfToMapiFileTagExt(FileType);
  end;
end;

function IntfToMapiFileDesc(ASrc: ISMapiFileDesc): PMapiFileDesc;
begin
  if Assigned(ASrc) then
  begin
    Result := AllocMem(SizeOf(MapiFileDesc));
    FillByte(Result^, SizeOf(MapiFileDesc), 0);
    IntfToMapiFileDesc(ASrc, Result^);
  end
  else
    Result := nil;
end;

procedure IntfToMapiFileTagExt(ASrc: ISMapiFileTagExt; var ADest: MapiFileTagExt
  );
begin
  with ADest, ASrc do
  begin
    ulReserved := Reserved;
    VarArrayToBytes(Tag, cbTag, lpTag);
    VarArrayToBytes(Encoding, cbEncoding, lpEncoding);
  end;
end;

function IntfToMapiFileTagExt(ASrc: ISMapiFileTagExt): PMapiFileTagExt;
begin
  if Assigned(ASrc) then
  begin
    Result := AllocMem(SizeOf(MapiFileTagExt));
    FillByte(Result^, SizeOf(MapiFileTagExt), 0);
    IntfToMapiFileTagExt(ASrc, Result^);
  end
  else
    Result := nil;
end;

procedure IntfToMapiRecipDescW(ASrc: ISMapiRecipDesc; var ADest: MapiRecipDescW);
begin
  with ADest, ASrc do
  begin
    ulReserved := Reserved;
    ulRecipClass := RecipClass;
    lpszName := strnew(PWideChar(Name));
    lpszAddress := strnew(PWideChar(Address));
    VarArrayToBytes(EntryID, ulEIDSize, lpEntryID);
  end;
end;

procedure IntfToMapiRecipDesc(ASrc: ISMapiRecipDesc; var ADest: MapiRecipDesc);
begin
  with ADest, ASrc do
  begin
    ulReserved := Reserved;
    ulRecipClass := RecipClass;
    lpszName := strnew(PAnsiChar(String(Name)));
    lpszAddress := strnew(PAnsiChar(String(Address)));
    VarArrayToBytes(EntryID, ulEIDSize, lpEntryID);
  end;
end;

function IntfToMapiRecipDescW(ASrc: ISMapiRecipDesc): PMapiRecipDescW;
begin
  if Assigned(ASrc) then
  begin
    Result := AllocMem(SizeOf(MapiRecipDescW));
    FillByte(Result^, SizeOf(MapiRecipDescW), 0);
    IntfToMapiRecipDescW(ASrc, Result^);
  end
  else
    Result := nil;
end;

function IntfToMapiRecipDesc(ASrc: ISMapiRecipDesc): PMapiRecipDesc;
begin
  if Assigned(ASrc) then
  begin
    Result := AllocMem(SizeOf(MapiRecipDesc));
    FillByte(Result^, SizeOf(MapiRecipDesc), 0);
    IntfToMapiRecipDesc(ASrc, Result^);
  end
  else
    Result := nil;
end;

procedure IntfToMapiMessageW(ASrc: ISMapiMessage; var ADest: MapiMessageW);
var
  I: Integer;
begin
  with ADest, ASrc do
  begin
    ulReserved := Reserved;
    lpszSubject := StrNew(PWideChar(Subject));
    lpszNoteText := StrNew(PWideChar(NoteText));
    lpszMessageType := StrNew(PWideChar(MessageType));
    lpszDateReceived := StrNew(PWideChar(DateReceived));
    lpszConversationID := StrNew(PWideChar(ConversationID));
    lpOriginator := IntfToMapiRecipDescW(Originator);
    if Assigned(Recips) and (Recips.Count > 0) then
    begin
      nRecipCount := Recips.Count;
      lpRecips := AllocMem(SizeOf(MapiRecipDesc) * Recips.Count);
      FillByte(lpRecips^, SizeOf(MapiRecipDesc) * Recips.Count, 0);
      for I := 0 to Recips.Count - 1 do
        IntfToMapiRecipDescW(IUnknown(Recips[I]) as ISMapiRecipDesc, lpRecips[I]);
    end;
    if Assigned(Files) and (Files.Count > 0) then
    begin
      nFileCount := Files.Count;
      lpFiles := AllocMem(SizeOf(MapiFileDescW) * Files.Count);
      FillByte(lpFiles^, SizeOf(MapiFileDescW) * Files.Count, 0);
      for I := 0 to Files.Count - 1 do
        IntfToMapiFileDescW(IUnknown(Files[I]) as ISMapiFileDesc, lpFiles[I]);
    end;
  end;
end;

function IntfToMapiMessageW(ASrc: ISMapiMessage): PMapiMessageW;
begin
  if Assigned(ASrc) then
  begin
    Result := AllocMem(SizeOf(MapiMessageW));
    FillByte(Result^, SizeOf(MapiMessageW), 0);
    IntfToMapiMessageW(ASrc, Result^);
  end
  else
    Result := nil;
end;

procedure IntfToMapiMessage(ASrc: ISMapiMessage; var ADest: MapiMessage; AIsUTF8: Boolean);
var
  I: Integer;
begin
  with ADest, ASrc do
  begin
    ulReserved := Reserved;
    lpszSubject := WStrToAnsi(Subject, AIsUTF8);
    lpszNoteText := WStrToAnsi(NoteText, AIsUTF8);
    lpszMessageType := WStrToAnsi(MessageType, AIsUTF8);
    lpszDateReceived := WStrToAnsi(DateReceived, AIsUTF8);
    lpszConversationID := WStrToAnsi(ConversationID, AIsUTF8);
    lpOriginator := IntfToMapiRecipDesc(Originator);
    if Assigned(Recips) and (Recips.Count > 0) then
    begin
      nRecipCount := Recips.Count;
      lpRecips := AllocMem(SizeOf(MapiRecipDesc) * Recips.Count);
      FillByte(lpRecips^, SizeOf(MapiRecipDesc) * Recips.Count, 0);
      for I := 0 to Recips.Count - 1 do
        IntfToMapiRecipDesc(IUnknown(Recips[I]) as ISMapiRecipDesc, lpRecips[I]);
    end;
    if Assigned(Files) and (Files.Count > 0) then
    begin
      nFileCount := Files.Count;
      lpFiles := AllocMem(SizeOf(MapiFileDescW) * Files.Count);
      FillByte(lpFiles^, SizeOf(MapiFileDescW) * Files.Count, 0);
      for I := 0 to Files.Count - 1 do
        IntfToMapiFileDesc(IUnknown(Files[I]) as ISMapiFileDesc, lpFiles[I]);
    end;
  end;
end;

function IntfToMapiMessage(ASrc: ISMapiMessage; AIsUTF8: Boolean): PMapiMessage;
begin
  begin
    if Assigned(ASrc) then
    begin
      Result := AllocMem(SizeOf(MapiMessageW));
      FillByte(Result^, SizeOf(MapiMessageW), 0);
      IntfToMapiMessage(ASrc, Result^, AIsUTF8);
    end
    else
      Result := nil;
  end;
end;

procedure FreeMapiFileDesc(ASrc: PMapiFileDesc; AFreeOnlyFields: Boolean);
begin
  if ASrc^.lpszFileName <> nil then
    StrDispose(ASrc^.lpszFileName);
  if ASrc^.lpszPathName <> nil then
    StrDispose(ASrc^.lpszPathName);
  if ASrc^.lpFileType <> nil then
    FreeMapiFileTagExt(ASrc^.lpFileType);
  if not AFreeOnlyFields then
    Freemem(ASrc);
end;

procedure FreeMapiFileDescW(ASrc: PMapiFileDescW; AFreeOnlyFields: Boolean);
begin
  if ASrc^.lpszFileName <> nil then
    StrDispose(ASrc^.lpszFileName);
  if ASrc^.lpszPathName <> nil then
    StrDispose(ASrc^.lpszPathName);
  if ASrc^.lpFileType <> nil then
    FreeMapiFileTagExt(ASrc^.lpFileType);
  if not AFreeOnlyFields then
    Freemem(ASrc);
end;

procedure FreeMapiFileTagExt(ASrc: PMapiFileTagExt);
begin
  if ASrc^.lpTag <> nil then
    Freemem(ASrc^.lpTag);
  if ASrc^.lpEncoding <> nil then
    Freemem(ASrc^.lpEncoding);
  Freemem(ASrc);
end;

procedure FreeMapiRecipDesc(ASrc: PMapiRecipDesc; AFreeOnlyFields: Boolean);
begin
  if ASrc^.lpszName <> nil then
    StrDispose(ASrc^.lpszName);
  if ASrc^.lpszAddress <> nil then
    StrDispose(ASrc^.lpszAddress);
  if not AFreeOnlyFields then
    Freemem(ASrc);
end;

procedure FreeMapiRecipDescW(ASrc: PMapiRecipDescW);
begin
  if ASrc^.lpszName <> nil then
    StrDispose(ASrc^.lpszName);
  if ASrc^.lpszAddress <> nil then
    StrDispose(ASrc^.lpszAddress);
  Freemem(ASrc);
end;

procedure FreeMapiMessage(ASrc: PMapiMessage; AFreeOnlyFields: Boolean);
var
  I: Integer;
begin
  if ASrc^.lpszSubject <> nil then
    StrDispose(ASrc^.lpszSubject);
  if ASrc^.lpszNoteText <> nil then
    StrDispose(ASrc^.lpszNoteText);
  if ASrc^.lpszMessageType <> nil then
    StrDispose(ASrc^.lpszMessageType);
  if ASrc^.lpszDateReceived <> nil then
    StrDispose(ASrc^.lpszDateReceived);
  if ASrc^.lpszConversationID <> nil then
    StrDispose(ASrc^.lpszConversationID);
  if ASrc^.lpOriginator <> nil then
    FreeMapiRecipDesc(ASrc^.lpOriginator);
  if (ASrc^.lpRecips <> nil) and (ASrc^.nRecipCount > 0) then
  begin
    for I := 0 to ASrc^.nRecipCount - 1 do
      FreeMapiRecipDesc(@ASrc^.lpRecips[I], True);
    Freemem(ASrc^.lpRecips);
  end;
  if (ASrc^.lpFiles <> nil) and (ASrc^.nFileCount > 0) then
  begin
    for I := 0 to ASrc^.nFileCount - 1 do
      FreeMapiFileDesc(@ASrc^.lpFiles[I], True);
    Freemem(ASrc^.lpFiles);
  end;
  if not AFreeOnlyFields then
    Freemem(ASrc);
end;

procedure FreeMapiMessageW(ASrc: PMapiMessageW);
var
  I: Integer;
begin
  if ASrc^.lpszSubject <> nil then
    StrDispose(ASrc^.lpszSubject);
  if ASrc^.lpszNoteText <> nil then
    StrDispose(ASrc^.lpszNoteText);
  if ASrc^.lpszMessageType <> nil then
    StrDispose(ASrc^.lpszMessageType);
  if ASrc^.lpszDateReceived <> nil then
    StrDispose(ASrc^.lpszDateReceived);
  if ASrc^.lpszConversationID <> nil then
    StrDispose(ASrc^.lpszConversationID);
  if ASrc^.lpOriginator <> nil then
    FreeMapiRecipDescW(ASrc^.lpOriginator);
  if (ASrc^.lpRecips <> nil) and (ASrc^.nRecipCount > 0) then
  begin
    for I := 0 to ASrc^.nRecipCount - 1 do
      FreeMapiRecipDesc(@ASrc^.lpRecips[I], True);
    Freemem(ASrc^.lpRecips);
  end;
  if (ASrc^.lpFiles <> nil) and (ASrc^.nFileCount > 0) then
  begin
    for I := 0 to ASrc^.nFileCount - 1 do
      FreeMapiFileDescW(@ASrc^.lpFiles[I], True);
    Freemem(ASrc^.lpFiles);
  end;
  Freemem(ASrc);
end;

end.

