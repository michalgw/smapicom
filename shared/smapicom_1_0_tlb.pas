Unit SMAPICOM_1_0_TLB;

//  Imported SMAPICOM on 2026-09-23 20:40:44 from D:\lazarus-projekty\smapicom\com\smapicom.tlb

{$mode delphi}{$H+}

interface

// Dependency: stdole v2 (stdole2.pas)
//  Warning: 'GUID' not automatable in ISMapiFileDescdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiFileDescdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiFileDescdisp.GetTypeInfo
//  Warning: 'GUID' not automatable in ISMapiFileDescdisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in ISMapiFileDescdisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in ISMapiFileDescdisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in ISMapiFileDescdisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in ISMapiFileDescdisp.Invoke
//  Warning: 'LongWord' not automatable in ISMapiFileDesc.Reserved
//  Warning: 'LongWord' not automatable in ISMapiFileDesc.Flags
//  Warning: 'LongWord' not automatable in ISMapiFileDesc.Position
//  Warning: 'WideString' not automatable in ISMapiFileDesc.PathName
//  Warning: 'WideString' not automatable in ISMapiFileDesc.FileName
//  Warning: 'ISMapiFileTagExt' not automatable in ISMapiFileDesc.FileType
//  Warning: 'GUID' not automatable in ISMapiFileTagExtdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiFileTagExtdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiFileTagExtdisp.GetTypeInfo
//  Warning: 'GUID' not automatable in ISMapiFileTagExtdisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in ISMapiFileTagExtdisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in ISMapiFileTagExtdisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in ISMapiFileTagExtdisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in ISMapiFileTagExtdisp.Invoke
//  Warning: 'LongWord' not automatable in ISMapiFileTagExt.Reserved
//  Warning: 'OleVariant' not automatable in ISMapiFileTagExt.Tag
//  Warning: 'OleVariant' not automatable in ISMapiFileTagExt.Encoding
//  Warning: 'GUID' not automatable in ISMapiLoaderdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiLoaderdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiLoaderdisp.GetTypeInfo
//  Warning: 'GUID' not automatable in ISMapiLoaderdisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in ISMapiLoaderdisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in ISMapiLoaderdisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in ISMapiLoaderdisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in ISMapiLoaderdisp.Invoke
//  Warning: 'GUID' not automatable in ISMapiLibrarydisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiLibrarydisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiLibrarydisp.GetTypeInfo
//  Warning: 'GUID' not automatable in ISMapiLibrarydisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in ISMapiLibrarydisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in ISMapiLibrarydisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in ISMapiLibrarydisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in ISMapiLibrarydisp.Invoke
//  Warning: 'GUID' not automatable in ISMapiMessagedisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiMessagedisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiMessagedisp.GetTypeInfo
//  Warning: 'GUID' not automatable in ISMapiMessagedisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in ISMapiMessagedisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in ISMapiMessagedisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in ISMapiMessagedisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in ISMapiMessagedisp.Invoke
//  Warning: 'LongWord' not automatable in ISMapiMessage.Reserved
//  Warning: 'WideString' not automatable in ISMapiMessage.Subject
//  Warning: 'WideString' not automatable in ISMapiMessage.NoteText
//  Warning: 'WideString' not automatable in ISMapiMessage.MessageType
//  Warning: 'WideString' not automatable in ISMapiMessage.DateReceived
//  Warning: 'WideString' not automatable in ISMapiMessage.ConversationID
//  Warning: 'LongWord' not automatable in ISMapiMessage.Flags
//  Warning: 'ISMapiRecipDesc' not automatable in ISMapiMessage.Originator
//  Warning: 'ISMapiCollection' not automatable in ISMapiMessage.Recips
//  Warning: 'ISMapiCollection' not automatable in ISMapiMessage.Files
//  Warning: 'GUID' not automatable in ISMapiRecipDescdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiRecipDescdisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiRecipDescdisp.GetTypeInfo
//  Warning: 'GUID' not automatable in ISMapiRecipDescdisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in ISMapiRecipDescdisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in ISMapiRecipDescdisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in ISMapiRecipDescdisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in ISMapiRecipDescdisp.Invoke
//  Warning: 'LongWord' not automatable in ISMapiRecipDesc.Reserved
//  Warning: 'LongWord' not automatable in ISMapiRecipDesc.RecipClass
//  Warning: 'WideString' not automatable in ISMapiRecipDesc.Name
//  Warning: 'WideString' not automatable in ISMapiRecipDesc.Address
//  Warning: 'OleVariant' not automatable in ISMapiRecipDesc.EntryID
//  Warning: 'GUID' not automatable in ISMapiCollectiondisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiCollectiondisp.QueryInterface
//  Warning: 'Ppointer' not automatable in ISMapiCollectiondisp.GetTypeInfo
//  Warning: 'GUID' not automatable in ISMapiCollectiondisp.GetIDsOfNames
//  Warning: 'PShortInt' not automatable in ISMapiCollectiondisp.GetIDsOfNames
//  Warning: 'GUID' not automatable in ISMapiCollectiondisp.Invoke
//  Warning: 'DISPPARAMS' not automatable in ISMapiCollectiondisp.Invoke
//  Warning: 'EXCEPINFO' not automatable in ISMapiCollectiondisp.Invoke
Uses
  Windows,ActiveX,Classes,Variants,stdole2;

Const
  SMAPICOMMajorVersion = 1;
  SMAPICOMMinorVersion = 0;
  SMAPICOMLCID = 0;
  LIBID_SMAPICOM : TGUID = '{E9D4ABC1-8CA7-4906-BA3A-DEBED85C147E}';

  IID_ISMapiFileDesc : TGUID = '{62963666-C343-4161-A5CB-5437A3AC4B30}';
  IID_ISMapiFileTagExt : TGUID = '{470625DF-43EC-4E50-B5B7-79B1E1B0C910}';
  IID_ISMapiLoader : TGUID = '{EA64C36A-166F-4C2A-A649-C88FDE626003}';
  IID_ISMapiLibrary : TGUID = '{5C8C3B90-4886-4CB1-9AAB-0E15267ED341}';
  IID_ISMapiMessage : TGUID = '{1DC5FCFF-6EFA-49C8-BF32-C215B3D29E2B}';
  IID_ISMapiRecipDesc : TGUID = '{04F810FC-8D72-46EC-99DF-FB8BBE70AC2A}';
  IID_ISMapiCollection : TGUID = '{AC07A9D0-AD80-4E92-AEDB-9FDFC79BFC58}';
  CLASS_SMapiCollection : TGUID = '{C40484EA-228E-409D-AB0A-172AE1A2F11D}';
  CLASS_SMapiFileDesc : TGUID = '{8047D49D-0397-4F5C-9C03-CA7416579BA0}';
  CLASS_SMapiFileTagExt : TGUID = '{0B68B2F5-22AD-4B3F-BE53-0D1D9F57E244}';
  CLASS_SMapiRecipDesc : TGUID = '{886B8C1B-DB19-4966-B6BB-67F2A8FBD76F}';
  CLASS_SMapiMessage : TGUID = '{E555476F-DA65-47D0-9E48-79E19310D5D5}';
  CLASS_SMapiLoader : TGUID = '{42BA302B-FBEC-4962-BE1F-3E8573C06617}';
  CLASS_SMapiLibrary : TGUID = '{C01AC2C9-B99B-410F-9E5F-3E2596304258}';

//Enums

Type
  SMapiRecipClass = Integer;
Const
  MAPI_ORIG = $0000000000000000;
  MAPI_TO = $0000000000000001;
  MAPI_CC = $0000000000000002;
  MAPI_BCC = $0000000000000003;

Type
  SMapiMessageFlags = Integer;
Const
  MAPI_UNREAD = $0000000000000001;
  MAPI_RECEIPT_REQUESTED = $0000000000000002;
  MAPI_SENT = $0000000000000004;

Type
  SMapiFlags = Integer;
Const
  MAPI_LOGON_UI = $0000000000000001;
  MAPI_NEW_SESSION = $0000000000000002;
  MAPI_DIALOG = $0000000000000008;
  MAPI_UNREAD_ONLY = $0000000000000020;
  MAPI_ENVELOPE_ONLY = $0000000000000040;
  MAPI_PEEK = $0000000000000080;
  MAPI_GUARANTEE_FIFO = $0000000000000100;
  MAPI_BODY_AS_FILE = $0000000000000200;
  MAPI_AB_NOMODIFY = $0000000000000400;
  MAPI_SUPPRESS_ATTACH = $0000000000000800;
  MAPI_FORCE_DOWNLOAD = $0000000000001000;
  MAPI_LONG_MSGID = $0000000000004000;
  MAPI_PASSWORD_UI = $0000000000020000;
  MAPI_FORCE_UNICODE = $0000000000040000;

Type
  SMapiLibFlags = Integer;
Const
  SMF_INCLUDE_NAME = $0000000000000001;
  SMF_ONLY_DEFAULT = $0000000000000002;
  SMF_UTF8 = $0000000000000004;

//Forward declarations

Type
 ISMapiFileDesc = interface;
 ISMapiFileDescDisp = dispinterface;
 ISMapiFileTagExt = interface;
 ISMapiFileTagExtDisp = dispinterface;
 ISMapiLoader = interface;
 ISMapiLoaderDisp = dispinterface;
 ISMapiLibrary = interface;
 ISMapiLibraryDisp = dispinterface;
 ISMapiMessage = interface;
 ISMapiMessageDisp = dispinterface;
 ISMapiRecipDesc = interface;
 ISMapiRecipDescDisp = dispinterface;
 ISMapiCollection = interface;
 ISMapiCollectionDisp = dispinterface;

//Map CoClass to its default interface

 SMapiCollection = ISMapiCollection;
 SMapiFileDesc = ISMapiFileDesc;
 SMapiFileTagExt = ISMapiFileTagExt;
 SMapiRecipDesc = ISMapiRecipDesc;
 SMapiMessage = ISMapiMessage;
 SMapiLoader = ISMapiLoader;
 SMapiLibrary = ISMapiLibrary;

//records, unions, aliases


//interface declarations

// ISMapiFileDesc : 

 ISMapiFileDesc = interface(IDispatch)
   ['{62963666-C343-4161-A5CB-5437A3AC4B30}']
   function Get_Reserved : LongWord; Safecall;
   procedure Set_Reserved(const Value:LongWord); safecall;
   function Get_Flags : LongWord; Safecall;
   procedure Set_Flags(const Value:LongWord); safecall;
   function Get_Position : LongWord; Safecall;
   procedure Set_Position(const Value:LongWord); safecall;
   function Get_PathName : WideString; Safecall;
   procedure Set_PathName(const Value:WideString); safecall;
   function Get_FileName : WideString; Safecall;
   procedure Set_FileName(const Value:WideString); safecall;
   function Get_FileType : ISMapiFileTagExt; Safecall;
   procedure Set_FileType(Value:ISMapiFileTagExt); safecall;
    // Reserved : Reserved for future use (M.B. 0) 
   property Reserved: LongWord read Get_Reserved write Set_Reserved;
    // Flags : Flags 
   property Flags: LongWord read Get_Flags write Set_Flags;
    // Position : Character in text to be replaced by attachment 
   property Position: LongWord read Get_Position write Set_Position;
    // PathName : Full path name of attachment file 
   property PathName: WideString read Get_PathName write Set_PathName;
    // FileName : Original file name (optional) 
   property FileName: WideString read Get_FileName write Set_FileName;
    // FileType : Attachment file type (can be lpMapiFileTagExt) 
   property FileType: ISMapiFileTagExt read Get_FileType write Set_FileType;
  end;


// ISMapiFileDesc : 

 ISMapiFileDescDisp = dispinterface
   ['{62963666-C343-4161-A5CB-5437A3AC4B30}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef: LongWord;dispid 1610612737;
    // Release :  
   function Release: LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // Reserved : Reserved for future use (M.B. 0) 
   property Reserved: LongWord dispid 1610743808;
    // Flags : Flags 
   property Flags: LongWord dispid 1610743810;
    // Position : Character in text to be replaced by attachment 
   property Position: LongWord dispid 1610743812;
    // PathName : Full path name of attachment file 
   property PathName: WideString dispid 1610743814;
    // FileName : Original file name (optional) 
   property FileName: WideString dispid 1610743816;
    // FileType : Attachment file type (can be lpMapiFileTagExt) 
   property FileType: ISMapiFileTagExt dispid 1610743818;
  end;


// ISMapiFileTagExt : 

 ISMapiFileTagExt = interface(IDispatch)
   ['{470625DF-43EC-4E50-B5B7-79B1E1B0C910}']
   function Get_Reserved : LongWord; Safecall;
   procedure Set_Reserved(const Value:LongWord); safecall;
   function Get_Tag : OleVariant; Safecall;
   procedure Set_Tag(Value:OleVariant); safecall;
   function Get_Encoding : OleVariant; Safecall;
   procedure Set_Encoding(Value:OleVariant); safecall;
    // Reserved : Reserved for future use (M.B. 0) 
   property Reserved: LongWord read Get_Reserved write Set_Reserved;
    // Tag : X.400 OID for this attachment type 
   property Tag: OleVariant read Get_Tag write Set_Tag;
    // Encoding : X.400 OID for this attachment's encoding 
   property Encoding: OleVariant read Get_Encoding write Set_Encoding;
  end;


// ISMapiFileTagExt : 

 ISMapiFileTagExtDisp = dispinterface
   ['{470625DF-43EC-4E50-B5B7-79B1E1B0C910}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef: LongWord;dispid 1610612737;
    // Release :  
   function Release: LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // Reserved : Reserved for future use (M.B. 0) 
   property Reserved: LongWord dispid 1610743808;
    // Tag : X.400 OID for this attachment type 
   property Tag: OleVariant dispid 1610743810;
    // Encoding : X.400 OID for this attachment's encoding 
   property Encoding: OleVariant dispid 1610743812;
  end;


// ISMapiLoader : 

 ISMapiLoader = interface(IDispatch)
   ['{EA64C36A-166F-4C2A-A649-C88FDE626003}']
    // LoadLibrary :  
   function LoadLibrary(LibraryFile:WideString): ISMapiLibrary;safecall;
    // ListProfiles :  
   function ListProfiles(Flags:LongWord): OleVariant;safecall;
  end;


// ISMapiLoader : 

 ISMapiLoaderDisp = dispinterface
   ['{EA64C36A-166F-4C2A-A649-C88FDE626003}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef: LongWord;dispid 1610612737;
    // Release :  
   function Release: LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // LoadLibrary :  
   function LoadLibrary(LibraryFile:WideString): ISMapiLibrary;dispid 1610743808;
    // ListProfiles :  
   function ListProfiles(Flags:LongWord): OleVariant;dispid 1610743809;
  end;


// ISMapiLibrary : 

 ISMapiLibrary = interface(IDispatch)
   ['{5C8C3B90-4886-4CB1-9AAB-0E15267ED341}']
    // LoadLibrary :  
   procedure LoadLibrary(LibraryFile:WideString);safecall;
    // UnloadLibrary :  
   procedure UnloadLibrary;safecall;
   function Get_LibraryFile : WideString; Safecall;
   function Get_IsLibraryLoaded : WordBool; Safecall;
    // Logon :  
   function Logon(UIParams:LongWord;ProfileName:WideString;Password:WideString;Flags:LongWord;Reserved:LongWord): LongWord;safecall;
    // Logoff :  
   procedure Logoff(Session:LongWord;UIParam:LongWord;Flags:LongWord;Reserved:LongWord);safecall;
    // SendMail :  
   procedure SendMail(Session:LongWord;UIParam:LongWord;Message:ISMapiMessage;Flags:LongWord;Reserved:LongWord;UseAnsiFunction:WordBool);safecall;
    // SendDocuments :  
   procedure SendDocuments(UIParam:LongWord;DelimChar:WideString;FullPaths:WideString;FileNames:WideString;Reserved:LongWord);safecall;
    // FindNext :  
   function FindNext(Session:LongWord;UIParam:LongWord;MessageType:WideString;SeedMessageID:WideString;Flags:LongWord;Reserved:LongWord): WideString;safecall;
    // ReadMail :  
   function ReadMail(Session:LongWord;UIParam:LongWord;MessageID:WideString;Flags:LongWord;Reserved:LongWord): ISMapiMessage;safecall;
    // SaveMail :  
   function SaveMail(Session:LongWord;UIParam:LongWord;Message:ISMapiMessage;Flags:LongWord;Reserved:LongWord): WideString;safecall;
    // DeleteMail :  
   procedure DeleteMail(Session:LongWord;UIParam:LongWord;MessageID:WideString;Flags:LongWord;Reserved:LongWord);safecall;
    // Address :  
   function Address(Session:LongWord;UIParam:LongWord;Caption:WideString;EditFields:LongWord;Labels:WideString;Recips:ISMapiCollection;Flags:LongWord;Reserved:LongWord): ISMapiCollection;safecall;
    // Details :  
   procedure Details(Session:LongWord;UIParam:LongWord;Recip:ISMapiRecipDesc;Flags:LongWord;Reserved:LongWord);safecall;
    // ResolveName :  
   function ResolveName(Session:LongWord;UIParam:LongWord;Name:WideString;Flags:LongWord;Reserved:LongWord): ISMapiRecipDesc;safecall;
    // LibraryFile :  
   property LibraryFile: WideString read Get_LibraryFile;
    // IsLibraryLoaded :  
   property IsLibraryLoaded: WordBool read Get_IsLibraryLoaded;
  end;


// ISMapiLibrary : 

 ISMapiLibraryDisp = dispinterface
   ['{5C8C3B90-4886-4CB1-9AAB-0E15267ED341}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef: LongWord;dispid 1610612737;
    // Release :  
   function Release: LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // LoadLibrary :  
   procedure LoadLibrary(LibraryFile:WideString);dispid 1610743808;
    // UnloadLibrary :  
   procedure UnloadLibrary;dispid 1610743809;
    // Logon :  
   function Logon(UIParams:LongWord;ProfileName:WideString;Password:WideString;Flags:LongWord;Reserved:LongWord): LongWord;dispid 1610743812;
    // Logoff :  
   procedure Logoff(Session:LongWord;UIParam:LongWord;Flags:LongWord;Reserved:LongWord);dispid 1610743813;
    // SendMail :  
   procedure SendMail(Session:LongWord;UIParam:LongWord;Message:ISMapiMessage;Flags:LongWord;Reserved:LongWord;UseAnsiFunction:WordBool);dispid 1610743814;
    // SendDocuments :  
   procedure SendDocuments(UIParam:LongWord;DelimChar:WideString;FullPaths:WideString;FileNames:WideString;Reserved:LongWord);dispid 1610743815;
    // FindNext :  
   function FindNext(Session:LongWord;UIParam:LongWord;MessageType:WideString;SeedMessageID:WideString;Flags:LongWord;Reserved:LongWord): WideString;dispid 1610743816;
    // ReadMail :  
   function ReadMail(Session:LongWord;UIParam:LongWord;MessageID:WideString;Flags:LongWord;Reserved:LongWord): ISMapiMessage;dispid 1610743817;
    // SaveMail :  
   function SaveMail(Session:LongWord;UIParam:LongWord;Message:ISMapiMessage;Flags:LongWord;Reserved:LongWord): WideString;dispid 1610743818;
    // DeleteMail :  
   procedure DeleteMail(Session:LongWord;UIParam:LongWord;MessageID:WideString;Flags:LongWord;Reserved:LongWord);dispid 1610743819;
    // Address :  
   function Address(Session:LongWord;UIParam:LongWord;Caption:WideString;EditFields:LongWord;Labels:WideString;Recips:ISMapiCollection;Flags:LongWord;Reserved:LongWord): ISMapiCollection;dispid 1610743820;
    // Details :  
   procedure Details(Session:LongWord;UIParam:LongWord;Recip:ISMapiRecipDesc;Flags:LongWord;Reserved:LongWord);dispid 1610743821;
    // ResolveName :  
   function ResolveName(Session:LongWord;UIParam:LongWord;Name:WideString;Flags:LongWord;Reserved:LongWord): ISMapiRecipDesc;dispid 1610743822;
    // LibraryFile :  
   property LibraryFile: WideString  readonly dispid 1610743810;
    // IsLibraryLoaded :  
   property IsLibraryLoaded: WordBool  readonly dispid 1610743811;
  end;


// ISMapiMessage : 

 ISMapiMessage = interface(IDispatch)
   ['{1DC5FCFF-6EFA-49C8-BF32-C215B3D29E2B}']
   function Get_Reserved : LongWord; Safecall;
   procedure Set_Reserved(const Value:LongWord); safecall;
   function Get_Subject : WideString; Safecall;
   procedure Set_Subject(const Value:WideString); safecall;
   function Get_NoteText : WideString; Safecall;
   procedure Set_NoteText(const Value:WideString); safecall;
   function Get_MessageType : WideString; Safecall;
   procedure Set_MessageType(const Value:WideString); safecall;
   function Get_DateReceived : WideString; Safecall;
   procedure Set_DateReceived(const Value:WideString); safecall;
   function Get_ConversationID : WideString; Safecall;
   procedure Set_ConversationID(const Value:WideString); safecall;
   function Get_Flags : LongWord; Safecall;
   procedure Set_Flags(const Value:LongWord); safecall;
   function Get_Originator : ISMapiRecipDesc; Safecall;
   procedure Set_Originator(Value:ISMapiRecipDesc); safecall;
   function Get_Recips : ISMapiCollection; Safecall;
   procedure Set_Recips(Value:ISMapiCollection); safecall;
   function Get_Files : ISMapiCollection; Safecall;
   procedure Set_Files(Value:ISMapiCollection); safecall;
    // Reserved : Reserved for future use (M.B. 0) 
   property Reserved: LongWord read Get_Reserved write Set_Reserved;
    // Subject : Message Subject 
   property Subject: WideString read Get_Subject write Set_Subject;
    // NoteText : Message Text 
   property NoteText: WideString read Get_NoteText write Set_NoteText;
    // MessageType : Message Class 
   property MessageType: WideString read Get_MessageType write Set_MessageType;
    // DateReceived : in YYYY/MM/DD HH:MM format 
   property DateReceived: WideString read Get_DateReceived write Set_DateReceived;
    // ConversationID : conversation thread ID 
   property ConversationID: WideString read Get_ConversationID write Set_ConversationID;
    // Flags : unread,return receipt 
   property Flags: LongWord read Get_Flags write Set_Flags;
    // Originator : Originator descriptor 
   property Originator: ISMapiRecipDesc read Get_Originator write Set_Originator;
    // Recips : Recipient descriptors 
   property Recips: ISMapiCollection read Get_Recips write Set_Recips;
    // Files : Attachment descriptors 
   property Files: ISMapiCollection read Get_Files write Set_Files;
  end;


// ISMapiMessage : 

 ISMapiMessageDisp = dispinterface
   ['{1DC5FCFF-6EFA-49C8-BF32-C215B3D29E2B}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef: LongWord;dispid 1610612737;
    // Release :  
   function Release: LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // Reserved : Reserved for future use (M.B. 0) 
   property Reserved: LongWord dispid 1610743808;
    // Subject : Message Subject 
   property Subject: WideString dispid 1610743810;
    // NoteText : Message Text 
   property NoteText: WideString dispid 1610743812;
    // MessageType : Message Class 
   property MessageType: WideString dispid 1610743814;
    // DateReceived : in YYYY/MM/DD HH:MM format 
   property DateReceived: WideString dispid 1610743816;
    // ConversationID : conversation thread ID 
   property ConversationID: WideString dispid 1610743818;
    // Flags : unread,return receipt 
   property Flags: LongWord dispid 1610743820;
    // Originator : Originator descriptor 
   property Originator: ISMapiRecipDesc dispid 1610743822;
    // Recips : Recipient descriptors 
   property Recips: ISMapiCollection dispid 1610743824;
    // Files : Attachment descriptors 
   property Files: ISMapiCollection dispid 1610743826;
  end;


// ISMapiRecipDesc : 

 ISMapiRecipDesc = interface(IDispatch)
   ['{04F810FC-8D72-46EC-99DF-FB8BBE70AC2A}']
   function Get_Reserved : LongWord; Safecall;
   procedure Set_Reserved(const Value:LongWord); safecall;
   function Get_RecipClass : LongWord; Safecall;
   procedure Set_RecipClass(const Value:LongWord); safecall;
   function Get_Name : WideString; Safecall;
   procedure Set_Name(const Value:WideString); safecall;
   function Get_Address : WideString; Safecall;
   procedure Set_Address(const Value:WideString); safecall;
   function Get_EntryID : OleVariant; Safecall;
   procedure Set_EntryID(Value:OleVariant); safecall;
    // Reserved : Reserved for future use (M.B. 0) 
   property Reserved: LongWord read Get_Reserved write Set_Reserved;
    // RecipClass : Recipient class (MAPI_TO, MAPI_CC, MAPI_BCC, MAPI_ORIG) 
   property RecipClass: LongWord read Get_RecipClass write Set_RecipClass;
    // Name : Recipient name 
   property Name: WideString read Get_Name write Set_Name;
    // Address : Recipient address (optional) 
   property Address: WideString read Get_Address write Set_Address;
    // EntryID : System-specific recipient reference 
   property EntryID: OleVariant read Get_EntryID write Set_EntryID;
  end;


// ISMapiRecipDesc : 

 ISMapiRecipDescDisp = dispinterface
   ['{04F810FC-8D72-46EC-99DF-FB8BBE70AC2A}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef: LongWord;dispid 1610612737;
    // Release :  
   function Release: LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // Reserved : Reserved for future use (M.B. 0) 
   property Reserved: LongWord dispid 1610743808;
    // RecipClass : Recipient class (MAPI_TO, MAPI_CC, MAPI_BCC, MAPI_ORIG) 
   property RecipClass: LongWord dispid 1610743810;
    // Name : Recipient name 
   property Name: WideString dispid 1610743812;
    // Address : Recipient address (optional) 
   property Address: WideString dispid 1610743814;
    // EntryID : System-specific recipient reference 
   property EntryID: OleVariant dispid 1610743816;
  end;


// ISMapiCollection : 

 ISMapiCollection = interface(IDispatch)
   ['{AC07A9D0-AD80-4E92-AEDB-9FDFC79BFC58}']
   function Get_Item(Index:Integer) : OleVariant; Safecall;
   procedure Set_Item(const Index:Integer; parItem:OleVariant); safecall;
   function Get_Count : Integer; Safecall;
   function Get__NewEnum : IUnknown; Safecall;
    // Add :  
   function Add(NewItem:OleVariant): Integer;safecall;
    // Delete :  
   procedure Delete(Index:Integer);safecall;
    // Clear :  
   procedure Clear;safecall;
    // Item :  
   property Item[Index:Integer]: OleVariant read Get_Item write Set_Item; default;
    // Count :  
   property Count: Integer read Get_Count;
    // _NewEnum :  
   property _NewEnum: IUnknown read Get__NewEnum;
  end;


// ISMapiCollection : 

 ISMapiCollectionDisp = dispinterface
   ['{AC07A9D0-AD80-4E92-AEDB-9FDFC79BFC58}']
    // QueryInterface :  
   procedure QueryInterface(var riid:{!! GUID !!} OleVariant;out ppvObj:{!! Ppointer !!} OleVariant);dispid 1610612736;
    // AddRef :  
   function AddRef: LongWord;dispid 1610612737;
    // Release :  
   function Release: LongWord;dispid 1610612738;
    // GetTypeInfoCount :  
   procedure GetTypeInfoCount(out pctinfo:UInt);dispid 1610678272;
    // GetTypeInfo :  
   procedure GetTypeInfo(itinfo:UInt;lcid:LongWord;out pptinfo:{!! Ppointer !!} OleVariant);dispid 1610678273;
    // GetIDsOfNames :  
   procedure GetIDsOfNames(var riid:{!! GUID !!} OleVariant;var rgszNames:{!! PShortInt !!} OleVariant;cNames:UInt;lcid:LongWord;out rgdispid:Integer);dispid 1610678274;
    // Invoke :  
   procedure Invoke(dispidMember:Integer;var riid:{!! GUID !!} OleVariant;lcid:LongWord;wFlags:Word;var pdispparams:{!! DISPPARAMS !!} OleVariant;out pvarResult:OleVariant;out pexcepinfo:{!! EXCEPINFO !!} OleVariant;out puArgErr:UInt);dispid 1610678275;
    // Add :  
   function Add(NewItem:OleVariant): Integer;dispid 1610743812;
    // Delete :  
   procedure Delete(Index:Integer);dispid 1610743813;
    // Clear :  
   procedure Clear;dispid 1610743814;
    // Item :  
   property Item[Index:Integer]: OleVariant dispid 0; default;
    // Count :  
   property Count: Integer  readonly dispid 1;
    // _NewEnum :  
   property _NewEnum: IUnknown  readonly dispid -4;
  end;

//CoClasses
  CoSMapiCollection = Class
  Public
    Class Function Create: ISMapiCollection;
    Class Function CreateRemote(const MachineName: string): ISMapiCollection;
  end;

  CoSMapiFileDesc = Class
  Public
    Class Function Create: ISMapiFileDesc;
    Class Function CreateRemote(const MachineName: string): ISMapiFileDesc;
  end;

  CoSMapiFileTagExt = Class
  Public
    Class Function Create: ISMapiFileTagExt;
    Class Function CreateRemote(const MachineName: string): ISMapiFileTagExt;
  end;

  CoSMapiRecipDesc = Class
  Public
    Class Function Create: ISMapiRecipDesc;
    Class Function CreateRemote(const MachineName: string): ISMapiRecipDesc;
  end;

  CoSMapiMessage = Class
  Public
    Class Function Create: ISMapiMessage;
    Class Function CreateRemote(const MachineName: string): ISMapiMessage;
  end;

  CoSMapiLoader = Class
  Public
    Class Function Create: ISMapiLoader;
    Class Function CreateRemote(const MachineName: string): ISMapiLoader;
  end;

  CoSMapiLibrary = Class
  Public
    Class Function Create: ISMapiLibrary;
    Class Function CreateRemote(const MachineName: string): ISMapiLibrary;
  end;

implementation

uses comobj;

Class Function CoSMapiCollection.Create: ISMapiCollection;
begin
  Result := CreateComObject(CLASS_SMapiCollection) as ISMapiCollection;
end;

Class Function CoSMapiCollection.CreateRemote(const MachineName: String): ISMapiCollection;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_SMapiCollection) as ISMapiCollection;
end;

Class Function CoSMapiFileDesc.Create: ISMapiFileDesc;
begin
  Result := CreateComObject(CLASS_SMapiFileDesc) as ISMapiFileDesc;
end;

Class Function CoSMapiFileDesc.CreateRemote(const MachineName: String): ISMapiFileDesc;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_SMapiFileDesc) as ISMapiFileDesc;
end;

Class Function CoSMapiFileTagExt.Create: ISMapiFileTagExt;
begin
  Result := CreateComObject(CLASS_SMapiFileTagExt) as ISMapiFileTagExt;
end;

Class Function CoSMapiFileTagExt.CreateRemote(const MachineName: String): ISMapiFileTagExt;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_SMapiFileTagExt) as ISMapiFileTagExt;
end;

Class Function CoSMapiRecipDesc.Create: ISMapiRecipDesc;
begin
  Result := CreateComObject(CLASS_SMapiRecipDesc) as ISMapiRecipDesc;
end;

Class Function CoSMapiRecipDesc.CreateRemote(const MachineName: String): ISMapiRecipDesc;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_SMapiRecipDesc) as ISMapiRecipDesc;
end;

Class Function CoSMapiMessage.Create: ISMapiMessage;
begin
  Result := CreateComObject(CLASS_SMapiMessage) as ISMapiMessage;
end;

Class Function CoSMapiMessage.CreateRemote(const MachineName: String): ISMapiMessage;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_SMapiMessage) as ISMapiMessage;
end;

Class Function CoSMapiLoader.Create: ISMapiLoader;
begin
  Result := CreateComObject(CLASS_SMapiLoader) as ISMapiLoader;
end;

Class Function CoSMapiLoader.CreateRemote(const MachineName: String): ISMapiLoader;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_SMapiLoader) as ISMapiLoader;
end;

Class Function CoSMapiLibrary.Create: ISMapiLibrary;
begin
  Result := CreateComObject(CLASS_SMapiLibrary) as ISMapiLibrary;
end;

Class Function CoSMapiLibrary.CreateRemote(const MachineName: String): ISMapiLibrary;
begin
  Result := CreateRemoteComObject(MachineName,CLASS_SMapiLibrary) as ISMapiLibrary;
end;

end.
