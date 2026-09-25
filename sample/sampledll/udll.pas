unit uDLL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uBase, MAPI, dynlibs, Windows;

type

  { TDLLClient }

  TDLLClient = class(TMAPICLient)
  private
    function CheckMapiResult(ARes: LongWord): Boolean;
    procedure DumpMessage(AMessage: PMapiMessage);
    procedure DumpMessageW(AMessage: PMapiMessageW);
    procedure DumpRecip(ARecip: PMapiRecipDesc);
    procedure DumpRecipW(ARecip: PMapiRecipDescW);
    procedure DumpFile(AFile: PMapiFileDesc);
    procedure DumpFileW(AFile: PMapiFileDescW);
  public
    Handle: TLibHandle;
    Session: LongWord;
    FLib: record
      MAPILogon: LPMAPILOGON;
      MAPILogoff: LPMAPILOGOFF;
      MAPISendMail: LPMAPISENDMAIL;
      MAPISendMailW: LPMAPISENDMAILW;
      MAPISendDocuments: LPMAPISENDDOCUMENTS;
      MAPIFindNext: LPMAPIFINDNEXT;
      MAPIReadMail: LPMAPIREADMAIL;
      MAPISaveMail: LPMAPISAVEMAIL;
      MAPIDeleteMail: LPMAPIDELETEMAIL;
      MAPIAddress: LPMAPIADDRESS;
      MAPIDetails: LPMAPIDETAILS;
      MAPIResolveName: LPMAPIRESOLVENAME;
      MAPIFreeBuffer: LPMAPIFREEBUFFER;

      SMCListProfiles: function(
        flFlags: ULONG;
        lpnProfiles: LPULONG;
        lppProfiles: PLPSTR): ULONG; stdcall;

      SMCListProfilesW: function(
        flFlags: ULONG;
        lpnProfiles: LPULONG;
        lppProfiles: LPPWSTR): ULONG; stdcall;

      SMCLoadLibrary: function(
        lpszLibraryFile: LPSTR;
        flFlags: ULONG): ULONG; stdcall;

      SMCLoadLibraryW: function(
        lpszLibraryFile: LPWSTR;
        flFlags: ULONG): ULONG; stdcall;

      SMCGetLoadedLibraryName: function(
        flFlags: ULONG;
        lpszLibraryFile: PLPSTR): ULONG; stdcall;

      SMCGetLoadedLibraryNameW: function(
        flFlags: ULONG;
        lpszLibraryFile: PLPWSTR): ULONG; stdcall;
    end;
    function Init: Boolean; override;
    function ListLibraries(AFlags: LongWord): TStringArray; override;
    function LoadLibrary(ALib: String): Boolean; override;
    function Logon(AHwnd: LongWord; AProfileName, APassword: String;
      AFlags: LongWord): Boolean; override;
    function Logoff(AHwnd: LongWord): Boolean; override;
    function FindNext(AMsgType, ASeedMsgID: String; AFlags: LongWord; out
      AMsgID: String): Boolean; override;
    function ReadMail(AMsgID: String; AFlags: LongWord): Boolean; override;
    function DeleteMail(AMsgID: String): Boolean; override;
    function SendMail(const AMsg: TSendMessage; AIsAnsi: Boolean; AIsUTF8: Boolean;
      AFlags: LongWord): Boolean; override;
    function SendDocuments(const ADocs: TFileDescs): Boolean; override;
  end;

const
  {$IFDEF CPU64}
  MAPI_LIB = 'smapicli64.dll';
  {$ELSE}
  MAPI_LIB = 'smapicli32.dll';
  {$ENDIF}

implementation

uses
  SMAPICOM_1_0_TLB, LazUTF8;

{ TDLLClient }

function TDLLClient.CheckMapiResult(ARes: LongWord): Boolean;
begin
  if ARes = 0 then
    Result := True
  else
  begin
    Log('MAPI error: ' + IntToStr(ARes));
    Result := False;
  end;
end;

procedure TDLLClient.DumpMessage(AMessage: PMapiMessage);
var
  I: Integer;
begin
  if Assigned(AMessage) then
    with AMessage^ do
    begin
      Log('Reserver: ' + IntToStr(ulReserved));
      Log('Subject: ' + String(lpszSubject));
      Log('Message type: ' + String(lpszMessageType));
      Log('Date recived: ' + String(lpszDateReceived));
      Log('Conversation ID: ' + String(lpszConversationID));
      Log('Flags: ' + IntToHex(flFlags));
      Log('Originator:');
      DumpRecip(lpOriginator);
      Log('Recips:');
      if Assigned(lpRecips) and (nRecipCount > 0) then
        for I := 0 to nRecipCount - 1 do
        begin
          Log('Recipt ' + IntToStr(I) + ':');
          DumpRecip(@lpRecips[I]);
        end;
      Log('Files:');
      if Assigned(lpFiles) and (nFileCount > 0) then
        for I := 0 to nFileCount - 1 do
        begin
          Log('File ' + IntToStr(I) + ':');
          DumpFile(@lpFiles[I]);
        end;
      Log('Note text: ' + String(lpszNoteText));
    end
  else
    Log('<nil>');
end;

procedure TDLLClient.DumpMessageW(AMessage: PMapiMessageW);
var
  I: Integer;
begin
  if Assigned(AMessage) then
    with AMessage^ do
    begin
      Log('Reserver: ' + IntToStr(ulReserved));
      Log('Subject: ' + WideString(lpszSubject));
      Log('Message type: ' + WideString(lpszMessageType));
      Log('Date recived: ' + WideString(lpszDateReceived));
      Log('Conversation ID: ' + WideString(lpszConversationID));
      Log('Flags: ' + IntToHex(flFlags));
      Log('Originator:');
      DumpRecipW(lpOriginator);
      Log('Recips:');
      if Assigned(lpRecips) and (nRecipCount > 0) then
        for I := 0 to nRecipCount - 1 do
        begin
          Log('Recipt ' + IntToStr(I) + ':');
          DumpRecipW(@lpRecips[I]);
        end;
      Log('Files:');
      if Assigned(lpFiles) and (nFileCount > 0) then
        for I := 0 to nFileCount - 1 do
        begin
          Log('File ' + IntToStr(I) + ':');
          DumpFileW(@lpFiles[I]);
        end;
      Log('Note text: ' + WideString(lpszNoteText));
    end
  else
    Log('<nil>');
end;

procedure TDLLClient.DumpRecip(ARecip: PMapiRecipDesc);
begin
  if Assigned(ARecip) then
    with ARecip^ do
    begin
      Log('Reserved: ' + IntToHex(ulReserved));
      Log('Recipt class: ' + IntToHex(ulRecipClass));
      Log('Name: ' + String(lpszName));
      Log('Address: ' + String(lpszAddress));
    end
  else
    Log('<nil>');
end;

procedure TDLLClient.DumpRecipW(ARecip: PMapiRecipDescW);
begin
  if Assigned(ARecip) then
    with ARecip^ do
    begin
      Log('Reserved: ' + IntToHex(ulReserved));
      Log('Recipt class: ' + IntToHex(ulRecipClass));
      Log('Name: ' + WideString(lpszName));
      Log('Address: ' + WideString(lpszAddress));
    end
  else
    Log('<nil>');
end;

procedure TDLLClient.DumpFile(AFile: PMapiFileDesc);
begin
  if Assigned(AFile) then
    with AFile^ do
    begin
      Log('Reserved: ' + IntToHex(ulReserved));
      Log('Flags: ' + IntToHex(flFlags));
      Log('Position: ' + IntToStr(nPosition));
      Log('Path name: ' + String(lpszPathName));
      Log('File name: ' + String(lpszFileName));
    end
  else
    Log('<nil>');
end;

procedure TDLLClient.DumpFileW(AFile: PMapiFileDescW);
begin
  if Assigned(AFile) then
    with AFile^ do
    begin
      Log('Reserved: ' + IntToHex(ulReserved));
      Log('Flags: ' + IntToHex(flFlags));
      Log('Position: ' + IntToStr(nPosition));
      Log('Path name: ' + WideString(lpszPathName));
      Log('File name: ' + WideString(lpszFileName));
    end
  else
    Log('<nil>');
end;

function TDLLClient.Init: Boolean;
begin
  Result := False;
  Handle := dynlibs.LoadLibrary(MAPI_LIB);
  if Handle <> NilHandle then
  begin
    Pointer(FLib.MAPILogon) := GetProcAddress(Handle, 'MAPILogon');
    Pointer(FLib.MAPILogoff) := GetProcAddress(Handle, 'MAPILogoff');
    Pointer(FLib.MAPISendMail) := GetProcAddress(Handle, 'MAPISendMail');
    Pointer(FLib.MAPISendMailW) := GetProcAddress(Handle, 'MAPISendMailW');
    Pointer(FLib.MAPISendDocuments) := GetProcAddress(Handle, 'MAPISendDocuments');
    Pointer(FLib.MAPIFindNext) := GetProcAddress(Handle, 'MAPIFindNext');
    Pointer(FLib.MAPIReadMail) := GetProcAddress(Handle, 'MAPIReadMail');
    Pointer(FLib.MAPISaveMail) := GetProcAddress(Handle, 'MAPISaveMail');
    Pointer(FLib.MAPIDeleteMail) := GetProcAddress(Handle, 'MAPIDeleteMail');
    Pointer(FLib.MAPIAddress) := GetProcAddress(Handle, 'MAPIAddress');
    Pointer(FLib.MAPIDetails) := GetProcAddress(Handle, 'MAPIDetails');
    Pointer(FLib.MAPIResolveName) := GetProcAddress(Handle, 'MAPIResolveName');
    Pointer(FLib.MAPIFreeBuffer) := GetProcAddress(Handle, 'MAPIFreeBuffer');
    Pointer(FLib.SMCListProfiles) := GetProcAddress(Handle, 'SMCListProfiles');
    Pointer(FLib.SMCListProfilesW) := GetProcAddress(Handle, 'SMCListProfilesW');
    Pointer(FLib.SMCLoadLibrary) := GetProcAddress(Handle, 'SMCLoadLibrary');
    Pointer(FLib.SMCLoadLibraryW) := GetProcAddress(Handle, 'SMCLoadLibraryW');
    Pointer(FLib.SMCGetLoadedLibraryName) := GetProcAddress(Handle, 'SMCGetLoadedLibraryName');
    Pointer(FLib.SMCGetLoadedLibraryNameW) := GetProcAddress(Handle, 'SMCGetLoadedLibraryNameW');
    Result := True;
  end;
end;

function TDLLClient.ListLibraries(AFlags: LongWord): TStringArray;
var
  List: PPAnsiChar = nil;
  Count: LongWord = 0;
  I: Integer;
begin
  Result := [];
  if CheckMapiResult(FLib.SMCListProfiles(AFlags or SMF_UTF8 or SMF_INCLUDE_NAME, @Count, @List)) then
  begin
    SetLength(Result, Count);
    for I := 0 to Count - 1 do
      Result[I] := List[I];
  end;
end;

function TDLLClient.LoadLibrary(ALib: String): Boolean;
var
  S: PAnsiChar = nil;
begin
  Result := CheckMapiResult(FLib.SMCLoadLibrary(PChar(ALib), SMF_UTF8));
  if CheckMapiResult(FLib.SMCGetLoadedLibraryName(SMF_UTF8, @S)) then
    Log('Loaded library: ' + String(S));
end;

function TDLLClient.Logon(AHwnd: LongWord; AProfileName, APassword: String;
  AFlags: LongWord): Boolean;
begin
  Result := CheckMapiResult(FLib.MAPILogon(AHwnd, PAnsiChar(UTF8ToWinCP(AProfileName)),
    PAnsiChar(UTF8ToWinCP(APassword)), AFlags, 0, @Session));
end;

function TDLLClient.Logoff(AHwnd: LongWord): Boolean;
begin
  Result := CheckMapiResult(FLib.MAPILogoff(Session, AHwnd, 0, 0));
end;

function TDLLClient.FindNext(AMsgType, ASeedMsgID: String; AFlags: LongWord;
  out AMsgID: String): Boolean;
var
  Buf: array[0..511] of AnsiChar;
begin
  FillByte(Buf, SizeOf(Buf), 0);
  Result := CheckMapiResult(FLib.MAPIFindNext(Session, 0, PAnsiChar(AMsgType),
    PAnsiChar(ASeedMsgID), AFlags, 0, @Buf));
  if Result then
    AMsgID := Buf;
end;

function TDLLClient.ReadMail(AMsgID: String; AFlags: LongWord): Boolean;
var
  Msg: PMapiMessage = nil;
begin
  Result := CheckMapiResult(FLib.MAPIReadMail(Session, 0, PAnsiChar(AMsgID), AFlags, 0, @Msg));
  if Result then
  begin
    DumpMessage(Msg);
    if Msg <> nil then
      CheckMapiResult(FLib.MAPIFreeBuffer(Msg));
  end;
end;

function TDLLClient.DeleteMail(AMsgID: String): Boolean;
begin
  Result := CheckMapiResult(FLib.MAPIDeleteMail(Session, 0, PAnsiChar(AMsgID), 0, 0));
  if Result then
    Log('Deleted');
end;

function TDLLClient.SendMail(const AMsg: TSendMessage; AIsAnsi: Boolean;
  AIsUTF8: Boolean; AFlags: LongWord): Boolean;

function NewStrM(AStr: String): PAnsiChar; //inline;
begin
  if AIsAnsi then
    if AIsUTF8 then
      Result := StrNew(PAnsiChar(AStr))
    else
      Result := StrNew(PAnsiChar(UTF8ToWinCP(AStr)))
  else
    Result := PAnsiChar(StrNew(PWideChar(WideString(AStr))));
end;

var
  Msg: MapiMessage;
  I: Integer;
begin
  FillByte(Msg, SizeOf(Msg), 0);
  if AIsAnsi and AIsUTF8 then
    Msg.ulReserved := CP_UTF8;
  Msg.lpszSubject := NewStrM(AMsg.Subject);
  Msg.lpszNoteText := NewStrM(AMsg.Body);
  if Length(AMsg.Recipts) > 0 then
  begin
    Msg.nRecipCount := Length(AMsg.Recipts);
    Msg.lpRecips := AllocMem(SizeOf(MapiRecipDesc) * Length(AMsg.Recipts));
    for I := 0 to Length(AMsg.Recipts) - 1do
    begin
      Msg.lpRecips[I].ulRecipClass := AMsg.Recipts[I].ReciptClass;
      Msg.lpRecips[I].lpszAddress := NewStrM(AMsg.Recipts[I].Address);
      Msg.lpRecips[I].lpszName := NewStrM(AMsg.Recipts[I].Name);
    end;
  end;
  if Length(AMsg.Files) > 0 then
  begin
    Msg.nFileCount := Length(AMsg.Recipts);
    Msg.lpFiles := AllocMem(SizeOf(MapiFileDesc) * Length(AMsg.Files));
    for I := 0 to Length(AMsg.Files) - 1 do
    begin
      Msg.lpFiles[I].nPosition := AMsg.Files[I].Order;
      Msg.lpFiles[I].lpszFileName := NewStrM(AMsg.Files[I].FileName);
      Msg.lpFiles[I].lpszPathName := NewStrM(AMsg.Files[I].FullPath);
    end;
  end;

  if AIsAnsi then
    Result := CheckMapiResult(FLib.MAPISendMail(Session, 0, @Msg, AFlags, 0))
  else
    Result := CheckMapiResult(FLib.MAPISendMailW(Session, 0, @Msg, AFlags, 0));

  StrDispose(Msg.lpszSubject);
  StrDispose(Msg.lpszNoteText);
  for I := 0 to Msg.nRecipCount - 1 do
  begin
    StrDispose(Msg.lpRecips[I].lpszAddress);
    StrDispose(Msg.lpRecips[I].lpszName);
  end;
  if Msg.lpRecips <> nil then
    Freemem(Msg.lpRecips);
  for I := 0 to Msg.nFileCount - 1 do
  begin
    StrDispose(Msg.lpFiles[I].lpszFileName);
    StrDispose(Msg.lpFiles[I].lpszPathName);
  end;
  if Msg.lpFiles <> nil then
    Freemem(Msg.lpFiles);
end;

function TDLLClient.SendDocuments(const ADocs: TFileDescs): Boolean;
var
  Files, Names: String;
  F: TFileDesc;
begin
  Files := '';
  Names := '';
  for F in ADocs do
  begin
    Files := Files + ';' + F.FullPath;
    Names := Names + ';' + F.FileName;
  end;
  Result := CheckMapiResult(FLib.MAPISendDocuments(Session, ';',
    PAnsiChar(UTF8ToWinCP(Files)), PAnsiChar(UTF8ToWinCP(Names)), 0));
end;

initialization
  Base := TDLLClient.Create;

end.

