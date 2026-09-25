unit uBase;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TRecipt = record
    ReciptClass: LongWord;
    Name: String;
    Address: String;
  end;

  TRecipts = array of TRecipt;

  TFileDesc = record
    Order: Integer;
    FileName: String;
    FullPath: String;
  end;

  TFileDescs = array of TFileDesc;

  TSendMessage = record
    Subject: String;
    Body: String;
    Recipts: TRecipts;
    Files: TFileDescs;
  end;

  { TMAPICLient }

  TMAPICLient = class
  protected
    procedure Log(AData: String);
  public
    function Init: Boolean; virtual; abstract;
    function ListLibraries(AFlags: LongWord): TStringArray; virtual; abstract;
    function LoadLibrary(ALib: String): Boolean; virtual; abstract;
    function Logon(AHwnd: LongWord; AProfileName, APassword: String; AFlags: LongWord): Boolean; virtual; abstract;
    function Logoff(AHwnd: LongWord): Boolean; virtual; abstract;
    function FindNext(AMsgType, ASeedMsgID: String; AFlags: LongWord; out AMsgID: String): Boolean; virtual; abstract;
    function ReadMail(AMsgID: String; AFlags: LongWord): Boolean; virtual; abstract;
    function DeleteMail(AMsgID: String): Boolean; virtual; abstract;
    function SendMail(const AMsg: TSendMessage; AIsAnsi: Boolean; AIsUTF8: Boolean; AFlags: LongWord): Boolean; virtual; abstract;
    function SendDocuments(const ADocs: TFileDescs): Boolean; virtual; abstract;
  end;

var
  Base: TMAPICLient = nil;

implementation

uses
  uFormMain;

{ TMAPICLient }

procedure TMAPICLient.Log(AData: String);
begin
  FormMain.MemoLog.Append(AData);
end;

finalization
  if Assigned(Base) then
    Base.Free;

end.

