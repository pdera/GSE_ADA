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
pro Unit_cell_select, Event

   common uc_selection, sel, sel1, li, dl

   sel=WIDGET_info(li, /list_select)
   sel1=WIDGET_info(li, /list_select)

   print, '---- select'
   WIDGET_CONTROL, event.top, /destroy
end
