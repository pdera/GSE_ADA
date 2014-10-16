   function unpack_words, raw, nx, ny

   valids    = 0L
   spillbits = 0L
   usedbits  = 0L
   total     = long(nx) * ny;
   img       = uintarr(total)
   next      = 0L
   window    = 0L
   spill     = 0L
   pixel     = 0L
   nextint   = 0L
   bitnum    = 0L
   pixnum    = 0L
   bitdecode = [0L, 4L, 5L, 6L, 7L, 8L, 16L, 32L]
   setbits   = ['00000000'xl, '00000001'xl, '00000003'xl, '00000007'xl, $
                '0000000F'xl, '0000001F'xl, '0000003F'xl, '0000007F'xl, $
                '000000FF'xl, '000001FF'xl, '000003FF'xl, '000007FF'xl, $
                '00000FFF'xl, '00001FFF'xl, '00003FFF'xl, '00007FFF'xl, $
                '0000FFFF'xl, '0001FFFF'xl, '0003FFFF'xl, '0007FFFF'xl, $
                '000FFFFF'xl, '001FFFFF'xl, '003FFFFF'xl, '007FFFFF'xl, $
                '00FFFFFF'xl, '01FFFFFF'xl, '03FFFFFF'xl, '07FFFFFF'xl, $
                '0FFFFFFF'xl, '1FFFFFFF'xl, '3FFFFFFF'xl, '7FFFFFFF'xl, $
                'FFFFFFFF'xl]

   while (pixel lt total) do begin
      if (valids lt 6) then begin
         if (spillbits gt 0)  then begin
            window or= ishft(spill, valids)
            valids += spillbits
            spillbits = 0
         endif else begin
            spill = long(raw[next++])
            spillbits = 8
         endelse
      endif else begin
         pixnum = ishft(1, (window and setbits[3]))
         window = ishft(window, -3)
         bitnum = bitdecode[window and setbits[3]]
         window = ishft(window, -3)
         valids -= 6
         while ((pixnum gt 0) and (pixel lt total)) do begin
            if (valids lt bitnum) then begin
               if (spillbits gt 0) then begin
                  window or= ishft(spill, valids)
                  if ((32 - valids) gt spillbits) then begin
                     valids += spillbits
                     spillbits = 0L
                  endif else begin
                     usedbits = 32L - valids
                     spill = ishft(spill, -usedbits)
                     spillbits -= usedbits
                     valids = 32L
                  endelse
               endif else begin
                  spill = long(raw[next++])
                  spillbits = 8
               endelse
            endif else begin
               --pixnum
               if (bitnum eq 0) then begin
                  nextint = 0
               endif else begin
                  nextint = window and setbits[bitnum]
                  valids -= bitnum
                  window = ishft(window, -bitnum)
                  if ((nextint and (ishft(1, (bitnum - 1)))) ne 0) then $
                     nextint or= not setbits[bitnum]
               endelse
               if (pixel gt nx) then begin
                  img[pixel] = (nextint + $
                               (img[pixel-1] + img[pixel-nx+1] + $
                                img[pixel-nx] + img[pixel-nx-1] + 2) / 4)
                  ++pixel
               endif else if (pixel ne 0) then begin
                  img[pixel] = img[pixel-1] + nextint
                  ++pixel
               endif else begin
                  img[pixel++] = nextint
               endelse
            endelse
         endwhile
      endelse
   endwhile
   return, img
end


pro read_mar345, file, data, header

;+
; NAME:
;   READ_MAR345
;
; PURPOSE:
;   This procedures reads a MAR 345 image plate file.
;
; CATEGORY:
;   Detectors.
;
; CALLING SEQUENCE:
;   READ_MAR345, File, Data, Header
;
; INPUTS:
;   File:
;       The name of the MAR345 input file.
;
; OUTPUTS:
;   Data:
;       The 2-D array of intensities.  This is a 16-bit UINT array if the data
;       does not contain any high pixels (>65535) , and LONG if the data does contain
;       any high pixels.
;
;   Header:
;       A structure which contains the header information.
;       The names of the fields in this structure are meant to be
;       self-explanatory.
;
; OPERATION:
;   This routine uses IDL to read the header information and the table
;   of high pixel values (if present).
;
;   It can also use IDL to read and decompress the data, but this is quite slow,
;   about 90 seconds for a 3450x3450 image.
;
;   To improve performance there is a C code function provided that can read the files
;   and decompress them much faster, about 2 seconds for a 3450x3450 image.
;   This C code is built into a shareable object or DLL which is called from IDL.
;   Prebuilt shareable libraries are provided for Linux (mar345_IDL.so) and
;   Windows (mar345_IDL.dll). The source code (mar345_IDL.c) and Makefile for Linux and Unix,
;   and a .bat file to build on Windows are also provided in this directory.
;   The required support files, mar3xx_pck.c and mar3xx_pck.h are also provided.
;
;   At run time this IDL routine will see if there is an environment variable
;   called MAR345_IDL.  If it exists, it is assumed to be the complete path specification
;   to a shareable library. If the environment variable does not exist or does not
;   point to a valid file, then the routine will search the IDL_PATH for mar345_IDL.dll
;   (on Windows) or mar345_IDL.so (all other operating systems).  If the shareable
;   object is found then read_mar345.pro will call that shareable library to read and
;   decompress the file.  If the shareable object is not found then the built-in IDL
;   code will be used instead, which is quite slow.
;
; EXAMPLE:
;   READ_MAR345, 'Myfile.mar345', data, header
;
; MODIFICATION HISTORY:
;   Written by:     Mark Rivers, 2006
;   Modifications:
;-

   common read_mar345_common, mar345_IDL_object

   openr, lun, file, /get
   head = lonarr(16)
   readu, lun, head
   if (head[0] eq 1234) then swap=0 else swap=1
   if (swap) then head = swap_endian(head)
   temp = bytarr(64, 63)
   text = strarr(63)
   readu, lun, temp
   for i=0, 62 do begin
      ; Replace linefeeds with blanks
      for j=0, 63 do begin
         if (temp[j,i] eq 10) then temp[j,i]=32
      endfor
      text[i] = strtrim(string(temp[*,i]),2)
   endfor
   header = {mar345, $
             nx:              head[1], $
             ny:              head[1], $
             nhigh:           head[2], $
             format:          head[3], $
             collection_mode: head[4], $
             npixels:         head[5], $
             x_pixel_size:    head[6]/1000., $
             y_pixel_size:    head[7]/1000., $
             wavelength:      head[8]/1.e6, $
             distance:        head[9]/1000., $
             phi_start:       head[10]/1000., $
             phi_end:         head[11]/1000., $
             omega_start:     head[12]/1000., $
             omega_end:       head[13]/1000., $
             chi:             head[14]/1000., $
             two_theta:       head[15]/1000., $
             text_lines:      text }

   ; Read the high-intensity pixel table
   if (header.nhigh gt 0) then begin
      table_entries = long(header.nhigh/8.0 + .9) * 8
      records = lonarr(2, table_entries)
      readu, lun, records
      high_offsets = reform(records[0, 0:header.nhigh-1])
      high_values  = reform(records[1, 0:header.nhigh-1])
   endif

   ; The next data in the file should be the CBF header, which is 37 characters
   ; \nCCP4 packed image, X: %04d, Y: %04d\n
   temp = bytarr(37)
   readu, lun, temp
   if (string(temp[1:4]) ne "CCP4") then begin
      print, "Error, did not find CCP4 header where expected"
      return
   endif
   ; We have 2 ways to get the data from the file
   ; 1) Use the shareable library defined by environment variable MAR345_IDL if it exists
   ;    or searching for the shareable object in IDL_PATH
   ; 2) Use the unpack_words IDL routine above, which is much slower
   if (n_elements(mar345_IDL_object) eq 0) then begin
      ; See if the environment variable exists and points to a valid file
      object = getenv("MAR345_IDL")
      if (object ne "") then begin
         ; Make sure the file exists
         f = findfile(object)
         if (f ne '') then mar345_IDL_object = object
      endif
      ; If environment variable did not exist try looking for file directly

      if (n_elements(mar345_IDL_object) eq 0) then begin
         if (!version.os_family eq 'Windows') then begin
            object = file_which('mar345_IDL.dll')
         endif else begin
            object = file_which('mar345_IDL.so')
         endelse
         if (object ne '') then mar345_IDL_object = object
      endif
   endif
   if (n_elements(mar345_IDL_object) ne 0) then begin
      data = uintarr(header.nx*header.ny, /nozero)
      temp_file = [byte(file),0B]
      status = call_external(mar345_IDL_object, 'mar345_IDL', temp_file, data)
   endif else $
    begin
      ; Figure out how much data to read from file
      fs = fstat(lun)
      nread = fs.size - fs.cur_ptr
      raw = bytarr(nread)
      readu, lun, raw
      data = unpack_words(raw, header.nx, header.ny)
    endelse
    free_lun, lun

    ; If there were any high pixels convert data to long and replace them
    if (header.nhigh gt 0) then begin
       data = long(data)
       for i=0L, header.nhigh-1 do begin
          data[high_offsets[i]] = high_values[i]
       endfor
    endif

    ; Reform array to 2-D inplace
    data = reform(data, header.nx, header.ny, /overwrite)
end

