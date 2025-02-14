(****************************************************************************
*
*  FILE: saneopts.pas
*
*  VERSION:     1.3.1
*
*  DESCRIPTION:
*    Option NAMEs, TITLEs and DESCs that are used by several SANE backends.
*
*****************************************************************************
*
*  2025-02-14 Translation and adaptation by Massimo Magnano
*             based on Malcolm Poole August 2008
*
*****************************************************************************

   sane - Scanner Access Now Easy.
   Copyright (C) 1996, 1997 David Mosberger-Tang and Andreas Beck
   This file is part of the SANE package.

   SANE is free software; you can redistribute it and/or modify it under
   the terms of the GNU General Public License as published by the Free
   Software Foundation; either version 2 of the License, or (at your
   option) any later version.

   SANE is distributed in the hope that it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
   for more details.

   You should have received a copy of the GNU General Public License
   along with sane; see the file COPYING.
   If not, see <https://www.gnu.org/licenses/>.

   As a special exception, the authors of SANE give permission for
   additional uses of the libraries contained in this release of SANE.

   The exception is that, if you link a SANE library with other files
   to produce an executable, this does not by itself cause the
   resulting executable to be covered by the GNU General Public
   License.  Your use of that executable is in no way restricted on
   account of linking the SANE library code into it.

   This exception does not, however, invalidate any other reasons why
   the executable file might be covered by the GNU General Public
   License.

   If you submit changes to SANE to the maintainers to be included in
   a subsequent release, you agree by submitting the changes that
   those changes may be distributed with this exception intact.

   If you write modifications of your own for SANE, it is your choice
   whether to permit this exception to apply to your modifications.
   If you do not wish that, delete this exception notice.

   This file declares common option names, titles, and descriptions.  A
   backend is not limited to these options but for the sake of
   consistency it's better to use options declared here when appropriate.

   This file defines several option NAMEs, TITLEs and DESCs
   that are (or should be) used by several backends.

   All well known options should be listed here. But this does
   not mean that all options that are listed here are well known options.
   To find out if an option is a well known option and how well known
   options have to be defined please take a look at the sane standard!!!
 *)

Unit saneopts;

{$ifdef FPC}
  {$mode objfpc}
{$endif}

interface

const
// This _must_ be the first option (index 0):
 SANE_NAME_NUM_OPTIONS		= '';	// never settable

 // The common option groups
 SANE_NAME_STANDARD   		= 'standard';
 SANE_NAME_GEOMETRY   		= 'geometry';
 SANE_NAME_ENHANCEMENT		= 'enhancement';
 SANE_NAME_ADVANCED   		= 'advanced';
 SANE_NAME_SENSORS    		= 'sensors';

 SANE_NAME_PREVIEW		= 'preview';
 SANE_NAME_GRAY_PREVIEW		= 'preview-in-gray';
 SANE_NAME_BIT_DEPTH		= 'depth';
 SANE_NAME_SCAN_MODE		= 'mode';
 SANE_NAME_SCAN_SPEED		= 'speed';
 SANE_NAME_SCAN_SOURCE		= 'source';
 SANE_NAME_BACKTRACK		= 'backtrack';
(* Most user-interfaces will let the user specify the scan area as the
   top-left corner and the width/height of the scan area.  The reason
   the backend interface uses the top-left/bottom-right corner is so
   that the scan area values can be properly constraint independent of
   any other option value.  *)
 SANE_NAME_SCAN_TL_X		= 'tl-x';
 SANE_NAME_SCAN_TL_Y		= 'tl-y';
 SANE_NAME_SCAN_BR_X		= 'br-x';
 SANE_NAME_SCAN_BR_Y		= 'br-y';
 SANE_NAME_SCAN_RESOLUTION	= 'resolution';
 SANE_NAME_SCAN_X_RESOLUTION	= 'x-resolution';
 SANE_NAME_SCAN_Y_RESOLUTION	= 'y-resolution';
 SANE_NAME_CUSTOM_GAMMA		= 'custom-gamma';
 SANE_NAME_GAMMA_VECTOR		= 'gamma-table';
 SANE_NAME_GAMMA_VECTOR_R	= 'red-gamma-table';
 SANE_NAME_GAMMA_VECTOR_G	= 'green-gamma-table';
 SANE_NAME_GAMMA_VECTOR_B	= 'blue-gamma-table';
 SANE_NAME_BRIGHTNESS		= 'brightness';
 SANE_NAME_CONTRAST		= 'contrast';
 SANE_NAME_GRAIN_SIZE		= 'grain';
 SANE_NAME_HALFTONE		= 'halftoning';
 SANE_NAME_BLACK_LEVEL          = 'black-level';
 SANE_NAME_WHITE_LEVEL          = 'white-level';
 SANE_NAME_WHITE_LEVEL_R        = 'white-level-r';
 SANE_NAME_WHITE_LEVEL_G        = 'white-level-g';
 SANE_NAME_WHITE_LEVEL_B        = 'white-level-b';
 SANE_NAME_SHADOW	        = 'shadow';
 SANE_NAME_SHADOW_R		= 'shadow-r';
 SANE_NAME_SHADOW_G		= 'shadow-g';
 SANE_NAME_SHADOW_B		= 'shadow-b';
 SANE_NAME_HIGHLIGHT		= 'highlight';
 SANE_NAME_HIGHLIGHT_R		= 'highlight-r';
 SANE_NAME_HIGHLIGHT_G		= 'highlight-g';
 SANE_NAME_HIGHLIGHT_B		= 'highlight-b';
 SANE_NAME_HUE			= 'hue';
 SANE_NAME_SATURATION		= 'saturation';
 SANE_NAME_FILE			= 'filename';
 SANE_NAME_HALFTONE_DIMENSION	= 'halftone-size';
 SANE_NAME_HALFTONE_PATTERN	= 'halftone-pattern';
 SANE_NAME_RESOLUTION_BIND	= 'resolution-bind';
 SANE_NAME_NEGATIVE		= 'negative';
 SANE_NAME_QUALITY_CAL		= 'quality-cal';
 SANE_NAME_DOR			= 'double-res';
 SANE_NAME_RGB_BIND		= 'rgb-bind';
 SANE_NAME_THRESHOLD		= 'threshold';
 SANE_NAME_ANALOG_GAMMA		= 'analog-gamma';
 SANE_NAME_ANALOG_GAMMA_R	= 'analog-gamma-r';
 SANE_NAME_ANALOG_GAMMA_G	= 'analog-gamma-g';
 SANE_NAME_ANALOG_GAMMA_B	= 'analog-gamma-b';
 SANE_NAME_ANALOG_GAMMA_BIND	= 'analog-gamma-bind';
 SANE_NAME_WARMUP		= 'warmup';
 SANE_NAME_CAL_EXPOS_TIME	= 'cal-exposure-time';
 SANE_NAME_CAL_EXPOS_TIME_R	= 'cal-exposure-time-r';
 SANE_NAME_CAL_EXPOS_TIME_G	= 'cal-exposure-time-g';
 SANE_NAME_CAL_EXPOS_TIME_B	= 'cal-exposure-time-b';
 SANE_NAME_SCAN_EXPOS_TIME	= 'scan-exposure-time';
 SANE_NAME_SCAN_EXPOS_TIME_R	= 'scan-exposure-time-r';
 SANE_NAME_SCAN_EXPOS_TIME_G	= 'scan-exposure-time-g';
 SANE_NAME_SCAN_EXPOS_TIME_B	= 'scan-exposure-time-b';
 SANE_NAME_SELECT_EXPOSURE_TIME	= 'select-exposure-time';
 SANE_NAME_CAL_LAMP_DEN		= 'cal-lamp-density';
 SANE_NAME_SCAN_LAMP_DEN	= 'scan-lamp-density';
 SANE_NAME_SELECT_LAMP_DENSITY	= 'select-lamp-density';
 SANE_NAME_LAMP_OFF_AT_EXIT	= 'lamp-off-at-exit';
 SANE_NAME_FOCUS		= 'focus';
 SANE_NAME_AUTOFOCUS            = 'autofocus';
 SANE_NAME_INFRARED             = 'infra-red';

 // well known options from 'SENSORS' group
 SANE_NAME_SCAN			= 'scan';
 SANE_NAME_EMAIL		= 'email';
 SANE_NAME_FAX			= 'fax';
 SANE_NAME_COPY			= 'copy';
 SANE_NAME_PDF			= 'pdf';
 SANE_NAME_CANCEL		= 'cancel';
 SANE_NAME_PAGE_LOADED		= 'page-loaded';
 SANE_NAME_COVER_OPEN		= 'cover-open';

resourcestring
 SANE_TITLE_NUM_OPTIONS		= 'Number of options';

 SANE_TITLE_STANDARD   		= 'Standard';
 SANE_TITLE_GEOMETRY   		= 'Geometry';
 SANE_TITLE_ENHANCEMENT		= 'Enhancement';
 SANE_TITLE_ADVANCED   		= 'Advanced';
 SANE_TITLE_SENSORS    		= 'Sensors';

 SANE_TITLE_PREVIEW		= 'Preview';
 SANE_TITLE_GRAY_PREVIEW	= 'Force monochrome preview';
 SANE_TITLE_BIT_DEPTH		= 'Bit depth';
 SANE_TITLE_SCAN_MODE		= 'Scan mode';
 SANE_TITLE_SCAN_SPEED		= 'Scan speed';
 SANE_TITLE_SCAN_SOURCE		= 'Scan source';
 SANE_TITLE_BACKTRACK		= 'Force backtracking';
 SANE_TITLE_SCAN_TL_X		= 'Top-left x';
 SANE_TITLE_SCAN_TL_Y		= 'Top-left y';
 SANE_TITLE_SCAN_BR_X		= 'Bottom-right x';
 SANE_TITLE_SCAN_BR_Y		= 'Bottom-right y';
 SANE_TITLE_SCAN_RESOLUTION	= 'Scan resolution';
 SANE_TITLE_SCAN_X_RESOLUTION	= 'X-resolution';
 SANE_TITLE_SCAN_Y_RESOLUTION	= 'Y-resolution';
 SANE_TITLE_PAGE_WIDTH  	= 'Page width';
 SANE_TITLE_PAGE_HEIGHT 	= 'Page height';
 SANE_TITLE_CUSTOM_GAMMA	= 'Use custom gamma table';
 SANE_TITLE_GAMMA_VECTOR	= 'Image intensity';
 SANE_TITLE_GAMMA_VECTOR_R	= 'Red intensity';
 SANE_TITLE_GAMMA_VECTOR_G	= 'Green intensity';
 SANE_TITLE_GAMMA_VECTOR_B	= 'Blue intensity';
 SANE_TITLE_BRIGHTNESS		= 'Brightness';
 SANE_TITLE_CONTRAST		= 'Contrast';
 SANE_TITLE_GRAIN_SIZE		= 'Grain size';
 SANE_TITLE_HALFTONE		= 'Halftoning';
 SANE_TITLE_BLACK_LEVEL         = 'Black level';
 SANE_TITLE_WHITE_LEVEL         = 'White level';
 SANE_TITLE_WHITE_LEVEL_R       = 'White level for red';
 SANE_TITLE_WHITE_LEVEL_G       = 'White level for green';
 SANE_TITLE_WHITE_LEVEL_B       = 'White level for blue';
 SANE_TITLE_SHADOW		= 'Shadow';
 SANE_TITLE_SHADOW_R		= 'Shadow for red';
 SANE_TITLE_SHADOW_G		= 'Shadow for green';
 SANE_TITLE_SHADOW_B		= 'Shadow for blue';
 SANE_TITLE_HIGHLIGHT		= 'Highlight';
 SANE_TITLE_HIGHLIGHT_R		= 'Highlight for red';
 SANE_TITLE_HIGHLIGHT_G		= 'Highlight for green';
 SANE_TITLE_HIGHLIGHT_B		= 'Highlight for blue';
 SANE_TITLE_HUE			= 'Hue';
 SANE_TITLE_SATURATION		= 'Saturation';
 SANE_TITLE_FILE		= 'Filename';
 SANE_TITLE_HALFTONE_DIMENSION	= 'Halftone pattern size';
 SANE_TITLE_HALFTONE_PATTERN	= 'Halftone pattern';
 SANE_TITLE_RESOLUTION_BIND	= 'Bind X and Y resolution';
 SANE_TITLE_NEGATIVE		= 'Negative';
 SANE_TITLE_QUALITY_CAL		= 'Quality calibration';
 SANE_TITLE_DOR			= 'Double Optical Resolution';
 SANE_TITLE_RGB_BIND		= 'Bind RGB';
 SANE_TITLE_THRESHOLD		= 'Threshold';
 SANE_TITLE_ANALOG_GAMMA	= 'Analog gamma correction';
 SANE_TITLE_ANALOG_GAMMA_R	= 'Analog gamma red';
 SANE_TITLE_ANALOG_GAMMA_G	= 'Analog gamma green';
 SANE_TITLE_ANALOG_GAMMA_B	= 'Analog gamma blue';
 SANE_TITLE_ANALOG_GAMMA_BIND   = 'Bind analog gamma';
 SANE_TITLE_WARMUP		= 'Warmup lamp';
 SANE_TITLE_CAL_EXPOS_TIME	= 'Cal. exposure-time';
 SANE_TITLE_CAL_EXPOS_TIME_R	= 'Cal. exposure-time for red';
 SANE_TITLE_CAL_EXPOS_TIME_G	= 'Cal. exposure-time for green';
 SANE_TITLE_CAL_EXPOS_TIME_B	= 'Cal. exposure-time for blue';
 SANE_TITLE_SCAN_EXPOS_TIME	= 'Scan exposure-time';
 SANE_TITLE_SCAN_EXPOS_TIME_R	= 'Scan exposure-time for red';
 SANE_TITLE_SCAN_EXPOS_TIME_G	= 'Scan exposure-time for green';
 SANE_TITLE_SCAN_EXPOS_TIME_B	= 'Scan exposure-time for blue';
 SANE_TITLE_SELECT_EXPOSURE_TIME= 'Set exposure-time';
 SANE_TITLE_CAL_LAMP_DEN	= 'Cal. lamp density';
 SANE_TITLE_SCAN_LAMP_DEN	= 'Scan lamp density';
 SANE_TITLE_SELECT_LAMP_DENSITY	= 'Set lamp density';
 SANE_TITLE_LAMP_OFF_AT_EXIT	= 'Lamp off at exit';
 SANE_TITLE_FOCUS		= 'Focus position';
 SANE_TITLE_AUTOFOCUS		= 'Autofocus';
 SANE_TITLE_INFRARED            = 'Infrared scan';

const
 // well known options from 'SENSORS' group
 SANE_TITLE_SCAN		= 'Scan button';
 SANE_TITLE_EMAIL		= 'Email button';
 SANE_TITLE_FAX			= 'Fax button';
 SANE_TITLE_COPY		= 'Copy button';
 SANE_TITLE_PDF			= 'PDF button';
 SANE_TITLE_CANCEL		= 'Cancel button';
 SANE_TITLE_PAGE_LOADED		= 'Page loaded';
 SANE_TITLE_COVER_OPEN		= 'Cover open';

resourcestring
 // Descriptive/help strings for above options:
 SANE_DESC_NUM_OPTIONS       = 'Read-only option that specifies how many options a specific device supports.';
 SANE_DESC_STANDARD          = 'Source, mode and resolution options';
 SANE_DESC_GEOMETRY          = 'Scan area and media size options';
 SANE_DESC_ENHANCEMENT       = 'Image modification options';
 SANE_DESC_ADVANCED          = 'Hardware specific options';
 SANE_DESC_SENSORS           = 'Scanner sensors and buttons';
 SANE_DESC_PREVIEW           = 'Request a preview-quality scan.';
 SANE_DESC_GRAY_PREVIEW      = 'Request that all previews are done in monochrome mode.  On a '+
                               'three-pass scanner this cuts down the number of passes to one and on a '+
                               'one-pass scanner, it reduces the memory requirements and scan-time of the '+
                               'preview.';
 SANE_DESC_BIT_DEPTH         = 'Number of bits per sample, typical values are 1 for "line-art" and 8 for multibit scans.';
 SANE_DESC_SCAN_MODE         = 'Selects the scan mode (e.g., lineart, monochrome, or color).';
 SANE_DESC_SCAN_SPEED        = 'Determines the speed at which the scan proceeds.';
 SANE_DESC_SCAN_SOURCE       = 'Selects the scan source (such as a document-feeder).';
 SANE_DESC_BACKTRACK         = 'Controls whether backtracking is forced.';
 SANE_DESC_SCAN_TL_X         = 'Top-left x position of scan area.';
 SANE_DESC_SCAN_TL_Y         = 'Top-left y position of scan area.';
 SANE_DESC_SCAN_BR_X         = 'Bottom-right x position of scan area.';
 SANE_DESC_SCAN_BR_Y         = 'Bottom-right y position of scan area.';
 SANE_DESC_SCAN_RESOLUTION   = 'Sets the resolution of the scanned image.';
 SANE_DESC_SCAN_X_RESOLUTION = 'Sets the horizontal resolution of the scanned image.';
 SANE_DESC_SCAN_Y_RESOLUTION = 'Sets the vertical resolution of the scanned image.';
 SANE_DESC_PAGE_WIDTH        = 'Specifies the width of the media.  Required for automatic centering of sheet-fed scans.';
 SANE_DESC_PAGE_HEIGHT       = 'Specifies the height of the media.';
 SANE_DESC_CUSTOM_GAMMA      = 'Determines whether a builtin or a custom gamma-table should be used.';
 SANE_DESC_GAMMA_VECTOR      = 'Gamma-correction table.  In color mode this option equally '+
                               'affects the red, green, and blue channels simultaneously (i.e., it is an intensity gamma table).';
 SANE_DESC_GAMMA_VECTOR_R    = 'Gamma-correction table for the red band.';
 SANE_DESC_GAMMA_VECTOR_G    = 'Gamma-correction table for the green band.';
 SANE_DESC_GAMMA_VECTOR_B    = 'Gamma-correction table for the blue band.';
 SANE_DESC_BRIGHTNESS        = 'Controls the brightness of the acquired image.';
 SANE_DESC_CONTRAST          = 'Controls the contrast of the acquired image.';
 SANE_DESC_GRAIN_SIZE        = 'Selects the \"graininess\" of the acquired image.  Smaller values result in sharper images.';
 SANE_DESC_HALFTONE          = 'Selects whether the acquired image should be halftoned (dithered).';
 SANE_DESC_BLACK_LEVEL       = 'Selects what radiance level should be considered "black".';
 SANE_DESC_WHITE_LEVEL       = 'Selects what radiance level should be considered "white".';
 SANE_DESC_WHITE_LEVEL_R     = 'Selects what red radiance level should be considered "white".';
 SANE_DESC_WHITE_LEVEL_G     = 'Selects what green radiance level should be considered "white".';
 SANE_DESC_WHITE_LEVEL_B     = 'Selects what blue radiance level should be considered "white".';
 SANE_DESC_SHADOW            = 'Selects what radiance level should be considered "black".';
 SANE_DESC_SHADOW_R          = 'Selects what red radiance level should be considered "black".';
 SANE_DESC_SHADOW_G          = 'Selects what green radiance level should be considered "black".';
 SANE_DESC_SHADOW_B          = 'Selects what blue radiance level should be considered "black".';
 SANE_DESC_HIGHLIGHT         = 'Selects what radiance level should be considered "white".';
 SANE_DESC_HIGHLIGHT_R       = 'Selects what red radiance level should be considered "full red".';
 SANE_DESC_HIGHLIGHT_G       = 'Selects what green radiance level should be considered "full green".';
 SANE_DESC_HIGHLIGHT_B       = 'Selects what blue radiance level should be considered "full blue".';
 SANE_DESC_HUE               = 'Controls the "hue" (blue-level) of the acquired image.';
 SANE_DESC_SATURATION        = 'The saturation level controls the amount of "blooming" that occurs '+
                               'when acquiring an image with a camera. Larger values cause more blooming.';
 SANE_DESC_FILE              = 'The filename of the image to be loaded.';
 SANE_DESC_HALFTONE_DIMENSION= 'Sets the size of the halftoning (dithering) pattern used when scanning halftoned images.';
 SANE_DESC_HALFTONE_PATTERN  = 'Defines the halftoning (dithering) pattern for scanning halftoned images.';
 SANE_DESC_RESOLUTION_BIND   = 'Use same values for X and Y resolution';
 SANE_DESC_NEGATIVE          = 'Swap black and white';
 SANE_DESC_QUALITY_CAL       = 'Do a quality white-calibration';
 SANE_DESC_DOR               = 'Use lens that doubles optical resolution';
 SANE_DESC_RGB_BIND          = 'In RGB-mode use same values for each color';
 SANE_DESC_THRESHOLD         = 'Select minimum-brightness to get a white point';
 SANE_DESC_ANALOG_GAMMA      = 'Analog gamma-correction';
 SANE_DESC_ANALOG_GAMMA_R    = 'Analog gamma-correction for red';
 SANE_DESC_ANALOG_GAMMA_G    = 'Analog gamma-correction for green';
 SANE_DESC_ANALOG_GAMMA_B    = 'Analog gamma-correction for blue';
 SANE_DESC_ANALOG_GAMMA_BIND = 'In RGB-mode use same values for each color';
 SANE_DESC_WARMUP            = 'Warm up lamp before scanning';
 SANE_DESC_CAL_EXPOS_TIME    = 'Define exposure-time for calibration';
 SANE_DESC_CAL_EXPOS_TIME_R  = 'Define exposure-time for red calibration';
 SANE_DESC_CAL_EXPOS_TIME_G  = 'Define exposure-time for green calibration';
 SANE_DESC_CAL_EXPOS_TIME_B  = 'Define exposure-time for blue calibration';
 SANE_DESC_SCAN_EXPOS_TIME   = 'Define exposure-time for scan';
 SANE_DESC_SCAN_EXPOS_TIME_R = 'Define exposure-time for red scan';
 SANE_DESC_SCAN_EXPOS_TIME_G = 'Define exposure-time for green scan';
 SANE_DESC_SCAN_EXPOS_TIME_B = 'Define exposure-time for blue scan';
 SANE_DESC_SELECT_EXPOSURE_TIME = 'Enable selection of exposure-time';
 SANE_DESC_CAL_LAMP_DEN         = 'Define lamp density for calibration';
 SANE_DESC_SCAN_LAMP_DEN        = 'Define lamp density for scan';
 SANE_DESC_SELECT_LAMP_DENSITY  = 'Enable selection of lamp density';
 SANE_DESC_LAMP_OFF_AT_EXIT     = 'Turn off lamp when program exits';
 SANE_DESC_FOCUS                = 'Focus position for manual focus';
 SANE_DESC_AUTOFOCUS            = 'Perform autofocus before scan';
 SANE_DESC_INFRARED             = 'Perform infrared scan';

 // well known options from 'SENSORS' group
 SANE_DESC_SCAN		= 'Scan button';
 SANE_DESC_EMAIL	= 'Email button';
 SANE_DESC_FAX		= 'Fax button';
 SANE_DESC_COPY		= 'Copy button';
 SANE_DESC_PDF		= 'PDF button';
 SANE_DESC_CANCEL	= 'Cancel button';
 SANE_DESC_PAGE_LOADED	= 'Page loaded';
 SANE_DESC_COVER_OPEN	= 'Cover open';

 // Typical values for stringlists (to keep the backends consistent)
 SANE_VALUE_SCAN_MODE_COLOR	      = 'Color';
 SANE_VALUE_SCAN_MODE_COLOR_LINEART   = 'Color Lineart';
 SANE_VALUE_SCAN_MODE_COLOR_HALFTONE  = 'Color Halftone';
 SANE_VALUE_SCAN_MODE_GRAY	      = 'Gray';
 SANE_VALUE_SCAN_MODE_HALFTONE        = 'Halftone';
 SANE_VALUE_SCAN_MODE_LINEART	      = 'Lineart';

implementation

end.
