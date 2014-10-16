
; Set of routined that deal with file names and disk operations

;----------------------------------------

; Modification history

; 8/25/08 PD
;    added test_write
;    added comments

;----------------------------------------
; List of routines defined within this file

; function test_write, dir
; function generate_fname, res
; function find_series_start, res
; function find_series_end, res
; function analyse_fname, st, dir, extno

;----------------------------------------
;----------------------------------------

function test_write, dir
 fn=dir+'xxxx.tst'
 openw, 3, fn, error=err
 close, 3
 if err eq 0 then $
 begin
   file_delete, fn
   return, 1
 end else return, 0
end
;----------------------------------------

function generate_fname, res
case res.extno of
1:r='(I01)'
2:r='(I02)'
3:r='(I03)'
4:r='(I04)'
5:r='(I05)'
else: r='(I03)'
endcase
 return,res.base+string(res.seq,format=r)+res.ext
end
;----------------------------------------

function find_series_start, res
; set res.seq to appropriate value before calling this function
   found=1
   res1=res
   while res1.seq ge 0 and found eq 1 do $
   begin
   if res1.seq ge 1 then $
   begin
    res1.seq=res1.seq-1
    fn1=generate_fname(res1)
    r=file_info(fn1)
    if r.exists eq 1 then found=1 else found=0
   endif else found=0
   endwhile
   if found eq 0 then return,res1.seq+1 else return,res1.seq
end
;--------------------------------------
function find_series_end, res
   found=1
   res1=res
   while found eq 1 do $
   begin
   if res1.seq ge 1 then $
   begin
    res1.seq=res1.seq+1
    fn1=generate_fname(res1)
    r=file_info(fn1)
    if r.exists eq 1 then found=1 else found=0
   endif else found=0
   endwhile
   if found eq 0 then return,res1.seq-1 else return,res1.seq
end

;------------------------------------------

function analyse_fname, st, dir, extno
; Input:
;    st    - name of the file, including directory
;    dir   - name of the directory, as obtained by path in dialog_pickfile
;    extno - number of digits in the extension
;
; Assumes that the sequence number is the last extno characters before the extension,
; e.g. name001.tiff with extno=3

   res={base:'',seq:0L,ext:'',path:'',base0:'',extno:0, name0:''}
  po1=strpos(st,'.',/reverse_search)
  po2=strlen(dir)
  ln=strlen(st)

  ext=strmid(st, po1,ln-po1) ; extension from the last fullstop to the end
  path=dir
  seq=strmid(st, po1-extno,extno)
  seq=Long(seq)
  base=strmid(st, 0,po1-extno) ; includes directory
  base0=strmid(st, po2, strlen(base)-strlen(path)) ; excludes directory
  name0=strmid(st, po2,ln-po2)
  res.extno=extno
  res.base=base
  res.base0=base0
  res.path=path
  res.seq=seq
  res.ext=ext
  res.name0=name0
  return, res
end

;------------------------------------------

pro filenames
end