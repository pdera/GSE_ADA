pro GSE_ADA

@COMMON_DATAS

COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask
COMMON EX, EXCLUSIONS
common mcoordinates, x, y, x1, y1, ox, oy
COMMON prof, profiles
common local_pt,pt, pn
COMMON draws,DRAWA,wid_list_3a
common status, PE_open, SIM_open
Common labels, loffset
common calib_ref, zeroref
common closing, Wid_Image_simulation

common uc_selection, sel, sel1, li, dl, lpss

COMMON Myimage,Myimg, Myadt
nop=0
;******************************* NEW CODE **********************
;Error handling
Catch, GSE_Error
if GSE_Error ne 0 then $
begin
Catch, /Cancel
;Message, 'ERROR:'
ok = Dialog_Message (!Error_State.Msg + ' Exiting code...', $
                    /Error)
RETURN
endif
;******************************* NEW CODE **********************

PE_open=0
SIM_open=0
peak_fitting
selecting_status=0
select=0
mask=0
unmask=0
zoom=0
unselect=0
addpeak=0
excl=0
EXCLUSIONS=[0,0]
UB=fltarr(3,3)
peaktable_file=''


DEVICE, DECOMPOSED = 0
  ed
  read_last_directories
  Class_adetector
  oadetector=obj_new('adetector_class')
  load_cal, 'last_calibration.cal', oadetector, wv
  ;class_peaktable
  opt=obj_new('CLASS_peaktable')
  opt1=obj_new('CLASS_peaktable')
  opt2=obj_new('CLASS_peaktable')
  WID_Image_and_arrays_L
  CLASS_adimage, oadetector, imt, arr1, arr2
  ad=oadetector->get_object()
  ad.nopixx=arr1
  ad.nopixy=arr2
  maskarr=lonarr(arr1,arr2)
  maskarr[*,*]=1
  oadetector->set_object, ad
  oimage=obj_new('adimage_CLASS')
  oimage->set_detector_format, imt
  ;oimage->resize_image, arr1,arr2
  CLASS_peaksearch
  ops=obj_new('peaksearch_CLASS')
  ;wv=0.3344

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
  WID_MAR345_ext
  WID_MAR345_L
  print_scale_poly, [0.0,0.0,0.0]
  print_calibration, oadetector, wv
  wid_sim=obj_new('WID_Image_simulation')
  wid_sim->hide

  Wid_Image_simulation=wid_sim
  wid_peditor=obj_new('WID_Peak_editor')
  wid_peditor->hide
  wid_film=obj_new('WID_profile_film_viewer')
  wid_film->hide

end