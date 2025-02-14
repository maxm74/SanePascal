{ scanutils.pas
  Basic functions for working with the libsane bindings and scanner output

  Copyright (C) 2008 Malcolm Poole mgpoole@users.sourceforge.net

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

unit ScanUtils;

{
  This unit contains functions used by demomain.pas
  Although the functions could be easily reused they have been kept simple for
  clarity and would benefit from additional error trapping
  }
  

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Forms, sane, saneopts;
  
procedure SaneGetDeviceList( aList: TStrings );
function GetSaneVersion : string;
function SaneGetResolution ( const ScannerHandle: SANE_Handle ) : integer;
function SaneGetMode ( const ScannerHandle: SANE_Handle ) : string;
function SaneGetOption ( const ScannerHandle: SANE_Handle; OptionName: string ) : SANE_Option_Descriptor;
function SaneGetOptionIndex ( const ScannerHandle: SANE_Handle; OptionName: string ): integer;
function SaneSetOption ( const ScannerHandle: SANE_Handle; OptionName, Value: string ): SANE_Status;

function SetPNMHeader (imagedepth, pixels_per_line, lines: longint; frameformat: SANE_Frame; var PNMHeader: string): byte;

function PNMtoBitmap ( PNMimagetype, rowcount, linecount: longint; Str: TStream; bmp: TBitmap
  ) : Boolean;

function DrawPNMtoForm ( rowcount, linecount: longint; var Str: TStream; var bmp: Tform
  ) : Boolean;
  
function GrayscaleToColor( Value: byte ):TColor;
function BitToColor( Value, Bit: byte ):TColor;
  
implementation

procedure SaneGetDeviceList ( aList: TStrings ) ;
var
  x: longint;
  res: SANE_Status;
  Devicelist: PDeviceArray;
  s: string;
  ver: SANE_Int;

begin
  aList.Clear;
  res := sane_init(nil, nil);
  if res = SANE_STATUS_GOOD then
     try
        //Getmem(Devicelist, sizeof(Devicelist));
        Devicelist:=nil;
        res := sane_get_devices(Devicelist, SANE_TRUE);   //@Devicelist
        x := 0;
        if res = SANE_STATUS_GOOD then
           while Devicelist^[x] <> nil do
             begin
               s := Devicelist^[x]^.name;
               aList.Add(s);
               Inc(x);
             end;
     finally
        sane_exit;
        //if Devicelist <> nil then Freemem(Devicelist);
     end;
end;

function GetSaneVersion: string;
var
  v: SANE_Int;
begin
  Result := '';
  if sane_init(@v, nil) = SANE_STATUS_GOOD
     then Result :=  IntToStr( SANE_VERSION_MAJOR(v) ) + '.'
                     + IntToStr( SANE_VERSION_MINOR(v) ) + '.'
                     + IntToStr( SANE_VERSION_BUILD(v) );
end;

function SaneGetResolution (const ScannerHandle: SANE_Handle ) : integer;
var
  saneoption: pSANE_Option_Descriptor;
  x: Integer;
  i: SANE_Int;
  OptionIndex: integer;
begin
  Result := -1;
  OptionIndex := -1;
  x := 0;
  repeat    // search through the options for  SANE_NAME_SCAN_RESOLUTION
    saneoption := sane_get_option_descriptor(ScannerHandle, x);
    if saneoption^.name = SANE_NAME_SCAN_RESOLUTION then
       OptionIndex := x;
    inc(x);
    saneoption := sane_get_option_descriptor(ScannerHandle, x);
  until not ((saneoption<>nil) and(OptionIndex < 0));


  if OptionIndex >= 0 then
     // Now get the current setting for that option
     if sane_control_option(ScannerHandle, OptionIndex, SANE_ACTION_GET_VALUE, @x, i) = SANE_STATUS_GOOD then
       { case saneoption^.option_type of
             SANE_TYPE_INT :} Result := x;{
             SANE_TYPE_FIXED : Result := Trunc( SANE_UNFIX( x ) );
        end;}
end;

function SaneGetMode ( const ScannerHandle: SANE_Handle ) : string;
var
  saneoption: pSANE_Option_Descriptor;
  x: Integer;
  l: longint;
  s: array[0..255] of char;
  OptionIndex: integer;
  y: Integer;
begin
  Result := '';
  OptionIndex := -1;
  x := 0;
  saneoption := sane_get_option_descriptor(ScannerHandle, x);
  while (saneoption<>nil) and(OptionIndex = -1) do
        begin
          if saneoption^.name = SANE_NAME_SCAN_MODE then
             OptionIndex := x;
          inc(x);
          saneoption := sane_get_option_descriptor(ScannerHandle, x);
        end;
  if sane_control_option(ScannerHandle, OptionIndex, SANE_ACTION_GET_VALUE, @s, l) = SANE_STATUS_GOOD then
     begin
        y := 0;
        while s[y] <> #0 do
              begin
              Result := Result+s[y];
              Inc(y);
              end;
     end;
end;

function SaneGetOption ( const ScannerHandle: SANE_Handle; OptionName: string ) : SANE_Option_Descriptor;
var
  saneoption: pSANE_Option_Descriptor;
  x: Integer;
begin
  x := SaneGetOptionIndex(ScannerHandle, OptionName);
  if x > -1 then
     begin
       saneoption := sane_get_option_descriptor(ScannerHandle, x);
       Result := saneoption^;
     end;
end;

function SaneGetOptionIndex ( const ScannerHandle: SANE_Handle; OptionName: string
  ) : integer;
var
  x: Integer;
  saneoption: PSANE_Option_Descriptor;
begin
  Result := -1;
  x := 0;
  saneoption := sane_get_option_descriptor(ScannerHandle, x);
  while (saneoption<>nil) and(Result < 0) do
        begin
          if saneoption^.name = OptionName then
             Result := x;
          inc(x);
          saneoption := sane_get_option_descriptor(ScannerHandle, x);
        end;
end;

function SaneSetOption ( const ScannerHandle: SANE_Handle; OptionName, Value: string
  ) : SANE_Status;
var
  vp: Pointer;
  x: LongInt;
  optionindex: LongInt;
  l: SANE_Int;
begin
  optionindex := SaneGetOptionIndex(ScannerHandle, OptionName);
  if optionindex > -1 then
     begin
        if TryStrToInt(Value, x)
           then vp := @x
           else vp := Pchar(Value);
        Result := sane_control_option(ScannerHandle, optionindex, SANE_ACTION_SET_VALUE, vp, l);
     end;
end;

function SetPNMHeader (imagedepth, pixels_per_line, lines: longint; frameformat: SANE_Frame; var PNMHeader: string): byte; //byte is PNM 'magic number' (4,5,6)
begin
  Result := 0;
  PNMHeader := '';
        begin
          case frameformat of
               SANE_FRAME_GRAY: begin
                                  if imagedepth=1 then
                                     begin
                                       PNMHeader := 'P4' + #10 + '# SANE data follows' + #10
                                          + IntToStr(pixels_per_line) + #32 + IntTostr(lines) + #10;
                                       Result := 4;
                                     end
                                  else
                                     begin
                                       PNMHeader := 'P5' + #10 + '# SANE data follows' + #10
                                          + IntToStr(pixels_per_line) + #32 + IntTostr(lines) + #10  + '255' + #10;
                                       Result := 5;
                                     end;
                                end;
               SANE_FRAME_RGB,
               SANE_FRAME_RED,
               SANE_FRAME_GREEN,
               SANE_FRAME_BLUE: begin
                                  PNMHeader := 'P6' + #10 + '# SANE data follows' + #10
                                      + IntToStr(pixels_per_line) + #32 + IntTostr(lines) + #10 + '255' + #10;
                                  Result := 6;
                                end;
               end;
        end;
end;

{ This function is here for demonstration purposes as it would be too slow for large scans}
function PNMtoBitmap ( PNMimagetype, rowcount, linecount: longint; Str: TStream; bmp: TBitmap
  ) : Boolean;
var
  ct: integer;
  whitespace: integer;
  aByte: byte;
  row: integer;
  line: integer;
  PixelRGB: array[0..2] of byte;
begin
  bmp.Height := linecount;
  bmp.Width := rowcount;
  bmp.PixelFormat := pf24bit;
  ct := 0;
  if PNMimagetype = 4
     then whitespace := 3
     else whitespace := 4;
  Str.Seek(0, soBeginning);
  while ct < whitespace do
        begin
          Str.Read(aByte, 1);
          if aByte = 10 then Inc(ct);
//          write(chr(aByte));
        end;
  case PNMimagetype of
       4: begin
            line := 0;
            row := 0;
            while Str.Position < Str.Size do
              begin
                Str.Read(aByte, 1);
                for ct := 7 downto 0  do
                   begin
                     bmp.Canvas.Pixels[row, line] := BitToColor(aByte,ct);
                     Inc(row);
                     if row = rowcount then
                             begin
                               row := 0;
                               Inc(line);
                             end;
                   end;
              end;
          end;
       5: for line := 0 to linecount-1 do
              for row := 0 to rowcount-1 do
          begin
            Str.Read(aByte, 1);
            bmp.Canvas.Pixels[row, line] := GrayscaleToColor(aByte);
          end;
       6: for line := 0 to linecount-1 do
              for row := 0 to rowcount-1 do
          begin
            Str.Read(PixelRGB, 3);
            bmp.Canvas.Pixels[row, line] := RGBToColor(PixelRGB[0], PixelRGB[1], PixelRGB[2]);
          end;
       end;  //case
end;

function DrawPNMtoForm ( rowcount, linecount: longint; var Str: TStream; var bmp: Tform
  ) : Boolean;
var
  ct: integer;
  B: string;
  row: integer;
  line: integer;
  PixelRGB: array[0..2] of byte;
  bytesread: longint;
begin
  Result := False;
  bmp.Height := linecount+10;
  bmp.Width := rowcount+10;
  ct := 0;
  bytesread := 0;
  SetLength(b, 1);
  Str.Seek(0, soBeginning);
  while ct < 4 do
        begin
          bytesread := bytesread + Str.Read(b[1], 1);
          if b[1] = #10 then Inc(ct);
          writeln(Str.Size, ' : ', Str.Position, ' : ', bytesread, ' : ', b);
        end;
  for line := 0 to linecount-1 do
      for row := 0 to 20 do
          begin
            bytesread := bytesread + Str.Read(PixelRGB, 3);
            bmp.Canvas.Pixels[row, line] := RGBToColor(PixelRGB[0], PixelRGB[1], PixelRGB[2]);
            writeln(Str.Size, ' : ', bytesread, ' : ', line, '/', linecount);
          end;
  Result := True;
  Application.ProcessMessages;
end;

function GrayscaleToColor ( Value: byte ) : TColor;
begin
  Result := (Value shl 16) or (Value shl 8) or Value;
end;

function BitToColor ( Value, Bit: byte ) : TColor;
begin
  if (Value and (1 shl Bit)) <> 0
     then Result := clBlack
     else Result := clWhite;
end;

end.

