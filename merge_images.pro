pro merge_images

  name_root='T:\lvp_user\data\13-BM-D\2010\Mar10\GSECARS\D1094\Diffraction\D1094_S8\Scan8_'
  ;name_root='T:\lvp_user\data\13-BM-D\2009\Nov09\GSECARS\D1059\Diff\ambient1\D_D1059_p1_25_50_'
  ;name_root='T:\lvp_user\data\13-BM-D\2009\Nov09\GSECARS\D1059\Diff\20tons\retract1\D1059_p8_20_48_'
  ;name_root='T:\lvp_user\data\13-BM-D\2009\Nov09\GSECARS\D1059\Diff\D1060\scan_amb\D1060_amb_'
  n0=001
  n1=120
  for i=n0, n1 do $
  begin
     fname=name_root+strcompress(string(i,format='(I03)'), /remove_all)+'.tif'
     print,fname
     data=read_tiff(fname)

     if i eq n0 then mdata=data else mdata=mdata+(data)
  endfor
  ;mdata=mdata/(n1-n0)
  write_tiff, 'c:\Mar10_94scan8.tif',mdata, /long
  print, '-----------> FINISHED '

end