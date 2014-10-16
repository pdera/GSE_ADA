; P.Dera, 03/07/2005


pro CLASS_Area_detector_parameters

COMMON CLASS_Area_detector_parameters_reference, ref_adp

 ref_adp={area_detector_parameters_CLASS, $
        adp_distance   : 0.0,$ ; distance in mm
        adp_nopixx     : 0L, $ ; number of pixels horiz.
        adp_nopixy     : 0L, $ ; number of pixels vert.
        adp_pixsizex   : 0.0,$ ; pixel size horiz.
        adp_pixsizey   : 0.0,$ ; pixel size vertical
        adp_beamx      : 0.0,$ ; beam center horizontal
        adp_beamy      : 0.0,$ ; beam center vertical
        adp_tilt1      : 0.0,$ ; tilt omega
        adp_tilt2      : 0.0,$ ; tilt chi
        adp_inversionX : 0,  $ ; inversion horizontal
        adp_inversionY : 0  $ ; inversion vertical
        }
end

;------------------------------
pro area_detector_parameters_CLASS::get_object_adp,ref_adp

        ref_adp.adp_distance   = self.adp_distance
        ref_adp.adp_nopixx     = self.adp_nopixx
        ref_adp.adp_nopixy     = self.adp_nopixy
        ref_adp.adp_pixsizex   = self.adp_pixsizex
        ref_adp.adp_pixsizey   = self.adp_pixsizey
        ref_adp.adp_beamx      = self.adp_beamx
        ref_adp.adp_beamy      = self.adp_beamy
        ref_adp.adp_tilt1      = self.adp_tilt1
        ref_adp.adp_tilt2      = self.adp_tilt2
        ref_adp.adp_inversionX = self.adp_inversionX
        ref_adp.adp_inversionY = self.adp_inversionY

end

;------------------------------
;------------------------------
pro area_detector_parameters_CLASS::set_object_adp, ref_adp

        self.adp_distance   = ref_adp.adp_distance
        self.adp_nopixx     = ref_adp.adp_nopixx
        self.adp_nopixy     = ref_adp.adp_nopixy
        self.adp_pixsizex   = ref_adp.adp_pixsizex
        self.adp_pixsizey   = ref_adp.adp_pixsizey
        self.adp_beamx      = ref_adp.adp_beamx
        self.adp_beamy      = ref_adp.adp_beamy
        self.adp_tilt1      = ref_adp.adp_tilt1
        self.adp_tilt2      = ref_adp.adp_tilt2
        self.adp_inversionX = ref_adp.adp_inversionX
        self.adp_inversionY = ref_adp.adp_inversionY

end

;------------------------------

;------------------------------------------------------

pro area_detector_parameters_CLASS::write_adp, filename

COMMON CLASS_Area_detector_parameters_reference, ref_adp

 ref_adp=self->get_object()

 free_lun, 3
 OPENW, 3, filename
 writeu,3,  ref_adp
 CLOSE, 3
 free_lun, 3

end

;------------------------------------------------------
pro area_detector_parameters_CLASS::read_adp, filename

COMMON CLASS_Area_detector_parameters_reference, ref_adp


 free_lun, 3
 OPENR, 3, filename
 readu,3,  ref_adp
 CLOSE, 3
 free_lun, 3

 self->set_object, ref_adp

end

;------------------------------------------------------
