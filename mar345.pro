pro MAR345
common datas, data, data1,oadetector,opt,oimage, ops, res, f0, f1, dir, wv, out_dir, ct, ub, pred, peaktable_file
COMMON image_type_and_arrays, imt, arr1, arr2
common selections, selecting_status, select, excl
COMMON EX, EXCLUSIONS
common mcoordinates, x, y, x1, y1, ox, oy
selecting_status=0
select=0
excl=0
EXCLUSIONS=[0,0]
UB=fltarr(3,3)
peaktable_file=''

DEVICE, DECOMPOSED = 0
  Class_adetector
  oadetector=obj_new('adetector_class')
  load_cal, 'last_calibration.cal', oadetector, wv
  class_peaktable
  opt=obj_new('CLASS_peaktable')
  WID_Image_and_arrays_L
  CLASS_adimage, oadetector, imt, arr1, arr2
  ad=oadetector->get_object()
  ad.nopixx=arr1
  ad.nopixy=arr2
  oadetector->set_object, ad
  oimage=obj_new('adimage_CLASS')
  oimage->set_detector_format, imt
  ;oimage->resize_image, arr1,arr2
  CLASS_peaksearch
  ops=obj_new('peaksearch_CLASS')
  ;wv=0.3344
  dir=''
  out_dir=''

pred={  om_start : 0.0, $
        om_range : 0.0, $
        chi       : 0.0, $
        d         : 0.0, $
        h1        : 0, $
        h2        : 0, $
        k1        : 0, $
        k2        : 0, $
        l1        : 0, $
        l2        : 0}

  re=file_info('colors.ct')
  if re.exists then $
  begin
   print, 'Reading last color table'
   free_lun, 2
   TVLCT, V1, V2, V3, /GET
   openr, 2, 'colors.ct'
   readf, 2 , V1
   readf, 2 , V2
   readf, 2 , V3
   TVLCT, V1, V2, V3
   close, 2
   free_lun, 2
  end

  WID_MAR345_L
  print_calibration, oadetector, wv

end