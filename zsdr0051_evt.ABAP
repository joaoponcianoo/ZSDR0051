*&---------------------------------------------------------------------*
*&  Include           ZSDR0051_EVT
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  PERFORM f_get_data.

  PERFORM f_outtab.

END-OF-SELECTION.

  IF gt_outtab IS NOT INITIAL.
    PERFORM f_show_alv.
  ELSE.
    MESSAGE text-002 TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.