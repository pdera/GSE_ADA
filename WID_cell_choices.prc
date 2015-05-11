HEADER
; IDL Visual Widget Builder Resource file. Version 1
; Generated on:	05/10/2015 08:42.57
VERSION 1
END

WID_cell_choices_L BASE 5 5 536 319
TLB
CAPTION "Unit cell choices"
XPAD = 3
YPAD = 3
SPACE = 3
BEGIN
  WID_LIST_cell_choices LIST 13 18 492 206
  WIDTH = 11
  HEIGHT = 2
  END
  WID_BUTTON_unit_cell_select PUSHBUTTON 397 244 106 29
  VALUE "Select"
  ALIGNCENTER
  ONACTIVATE "Unit_cell_select"
  END
  WID_DROPLIST_symmetry DROPLIST 12 253 132 19
  NUMITEMS = 7
  ITEM "cubic"
  ITEM "hexagonal"
  ITEM "tetragonal"
  ITEM "orthorhombic"
  ITEM "monoclinic-a"
  ITEM "monoclinic-b"
  ITEM "monoclinic-c"
  END
  WID_LABEL_0 LABEL 14 231 47 19
  VALUE "Symmetry"
  ALIGNLEFT
  END
END
