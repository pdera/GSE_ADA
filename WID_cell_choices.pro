;
; IDL Widget Interface Procedures. This Code is automatically
;     generated and should not be modified.

;
; Generated on:	05/10/2015 08:43.02
;
pro WID_cell_choices_L_event, Event

  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
      widget_info(Event.id, /tree_root) : event.id)


  wWidget =  Event.top

  case wTarget of

    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_unit_cell_select'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Unit_cell_select, Event
    end
    else:
  endcase

end

pro WID_cell_choices, lps, v, l;, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

   common uc_selection, sel, sel1, li, dl

  Resolve_Routine, 'WID_cell_choices_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

  WID_cell_choices_L = Widget_Base( GROUP_LEADER=wGroup,  $
      UNAME='WID_cell_choices_L' ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=536  $
      ,SCR_YSIZE=319 ,TITLE='Unit cell choices' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)


  WID_LIST_cell_choices = Widget_List(WID_cell_choices_L,  $
      UNAME='WID_LIST_cell_choices' ,XOFFSET=13 ,YOFFSET=18  $
      ,SCR_XSIZE=492 ,SCR_YSIZE=206 ,XSIZE=11 ,YSIZE=2)


  WID_BUTTON_unit_cell_select = Widget_Button(WID_cell_choices_L,  $
      UNAME='WID_BUTTON_unit_cell_select' ,XOFFSET=397 ,YOFFSET=244  $
      ,SCR_XSIZE=106 ,SCR_YSIZE=29 ,/ALIGN_CENTER ,VALUE='Select')


  WID_DROPLIST_symmetry = Widget_Droplist(WID_cell_choices_L,  $
      UNAME='WID_DROPLIST_symmetry' ,XOFFSET=12 ,YOFFSET=253  $
      ,SCR_XSIZE=132 ,SCR_YSIZE=19 ,VALUE=[ 'cubic', 'hexagonal',  $
      'tetragonal', 'orthorhombic', 'monoclinic-a', 'monoclinic-b',  $
      'monoclinic-c' ])


  WID_LABEL_0 = Widget_Label(WID_cell_choices_L, UNAME='WID_LABEL_0'  $
      ,XOFFSET=14 ,YOFFSET=231 ,SCR_XSIZE=47 ,SCR_YSIZE=19  $
      ,/ALIGN_LEFT ,VALUE='Symmetry')

  Widget_Control, /REALIZE, WID_cell_choices_L

  li=WID_LIST_cell_choices
  dl=WID_DROPLIST_symmetry

  st=''
  for j=0,5 do st=st+string(lps[j,0], format='(F10.4)')
  list=st+string(V[0],format='(F12.2)')+l[0]
  for i=0, n_elements(lps)/6-1 do $
  begin
    st=''
    for j=0,5 do st=st+string(lps[j,i], format='(F10.4)')
    list=[list, st+string(V[0],format='(F12.2)')+l[i]]
  endfor

  Widget_Control, WID_LIST_cell_choices, set_value=string(list)

  XManager, 'WID_cell_choices_L', WID_cell_choices_L;, /NO_BLOCK

end

