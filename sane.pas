(****************************************************************************
*
*  FILE: sane.pas
*
*  VERSION:     1.3.1
*
*  DESCRIPTION:
*    Bindings for libsane API, Types and Consts.
*
*****************************************************************************
*
*  2025-02-14 Translation and adaptation by Massimo Magnano
*             based on Malcolm Poole August 2008
*
*****************************************************************************

   sane - Scanner Access Now Easy.
   Copyright (C) 1997-1999 David Mosberger-Tang and Andreas Beck
   This file is part of the SANE package.

   This file is in the public domain.  You may use and modify it as
   you see fit, as long as this copyright message is included and
   that there is an indication as to what modifications have been
   made (if any).

   SANE is distributed in the hope that it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
   FITNESS FOR A PARTICULAR PURPOSE.

   This file declares SANE application interface.  See the SANE
   standard for a detailed explanation of the interface.

   For documentation libsane API documentation see
     http://www.sane-project.org/html/doc009.html
*)

Unit sane;

{$ifdef FPC}
  {$mode objfpc}
{$endif}

{$PACKRECORDS C}

//Enable this define if you want a dynamic load of the Library
//  using Load/Unload functions intestead the Library is linked in project
{$define SANE_DYNAMIC_LOAD}

interface

uses SysUtils;
  
const
  SaneLib = 'libsane';

const
  SANE_CURRENT_MAJOR = 1;
  SANE_CURRENT_MINOR = 0;

  SANE_FALSE = 0;
  SANE_TRUE  = 1;
  
type
  SANE_Byte = Char;
  SANE_Word = LongInt;
  SANE_Bool = SANE_Word;
  SANE_Int = SANE_Word;
  SANE_Char = Char;
  SANE_String = PChar;
  SANE_String_Const = PChar;
  SANE_Handle = Pointer;
  SANE_Fixed = SANE_Word;

  PSANE_Byte = ^SANE_Byte;
  PSANE_Int = ^SANE_Int;
  PSANE_Handle = ^SANE_Handle;

  CharArray = array[0..0] of PChar;
  PCharArray = ^CharArray;

  // the address of a callback for user authorisation can be passed as the second parameter of sane_init
  // strings addressed by username and password must be #0 terminated and must not exceed 128 characters
  TSANE_Authorization_Callback = procedure(resource: SANE_String_Const; username, password: PChar); cdecl;

const
  SANE_FIXED_SCALE_SHIFT = 16;
  
function SANE_VERSION_CODE(major,minor,build: SANE_Word): LongWord;
function SANE_VERSION_MAJOR(code: LongWord): Byte;
function SANE_VERSION_MINOR(code: LongWord): Byte;
function SANE_VERSION_BUILD(code: LongWord): Word;

function SANE_FIX(v: Double): SANE_Word;
function SANE_UNFIX(v: SANE_Word): Double;
  
type
  SANE_Status = (
    SANE_STATUS_GOOD = 0,	// everything A-OK
    SANE_STATUS_UNSUPPORTED,	// operation is not supported
    SANE_STATUS_CANCELLED,	// operation was cancelled
    SANE_STATUS_DEVICE_BUSY,	// device is busy; try again later
    SANE_STATUS_INVAL,		// data is invalid (includes no dev at open)
    SANE_STATUS_EOF,		// no more data available (end-of-file)
    SANE_STATUS_JAMMED,		// document feeder jammed
    SANE_STATUS_NO_DOCS,	// document feeder out of documents
    SANE_STATUS_COVER_OPEN,	// scanner cover is open
    SANE_STATUS_IO_ERROR,	// error during device I/O
    SANE_STATUS_NO_MEM,		// out of memory
    SANE_STATUS_ACCESS_DENIED,	// access to resource has been denied

    //following are for later sane version, older frontends won't support
    SANE_STATUS_WARMING_UP,     // lamp not ready, please retry
    SANE_STATUS_HW_LOCKED       // scanner mechanism locked for transport
  );

  SANE_Value_Type = (
    SANE_TYPE_BOOL = 0,
    SANE_TYPE_INT,
    SANE_TYPE_FIXED,             // use functions SANE_FIX and SANE_UNFIX with values of type SANE_TYPE_FIXED
    SANE_TYPE_STRING,
    SANE_TYPE_BUTTON,
    SANE_TYPE_GROUP
  );

  SANE_Unit = (
    SANE_UNIT_NONE = 0,		// the value is unit-less (e.g., # of scans)
    SANE_UNIT_PIXEL,		// value is number of pixels
    SANE_UNIT_BIT,		// value is number of bits
    SANE_UNIT_MM,		// value is millimeters
    SANE_UNIT_DPI,		// value is resolution in dots/inch
    SANE_UNIT_PERCENT,		// value is a percentage
    SANE_UNIT_MICROSECOND	// value is micro seconds
  );

  SANE_Device = record
    name,
    vendor,
    model,
    _type: SANE_String_Const;
  end;

  PSANE_Device = ^SANE_Device;
  DeviceArray = array[0..0] of PSANE_Device;
  PDeviceArray = ^DeviceArray;

const
  SANE_CAP_SOFT_SELECT        = 1 shl 0;
  SANE_CAP_HARD_SELECT        = 1 shl 1;
  SANE_CAP_SOFT_DETECT	      = 1 shl 2;
  SANE_CAP_EMULATED	      = 1 shl 3;
  SANE_CAP_AUTOMATIC	      = 1 shl 4;
  SANE_CAP_INACTIVE           = 1 shl 5;
  SANE_CAP_ADVANCED           = 1 shl 6;
  //SANE_CAP_ALWAYS_SETTABLE    = 1 shl 7;
  
function SANE_OPTION_IS_ACTIVE(cap: SANE_Int): Boolean;
function SANE_OPTION_IS_SETTABLE(cap: SANE_Int): Boolean;

const
  SANE_INFO_INEXACT	      =	 1 shl 0;
  SANE_INFO_RELOAD_OPTIONS    =  1 shl 1;
  SANE_INFO_RELOAD_PARAMS     =  1 shl 2;


type
  SANE_Constraint_Type = (
    SANE_CONSTRAINT_NONE = 0,
    SANE_CONSTRAINT_RANGE,
    SANE_CONSTRAINT_WORD_LIST,
    SANE_CONSTRAINT_STRING_LIST
  );

  SANE_Range =  record
    min,		// minimum (element) value
    max,		// maximum (element) value
    quant: SANE_Word;	// quantization value (0 if none)
  end;
  PSANE_Range = ^SANE_Range;

  SANE_WordList = array of SANE_Word;
  PSANE_WordList = ^SANE_WordList;

  SANE_Option_Descriptor = record
    name,	               // name of this option (command-line name)
    title,	               // title of this option (single-line)
    desc: SANE_String_Const;   // description of this option (multi-line)
    _type: SANE_Value_Type;    // how are values interpreted?
    _unit: SANE_Unit;	       // what is the (physical) unit?
    size,
    cap: SANE_Int;	      // capabilities
    case constraint_type: SANE_Constraint_Type of
      SANE_CONSTRAINT_NONE :       ({none});
      SANE_CONSTRAINT_RANGE:       (range: PSANE_Range);        // SANE_Range
      SANE_CONSTRAINT_WORD_LIST:   (wordlist: PSANE_WordList);  // array of SANE_Word: first element is list-length
      SANE_CONSTRAINT_STRING_LIST: (stringlist: PCharArray);    // NULL-terminated array of PChar
  end;
  PSANE_Option_Descriptor = ^SANE_Option_Descriptor;

  SANE_Action = (
    SANE_ACTION_GET_VALUE = 0,
    SANE_ACTION_SET_VALUE,
    SANE_ACTION_SET_AUTO
  );

  SANE_Frame = (
    SANE_FRAME_GRAY = 0,	// band covering human visual range
    SANE_FRAME_RGB,             // pixel-interleaved red/green/blue bands
    SANE_FRAME_RED,		// red band only
    SANE_FRAME_GREEN,		// green band only
    SANE_FRAME_BLUE		// blue band only
  );

const
  // push remaining types down to match existing backends
  // these are to be exposed in a later version of SANE
  // most front-ends will require updates to understand them
  SANE_FRAME_TEXT  =$0A;  // backend specific textual data
  SANE_FRAME_JPEG  =$0B;  // complete baseline JPEG file
  SANE_FRAME_G31D  =$0C;  // CCITT Group 3 1-D Compressed (MH)
  SANE_FRAME_G32D  =$0D;  // CCITT Group 3 2-D Compressed (MR)
  SANE_FRAME_G42D  =$0E;  // CCITT Group 4 2-D Compressed (MMR)

  SANE_FRAME_IR    =$0F;  // bare infrared channel
  SANE_FRAME_RGBI  =$10;  // red+green+blue+infrared
  SANE_FRAME_GRAYI =$11;  // gray+infrared
  SANE_FRAME_XML   =$12;  // undefined schema

type
  SANE_Parameters = record
    format: SANE_Frame;
    last_frame: SANE_Bool;
    bytes_per_line,
    pixels_per_line,
    lines,
    depth: SANE_Int;
  end;
  pSANE_Parameters = ^SANE_Parameters;

  SANE_Auth_Data = record end;
  PSANE_Auth_Data = ^SANE_Auth_Data;
  
const
  SANE_MAX_USERNAME_LEN	= 128;
  SANE_MAX_PASSWORD_LEN	= 128;


{$ifdef SANE_DYNAMIC_LOAD}
type
   Tsane_init= function (version_code: PSANE_Int;
                         authorize: TSANE_Authorization_Callback): SANE_Status; cdecl;
   Tsane_exit= procedure; cdecl;
   Tsane_get_devices= function (var device_list: PDeviceArray;
                                local_only: SANE_Bool): SANE_Status; cdecl;
   Tsane_open= function (devicename: SANE_String_Const;
                         var handle: SANE_Handle): SANE_Status; cdecl;
   Tsane_close= procedure (handle: SANE_Handle); cdecl;
   Tsane_get_option_descriptor= function (handle: SANE_Handle; option: SANE_Int): PSANE_Option_Descriptor; cdecl;
   Tsane_control_option= function (handle: SANE_Handle; option: SANE_Int;
   			           action: SANE_Action; value: Pointer;
   			           var info: SANE_Int): SANE_Status; cdecl;
   Tsane_get_parameters= function (handle: SANE_Handle;
                                   var params: SANE_Parameters): SANE_Status; cdecl;
   Tsane_start= function (handle: SANE_Handle): SANE_Status; cdecl;
   Tsane_read= function (handle: SANE_Handle; data: PSANE_Byte;
                         max_length: SANE_Int; var length: SANE_Int): SANE_Status; cdecl;
   Tsane_cancel= procedure (handle: SANE_Handle); cdecl;
   Tsane_set_io_mode= function (handle: SANE_Handle; non_blocking: SANE_Bool): SANE_Status; cdecl;
   Tsane_get_select_fd= function (handle: SANE_Handle;
                                  var fd: SANE_Int): SANE_Status; cdecl;
   Tsane_strstatus= function (status: SANE_Status): SANE_String_Const; cdecl;

var
   libHandle: TLibHandle=0;

   sane_init: Tsane_init=nil;
   sane_exit: Tsane_exit=nil;
   sane_get_devices: Tsane_get_devices=nil;
   sane_open: Tsane_open=nil;
   sane_close: Tsane_close=nil;
   sane_get_option_descriptor: Tsane_get_option_descriptor=nil;
   sane_control_option: Tsane_control_option=nil;
   sane_get_parameters: Tsane_get_parameters=nil;
   sane_start: Tsane_start=nil;
   sane_read: Tsane_read=nil;
   sane_cancel: Tsane_cancel=nil;
   sane_set_io_mode: Tsane_set_io_mode=nil;
   sane_get_select_fd: Tsane_get_select_fd=nil;
   sane_strstatus: Tsane_strstatus=nil;

function Load(const LibraryName: String=SaneLib): Boolean;
function Unload: Boolean;

{$else}
function sane_init(version_code: PSANE_Int;
                   authorize: TSANE_Authorization_Callback): SANE_Status; cdecl; external SaneLib;
procedure sane_exit; cdecl; external SaneLib;
function sane_get_devices(var device_list: PDeviceArray;
                          local_only: SANE_Bool): SANE_Status; cdecl; external SaneLib;
function sane_open(devicename: SANE_String_Const;
                   var handle: SANE_Handle): SANE_Status; cdecl; external SaneLib;
procedure sane_close(handle: SANE_Handle); cdecl; external SaneLib;
function sane_get_option_descriptor(handle: SANE_Handle; option: SANE_Int): PSANE_Option_Descriptor; cdecl; external SaneLib;
function sane_control_option(handle: SANE_Handle; option: SANE_Int;
  			     action: SANE_Action; value: Pointer;
  			     var info: SANE_Int): SANE_Status; cdecl; external SaneLib;
function sane_get_parameters(handle: SANE_Handle;
                             var params: SANE_Parameters): SANE_Status; cdecl; external SaneLib;
function sane_start(handle: SANE_Handle): SANE_Status; cdecl; external SaneLib;
function sane_read(handle: SANE_Handle; data: PSANE_Byte;
                   max_length: SANE_Int; var length: SANE_Int): SANE_Status; cdecl; external SaneLib;
procedure sane_cancel(handle: SANE_Handle); cdecl; external SaneLib;
function sane_set_io_mode(handle: SANE_Handle; non_blocking: SANE_Bool): SANE_Status; cdecl; external SaneLib;
function sane_get_select_fd(handle: SANE_Handle;
                            var fd: SANE_Int): SANE_Status; cdecl; external SaneLib;
function sane_strstatus(status: SANE_Status): SANE_String_Const; cdecl; external SaneLib;
{$endif}

implementation

function SANE_VERSION_CODE(major,minor,build : SANE_Word) : longword;
begin
{$RANGECHECKS OFF}
   Result:= (((major and $ff) shl 24) or ((minor and $ff) shl 16) or ((build and $ffff) shl 0));
{$RANGECHECKS ON}
end;

function SANE_VERSION_MAJOR(code : LongWord): Byte;
begin
  Result:= (code shr 24) and $ff;
end;

function SANE_VERSION_MINOR(code : LongWord): Byte;
begin
  Result:= (code shr 16) and $ff;
end;

function SANE_VERSION_BUILD(code : longword) : word;
begin
  Result:= (code shr 0) and $ffff;
end;


function SANE_FIX(v: Double): SANE_Word;
begin
  Result:= Trunc(v * (1 shl SANE_FIXED_SCALE_SHIFT));
end;

function SANE_UNFIX(v: SANE_Fixed): Double;
begin
   Result:= Double(v) / (1 shl SANE_FIXED_SCALE_SHIFT);
end;


function SANE_OPTION_IS_ACTIVE(cap : SANE_Int) : Boolean;
begin
   Result:= ((cap and SANE_CAP_INACTIVE) = 0);
end;

function SANE_OPTION_IS_SETTABLE(cap : SANE_Int) : Boolean;
begin
   Result:= ((cap and SANE_CAP_SOFT_SELECT) <> 0);
end;

{$ifdef SANE_DYNAMIC_LOAD}
function Load(const LibraryName: String): Boolean;
begin
  libHandle:= LoadLibrary(LibraryName+'.'+SharedSuffix);
  Result:= (libHandle <> 0);

  if Result
  then begin
         sane_init:= Tsane_init(GetProcedureAddress(libHandle, 'sane_init'));
         if not(Assigned(sane_init)) then raise Exception.Create('Function "sane_init" not Found');

         sane_exit:= Tsane_exit(GetProcedureAddress(libHandle, 'sane_exit'));
         if not(Assigned(sane_exit)) then raise Exception.Create('Function "sane_exit" not Found');

         sane_get_devices:= Tsane_get_devices(GetProcedureAddress(libHandle, 'sane_get_devices'));
         if not(Assigned(sane_get_devices)) then raise Exception.Create('Function "sane_get_devices" not Found');

         sane_open:= Tsane_open(GetProcedureAddress(libHandle, 'sane_open'));
         if not(Assigned(sane_open)) then raise Exception.Create('Function "sane_open" not Found');

         sane_close:= Tsane_close(GetProcedureAddress(libHandle, 'sane_close'));
         if not(Assigned(sane_close)) then raise Exception.Create('Function "sane_close" not Found');

         sane_get_option_descriptor:= Tsane_get_option_descriptor(GetProcedureAddress(libHandle, 'sane_get_option_descriptor'));
         if not(Assigned(sane_get_option_descriptor)) then raise Exception.Create('Function "sane_get_option_descriptor" not Found');

         sane_control_option:= Tsane_control_option(GetProcedureAddress(libHandle, 'sane_control_option'));
         if not(Assigned(sane_control_option)) then raise Exception.Create('Function "sane_control_option" not Found');

         sane_get_parameters:= Tsane_get_parameters(GetProcedureAddress(libHandle, 'sane_get_parameters'));
         if not(Assigned(sane_get_parameters)) then raise Exception.Create('Function "sane_get_parameters" not Found');

         sane_start:= Tsane_start(GetProcedureAddress(libHandle, 'sane_start'));
         if not(Assigned(sane_start)) then raise Exception.Create('Function "sane_start" not Found');

         sane_read:= Tsane_read(GetProcedureAddress(libHandle, 'sane_read'));
         if not(Assigned(sane_read)) then raise Exception.Create('Function "sane_read" not Found');

         sane_cancel:= Tsane_cancel(GetProcedureAddress(libHandle, 'sane_cancel'));
         if not(Assigned(sane_cancel)) then raise Exception.Create('Function "sane_cancel" not Found');

         sane_set_io_mode:= Tsane_set_io_mode(GetProcedureAddress(libHandle, 'sane_set_io_mode'));
         if not(Assigned(sane_set_io_mode)) then raise Exception.Create('Function "sane_set_io_mode" not Found');

         sane_get_select_fd:= Tsane_get_select_fd(GetProcedureAddress(libHandle, 'sane_get_select_fd'));
         if not(Assigned(sane_get_select_fd)) then raise Exception.Create('Function "sane_get_select_fd" not Found');

         sane_strstatus:= Tsane_strstatus(GetProcedureAddress(libHandle, 'sane_strstatus'));
         if not(Assigned(sane_strstatus)) then raise Exception.Create('Function "sane_strstatus" not Found');
       end
  else begin
         sane_init:=nil;
         sane_exit:=nil;
         sane_get_devices:=nil;
         sane_open:=nil;
         sane_close:=nil;
         sane_get_option_descriptor:=nil;
         sane_control_option:=nil;
         sane_get_parameters:=nil;
         sane_start:=nil;
         sane_read:=nil;
         sane_cancel:=nil;
         sane_set_io_mode:=nil;
         sane_get_select_fd:=nil;
         sane_strstatus:=nil;
       end;
end;

function Unload: Boolean;
begin
  Result:= UnloadLibrary(libHandle);

  if Result then
  begin
    libHandle:=0;
    sane_init:=nil;
    sane_exit:=nil;
    sane_get_devices:=nil;
    sane_open:=nil;
    sane_close:=nil;
    sane_get_option_descriptor:=nil;
    sane_control_option:=nil;
    sane_get_parameters:=nil;
    sane_start:=nil;
    sane_read:=nil;
    sane_cancel:=nil;
    sane_set_io_mode:=nil;
    sane_get_select_fd:=nil;
    sane_strstatus:=nil;
  end;
end;
{$endif}


end.

