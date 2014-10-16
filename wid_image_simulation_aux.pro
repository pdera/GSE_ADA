
pro generate_laue
COMMON draws,DRAWA,wid_list_3a
common datas, data, data1,oadetector,opt,oimage, ops, res, f0, f1, dir, wv, out_dir, ct, ub, pred, peaktable_file
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad
@Image_simmulation_common
  opt->zero
  widget_control, wid_text_7, get_value=en0
  widget_control, wid_text_8, get_value=en1
  widget_control, wid_text_14, get_value=DAC_open
  DAC_open=float(DAC_open)
  read_predict_settings, pred
  oadetector->generate_peaks_laue, ub, opt, pred, [float(en0),float(en1)], Bravais_type(), DAC_open
  ;widget_control, wid_text_10, set_value=string(opt->peakno(), format='(I4)')
   plot_image, oimage
   plot_peaks, drawA, opt, arr1, arr2

  ;WID_peakfit2d_L
  print_peak_list, opt, wid_list_3a
end

;-----------------------

pro generate_mono_mv
COMMON draws,DRAWA,wid_list_3a
common datas, data, data1,oadetector,opt,oimage, ops, res, f0, f1, dir, wv, out_dir, ct, ub, pred, peaktable_file
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad
COMMON WID_Image_simulation_elements
  opt->zero
  widget_control, wid_text_7, get_value=en0
  widget_control, wid_text_8, get_value=en1
  widget_control, wid_text_14, get_value=DAC_open
  DAC_open=float(DAC_open)
  read_predict_settings, pred
  oadetector->generate_all_peaks, ub, opt, wv, pred, Bravais_type(),DAC_open
  ;oadetector->generate_peaks_laue, ub, opt, pred, [float(en0),float(en1)]
  opt->remove_peaks_outside_aa, oadetector
  plot_image, oimage
  plot_peaks, drawA, opt, arr1, arr2
  print_peak_list, opt, wid_list_3a
end



