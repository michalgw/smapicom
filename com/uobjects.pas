{ unit uObjects

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

unit uObjects;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ComObj, SMAPICOM_1_0_TLB, Generics.Collections, ActiveX,
  Windows, MAPI, dynlibs, uMapiUtils;

const
  SMAPI_APPID = '{A3A5CE18-F24D-4321-BF35-6AFECB17528C}';
  SMAPICOMSURROGATE_ENV = 'SMAPICOMSURROGATE';

type
  TVariantList = specialize TList<OleVariant>;

  TSMapiAutoObject = TAutoObject;

  { TSMapiAutoObjectFactory }

  TSMapiAutoObjectFactory = class(TAutoObjectFactory)
    procedure UpdateRegistry(Register: Boolean); override;
  end;

  { TSMapiCollection }

  TSMapiCollection = class(TSMapiAutoObject, ISMapiCollection)
  private
    FList: TVariantList;
  public
    destructor Destroy; override;
    procedure Initialize; override;
    function Get_Item(Index: Integer): OleVariant; Safecall;
    procedure Set_Item(const Index: Integer; Value: OleVariant); safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Add(NewItem: OleVariant): Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;
  end;

  { TSMapiCollectionEnum }

  TSMapiCollectionEnum = class(TInterfacedObject, IEnumVARIANT)
  private
    FCollection: ISMapiCollection;
    FCurrentIndex: Integer;
  public
    constructor Create(AList: ISMapiCollection);
    function Next(celt: ULONG; rgVar: POLEVARIANT;  pCeltFetched: pULONG{=nil}):HResult;StdCall;
    function Skip(celt: ULONG):HResult;StdCall;
    function Reset():HResult;StdCall;
    function Clone(OUT ppEnum: IEnumVARIANT):HResult;StdCall;
  end;

  { TSMapiFileDesc }

  TSMapiFileDesc = class(TSMapiAutoObject, ISMapiFileDesc)
  private
    FReserved: LongWord;
    FFlags: LongWord;
    FPosition: LongWord;
    FPathName: WideString;
    FFileName: WideString;
    FFileType: ISMapiFileTagExt;
  public
    function Get_Reserved : LongWord; Safecall;
    procedure Set_Reserved(const Value:LongWord); safecall;
    function Get_Flags: LongWord; Safecall;
    procedure Set_Flags(const Value: LongWord); safecall;
    function Get_Position: LongWord; Safecall;
    procedure Set_Position(const Value: LongWord); safecall;
    function Get_PathName: WideString; Safecall;
    procedure Set_PathName(const Value: WideString); safecall;
    function Get_FileName: WideString; Safecall;
    procedure Set_FileName(const Value: WideString); safecall;
    function Get_FileType: ISMapiFileTagExt; Safecall;
    procedure Set_FileType(Value:ISMapiFileTagExt); safecall;
  end;

  { TSMapiFileTagExt }

  TSMapiFileTagExt = class(TSMapiAutoObject, ISMapiFileTagExt)
  private
    FReserved: LongWord;
    FTag: OleVariant;
    FEncoding: OleVariant;
  public
    function Get_Reserved : LongWord; Safecall;
    procedure Set_Reserved(const Value:LongWord); safecall;
    function Get_Tag: OleVariant; Safecall;
    procedure Set_Tag(Value: OleVariant); safecall;
    function Get_Encoding: OleVariant; Safecall;
    procedure Set_Encoding(Value: OleVariant); safecall;
end;

  { TSMapiRecipDesc }

  TSMapiRecipDesc = class(TSMapiAutoObject, ISMapiRecipDesc)
    FReserved: LongWord;
    FRecipClass: LongWord;
    FName: WideString;
    FAddress: WideString;
    FEntryID: OleVariant;
  public
    function Get_Reserved : LongWord; Safecall;
    procedure Set_Reserved(const Value:LongWord); safecall;
    function Get_RecipClass: LongWord; Safecall;
    procedure Set_RecipClass(const Value: LongWord); safecall;
    function Get_Name: WideString; Safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Address: WideString; Safecall;
    procedure Set_Address(const Value: WideString); safecall;
    function Get_EntryID : OleVariant; Safecall;
    procedure Set_EntryID(Value:OleVariant); safecall;
  end;

  { TSMapiMessage }

  TSMapiMessage = class(TSMapiAutoObject, ISMapiMessage)
  private
    FReserved: LongWord;
    FSubject: WideString;
    FNoteText: WideString;
    FMessageType: WideString;
    FDateReceived: WideString;
    FConversationID: WideString;
    FFlags: LongWord;
    FOriginator: ISMapiRecipDesc;
    FRecips: ISMapiCollection;
    FFiles: ISMapiCollection;
  public
    function Get_Reserved: LongWord; Safecall;
    procedure Set_Reserved(const Value:LongWord); safecall;
    function Get_Subject: WideString; Safecall;
    procedure Set_Subject(const Value: WideString); safecall;
    function Get_NoteText: WideString; Safecall;
    procedure Set_NoteText(const Value: WideString); safecall;
    function Get_MessageType: WideString; Safecall;
    procedure Set_MessageType(const Value: WideString); safecall;
    function Get_DateReceived: WideString; Safecall;
    procedure Set_DateReceived(const Value: WideString); safecall;
    function Get_ConversationID: WideString; Safecall;
    procedure Set_ConversationID(const Value: WideString); safecall;
    function Get_Flags: LongWord; Safecall;
    procedure Set_Flags(const Value: LongWord); safecall;
    function Get_Originator: ISMapiRecipDesc; Safecall;
    procedure Set_Originator(Value: ISMapiRecipDesc); safecall;
    function Get_Recips: ISMapiCollection; Safecall;
    procedure Set_Recips(Value:ISMapiCollection); safecall;
    function Get_Files: ISMapiCollection; Safecall;
    procedure Set_Files(Value:ISMapiCollection); safecall;
  end;

  { TSMapiLoader }

  TSMapiLoader = class(TSMapiAutoObject, ISMapiLoader)
  public
    function LoadLibrary(LibraryFile: WideString): ISMapiLibrary; safecall;
    function ListProfiles(Flags:LongWord): OleVariant;safecall;
  end;

  { TSMapiLibrary }

  TSMapiLibrary = class(TSMapiAutoObject, ISMapiLibrary)
  private
    FHandle: TLibHandle;
    FLib: record
      MapiLogon: LPMAPILOGON;
      MapiLogoff: LPMAPILOGOFF;
      MapiSendMail: LPMAPISENDMAIL;
      MapiSendMailW: LPMAPISENDMAILW;
      MapiSendDocuments: LPMAPISENDDOCUMENTS;
      MapiFindNext: LPMAPIFINDNEXT;
      MapiReadMail: LPMAPIREADMAIL;
      MapiSaveMail: LPMAPISAVEMAIL;
      MapiDeleteMail: LPMAPIDELETEMAIL;
      MapiAddress: LPMAPIADDRESS;
      MapiDetails: LPMAPIDETAILS;
      MapiResolveName: LPMAPIRESOLVENAME;
      MapiFreeBuffer: LPMAPIFREEBUFFER;
    end;
    FLibFile: WideString;
    procedure CheckLib;
  public
    procedure LoadLibrary(LibraryFile:WideString);safecall;
    procedure UnloadLibrary;safecall;
    function Get_LibraryFile : WideString; Safecall;
    function Get_IsLibraryLoaded : WordBool; Safecall;
    function Logon(UIParams:LongWord;ProfileName:WideString;Password:WideString;Flags:LongWord;Reserved:LongWord): LongWord;safecall;
    procedure Logoff(Session:LongWord;UIParam:LongWord;Flags:LongWord;Reserved:LongWord);safecall;
    procedure SendMail(Session:LongWord;UIParam:LongWord;Message:ISMapiMessage;Flags:LongWord;Reserved:LongWord;UseAnsiFunction:WordBool);safecall;
    procedure SendDocuments(UIParam:LongWord;DelimChar:WideString;FullPaths:WideString;FileNames:WideString;Reserved:LongWord);safecall;
    function FindNext(Session:LongWord;UIParam:LongWord;MessageType:WideString;SeedMessageID:WideString;Flags:LongWord;Reserved:LongWord): WideString;safecall;
    function ReadMail(Session:LongWord;UIParam:LongWord;MessageID:WideString;Flags:LongWord;Reserved:LongWord): ISMapiMessage;safecall;
    function SaveMail(Session:LongWord;UIParam:LongWord;Message:ISMapiMessage;Flags:LongWord;Reserved:LongWord): WideString;safecall;
    procedure DeleteMail(Session:LongWord;UIParam:LongWord;MessageID:WideString;Flags:LongWord;Reserved:LongWord);safecall;
    function Address(Session:LongWord;UIParam:LongWord;Caption:WideString;EditFields:LongWord;Labels:WideString;Recips:ISMapiCollection;Flags:LongWord;Reserved:LongWord): ISMapiCollection;safecall;
    procedure Details(Session:LongWord;UIParam:LongWord;Recip:ISMapiRecipDesc;Flags:LongWord;Reserved:LongWord);safecall;
    function ResolveName(Session:LongWord;UIParam:LongWord;Name:WideString;Flags:LongWord;Reserved:LongWord): ISMapiRecipDesc;safecall;
  end;

function DllRegisterServer: HResult; stdcall;
function DllUnregisterServer: HResult; stdcall;

implementation

uses
  Variants, ComServ, Registry;

var
  ClientNames, ProfileNames, Libaries: TUnicodeStringArray;
  DefaultClientName: UnicodeString = '';
  DefaultClientLib: UnicodeString = '';
  DefaultProfileName: UnicodeString = '';

procedure LoadClients;
const
  MAIL_CLIENTS_REG = 'SOFTWARE\Clients\Mail';
var
  Reg: TRegistry = nil;
  I: Integer;
begin
  ClientNames := [];
  ProfileNames := [];
  Libaries := [];
  DefaultClientName := '';
  DefaultClientLib := '';
  DefaultProfileName := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly(MAIL_CLIENTS_REG) then
    begin
      DefaultClientName := Reg.ReadString(UnicodeString(''));
      Reg.CloseKey;
    end;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly(MAIL_CLIENTS_REG) then
    begin
      ClientNames := Reg.GetKeyNames;
      if Length(ClientNames) > 0 then
      begin
        SetLength(ProfileNames, Length(ClientNames));
        SetLength(Libaries, Length(ClientNames));
        for I := 0 to Length(ClientNames) - 1 do
        begin
          Reg.CloseKey;
          if Reg.OpenKeyReadOnly(MAIL_CLIENTS_REG + '\' + ClientNames[I]) then
          begin
            ProfileNames[I] := Reg.ReadString(UnicodeString(''));
            if ProfileNames[I] = '' then
              ProfileNames[I] := ClientNames[I];
            Libaries[I] := Reg.ReadString(UnicodeString('DLLPath'));
          end;
          if (DefaultClientName <> '') and (ClientNames[I] = DefaultClientName) then
          begin
            DefaultClientLib := Libaries[I];
            DefaultProfileName := ProfileNames[I];
          end;
        end;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure CheckMapiResult(AResult: ULONG);

function GetErrorName: String;
begin
  case AResult of
    MAPI_E_USER_ABORT: Result := 'MAPI_E_USER_ABORT';
    MAPI_E_FAILURE: Result := 'MAPI_E_FAILURE';
    MAPI_E_LOGON_FAILURE: Result := 'MAPI_E_LOGON_FAILURE';
    MAPI_E_DISK_FULL: Result := 'MAPI_E_DISK_FULL';
    MAPI_E_INSUFFICIENT_MEMORY: Result := 'MAPI_E_INSUFFICIENT_MEMORY';
    MAPI_E_ACCESS_DENIED: Result := 'MAPI_E_ACCESS_DENIED';
    MAPI_E_TOO_MANY_SESSIONS: Result := 'MAPI_E_TOO_MANY_SESSIONS';
    MAPI_E_TOO_MANY_FILES: Result := 'MAPI_E_TOO_MANY_FILES';
    MAPI_E_TOO_MANY_RECIPIENTS: Result := 'MAPI_E_TOO_MANY_RECIPIENTS';
    MAPI_E_ATTACHMENT_NOT_FOUND: Result := 'MAPI_E_ATTACHMENT_NOT_FOUND';
    MAPI_E_ATTACHMENT_OPEN_FAILURE: Result := 'MAPI_E_ATTACHMENT_OPEN_FAILURE';
    MAPI_E_ATTACHMENT_WRITE_FAILURE: Result := 'MAPI_E_ATTACHMENT_WRITE_FAILURE';
    MAPI_E_UNKNOWN_RECIPIENT: Result := 'MAPI_E_UNKNOWN_RECIPIENT';
    MAPI_E_BAD_RECIPTYPE: Result := 'MAPI_E_BAD_RECIPTYPE';
    MAPI_E_NO_MESSAGES: Result := 'MAPI_E_NO_MESSAGES';
    MAPI_E_INVALID_MESSAGE: Result := 'MAPI_E_INVALID_MESSAGE';
    MAPI_E_TEXT_TOO_LARGE: Result := 'MAPI_E_TEXT_TOO_LARGE';
    MAPI_E_INVALID_SESSION: Result := 'MAPI_E_INVALID_SESSION';
    MAPI_E_TYPE_NOT_SUPPORTED: Result := 'MAPI_E_TYPE_NOT_SUPPORTED';
    MAPI_E_AMBIGUOUS_RECIPIENT: Result := 'MAPI_E_AMBIGUOUS_RECIPIENT';
    MAPI_E_MESSAGE_IN_USE: Result := 'MAPI_E_MESSAGE_IN_USE';
    MAPI_E_NETWORK_FAILURE: Result := 'MAPI_E_NETWORK_FAILURE';
    MAPI_E_INVALID_EDITFIELDS: Result := 'MAPI_E_INVALID_EDITFIELDS';
    MAPI_E_INVALID_RECIPS: Result := 'MAPI_E_INVALID_RECIPS';
    MAPI_E_NOT_SUPPORTED: Result := 'MAPI_E_NOT_SUPPORTED';
    MAPI_E_UNICODE_NOT_SUPPORTED: Result := 'MAPI_E_UNICODE_NOT_SUPPORTED';
    MAPI_E_ATTACHMENT_TOO_LARGE: Result := 'MAPI_E_ATTACHMENT_TOO_LARGE';
    else Result := 'unknown error';
  end;
end;

begin
  if AResult <> 0 then
    raise EOleSysError.Create(Format('MAPI error number: %d (%s)', [AResult,
      GetErrorName]), ActiveX.MakeResult(1, FACILITY_ITF, AResult), 0);
end;

function DllRegisterServer: HResult; stdcall;
begin
  Result := ComServ.DllRegisterServer;
  if (Result = S_OK) and (SysUtils.GetEnvironmentVariable(SMAPICOMSURROGATE_ENV) <> '') then
  begin
    CreateRegKey('AppID\' + SMAPI_APPID, '', 'Simple MAPI COM Interface');
    CreateRegKey('AppID\' + SMAPI_APPID, 'DllSurrogate', '');
  end;
end;

function DllUnregisterServer: HResult; stdcall;
begin
  Result := ComServ.DllUnregisterServer;
  if (Result = S_OK) then
    DeleteRegKey('AppID\' + SMAPI_APPID);
end;

{ TSMapiAutoObjectFactory }

procedure TSMapiAutoObjectFactory.UpdateRegistry(Register: Boolean);
begin
  inherited UpdateRegistry(Register);
  if Register and (Instancing <> ciInternal) and
    (SysUtils.GetEnvironmentVariable(SMAPICOMSURROGATE_ENV) <> '') then
    CreateRegKey('CLSID\' + GUIDToString(ClassID), 'AppID', SMAPI_APPID);
end;

{ TSMapiCollection }

destructor TSMapiCollection.Destroy;
begin
  if Assigned(FList) then
    FList.Free;
  inherited Destroy;
end;

procedure TSMapiCollection.Initialize;
begin
  inherited Initialize;
  FList := TVariantList.Create;
end;

function TSMapiCollection.Get_Item(Index: Integer): OleVariant; Safecall;
begin
  Result := FList[Index];
end;

procedure TSMapiCollection.Set_Item(const Index: Integer;
  Value: OleVariant); safecall;
begin
  FList[Index] := Value;
end;

function TSMapiCollection.Get_Count: Integer; safecall;
begin
  Result := FList.Count;
end;

function TSMapiCollection.Get__NewEnum: IUnknown; safecall;
begin
  Result := TSMapiCollectionEnum.Create(Self) as IUnknown;
end;

function TSMapiCollection.Add(NewItem: OleVariant): Integer; safecall;
begin
  Result := FList.Add(NewItem);
end;

procedure TSMapiCollection.Delete(Index: Integer); safecall;
begin
  FList.Delete(Index);
end;

procedure TSMapiCollection.Clear; safecall;
begin
  FList.Clear;
end;

{ TSMapiCollectionEnum }

constructor TSMapiCollectionEnum.Create(AList: ISMapiCollection);
begin
  FCollection := AList;
  FCurrentIndex := 0;
end;

function TSMapiCollectionEnum.Next(celt: ULONG; rgVar: POLEVARIANT; pCeltFetched: pULONG
  ): HResult; StdCall;
var
  Fetched: ULONG = 0;
begin
  while (Fetched < celt) and (FCurrentIndex < FCollection.Count) do
  begin
    rgVar[Fetched] := FCollection.Item[FCurrentIndex];
    Inc(FCurrentIndex);
    Inc(Fetched);
  end;
  if pCeltFetched <> nil then
    pCeltFetched^ := Fetched;
  if Fetched = celt then
    Result := S_OK
  else
    Result := S_FALSE;
end;

function TSMapiCollectionEnum.Skip(celt: ULONG): HResult; StdCall;
begin
  if FCurrentIndex + Integer(celt) <= FCollection.Count then
  begin
    Inc(FCurrentIndex, celt);
    Result := S_OK;
  end
  else
  begin
    FCurrentIndex := FCollection.Count;
    Result := S_FALSE;
  end;
end;

function TSMapiCollectionEnum.Reset(): HResult; StdCall;
begin
  FCurrentIndex := 0;
  Result := S_OK;
end;

function TSMapiCollectionEnum.Clone(out ppEnum: IEnumVARIANT): HResult; StdCall;
var
  NewEnum: TSMapiCollectionEnum;
begin
  try
    NewEnum := TSMapiCollectionEnum.Create(FCollection);
    NewEnum.FCurrentIndex := FCurrentIndex;
    ppenum := NewEnum;
    Result := S_OK;
  except
    Result := E_OUTOFMEMORY;
  end;
end;

{ TSMapiFileDesc }

function TSMapiFileDesc.Get_Reserved: LongWord; Safecall;
begin
  Result := FReserved;
end;

procedure TSMapiFileDesc.Set_Reserved(const Value: LongWord); safecall;
begin
  FReserved := Value;
end;

function TSMapiFileDesc.Get_Flags: LongWord; Safecall;
begin
  Result := FFlags;
end;

procedure TSMapiFileDesc.Set_Flags(const Value: LongWord); safecall;
begin
  FFlags := Value;
end;

function TSMapiFileDesc.Get_Position: LongWord; Safecall;
begin
  Result := FPosition;
end;

procedure TSMapiFileDesc.Set_Position(const Value: LongWord); safecall;
begin
  FPosition := Value;
end;

function TSMapiFileDesc.Get_PathName: WideString; Safecall;
begin
  Result := FPathName;
end;

procedure TSMapiFileDesc.Set_PathName(const Value: WideString); safecall;
begin
  FPathName := Value;
end;

function TSMapiFileDesc.Get_FileName: WideString; Safecall;
begin
  Result := FFileName;
end;

procedure TSMapiFileDesc.Set_FileName(const Value: WideString); safecall;
begin
  FFileName := Value;
end;

function TSMapiFileDesc.Get_FileType: ISMapiFileTagExt; Safecall;
begin
  Result := FFileType;
end;

procedure TSMapiFileDesc.Set_FileType(Value: ISMapiFileTagExt); safecall;
begin
  FFileType := Value;
end;

{ TSMapiFileTagExt }

function TSMapiFileTagExt.Get_Reserved: LongWord; Safecall;
begin
  Result := FReserved;
end;

procedure TSMapiFileTagExt.Set_Reserved(const Value: LongWord); safecall;
begin
  FReserved := Value;
end;

function TSMapiFileTagExt.Get_Tag: OleVariant; Safecall;
begin
  Result := FTag;
end;

procedure TSMapiFileTagExt.Set_Tag(Value: OleVariant); safecall;
begin
  FTag := Value;
end;

function TSMapiFileTagExt.Get_Encoding: OleVariant; Safecall;
begin
  Result := FEncoding;
end;

procedure TSMapiFileTagExt.Set_Encoding(Value: OleVariant); safecall;
begin
  FEncoding := Value;
end;

{ TSMapiRecipDesc }

function TSMapiRecipDesc.Get_Reserved: LongWord; Safecall;
begin
  Result := FReserved;
end;

procedure TSMapiRecipDesc.Set_Reserved(const Value: LongWord); safecall;
begin
  FReserved := Value;
end;

function TSMapiRecipDesc.Get_RecipClass: LongWord; Safecall;
begin
  Result := FRecipClass;
end;

procedure TSMapiRecipDesc.Set_RecipClass(const Value: LongWord); safecall;
begin
  FRecipClass := Value;
end;

function TSMapiRecipDesc.Get_Name: WideString; Safecall;
begin
  Result := FName;
end;

procedure TSMapiRecipDesc.Set_Name(const Value: WideString); safecall;
begin
  FName := Value;
end;

function TSMapiRecipDesc.Get_Address: WideString; Safecall;
begin
  Result := FAddress;
end;

procedure TSMapiRecipDesc.Set_Address(const Value: WideString); safecall;
begin
  FAddress := Value;
end;

function TSMapiRecipDesc.Get_EntryID: OleVariant; Safecall;
begin
  Result := FEntryID;
end;

procedure TSMapiRecipDesc.Set_EntryID(Value: OleVariant); safecall;
begin
  FEntryID := Value;
end;

{ TSMapiMessage }

function TSMapiMessage.Get_Reserved: LongWord; Safecall;
begin
  Result := FReserved;
end;

procedure TSMapiMessage.Set_Reserved(const Value: LongWord); safecall;
begin
  FReserved := Value;
end;

function TSMapiMessage.Get_Subject: WideString; Safecall;
begin
  Result := FSubject;
end;

procedure TSMapiMessage.Set_Subject(const Value: WideString); safecall;
begin
  FSubject := Value;
end;

function TSMapiMessage.Get_NoteText: WideString; Safecall;
begin
  Result := FNoteText;
end;

procedure TSMapiMessage.Set_NoteText(const Value: WideString); safecall;
begin
  FNoteText := Value;
end;

function TSMapiMessage.Get_MessageType: WideString; Safecall;
begin
  Result := FMessageType;
end;

procedure TSMapiMessage.Set_MessageType(const Value: WideString); safecall;
begin
  FMessageType := Value;
end;

function TSMapiMessage.Get_DateReceived: WideString; Safecall;
begin
  Result := FDateReceived;
end;

procedure TSMapiMessage.Set_DateReceived(const Value: WideString); safecall;
begin
  FDateReceived := Value;
end;

function TSMapiMessage.Get_ConversationID: WideString; Safecall;
begin
  Result := FConversationID;
end;

procedure TSMapiMessage.Set_ConversationID(const Value: WideString); safecall;
begin
  FConversationID := Value;
end;

function TSMapiMessage.Get_Flags: LongWord; Safecall;
begin
  Result := FFlags;
end;

procedure TSMapiMessage.Set_Flags(const Value: LongWord); safecall;
begin
  FFlags := Value;
end;

function TSMapiMessage.Get_Originator: ISMapiRecipDesc; Safecall;
begin
  Result := FOriginator;
end;

procedure TSMapiMessage.Set_Originator(Value: ISMapiRecipDesc); safecall;
begin
  FOriginator := Value;
end;

function TSMapiMessage.Get_Recips: ISMapiCollection; Safecall;
begin
  Result := FRecips;
end;

procedure TSMapiMessage.Set_Recips(Value: ISMapiCollection); safecall;
begin
  FRecips := Value;
end;

function TSMapiMessage.Get_Files: ISMapiCollection; Safecall;
begin
  Result := FFiles;
end;

procedure TSMapiMessage.Set_Files(Value: ISMapiCollection); safecall;
begin
  FFiles := Value;
end;

{ TSMapiLoader }

function TSMapiLoader.LoadLibrary(LibraryFile: WideString): ISMapiLibrary;
  safecall;
begin
  Result := TSMapiLibrary.Create as ISMapiLibrary;
  try
    Result.LoadLibrary(LibraryFile);
  except
    Result := nil;
    raise;
  end;
end;

function TSMapiLoader.ListProfiles(Flags: LongWord): OleVariant; safecall;
var
  I: Integer;
  Item: WideString;
begin
  if Length(ClientNames) = 0 then
    LoadClients;
  if Length(ClientNames) = 0 then
    Exit(Null);
  // Only default profile
  if Flags and SMF_ONLY_DEFAULT <> 0 then
  begin
    Result := VarArrayCreate([0, 0], varOleStr);
    Item := DefaultClientLib;
    if Flags and SMF_INCLUDE_NAME <> 0 then
      Item := Item + ';' + DefaultProfileName;
    Result[0] := Item;
  end
  else
  begin
    // All profiles
    Result := VarArrayCreate([0, Length(ClientNames) - 1], varOleStr);
    for I := 0 to Length(ClientNames) - 1 do
    begin
      Item := Libaries[I];
      if Flags and SMF_INCLUDE_NAME <> 0 then
        Item := Item + ';' + ProfileNames[I];
      Result[I] := Item;
    end;
  end;
end;

{ TSMapiLibrary }

procedure TSMapiLibrary.CheckLib;
begin
  if FHandle = NilHandle then
    LoadLibrary('');
end;

procedure TSMapiLibrary.LoadLibrary(LibraryFile: WideString); safecall;

procedure LoadAndCheckProc(AName: String; var AProc: Pointer);
begin
  AProc := GetProcAddress(FHandle, AName);
  if AProc = nil then
  begin
    dynlibs.UnloadLibrary(FHandle);
    FHandle := NilHandle;
    raise Exception.Create('Function not found: ' + AName);
  end;
end;

begin
  if FHandle <> NilHandle then
    UnloadLibrary;
  if LibraryFile = '' then
  begin
    if DefaultClientLib = '' then
      LoadClients;
    LibraryFile := DefaultClientLib;
  end;
  if LibraryFile = '' then
    LibraryFile := 'Mapi32.dll';
  FHandle := dynlibs.LoadLibrary(LibraryFile);
  if FHandle <> NilHandle then
    with FLib do
    begin
      LoadAndCheckProc('MAPILogon', Pointer(MapiLogon));
      LoadAndCheckProc('MAPILogoff', Pointer(MapiLogoff));
      LoadAndCheckProc('MAPISendMail', Pointer(MapiSendMail));
      LoadAndCheckProc('MAPISendMailW', Pointer(MapiSendMailW));
      LoadAndCheckProc('MAPISendDocuments', Pointer(MapiSendDocuments));
      LoadAndCheckProc('MAPIFindNext', Pointer(MapiFindNext));
      LoadAndCheckProc('MAPIReadMail', Pointer(MapiReadMail));
      LoadAndCheckProc('MAPISaveMail', Pointer(MapiSaveMail));
      LoadAndCheckProc('MAPIDeleteMail', Pointer(MapiDeleteMail));
      LoadAndCheckProc('MAPIAddress', Pointer(MapiAddress));
      LoadAndCheckProc('MAPIDetails', Pointer(MapiDetails));
      LoadAndCheckProc('MAPIResolveName', Pointer(MapiResolveName));
      LoadAndCheckProc('MAPIFreeBuffer', Pointer(MapiFreeBuffer));
    end
  else
    raise Exception.Create('Can not load library: ' + String(LibraryFile));
  FLibFile := LibraryFile;
end;

procedure TSMapiLibrary.UnloadLibrary; safecall;
begin
  if FHandle <> NilHandle then
    dynlibs.UnloadLibrary(FHandle);
  FHandle := NilHandle;
  FillByte(FLib, SizeOf(FLib), 0);
  FLibFile := '';
end;

function TSMapiLibrary.Get_LibraryFile: WideString; Safecall;
begin
  Result := FLibFile;
end;

function TSMapiLibrary.Get_IsLibraryLoaded: WordBool; Safecall;
begin
  Result := FHandle <> NilHandle;
end;

function TSMapiLibrary.Logon(UIParams: LongWord; ProfileName: WideString;
  Password: WideString; Flags: LongWord; Reserved: LongWord): LongWord;
  safecall;
begin
  CheckLib;
  CheckMapiResult(FLib.MapiLogon(UIParams, PAnsiChar(String(ProfileName)),
    PAnsiChar(String(Password)), Flags, Reserved, @Result));
end;

procedure TSMapiLibrary.Logoff(Session: LongWord; UIParam: LongWord;
  Flags: LongWord; Reserved: LongWord); safecall;
begin
  CheckLib;
  CheckMapiResult(FLib.MapiLogoff(Session, UIParam, Flags, Reserved));
end;

procedure TSMapiLibrary.SendMail(Session: LongWord; UIParam: LongWord;
  Message: ISMapiMessage; Flags: LongWord; Reserved: LongWord;
  UseAnsiFunction: WordBool); safecall;
var
  MapiMsgW: PMapiMessageW = nil;
  MapiMsg: PMapiMessage = nil;
begin
  CheckLib;
  try
    if UseAnsiFunction or (Message.Reserved = CP_UTF8) then
    begin
      MapiMsg := IntfToMapiMessage(Message, Message.Reserved = CP_UTF8);
      CheckMapiResult(FLib.MapiSendMail(Session, UIParam, MapiMsg, Flags, Reserved));
    end
    else
    begin
      MapiMsgW := IntfToMapiMessageW(Message);
      CheckMapiResult(FLib.MapiSendMailW(Session, UIParam, MapiMsgW, Flags, Reserved));
    end;
  finally
    if MapiMsg <> nil then
      FreeMapiMessage(MapiMsg);
    if MapiMsgW <> nil then
      FreeMapiMessageW(MapiMsgW);
  end;
end;

procedure TSMapiLibrary.SendDocuments(UIParam: LongWord; DelimChar: WideString;
  FullPaths: WideString; FileNames: WideString; Reserved: LongWord); safecall;
begin
  CheckLib;
  CheckMapiResult(FLib.MapiSendDocuments(UIParam, PAnsiChar(String(DelimChar)),
    PAnsiChar(String(FullPaths)), PAnsiChar(String(FileNames)), Reserved));
end;

function TSMapiLibrary.FindNext(Session: LongWord; UIParam: LongWord;
  MessageType: WideString; SeedMessageID: WideString; Flags: LongWord;
  Reserved: LongWord): WideString; safecall;
var
  Buf: array[0..511] of AnsiChar;
begin
  CheckLib;
  FillByte(Buf, SizeOf(Buf), 0);
  CheckMapiResult(FLib.MapiFindNext(Session, UIParam, PAnsiChar(String(MessageType)),
    PAnsiChar(String(SeedMessageID)), Flags, Reserved, @Buf));
  Result := Buf;
end;

function TSMapiLibrary.ReadMail(Session: LongWord; UIParam: LongWord;
  MessageID: WideString; Flags: LongWord; Reserved: LongWord): ISMapiMessage;
  safecall;
var
  MapiMsg: PMapiMessage = nil;
begin
  Result := nil;
  CheckLib;
  try
    CheckMapiResult(FLib.MapiReadMail(Session, UIParam, PAnsiChar(String(MessageID)),
      Flags, Reserved, @MapiMsg));
    Result := TSMapiMessage.Create as ISMapiMessage;
    MapiMessageToIntf(MapiMsg^, Result, False);
  finally
    if MapiMsg <> nil then
      FLib.MapiFreeBuffer(MapiMsg);
  end;
end;

function TSMapiLibrary.SaveMail(Session: LongWord; UIParam: LongWord;
  Message: ISMapiMessage; Flags: LongWord; Reserved: LongWord): WideString;
  safecall;
var
  MapiMsg: PMapiMessage = nil;
  Buf: array[0..511] of AnsiChar;
begin
  CheckLib;
  try
    MapiMsg := IntfToMapiMessage(Message, Message.Reserved = CP_UTF8);
    FillByte(Buf, SizeOf(Buf), 0);
    CheckMapiResult(FLib.MapiSaveMail(Session, UIParam, MapiMsg, Flags,
      Reserved, @Buf));
    Result := Buf;
  finally
    if MapiMsg <> nil then
      FreeMapiMessage(MapiMsg);
  end;
end;

procedure TSMapiLibrary.DeleteMail(Session: LongWord; UIParam: LongWord;
  MessageID: WideString; Flags: LongWord; Reserved: LongWord); safecall;
begin
  CheckLib;
  CheckMapiResult(FLib.MapiDeleteMail(Session, UIParam,
    PAnsiChar(String(MessageID)), Flags, Reserved));
end;

function TSMapiLibrary.Address(Session: LongWord; UIParam: LongWord;
  Caption: WideString; EditFields: LongWord; Labels: WideString;
  Recips: ISMapiCollection; Flags: LongWord; Reserved: LongWord
  ): ISMapiCollection; safecall;
var
  MapiRecips: PMapiRecipDesc = nil;
  NumRecips: ULONG = 0;
  NewRecips: PMapiRecipDesc = nil;
  I: Integer;
  RecipItem: ISMapiRecipDesc;
begin
  Result := nil;
  CheckLib;
  try
    MapiRecips := AllocMem(SizeOf(MapiRecipDesc) * Recips.Count);
    for I := 0 to Recips.Count - 1 do
      IntfToMapiRecipDesc(Recips.Item[I], MapiRecips[I]);
    CheckMapiResult(FLib.MapiAddress(Session, UIParam, PAnsiChar(String(Caption)),
      EditFields, PAnsiChar(String(Labels)), Recips.Count, MapiRecips, Flags,
      Reserved, @NumRecips, @NewRecips));
    if NumRecips > 0 then
    begin
      Result := TSMapiCollection.Create as ISMapiCollection;
      for I := 0 to NumRecips - 1 do
      begin
        RecipItem := TSMapiRecipDesc.Create as ISMapiRecipDesc;
        MapiRecipDescToIntf(NewRecips[I], RecipItem);
        Result.Add(RecipItem);
      end;
    end;
  finally
    if MapiRecips <> nil then
    begin
      for I := 0 to Recips.Count - 1 do
        FreeMapiRecipDesc(@MapiRecips[I], True);
      Freemem(MapiRecips);
    end;
    if NewRecips <> nil then
      FLib.MapiFreeBuffer(NewRecips);
  end;
end;

procedure TSMapiLibrary.Details(Session: LongWord; UIParam: LongWord;
  Recip: ISMapiRecipDesc; Flags: LongWord; Reserved: LongWord); safecall;
var
  MapiRecip: PMapiRecipDesc = nil;
begin
  CheckLib;
  try
    MapiRecip := IntfToMapiRecipDesc(Recip);
    CheckMapiResult(FLib.MapiDetails(Session, UIParam, MapiRecip, Flags, Reserved));
  finally
    if MapiRecip <> nil then
      FreeMapiRecipDesc(MapiRecip);
  end;
end;

function TSMapiLibrary.ResolveName(Session: LongWord; UIParam: LongWord;
  Name: WideString; Flags: LongWord; Reserved: LongWord): ISMapiRecipDesc;
  safecall;
var
  MapiRecip: PMapiRecipDesc;
begin
  Result := nil;
  CheckLib;
  try
    CheckMapiResult(FLib.MapiResolveName(Session, UIParam, PAnsiChar(String(Name)),
      Flags, Reserved, @MapiRecip));
    if MapiRecip <> nil then
    begin
      Result := TSMapiRecipDesc.Create as ISMapiRecipDesc;
      MapiRecipDescToIntf(MapiRecip^, Result);
    end;
  finally
    if MapiRecip <> nil then
      FLib.MapiFreeBuffer(MapiRecip);
  end;
end;

initialization
  TSMapiAutoObjectFactory.Create(ComServer, TSMapiCollection, CLASS_SMapiCollection,
    ciMultiInstance, tmApartment);
  TSMapiAutoObjectFactory.Create(ComServer, TSMapiFileDesc, CLASS_SMapiFileDesc,
    ciMultiInstance, tmApartment);
  TSMapiAutoObjectFactory.Create(ComServer, TSMapiFileTagExt, CLASS_SMapiFileTagExt,
    ciMultiInstance, tmApartment);
  TSMapiAutoObjectFactory.Create(ComServer, TSMapiRecipDesc, CLASS_SMapiRecipDesc,
    ciMultiInstance, tmApartment);
  TSMapiAutoObjectFactory.Create(ComServer, TSMapiMessage, CLASS_SMapiMessage,
    ciMultiInstance, tmApartment);
  TSMapiAutoObjectFactory.Create(ComServer, TSMapiLoader, CLASS_SMapiLoader,
    ciMultiInstance, tmApartment);
  TSMapiAutoObjectFactory.Create(ComServer, TSMapiLibrary, CLASS_SMapiLibrary,
    ciMultiInstance, tmApartment);

end.

