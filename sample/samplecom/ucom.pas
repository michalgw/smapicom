unit uCOM;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, uBase, SMAPICOM_1_0_TLB;

type

  { TCOMClient }

  TCOMClient = class(TMAPICLient)
  private
    procedure LogException(E: Exception);
    procedure DumpMessage(AMsg: ISMapiMessage);
    procedure DumpRecip(ARec: ISMapiRecipDesc);
    procedure DumpFileTag(AFTag: ISMapiFileTagExt);
    procedure DumpFileDesc(AFDesc: ISMapiFileDesc);
  public
    Loader: ISMapiLoader;
    Lib: ISMapiLibrary;
    Session: LongWord;
    function Init: Boolean; override;
    function ListLibraries(AFlags: LongWord): TStringArray; override;
    function LoadLibrary(ALib: String): Boolean; override;
    function Logon(AHwnd: LongWord; AProfileName, APassword: String;
      AFlags: LongWord): Boolean; override;
    function Logoff(AHwnd: LongWord): Boolean; override;
    function FindNext(AMsgType, ASeedMsgID: String; AFlags: LongWord;
      out AMsgID: String): Boolean; override;
    function ReadMail(AMsgID: String; AFlags: LongWord): Boolean; override;
    function DeleteMail(AMsgID: String): Boolean; override;
    function SendMail(const AMsg: TSendMessage; AIsAnsi: Boolean; AIsUTF8: Boolean;
      AFlags: LongWord): Boolean; override;
    function SendDocuments(const ADocs: TFileDescs): Boolean; override;
  end;

implementation

uses
  Variants, ComObj, ActiveX, Windows;

{ TCOMClient }

procedure TCOMClient.LogException(E: Exception);
begin
  Log('EXCEPTION: ' + E.ClassName);
  Log('Message: ' + E.Message);
  if E is EOleSysError then
    with EOleSysError(E) do
    begin
      Log('HRESULT: ' + IntToHex(ErrorCode));
      if ResultFacility(ErrorCode) = FACILITY_ITF then
        Log('MAPI error number: ' + IntToStr(ResultCode(ErrorCode)));
    end;
end;

procedure TCOMClient.DumpMessage(AMsg: ISMapiMessage);
var
  I: Integer;
begin
  if Assigned(AMsg) then
    with AMsg do
    begin
      Log('Reserver: ' + IntToStr(Reserved));
      Log('Subject: ' + Subject);
      Log('Message type: ' + MessageType);
      Log('Date recived: ' + DateReceived);
      Log('Conversation ID: ' + ConversationID);
      Log('Flags: ' + IntToHex(Flags));
      Log('Originator:');
      DumpRecip(Originator);
      Log('Recips:');
      if Assigned(Recips) then
        for I := 0 to Recips.Count - 1 do
        begin
          Log('Recipt ' + IntToStr(I) + ':');
          DumpRecip(IUnknown(Recips[I]) as ISMapiRecipDesc);
        end;
      Log('Files:');
      if Assigned(Files) then
        for I := 0 to Files.Count - 1 do
        begin
          Log('File ' + IntToStr(I) + ':');
          DumpFileDesc(IUnknown(Files[I]) as ISMapiFileDesc);
        end;
      Log('Note text: ' + NoteText);
    end
  else
    Log('<nil>');
end;

procedure TCOMClient.DumpRecip(ARec: ISMapiRecipDesc);
begin
  if Assigned(ARec) then
    with ARec do
    begin
      Log('Reserved: ' + IntToHex(Reserved));
      Log('Recipt class: ' + IntToHex(RecipClass));
      Log('Name: ' + Name);
      Log('Address: ' + Address);
    end
  else
    Log('<nil>');
end;

procedure TCOMClient.DumpFileTag(AFTag: ISMapiFileTagExt);
begin
  //
end;

procedure TCOMClient.DumpFileDesc(AFDesc: ISMapiFileDesc);
begin
  if Assigned(AFDesc) then
    with AFDesc do
    begin
      Log('Reserved: ' + IntToHex(Reserved));
      Log('Flags: ' + IntToHex(Flags));
      Log('Position: ' + IntToStr(Position));
      Log('Path name: ' + PathName);
      Log('File name: ' + FileName);
    end;
end;

function TCOMClient.Init: Boolean;
begin
  Loader := CoSMapiLoader.Create;
  Result := True;
end;

function TCOMClient.ListLibraries(AFlags: LongWord): TStringArray;
var
  LibsArr: OleVariant;
  I, J: Integer;
begin
  Result := nil;
  try
    LibsArr := Loader.ListProfiles(SMF_INCLUDE_NAME or AFlags);
    if VarIsArray(LibsArr) then
    begin
      SetLength(Result, VarArrayHighBound(LibsArr, 1) - VarArrayLowBound(LibsArr, 1) + 1);
      J := 0;
      for I := VarArrayLowBound(LibsArr, 1) to VarArrayHighBound(LibsArr, 1) do
      begin
        Result[J] := WideString(LibsArr[I]);
        Inc(J);
      end;
    end;
  except
    on E: Exception do
      LogException(E);
  end;
end;

function TCOMClient.LoadLibrary(ALib: String): Boolean;
begin
  Result := False;
  try
    Lib := Loader.LoadLibrary(ALib);
    Result := Assigned(Lib);
    if Result then
      Log('Loaded library: ' + Lib.LibraryFile);
  except
    on E: Exception do
      LogException(E);
  end;
end;

function TCOMClient.Logon(AHwnd: LongWord; AProfileName, APassword: String;
  AFlags: LongWord): Boolean;
begin
  Result := False;
  try
    Session := Lib.Logon(AHwnd, AProfileName, APassword, AFlags, 0);
    Log('Loged on');
    Log('Session handle: ' + IntToHex(Session));
    Result := Session <> 0;
  except
    on E: Exception do
      LogException(E);
  end;
end;

function TCOMClient.Logoff(AHwnd: LongWord): Boolean;
begin
  Result := False;
  try
    Lib.Logoff(Session, AHwnd, 0, 0);
    Session := 0;
    Result := True;
  except
    on E: Exception do
      LogException(E);
  end;
end;

function TCOMClient.FindNext(AMsgType, ASeedMsgID: String; AFlags: LongWord;
  out AMsgID: String): Boolean;
begin
  Result := False;
  try
    AMsgID := Lib.FindNext(Session, 0, AMsgType, ASeedMsgID, AFlags, 0);
    Result := True;
  except
    on E: Exception do
      LogException(E);
  end;
end;

function TCOMClient.ReadMail(AMsgID: String; AFlags: LongWord): Boolean;
var
  Msg: ISMapiMessage;
begin
  Result := False;
  try
    Msg := Lib.ReadMail(Session, 0, AMsgID, AFlags, 0);
    Log('Message: ');
    DumpMessage(Msg);
    Result := True;
  except
    on E: Exception do
      LogException(E);
  end;
end;

function TCOMClient.DeleteMail(AMsgID: String): Boolean;
begin
  Result := False;
  try
    Lib.DeleteMail(Session, 0, AMsgID, 0, 0);
    Log('Deleted');
    Result := True;
  except
    on E: Exception do
      LogException(E);
  end;
end;

function TCOMClient.SendMail(const AMsg: TSendMessage; AIsAnsi: Boolean;
  AIsUTF8: Boolean; AFlags: LongWord): Boolean;
var
  SMsg: ISMapiMessage;
  SRecipt: ISMapiRecipDesc;
  R: TRecipt;
  SFile: ISMapiFileDesc;
  F: TFileDesc;
begin
  Result := False;
  try
    SMsg := CoSMapiMessage.Create;
    if AIsAnsi and AIsUTF8 then
      SMsg.Reserved := CP_UTF8;
    SMsg.Subject := AMsg.Subject;
    SMsg.NoteText := AMsg.Body;
    if Length(AMsg.Recipts) > 0 then
    begin
      SMsg.Recips := CoSMapiCollection.Create;
      for R in AMsg.Recipts do
      begin
        SRecipt := CoSMapiRecipDesc.Create;
        SRecipt.RecipClass := R.ReciptClass;
        SRecipt.Address := R.Address;
        SRecipt.Name := R.Name;
        SMsg.Recips.Add(SRecipt);
      end;
    end;
    if Length(AMsg.Files) > 0 then
    begin
      SMsg.Files := CoSMapiCollection.Create;
      for F in AMsg.Files do
      begin
        SFile := CoSMapiFileDesc.Create;
        SFile.FileName := F.FileName;
        SFile.PathName := F.FullPath;
        SMsg.Files.Add(SFile);
      end;
    end;
    DumpMessage(SMsg);
    Lib.SendMail(Session, 0, SMsg, AFlags, 0, AIsAnsi);
    Result := True;
  except
    on E: Exception do
      LogException(E);
  end;
end;

function TCOMClient.SendDocuments(const ADocs: TFileDescs): Boolean;
var
  Names: String = '';
  Paths: String = '';
  F: TFileDesc;
begin
  Result := False;
  try
    for F in ADocs do
    begin
      Log('File name: ' + F.FileName + ', path: ' + F.FullPath);
      Names := Names + ';' + F.FileName;
      Paths := Paths + ';' + F.FullPath;
    end;
    Delete(Names, 1, 1);
    Delete(Paths, 1, 1);
    Lib.SendDocuments(0, ';', Paths, Names, 0);
    Result := True;
  except
    on E: Exception do
      LogException(E);
  end;
end;

initialization
  Base := TCOMClient.Create;

end.

