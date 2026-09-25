unit uFormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, EditBtn, Grids;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonDelete: TButton;
    ButtonSend: TButton;
    ButtonRead: TButton;
    ButtonFind: TButton;
    ButtonLogoff: TButton;
    ButtonLogon: TButton;
    ButtonDLLList: TButton;
    ButtonDLLLoad: TButton;
    CheckBoxSendAsUTF8: TCheckBox;
    CheckBoxDLLDef: TCheckBox;
    CheckGroupSendFlags: TCheckGroup;
    CheckGroupReadFlags: TCheckGroup;
    CheckGroupFindFlags: TCheckGroup;
    CheckGroupLogonFlags: TCheckGroup;
    ComboBoxSendFunc: TComboBox;
    EditMessageIDDel: TEdit;
    EditSubject: TEdit;
    EditMessageID: TEdit;
    EditMessageType: TEdit;
    EditSeedMessageID: TEdit;
    EditProfileName: TEdit;
    EditPassword: TEdit;
    FileNameEditDLL: TFileNameEdit;
    GroupBox1: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    GroupBoxLogoff: TGroupBox;
    GroupBoxLogon: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListViewDLL: TListView;
    MemoMsg: TMemo;
    MemoLog: TMemo;
    PageControl1: TPageControl;
    Splitter1: TSplitter;
    StringGridRecipts: TStringGrid;
    StringGridFiles: TStringGrid;
    TabSheetSendMail: TTabSheet;
    TabSheetFindRead: TTabSheet;
    TabSheetLogInOff: TTabSheet;
    TabSheetDLL: TTabSheet;
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ButtonDLLListClick(Sender: TObject);
    procedure ButtonDLLLoadClick(Sender: TObject);
    procedure ButtonFindClick(Sender: TObject);
    procedure ButtonLogoffClick(Sender: TObject);
    procedure ButtonLogonClick(Sender: TObject);
    procedure ButtonReadClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
    procedure ComboBoxSendFuncChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListViewDLLClick(Sender: TObject);
  private

  public

  end;

var
  FormMain: TFormMain;

implementation

uses uBase, SMAPICOM_1_0_TLB;

{$R *.lfm}

{ TFormMain }

procedure TFormMain.ButtonDLLListClick(Sender: TObject);
var
  List, Fields: TStringArray;
  S: String;
begin
  ListViewDLL.Clear;
  List := Base.ListLibraries(specialize IfThen<LongWord>(CheckBoxDLLDef.Checked, SMF_ONLY_DEFAULT, 0));
  for S in List do
  begin
    Fields := S.Split([';']);
    if Length(Fields) = 2 then
      with ListViewDLL.Items.Add do
      begin
        Caption := Fields[1];
        SubItems.Add(Fields[0]);
      end;
  end;
end;

procedure TFormMain.ButtonDeleteClick(Sender: TObject);
begin
  if MessageDlg('Delete selected mail?', mtConfirmation, mbYesNo, 0) = mrYes then
    Base.DeleteMail(EditMessageIDDel.Text);
end;

procedure TFormMain.ButtonDLLLoadClick(Sender: TObject);
begin
  if Base.LoadLibrary(FileNameEditDLL.FileName) then
  begin
    ButtonDLLLoad.Enabled := False;
    TabSheetLogInOff.TabVisible := True;
    PageControl1.ActivePage := TabSheetLogInOff;
  end;
end;

procedure TFormMain.ButtonFindClick(Sender: TObject);
var
  S: String = '';
  Flags: LongWord = 0;
begin
  if CheckGroupFindFlags.Checked[0] then
    Flags := Flags or MAPI_GUARANTEE_FIFO;
  if CheckGroupFindFlags.Checked[1] then
    Flags := Flags or MAPI_LONG_MSGID;
  if CheckGroupFindFlags.Checked[1] then
    Flags := Flags or MAPI_UNREAD_ONLY;
  if Base.FindNext(EditMessageType.Text, EditSeedMessageID.Text, Flags, S) then
  begin
    EditMessageID.Text := S;
    EditSeedMessageID.Text := S;
    EditMessageIDDel.Text := S;
  end;
end;

procedure TFormMain.ButtonLogoffClick(Sender: TObject);
begin
  if Base.Logoff(LongWord(Self.Handle)) then
  begin
    GroupBoxLogon.Enabled := True;
    ButtonLogoff.Enabled := False;
    TabSheetFindRead.TabVisible := False;
    TabSheetSendMail.TabVisible := False;
  end;
end;

procedure TFormMain.ButtonLogonClick(Sender: TObject);
var
  Flags: LongWord = 0;
begin
  if CheckGroupLogonFlags.Checked[0] then
    Flags := Flags or MAPI_LOGON_UI;
  if CheckGroupLogonFlags.Checked[1] then
    Flags := Flags or MAPI_NEW_SESSION;
  if CheckGroupLogonFlags.Checked[2] then
    Flags := Flags or MAPI_PASSWORD_UI;
  if CheckGroupLogonFlags.Checked[3] then
    Flags := Flags or MAPI_FORCE_DOWNLOAD;
  if Base.Logon(LongWord(Self.Handle), EditProfileName.Text, EditPassword.Text, Flags) then
  begin
    GroupBoxLogon.Enabled := False;
    ButtonLogoff.Enabled := True;
    TabSheetFindRead.TabVisible := True;
    TabSheetSendMail.TabVisible := True;
  end;
end;

procedure TFormMain.ButtonReadClick(Sender: TObject);
var
  Flags: LongWord = 0;
begin
  if CheckGroupLogonFlags.Checked[0] then
    Flags := Flags or MAPI_BODY_AS_FILE;
  if CheckGroupLogonFlags.Checked[1] then
    Flags := Flags or MAPI_PEEK;
  if CheckGroupLogonFlags.Checked[2] then
    Flags := Flags or MAPI_ENVELOPE_ONLY;
  if CheckGroupLogonFlags.Checked[3] then
    Flags := Flags or MAPI_SUPPRESS_ATTACH;
  Base.ReadMail(EditMessageID.Text, Flags);
end;

procedure TFormMain.ButtonSendClick(Sender: TObject);

function BuildDocuments: TFileDescs;
var
  I: Integer;
  F: TFileDesc;
begin
  Result := [];
  for I := 1 to StringGridFiles.RowCount - 1 do
    if StringGridFiles.Cells[1, I] <> '' then
    begin
      F.FileName := StringGridFiles.Cells[0, I];
      F.FullPath := StringGridFiles.Cells[1, I];
      Result := Concat(Result, [F]);
    end;
end;

function BuildTestMail: TSendMessage;
var
  I: Integer;
  R: TRecipt;
  F: TFileDesc;
begin
  with Result do
  begin
    Subject := EditSubject.Text;
    Body := MemoMsg.Text;
    Recipts := [];
    for I := 1 to StringGridRecipts.RowCount - 1 do
      if (StringGridRecipts.Cells[0, I] <> '') and (StringGridRecipts.Cells[1, I] <> '') then
      begin
        case StringGridRecipts.Cells[0, I] of
          'MAPI_ORIG': R.ReciptClass := MAPI_ORIG;
          'MAPI_TO': R.ReciptClass := MAPI_TO;
          'MAPI_CC': R.ReciptClass := MAPI_CC;
          'MAPI_BCC': R.ReciptClass := MAPI_BCC;
        end;
        R.Address := StringGridRecipts.Cells[1, I];
        R.Name := StringGridRecipts.Cells[2, I];
        Recipts := Concat(Recipts, [R]);
      end;
    Files := BuildDocuments;
  end;
end;

var
  Flags: LongWord = 0;

begin
  case ComboBoxSendFunc.ItemIndex of
    0..1: begin
      if CheckGroupSendFlags.Checked[0] then
        Flags := Flags or MAPI_DIALOG;
      if CheckGroupSendFlags.Checked[0] then
        Flags := Flags or MAPI_LOGON_UI;
      if CheckGroupSendFlags.Checked[0] then
        Flags := Flags or MAPI_NEW_SESSION;
      if CheckGroupSendFlags.Checked[0] then
        Flags := Flags or MAPI_FORCE_UNICODE;
      case ComboBoxSendFunc.ItemIndex of
        0: Base.SendMail(BuildTestMail, True, CheckBoxSendAsUTF8.Checked, Flags);
        1: Base.SendMail(BuildTestMail, False, False, Flags);
      end;
    end;
    2: Base.SendDocuments(BuildDocuments);
  end;
end;

procedure TFormMain.ComboBoxSendFuncChange(Sender: TObject);
begin
  CheckBoxSendAsUTF8.Enabled := ComboBoxSendFunc.ItemIndex = 0;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheetDLL;
  if not Base.Init then
  begin
    MessageDlg('Init failed', mtError, [mbOK], 0);
    PageControl1.Enabled := False;
  end;
end;

procedure TFormMain.ListViewDLLClick(Sender: TObject);
begin
  if ListViewDLL.Selected <> nil then
    FileNameEditDLL.FileName := ListViewDLL.Selected.SubItems[0];
end;

end.

