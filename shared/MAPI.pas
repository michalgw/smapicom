unit MAPI;

{
 *	M A P I . H
 *
 *  Messaging Applications Programming Interface.
 *
 *  Copyright 1993-1999 Microsoft Corporation. All Rights Reserved.
 *
 *  Purpose:
 *
 *    This file defines the structures and constants used by that
 *    subset of the Messaging Applications Programming Interface
 *    which is supported under Windows by Microsoft Mail for PC
 *    Networks version 3.x.
}

interface

uses
  Windows;

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}

{ *  Types. }

type
  PLPULONG = ^LPULONG;
  LPULONG = ^ULONG;

  PFLAGS = ^FLAGS;
  FLAGS = ULONG;
  PLHANDLE = ^LHANDLE;
  LHANDLE = ULONG_PTR;
  LPLHANDLE = PLHANDLE;
  PLPLHANDLE = ^LPLHANDLE;
  PLPBYTE = ^LPBYTE;

const
  lhSessionNull = LHANDLE(0);

type
  PMapiFileDesc = ^MapiFileDesc;
  MapiFileDesc = record
    ulReserved : ULONG;     { Reserved for future use (must be 0)      }
    flFlags : ULONG;        { Flags                                    }
    nPosition : ULONG;      { character in text to be replaced by attachment  }
    lpszPathName : LPSTR;   { Full path name of attachment file        }
    lpszFileName : LPSTR;   { Original file name (optional)            }
    lpFileType : LPVOID;    { Attachment file type (can be lpMapiFileTagExt)  }
  end;
  lpMapiFileDesc = PMapiFileDesc;
  PlpMapiFileDesc = ^lpMapiFileDesc;

  PMapiFileDescW = ^MapiFileDescW;
  MapiFileDescW = record
    ulReserved : ULONG;
    flFlags : ULONG;
    nPosition : ULONG;
    lpszPathName : PWSTR;
    lpszFileName : PWSTR;
    lpFileType : PVOID;
  end;
  lpMapiFileDescW = PMapiFileDescW;
  PlpMapiFileDescW = ^lpMapiFileDescW;

const
  MAPI_OLE        = $00000001;
  MAPI_OLE_STATIC = $00000002;

type
  PMapiFileTagExt = ^MapiFileTagExt;
  MapiFileTagExt = record
    ulReserved : ULONG;    { Reserved, must be zero.                   }
    cbTag : ULONG;         { Size (in bytes) of                        }
    lpTag : LPBYTE;        { X.400 OID for this attachment type        }
    cbEncoding : ULONG;    { Size (in bytes) of                        }
    lpEncoding : LPBYTE;   { X.400 OID for this attachment's encoding  }
  end;
  lpMapiFileTagExt = PMapiFileTagExt;
  PlpMapiFileTagExt = ^lpMapiFileTagExt;

  PMapiRecipDesc = ^MapiRecipDesc;
  MapiRecipDesc = record
    ulReserved : ULONG;     { Reserved for future use                   }
    ulRecipClass : ULONG;   { Recipient class                           }
                            { MAPI_TO, MAPI_CC, MAPI_BCC, MAPI_ORIG     }
    lpszName : LPSTR;       { Recipient name                            }
    lpszAddress : LPSTR;    { Recipient address (optional)              }
    ulEIDSize : ULONG;      { Count in bytes of size of pEntryID        }
    lpEntryID : LPVOID;     { System-specific recipient reference       }
  end;
  lpMapiRecipDesc = PMapiRecipDesc;
  PlpMapiRecipDesc = ^lpMapiRecipDesc;

  PMapiRecipDescW = ^MapiRecipDescW;
  MapiRecipDescW = record
    ulReserved : ULONG;
    ulRecipClass : ULONG;
    lpszName : PWSTR;
    lpszAddress : PWSTR;
    ulEIDSize : ULONG;
    lpEntryID : PVOID;
  end;
  lpMapiRecipDescW = PMapiRecipDescW;
  PlpMapiRecipDescW = ^lpMapiRecipDescW;

const
  MAPI_ORIG = 0;    { Recipient is message originator           }
  MAPI_TO   = 1;    { Recipient is a primary recipient          }
  MAPI_CC   = 2;    { Recipient is a copy recipient             }
  MAPI_BCC  = 3;    { Recipient is blind copy recipient         }

type
  PMapiMessage = ^MapiMessage;
  MapiMessage = record
    ulReserved : ULONG;                  { Reserved for future use (M.B. 0)        }
    lpszSubject : LPSTR;                 { Message Subject                         }
    lpszNoteText : LPSTR;                { Message Text                            }
    lpszMessageType : LPSTR;             { Message Class                           }
    lpszDateReceived : LPSTR;            { in YYYY/MM/DD HH:MM format              }
    lpszConversationID : LPSTR;          { conversation thread ID                  }
    flFlags : FLAGS;                     { unread,return receipt                   }
    lpOriginator : lpMapiRecipDesc;      { Originator descriptor                   }
    nRecipCount : ULONG;                 { Number of recipients                    }
    lpRecips : lpMapiRecipDesc;          { Recipient descriptors                   }
    nFileCount : ULONG;                  { # of file attachments                   }
    lpFiles : lpMapiFileDesc;            { Attachment descriptors                  }
  end;
  lpMapiMessage = PMapiMessage;
  PlpMapiMessage = ^lpMapiMessage;

  PMapiMessageW = ^MapiMessageW;
  MapiMessageW = record
    ulReserved : ULONG;
    lpszSubject : PWSTR;
    lpszNoteText : PWSTR;
    lpszMessageType : PWSTR;
    lpszDateReceived : PWSTR;
    lpszConversationID : PWSTR;
    flFlags : FLAGS;
    lpOriginator : lpMapiRecipDescW;
    nRecipCount : ULONG;
    lpRecips : lpMapiRecipDescW;
    nFileCount : ULONG;
    lpFiles : lpMapiFileDescW;
  end;
  lpMapiMessageW = PMapiMessageW;
  PlpMapiMessageW = ^lpMapiMessageW;

const
  MAPI_UNREAD            = $00000001;
  MAPI_RECEIPT_REQUESTED = $00000002;
  MAPI_SENT              = $00000004;

{
 *  Entry points.
}
{
 *  flFlags values for Simple MAPI entry points. All documented flags are
 *  shown for each call. Duplicates are commented out but remain present
 *  for every call.
}

{ MAPILogon() flags.        }

const
  MAPI_LOGON_UI          = $00000001;   { Display logon UI              }
  MAPI_PASSWORD_UI       = $00020000;   { prompt for password only      }
  MAPI_NEW_SESSION       = $00000002;   { Don't use shared session      }
  MAPI_FORCE_DOWNLOAD    = $00001000;   { Get new mail before return    }
  MAPI_EXTENDED          = $00000020;   { Extended MAPI Logon           }

{ MAPISendMail() flags.     }

const
  MAPI_DIALOG            = $00000008;   { Display a send note UI        }
//MAPI_USE_DEFAULT       = $00000040;   { Use default profile in logon  }

{ MAPISendMailW() flags.     }

const
//MAPI_DIALOG_MODELESS   = $00000004 or MAPI_DIALOG  { Display a modeless window    }
  MAPI_FORCE_UNICODE     = $00040000;   { Don't down-convert to ANSI if provider does not support Unicode  }

{ MAPIFindNext() flags.     }

const
  MAPI_UNREAD_ONLY       = $00000020;   { Only unread messages          }
  MAPI_GUARANTEE_FIFO    = $00000100;   { use date order                }
  MAPI_LONG_MSGID        = $00004000;   { allow 512 char returned ID	 }

{ MAPIReadMail() flags.     }

const
  MAPI_PEEK              = $00000080;   { Do not mark as read.          }
  MAPI_SUPPRESS_ATTACH   = $00000800;   { header + body, no files       }
  MAPI_ENVELOPE_ONLY     = $00000040;   { Only header information       }
  MAPI_BODY_AS_FILE      = $00000200;

{ MAPISaveMail() flags.     }

//MAPI_LOGON_UI          = $00000001;   { Display logon UI              }
//MAPI_NEW_SESSION       = $00000002;   { Don't use shared session      }
//MAPI_LONG_MSGID        = $00004000;   { allow 512 char returned ID    }

{ MAPIAddress() flags.      }

//MAPI_LOGON_UI          = $00000001;   { Display logon UI              }
//MAPI_NEW_SESSION       = $00000002;   { Don't use shared session      }

{ MAPIDetails() flags.      }

const
//MAPI_LOGON_UI          = $00000001;   { Display logon UI              }
//MAPI_NEW_SESSION       = $00000002;   { Don't use shared session      }
  MAPI_AB_NOMODIFY       = $00000400;   { Don't allow mods of AB entries  }

{ MAPIResolveName() flags.  }

//MAPI_LOGON_UI          = $00000001;   { Display logon UI              }
//MAPI_NEW_SESSION       = $00000002;   { Don't use shared session      }
//MAPI_DIALOG            = $00000008;   { Prompt for choices if ambiguous  }
//MAPI_AB_NOMODIFY       = $00000400;   { Don't allow mods of AB entries  }

type
  LPMAPILOGON = function(
    ulUIParam: ULONG_PTR;
    lpszProfileName: LPSTR;
    lpszPassword: LPSTR;
    flFlags:FLAGS;
    ulReserved: ULONG;
    lplhSession: LPLHANDLE): ULONG; stdcall;

  LPMAPISENDMAIL = function(
    lhSession: LHANDLE;
    ulUIParam: ULONG_PTR;
    lpMessage: lpMapiMessage;
    flFlags: FLAGS;
    ulReserved: ULONG): ULONG; stdcall;

  LPMAPISENDMAILW = function(
    lhSession: LHANDLE;
    ulUIParam: ULONG_PTR;
    lpMessage: lpMapiMessageW;
    flFlags: FLAGS;
    ulReserved: ULONG): ULONG; stdcall;

  LPMAPISENDDOCUMENTS = function(
    ulUIParam: ULONG_PTR;
    lpszDelimChar: LPSTR;
    lpszFullPaths: LPSTR;
    lpszFileNames: LPSTR;
    ulReserved: ULONG): ULONG; stdcall;

  LPMAPIREADMAIL = function(
    lhSession: LHANDLE;
    ulUIParam: ULONG_PTR;
    lpszMessageID: LPSTR;
    flFlags: FLAGS;
    ulReserved: ULONG;
    lppMessage: PlpMapiMessage): ULONG; stdcall;

  LPMAPIFINDNEXT = function(
    lhSession: LHANDLE;
    ulUIParam: ULONG_PTR;
    lpszMessageType: LPSTR;
    lpszSeedMessageID: LPSTR;
    flFlags: FLAGS;
    ulReserved: ULONG;
    lpszMessageID: LPSTR): ULONG; stdcall;

  LPMAPIRESOLVENAME = function(
    lhSession: LHANDLE;
    ulUIParam: ULONG_PTR;
    lpszName: LPSTR;
    flFlags:FLAGS;
    ulReserved: ULONG;
    lppRecip: PlpMapiRecipDesc): ULONG; stdcall;

  LPMAPIADDRESS = function(
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

  LPMAPIFREEBUFFER = function(lpv: LPVOID): ULONG; stdcall;

  LPMAPIDETAILS = function(
    lhSession: LHANDLE;
    ulUIParam: ULONG_PTR;
    lpRecip: lpMapiRecipDesc;
    flFlags: FLAGS;
    ulReserved: ULONG): ULONG; stdcall;

  LPMAPISAVEMAIL = function(
    lhSession: LHANDLE;
    ulUIParam: ULONG_PTR;
    lpszMessage: lpMapiMessage;
    flFlags: FLAGS;
    ulReserved: ULONG;
    lpszMessageID: LPSTR): ULONG; stdcall;

  LPMAPIDELETEMAIL = function(
    lpSession: LHANDLE;
    ulUIParam: ULONG_PTR;
    lpszMessageID: LPSTR;
    flFlags: FLAGS;
    ulReserved: ULONG): ULONG; stdcall;

  LPMAPILOGOFF = function(
    lhSession: LHANDLE;
    ulUIParam: ULONG_PTR;
    flFlags: FLAGS;
    ulReserved: ULONG): ULONG; stdcall;

const
  SUCCESS_SUCCESS = 0;
  MAPI_USER_ABORT = 1;
  MAPI_E_USER_ABORT = MAPI_USER_ABORT;
  MAPI_E_FAILURE = 2;
  MAPI_E_LOGON_FAILURE = 3;
  MAPI_E_LOGIN_FAILURE = MAPI_E_LOGON_FAILURE;
  MAPI_E_DISK_FULL = 4;
  MAPI_E_INSUFFICIENT_MEMORY = 5;
  MAPI_E_ACCESS_DENIED = 6;
  MAPI_E_TOO_MANY_SESSIONS = 8;
  MAPI_E_TOO_MANY_FILES = 9;
  MAPI_E_TOO_MANY_RECIPIENTS = 10;
  MAPI_E_ATTACHMENT_NOT_FOUND = 11;
  MAPI_E_ATTACHMENT_OPEN_FAILURE = 12;
  MAPI_E_ATTACHMENT_WRITE_FAILURE = 13;
  MAPI_E_UNKNOWN_RECIPIENT = 14;
  MAPI_E_BAD_RECIPTYPE = 15;
  MAPI_E_NO_MESSAGES = 16;
  MAPI_E_INVALID_MESSAGE = 17;
  MAPI_E_TEXT_TOO_LARGE = 18;
  MAPI_E_INVALID_SESSION = 19;
  MAPI_E_TYPE_NOT_SUPPORTED = 20;
  MAPI_E_AMBIGUOUS_RECIPIENT = 21;
  MAPI_E_AMBIG_RECIP = MAPI_E_AMBIGUOUS_RECIPIENT;
  MAPI_E_MESSAGE_IN_USE = 22;
  MAPI_E_NETWORK_FAILURE = 23;
  MAPI_E_INVALID_EDITFIELDS = 24;
  MAPI_E_INVALID_RECIPS = 25;
  MAPI_E_NOT_SUPPORTED = 26;
  MAPI_E_UNICODE_NOT_SUPPORTED = 27;
  MAPI_E_ATTACHMENT_TOO_LARGE = 28;

implementation

end.
