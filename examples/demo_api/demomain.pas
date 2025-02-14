(* demomain.pas
  A demonstration application for
  SanePascal: Sane (libsane) features for Pascal and Delphi

  Copyright (C) 2008 Malcolm Poole mgpoole@users.sourceforge.net
                2025 Massimo Magnano
*)

unit demomain;

{$mode objfpc}{$H+}

//Enable this define if you want a dynamic load of the Library
//  using Load/Unload functions intestead the Library is linked in project
{$define SANE_DYNAMIC_LOAD}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls, ScanUtils, sane, saneopts;

type

  { TScannerForm }

  TScannerForm = class ( TForm )
    SaneTestCheck: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    FileNameEdit: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    OptionsButton: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ProgressLabel: TLabel;
    RefreshButton: TButton;
    ResolutionCombo: TComboBox;
    ResolutionEdit: TSpinEdit;
    ScanButton: TButton;
    ScanFileButton: TButton;
    ScanToScreenButton: TButton;
    UnsupportedLabel: TLabel;
    procedure ComboBox1Change ( Sender: TObject ) ;
    procedure FormCreate(Sender: TObject);
    procedure GroupBox2Resize(Sender: TObject);
    procedure ScanToScreenButtonClick ( Sender: TObject ) ;
    procedure ScanButtonClick ( Sender: TObject ) ;
    procedure ScanFileButtonClick ( Sender: TObject ) ;
    procedure UpdateDisplayedOptions;
    procedure OptionsButtonClick ( Sender: TObject ) ;
    procedure RefreshButtonClick ( Sender: TObject ) ;
  private
    { private declarations }
  public
    { public declarations }
  end; 
  
  { TBitmapForm }
  TBitmapForm = class ( TForm )
    Image: TImage;
    CloseButton: TButton;
    procedure CloseButtonClick ( Sender: TObject ) ;
    procedure BitmapFormResize ( Sender: TObject ) ;
  public
    constructor Create ( AOwner: TComponent ) ; override;
  end;

var
  ScannerForm: TScannerForm;

implementation

{ TScannerForm }

procedure TScannerForm.RefreshButtonClick ( Sender: TObject ) ;
begin
  TButton(Sender).Enabled := false;
  Application.ProcessMessages;
  SaneGetDeviceList(ComboBox1.Items);

  // libsane includes a test backend for developers to use when testing interfaces
  // man sane-test or http://www.meier-geinitz.de/sane/test-backend/ for further information
  if SaneTestCheck.Checked then ComboBox1.Items.Insert(0, 'test');
  if ComboBox1.Items.Count > 0 then
     begin
       ComboBox1.ItemIndex := 0;
       UpdateDisplayedOptions;
     end
  else ShowMessage('No scanners were found');

  OptionsButton.Enabled := ComboBox1.Itemindex > -1;
  ScanButton.Enabled := ComboBox1.Itemindex > -1;
  ScanFileButton.Enabled := ComboBox1.Itemindex > -1;
  ScanToScreenButton.Enabled := ComboBox1.Itemindex > -1;
  RefreshButton.Enabled := true;
end;


// this procedure lists all the options of the selected device and their characteristics
procedure TScannerForm.OptionsButtonClick ( Sender: TObject ) ;
type
 strlist = array[0..255] of PChar;
 pstrlist = ^strlist;
 wordlist = array [0..128] of SANE_Word;
 pwordlist = ^wordlist;
var
  RangeIndex,
  OptionIndex,
  x, ver: Integer;
  h: SANE_Handle;
  saneoption: pSANE_Option_Descriptor;
  range: ^SANE_Range;
  str : pstrlist;
  w   : pwordlist;
  scanner: string;
  val: Pointer;
  info: SANE_Int;

begin
  sane_init(@ver, nil);
  Memo1.Clear;
  scanner := ComboBox1.Items[ComboBox1.ItemIndex];
  if sane_open(PChar(scanner), h) = SANE_STATUS_GOOD then
     try
        OptionIndex := 0;
        saneoption := sane_get_option_descriptor(h, OptionIndex);
        while saneoption<>nil do
              begin
                Memo1.Lines.Add('Option ' + IntToStr(OptionIndex) + #32 + '"' + saneoption^.name + '"');
                Memo1.Lines.Add('Title: ' + saneoption^.title);
                Memo1.Lines.Add('Description: ' + saneoption^.desc);
                case saneoption^._unit of
                     SANE_UNIT_NONE : Memo1.Lines.Add('Unit is NONE');
                     SANE_UNIT_PIXEL : Memo1.Lines.Add('Unit is PIXEL');
                     SANE_UNIT_BIT : Memo1.Lines.Add('Unit is BIT');
                     SANE_UNIT_MM : Memo1.Lines.Add('Unit is MM');
                     SANE_UNIT_DPI : Memo1.Lines.Add('Unit is DPI');
                     SANE_UNIT_PERCENT : Memo1.Lines.Add('Unit is %');
                     SANE_UNIT_MICROSECOND : Memo1.Lines.Add('Unit is msec');
                     end;
                case saneoption^._type of
                     SANE_TYPE_BOOL : Memo1.Lines.Add('Type is BOOL');
                     SANE_TYPE_INT : Memo1.Lines.Add('Type is INT');
                     SANE_TYPE_FIXED : Memo1.Lines.Add('Type is FIXED');
                     SANE_TYPE_STRING : Memo1.Lines.Add('Type is STRING');
                     SANE_TYPE_BUTTON :Memo1.Lines.Add('Type is BUTTON');
                     SANE_TYPE_GROUP : Memo1.Lines.Add('Type is GROUP');
                     end;
                if SANE_OPTION_IS_ACTIVE(saneoption^.cap)
                   then Memo1.Lines.Add('Option is ACTIVE')
                   else Memo1.Lines.Add('Option NOT ACTIVE');
                if SANE_OPTION_IS_SETTABLE(saneoption^.cap)
                   then Memo1.Lines.Add('Option is SETTABLE')
                   else Memo1.Lines.Add('Option NOT SETTABLE');
                case saneoption^.constraint_type of
                     SANE_CONSTRAINT_NONE : Memo1.Lines.Add('Constraint is NONE');
                     SANE_CONSTRAINT_RANGE : begin
                                           Memo1.Lines.Add('Constraint is RANGE');
                                           range := saneoption^.range;
                                           if saneoption^._type = SANE_TYPE_FIXED
                                              then Memo1.Lines.Add('range min is ' + FloatToStr( SANE_UNFIX( range^.min)))
                                              else Memo1.Lines.Add('range min is ' + IntToStr(range^.min));
                                           if saneoption^._type = SANE_TYPE_FIXED
                                              then Memo1.Lines.Add('range max is ' + FloatToStr( SANE_UNFIX( range^.max)))
                                              else Memo1.Lines.Add('range max is ' + FloatToStr(range^.max));
                                           if saneoption^._type = SANE_TYPE_FIXED
                                              then Memo1.Lines.Add('range quant is ' + FloatToStr( SANE_UNFIX( range^.quant)))
                                              else Memo1.Lines.Add('range quant is ' + IntToStr(range^.quant));
                                           end;
                     SANE_CONSTRAINT_STRING_LIST : begin
                                                   Memo1.Lines.Add('Constraint is STRINGLIST');
                                                   Memo1.Lines.Add('Possible values are:');
                                                   str := pstrlist(saneoption^.stringlist);
                                                   RangeIndex := 0;
                                                   scanner := '';
                                                   while str^[RangeIndex] <> nil do
                                                         begin
                                                           Memo1.Lines.Add('    ' + str^[RangeIndex]);
                                                           Inc(RangeIndex);
                                                         end;

                                                   end;
                     SANE_CONSTRAINT_WORD_LIST : begin
                                                 Memo1.Lines.Add('Constraint is WORDLIST');
                                                 w := pwordlist(saneoption^.wordlist);
                                                 Memo1.Lines.Add(IntToStr(w^[0]) + ' items in list:');
                                                 if saneoption^._type=SANE_TYPE_INT then
                                                   for x := 1 to w^[0] do
                                                      Memo1.Lines.Add('    ' + IntToStr(w^[x]))
                                                 else
                                                 if saneoption^._type=SANE_TYPE_FIXED then
                                                   for x := 1 to w^[0] do
                                                      Memo1.Lines.Add('    ' + FloatToStr( SANE_UNFIX(w^[x]) ));
                                                 end;
                     end;
                // Now let's read the current value of the option

                // the SANE_Option_Descriptor size field must be used to make sure we have enough memory reserved for the value
                Getmem(Val, saneoption^.size);
                try
                if Val <> nil then
                  // get the value which will be placed in the memory addressed by Val
                  if sane_control_option(h, OptionIndex, SANE_ACTION_GET_VALUE, val, info) = SANE_STATUS_GOOD then
                    case saneoption^._type of
                         SANE_TYPE_BOOL: Memo1.Lines.Add('Current value: ' + BoolToStr(Integer(Val^)<>0));
                         SANE_TYPE_FIXED: Memo1.Lines.Add('Current value: ' + FloatToStr( SANE_UNFIX( Integer(Val^) ) ));
                         SANE_TYPE_INT : Memo1.Lines.Add('Current value: ' + IntToStr(Integer(Val^)));
                         SANE_TYPE_STRING: Memo1.Lines.Add('Current value: ' + PChar(Val));
                         SANE_TYPE_BUTTON: ; // this type has no value
                         SANE_TYPE_GROUP:  ; // this type has no value
                    end;
                finally
                Freemem(Val);
                end;
                inc(OptionIndex);
                saneoption := sane_get_option_descriptor(h, OptionIndex);
                Memo1.Lines.Add('------------');
              end;
     finally
       sane_close(h);
       sane_exit;
     end;
end;

// Shows how to obtain and display the values of two common options
// Note that in this example we do not check that the options are supported
// Checking for support is recommended even for common options
procedure TScannerForm.UpdateDisplayedOptions ;
type
 strlist = array[0..255] of PChar;
 pstrlist = ^strlist;
 wordlist = array [0..128] of SANE_Word;
 pwordlist = ^wordlist;
var
  SaneOption: SANE_Option_Descriptor;
  SaneRange: ^Sane_Range;
  str : pstrlist;
  x: Integer;
  res: SANE_Status;
  h: SANE_Handle;
  w: pwordlist;
  Resolution: LongInt;
begin
  if ComboBox1.ItemIndex > -1 then
     begin
  ComboBox2.Items.Clear;
  h := nil;
  res := sane_init(nil, nil);
  if res = SANE_STATUS_GOOD then
     if sane_open(PChar(ComboBox1.Items[ComboBox1.ItemIndex]), h) = SANE_STATUS_GOOD then
        try
           // Get the resolution range limits
           SaneOption := SaneGetOption(h, SANE_NAME_SCAN_RESOLUTION);
           //check that we are going to cast the constraint correctly, then get the constraint values
           if SaneOption.constraint_type = SANE_CONSTRAINT_RANGE then
              // scanner has a variable resolution between minimum and maximum values
              begin
               ResolutionCombo.Visible := false;
               ResolutionEdit.Visible := true;
               SaneRange := SaneOption.range;
               if SaneOption._type=SANE_TYPE_INT then
                  begin
                    ResolutionEdit.MinValue := SaneRange^.min;
                    ResolutionEdit.MaxValue := SaneRange^.max;
                  end
               else
               if SaneOption._type=SANE_TYPE_FIXED then
                  begin
                    ResolutionEdit.MinValue := Trunc( SANE_UNFIX(SaneRange^.min) );
                    ResolutionEdit.MaxValue := Trunc( SANE_UNFIX(SaneRange^.max) );
                  end;
              end
           else if SaneOption.constraint_type = SANE_CONSTRAINT_WORD_LIST then
           // some scanners have a list of defined resolutions
           // for SANE_CONSTRAINT_WORD_LIST we should check the value of SaneOption.option_type
           // so that we know how to interpret the values.
           // for resolution, however, it must be an integer so we're not doing a check here
              begin
                ResolutionCombo.Visible := true;
                ResolutionEdit.Visible := false;
                ResolutionCombo.Items.Clear;
                w := pWordlist(SaneOption.wordlist);
                for x := 1 to w^[0] do
                ResolutionCombo.Items.Add(IntToStr(w^[x]));
                ResolutionCombo.ItemIndex := 0;
              end;

           // Now show the current resolution
           Resolution := SaneGetResolution(h);
           if ResolutionEdit.Visible then ResolutionEdit.Value := Resolution
           else ResolutionCombo.ItemIndex := ResolutionCombo.Items.IndexOf(IntToStr(Resolution));
           UnsupportedLabel.Visible := false;
           if Resolution < 0 then
              begin
                ResolutionCombo.Visible:=false;
                ResolutionEdit.Visible:=false;
                UnsupportedLabel.Visible:=true;
              end;

           // Find out what colour modes are available, then display the current mode
           SaneOption := SaneGetOption(h, SANE_NAME_SCAN_MODE);
           if SaneOption.constraint_type = SANE_CONSTRAINT_STRING_LIST then
             begin
               str := pstrlist(SaneOption.stringlist);
               x := 0;
               while str^[x] <> nil do
                 begin
                   ComboBox2.Items.Add(str^[x]);
                   Inc(x);
                 end;
               ComboBox2.ItemIndex := ComboBox2.Items.IndexOf(SaneGetMode(h));
             end;
             
        finally
          sane_close(h);
          sane_exit;
        end;
     end;
end;

// This demo shows a way of scanning directly to an onscreen image and to show scan progress
// If the image is too large to display you could scale it by omitting
// pixels as appropriate
procedure TScannerForm.ScanToScreenButtonClick ( Sender: TObject ) ;
var
  h: SANE_Handle;
  status: SANE_Status;
  l : SANE_Int;
  par: SANE_Parameters;
  BitmapForm: TBitmapForm;
  linecount: LongInt;
  linewidth: LongInt;
  PNMImageType: Integer;
  pixeltotal: Integer;
  aByte: byte;
  PixelRGB: array[0..2] of byte;
  CurrentPixel: Integer;
  ct: Integer;
  CurrentLine: Integer;
  CurrentLinePos: Integer;
  Progress: LongInt;
  resolution: String;
begin
  BitmapForm := TBitmapForm.Create(Self);
  if sane_init(nil, nil) = SANE_STATUS_GOOD then
     if sane_open(PChar(ComboBox1.Items[ComboBox1.ItemIndex]), h) = SANE_STATUS_GOOD then
        try
          TButton(Sender).Enabled := false;

          // For this demo we use the lowest possible resolution as we are displaying on screen
          if ResolutionCombo.Visible
             then resolution := ResolutionCombo.Items[ResolutionCombo.ItemIndex]
             else resolution := IntToStr(ResolutionEdit.MinValue);
          SaneSetOption(h, SANE_NAME_SCAN_RESOLUTION, resolution);

          // set selected scan mode
          SaneSetOption(h, SANE_NAME_SCAN_MODE, ComboBox2.Items[ComboBox2.ItemIndex]) ;

          status := sane_start(h);
          if status = SANE_STATUS_GOOD then
             begin
                if sane_get_parameters(h, par)= SANE_STATUS_GOOD then
                  begin
                    linecount := par.lines;
                    linewidth := par.pixels_per_line;
                    pixeltotal := linecount * linewidth;
                    case par.format of
                         SANE_FRAME_GRAY: if par.depth=1
                                            then PNMImageType := 4
                                            else PNMImageType := 5;
                         SANE_FRAME_RGB,
                         SANE_FRAME_RED,
                         SANE_FRAME_GREEN,
                         SANE_FRAME_BLUE:   PNMImageType := 6;
                         end;
                    BitmapForm.Width := linewidth;
                    BitmapForm.Height := linecount + (BitmapForm.CloseButton.Height * 2);
                    BitmapForm.ShowOnTop;
                    Application.ProcessMessages;  // otherwise we won't see the form

                    CurrentPixel := 0;
                    CurrentLine := 0;
                    CurrentLinePos := 0;

                    while CurrentPixel < pixeltotal do
                          begin
                            if PNMImageType = 4 then   // Lineart
                                begin
                                  status := sane_read(h, @aByte, 1, l);
                                  for ct := 7 downto 0  do
                                     begin
                                       BitmapForm.Image.Picture.Bitmap.Canvas.Pixels[Currentlinepos, CurrentLine]
                                                                                                     := BitToColor(aByte,ct);
                                       Inc(CurrentPixel);
                                       Inc(CurrentLinepos);
                                       // a byte of a lineart image can contain data from two lines
                                       if CurrentLinepos = linewidth then
                                               begin
                                                 CurrentLinepos := 0;
                                                 Inc(CurrentLine);
                                               end;
                                     end;
                                end
                            else
                                begin
                                  if PNMImageType = 5 then    // Grayscale
                                    begin
                                      status := sane_read(h, @aByte, 1, l);
                                      BitmapForm.Image.Picture.Bitmap.Canvas.Pixels[Currentlinepos, CurrentLine]
                                                                                                    := GrayscaleToColor(aByte);
                                     end
                                  else                        // 24bit Color
                                     begin
                                      status := sane_read(h, @PixelRGB, 3, l);
                                      BitmapForm.Image.Picture.Bitmap.Canvas.Pixels[Currentlinepos, CurrentLine]
                                                      := RGBToColor(PixelRGB[0], PixelRGB[1], PixelRGB[2]);
                                     end;
                                  Inc(CurrentPixel);
                                  Inc(CurrentLinePos);
                                  if CurrentLinepos = linewidth then
                                       begin
                                         CurrentLinepos := 0;
                                         Inc(CurrentLine);
                                       end;
                                  end;
                            if pixeltotal > 9 then
                                if (CurrentPixel mod (pixeltotal div 10)) = 0 then   // update progress every 10%
                                  begin
                                    Progress := (CurrentPixel*10) div pixeltotal;
                                    BitmapForm.Caption := IntToStr(Progress*10) + '% loaded';
                                    Application.ProcessMessages;
                                  end;
                          end; //while CurrentPixel < ...
                  end
                else ShowMessage('Unable to get parameters');
             end else ShowMessage('Scan failed');
        finally
          sane_cancel(h);
          sane_close(h);
          sane_exit;

          BitmapForm.CloseButton.Enabled := true;
          BitmapForm.Caption := '100% loaded';
          TButton(Sender).Enabled := true;;
        end
        else ShowMessage('Unable to open device');
end;


// This demo shows how to scan to a stream and a way of displaying a scaled version
procedure TScannerForm.ScanButtonClick ( Sender: TObject ) ;
var
  h: SANE_Handle;
  par: SANE_Parameters;
  byteswritten: Integer;
  data: array[0..1023] of char;
  fileheader: String;
  l : SANE_Int;
  ms: TMemoryStream;
  status: SANE_Status;
  Bitmap: TBitmap;
  PNMtype: byte;
  resolution: String;
begin
  TButton(Sender).Enabled := false;
  fileheader := '';
  ProgressLabel.Caption := 'Initialising...';
  Application.ProcessMessages;
  if sane_init(nil, nil) = SANE_STATUS_GOOD then
     if sane_open(PChar(ComboBox1.Items[ComboBox1.ItemIndex]), h) = SANE_STATUS_GOOD then
        try
          // Set minimum resolution for preview quality
          if not UnsupportedLabel.Visible then
             begin
                if ResolutionCombo.Visible
                   then resolution := ResolutionCombo.Items[0]
                   else resolution := IntToStr(ResolutionEdit.MinValue);
                SaneSetOption(h, SANE_NAME_SCAN_RESOLUTION, resolution);
             end;
          // set selected scan mode
          SaneSetOption(h, SANE_NAME_SCAN_MODE, ComboBox2.Items[ComboBox2.ItemIndex]);

          // start scanning
          ProgressLabel.Caption := 'Scanning...';
          Application.ProcessMessages;
          status := sane_start(h);
          if status = SANE_STATUS_GOOD then
             begin
               byteswritten := 0;
               ms := TMemoryStream.Create;
               if sane_get_parameters(h, par)=SANE_STATUS_GOOD then
                 PNMtype := SetPNMHeader(par.depth, par.pixels_per_line, par.lines, par.format, fileheader);  // get current image parameters and create PNM header
               byteswritten := ms.Write(fileheader[1], Length(fileheader));
               
                while status = SANE_STATUS_GOOD do
                  begin
                    status := sane_read(h, @data, 1024, l);  //read data stream from scanner
                    byteswritten := byteswritten + ms.Write(data, l);
                  end;
             end
          else ShowMessage('Scan failed: ' + sane_strstatus(status));
          
          // now we have PNM image stored in stream ms
          // this can be read by MagickReadImageBlob and processed using libMagick
          // Unfortunately TPortableAnyMapGraphic.LoadFromStream chokes on libsane PNM output
          Bitmap := TBitmap.Create;
          ProgressLabel.Caption := 'Copying to bitmap...';
          Application.ProcessMessages;

          PNMtoBitmap(PNMtype, par.pixels_per_line, par.lines, ms, Bitmap);
          Image1.Picture.Bitmap.Assign(Bitmap); // Copy the contents of Bitmap to an image with StretchDraw set
          
        finally
          Bitmap.Free;
          ms.Free;
          
          // tidy up memory used by libsane
          sane_close(h);
          sane_exit;
        end;
  ProgressLabel.Caption := '';
  TButton(Sender).Enabled := true;
end;

// a simple method of scanning directly to a PNM format file
procedure TScannerForm.ScanFileButtonClick ( Sender: TObject ) ;
var
  h: SANE_Handle;
  fileheader: String;
  filename: String;
  f: LongInt;
  status: SANE_Status;
  data: array[0..1023] of char;
  l : SANE_Int;
  par: SANE_Parameters;
begin
  fileheader := '';
  if sane_init(nil, nil) = SANE_STATUS_GOOD then
     if sane_open(PChar(ComboBox1.Items[ComboBox1.ItemIndex]), h) = SANE_STATUS_GOOD then
        try
          // Set selected resolution
          if ResolutionEdit.Visible
               then SaneSetOption(h, SANE_NAME_SCAN_RESOLUTION, ResolutionEdit.Text)
               else SaneSetOption(h, SANE_NAME_SCAN_RESOLUTION, ResolutionCombo.Items[ResolutionCombo.ItemIndex]);

          // set selected scan mode
          SaneSetOption(h, SANE_NAME_SCAN_MODE, ComboBox2.Items[ComboBox2.ItemIndex]) ;
          
          if Pos('~/', FileNameEdit.Text) = 1
             then filename := GetEnvironmentVariable('HOME') + Copy(FileNameEdit.Text, 2, MaxInt)
             else filename := FileNameEdit.Text;
          f := FileCreate(filename);

          status := sane_start(h);  // start scanning
          if status = SANE_STATUS_GOOD then
             begin
                if sane_get_parameters(h, par) = SANE_STATUS_GOOD then // we know the image dimensions and depth
                  SetPNMHeader(par.depth, par.pixels_per_line, par.lines, par.format, fileheader);
                FileWrite(f, fileheader[1], Length(fileheader));
                while status = SANE_STATUS_GOOD do
                  begin
                    status := sane_read(h, @data, 1024, l);    //read data stream from scanner
                    FileWrite(f, data, l);                       //then just write it straight out to file
                  end;
             end
          else ShowMessage('Scan failed: ' + sane_strstatus(status));
        finally
          FileClose(f);
          sane_cancel(h);
          sane_close(h);
          sane_exit;
        end;
end;

procedure TScannerForm.ComboBox1Change ( Sender: TObject ) ;
begin
  if ComboBox1.ItemIndex > -1 then
     UpdateDisplayedOptions;
  OptionsButton.Enabled := ComboBox1.Itemindex > -1;
  ScanButton.Enabled := ComboBox1.Itemindex > -1;
  ScanFileButton.Enabled := ComboBox1.Itemindex > -1;
  ScanToScreenButton.Enabled := ComboBox1.Itemindex > -1;
end;

procedure TScannerForm.FormCreate(Sender: TObject);
begin
  Caption := Caption + ' - using libsane ' + GetSaneVersion;
end;

procedure TScannerForm.GroupBox2Resize(Sender: TObject);
begin
  Memo1.Height := GroupBox2.Height-25;
end;


{ TBitmapForm }

procedure TBitmapForm.CloseButtonClick ( Sender: TObject ) ;
begin
  Self.Close;
  Self.Free;
end;

procedure TBitmapForm.BitmapFormResize ( Sender: TObject ) ;
begin
  Image.Width := Width;
  Image.Picture.Bitmap.Width := Width;
  Image.Height := Height-(CloseButton.Height * 2);
  Image.Picture.Bitmap.Height := Height-(CloseButton.Height * 2);
  Image.Picture.Bitmap.Canvas.Rectangle(0,0,Width,Height);
  CloseButton.Left := (Width-CloseButton.Width) div 2;
  CloseButton.Top := Height - (CloseButton.Height div 2 *3);
end;

constructor TBitmapForm.Create ( AOwner: TComponent ) ;
begin
  inherited Create ( AOwner ) ;
  if AOwner is TForm then
     begin
       Top := TForm(AOwner).Top + 20;
       Left := TForm(AOwner).Left + 20;
     end;
  Self.OnResize := @BitmapFormResize;
  Image := TImage.Create(Self);
  Image.Parent := Self;
  Image.Top := 0;
  Image.Left := 0;
  Image.Picture.Bitmap.Canvas.Brush.Color := clCream;
  CloseButton := TButton.Create(Self);
  CloseButton.Caption := 'Close';
  CloseButton.Parent := Self;
  CloseButton.Enabled := false;
  CloseButton.OnClick := @CloseButtonClick;
  BitmapFormResize(self);
end;

initialization
  {$I demomain.lrs}

  {$ifdef SANE_DYNAMIC_LOAD} sane.Load; {$endif}

finalization
  {$ifdef SANE_DYNAMIC_LOAD} sane.Unload; {$endif}

end.

