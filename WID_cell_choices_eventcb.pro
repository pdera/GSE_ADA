;
; IDL Event Callback Procedures
; WID_cell_choices_eventcb
;
; Generated on:	05/09/2015 20:56.40
;
;
; Empty stub procedure used for autoloading.
;
pro WID_cell_choices_eventcb
end
;-----------------------------------------------------------------
; Activate Button Callback Procedure.
; Argument:
;   Event structure:
;
;   {WIDGET_BUTTON, ID:0L, TOP:0L, HANDLER:0L, SELECT:0}
;
;   ID is the widget ID of the component generating the event. TOP is
;       the widget ID of the top level widget containing ID. HANDLER
;       contains the widget ID of the widget associated with the
;       handler routine.

;   SELECT is set to 1 if the button was set, and 0 if released.
;       Normal buttons do not generate events when released, so
;       SELECT will always be 1. However, toggle buttons (created by
;       parenting a button to an exclusive or non-exclusive base)
;       return separate events for the set and release actions.

;   Retrieve the IDs of other widgets in the widget hierarchy using
;       id=widget_info(Event.top, FIND_BY_UNAME=name)

;-----------------------------------------------------------------


;-----------------------------------------------------------------

pro Unit_cell_select, Event

   common uc_selection, sel, sel1, li, dl, lpss

   sel=WIDGET_info(li, /list_select)
   sel1=WIDGET_info(dl, /droplist_select)
   if sel eq -1 then $
   begin
      re=dialog_message('You have to select one of the solutions')
   endif else $
   begin
     WIDGET_CONTROL, event.top, /destroy
   endelse
end

pro list_choice, Event
common uc_selection, sel, sel1, li, dl, lpss
   list=Widget_Info(event.top, FIND_BY_UNAME='WID_LIST_cell_choices')
   re=widget_info(list, /list_select)
   b=recognize_crystal_system_from_lp(lpss[0:5, re], 0.01, 1.0)
   drop=Widget_Info(event.top, FIND_BY_UNAME='WID_DROPLIST_symmetry')
   widget_control, drop, set_droplist_select=b
   print, 'list chocie', b
end
