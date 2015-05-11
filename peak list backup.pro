'peak list':$
begin

;----------------- read intentisy scale
 if current_vs_series() eq 0 then $ ;-------------- intensity from series
 begin
   widget_control, wid_text_24, get_value=imax
   widget_control, wid_text_25, get_value=imin
   imax=long(imax)
   imin=long(imin)
   imax=imax[0]
   imin=imin[0]

 pn=read_peak_selected(wid_list_3)
 if pn ge 0 and pn lt opt->peakno() then $
 begin
   pt=opt->get_object()
   widget_control, wid_text_37, SET_VALUE=strcompress(string(long(pt.peaks[pn].intssd[0])),/remove_all) ; display peak box size
   opt->unselect_all
   opt->select_peak, pn
   plot_peaks, draw0, opt, arr1, arr2
   bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
   lbcgr=oimage->calculate_local_background(0)

rep=0
rraa:
   ;re=fit_one_peak_PD(pn,lbcgr)
  ; re=fit_one_peak_PD(pn,lbcgr)

   pt=opt->get_object()
   XY=pt.peaks[pn].detxy
   pic=oimage->get_zoomin(XY, bs, maskarr)

   a=symmetric_corrlation(pic)

  ; pic=reform(cumInt[pn,20-bs[0]:20+bs[0],20-bs[1]:20+bs[1]])
   pic=reform(cumInt[pn,*,*])
   pic1=pic[20-bs[0]:20+bs[0],20-bs[1]:20+bs[1]]
 ;   print, 'MAX=', max(pic)
 ;   print, 'MEDIAN=', median(pic)

   re=fit_one_peak_PD_from_Pic(pn, pic)
   n=n_elements(re)-1
   if re[0] eq 0 then A=re[1:n/2]



   goto, no_circle

   ;---- if part of the box area is outside active circle, replace 0 with local background ------
   cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
   c=where(cc eq 1)
   if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))
   ;---------------------------------------------------------------------------------------------
   no_circle:
   pic1a=congrid(pic1, 210, 210)

  ;----- plot image zoom

    wset, wid_draw_1
    device, decomposed=0
    a0=pic1a<imax
    a1=a0>imin
    tvscl, a1, true=0

  ;----------------------

   if re[0] eq 0 then $
   begin
    XX=Xinvec([bs[0]*2+1,bs[1]*2+1])
    yy=yinvec([bs[0]*2+1,bs[1]*2+1])
    p2=long(one2two(profile_function(XX, YY, A)))
    pic2=congrid(p2, 210,210)
    p3=pic1-p2
    pic3=congrid(p3, 210,210)
    xy=pt.peaks[pn].detxy

    a=evaluate_fit_quality(pic1, p2)
    print, 'fit quality', a[0], a[1]
  ;------ profile optimization temporarily disabled
  ;  pw=determine_optimal_profile(pic, p2, 5)
  ;  bs=[pw,pw]
    if rep eq 0 then $
    begin
      rep=1
;      goto, rr
    endif

;    wset, wid_draw_1
;    device, decomposed=0
 ;   a=pic1<100
;    a1=pic1>median(pic1)
;    tv, a1
    wset, wid_draw_2
    a1=pic2<imax
    a2=a1>imin
    tvscl, a2, true=0

    wset, wid_draw_5
    a1=pic3<imax
    a2=a1>imin
    tvscl, a2, true=0

    if PE_open eq 1 then $ ;--- Peak Editor only
    begin
       display_peak, pn, pt
       plot_peak, pn, pt, oimage
    endif

  endif else $
  begin
    wset, wid_draw_1
    tvscl, pic1
   ; wset, wid_draw_2
   ; tvscl, pic2
   ; wset, wid_draw_5
   ; tvscl, pic3
  endelse
 endif
 endif else $

begin ;----------- individual image ----------------------

 pn=read_peak_selected(wid_list_3)
 if pn ge 0 and pn lt opt->peakno() then $
 begin

   pt=opt->get_object()
   widget_control, wid_text_37, SET_VALUE=strcompress(string(long(pt.peaks[pn].intssd[0])),/remove_all) ; display peak box size
   opt->unselect_all
   opt->select_peak, pn
   plot_peaks, draw0, opt, arr1, arr2
   bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
   lbcgr=oimage->calculate_local_background(0)
rep=0


rr:

   pic9=one_peak_get_profile(pn)

   re=fit_one_peak_PD(pn,lbcgr)
   n=n_elements(re)-1
   if re[0] eq 0 then A=re[1:n/2]

   pt=opt->get_object()
   XY=pt.peaks[pn].detxy
   pic=oimage->get_zoomin(XY, bs, maskarr)

   ;aaa=find_overlap(pic)
  ; aaa=center_intensity(pic)
   if do_symmetric_correlation() then $
   pic=symmetric_corrlation(pic)


   ;c=simple_sum(pic)
   ;c=simple_sum_locate_peak(pic)
   c=twoDfit_mpfit(pic, 0)
   ;---- if part of the box area is outside active circle, replace 0 with local background ------
   if exclude_corners() then $
   begin
     cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
     c=where(cc eq 1)
     if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))
   endif
   ;---------------------------------------------------------------------------------------------

   pic1=congrid(pic, 210, 210)

   if re[0] eq 0 then $
   begin
    XX=Xinvec([bs[0]*2+1,bs[1]*2+1])
    yy=yinvec([bs[0]*2+1,bs[1]*2+1])
    p2=long(one2two(profile_function(XX, YY, A)))
    pic2=congrid(p2, 210,210)
    p3=pic-p2
    pic3=pic1-pic2
    xy=pt.peaks[pn].detxy

    a=evaluate_fit_quality(pic, p2)
    print, 'fit quality', a[0], a[1]
    pw=determine_optimal_profile(pic, p2, 5)
    bs=[pw,pw]
    if rep eq 0 then $
    begin
      rep=1
;      goto, rr
    endif


   widget_control, wid_text_24, get_value=imax
   widget_control, wid_text_25, get_value=imin
   imax=long(imax)
   imin=long(imin)
   imax=imax[0]
   imin=imin[0]


    wset, wid_draw_1
	a1=pic1<imax
	a2=a1>imin
    tvscl, a2
    wset, wid_draw_2
	a1=pic2<imax
	a2=a1>imin
    tvscl, a2
    wset, wid_draw_5
	a1=pic3<imax
	a2=a1>imin
    tvscl, a2

    if PE_open eq 1 then $ ;--- Peak Editor only
    begin
       display_peak, pn, pt
       plot_peak, pn, pt, oimage
    endif

  endif else $
  begin
    wset, wid_draw_1
    tvscl, pic1
   ; wset, wid_draw_2
   ; tvscl, pic2
   ; wset, wid_draw_5
   ; tvscl, pic3
  endelse
 endif

 endelse
 end