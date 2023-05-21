*&---------------------------------------------------------------------*
*&  Include           ZSDR0051_FRM
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
FORM f_get_data.

  SELECT *
    FROM knvv
    INTO TABLE gt_knvv
   WHERE kunnr IN s_kunnr
     AND vwerk IN s_vwerk
     AND vkorg IN s_vkorg
     AND spart IN s_spart
     AND vtweg IN s_vtweg.

  IF sy-subrc EQ 0.

    SELECT *
      FROM oiisocikn
      INTO TABLE gt_oiisocikn
   FOR ALL ENTRIES IN gt_knvv
     WHERE kunnr EQ gt_knvv-kunnr
       AND socnr        IN s_socnr
       AND /ico/vari_id IN s_id
       AND zzblock_from IN s_from
       AND zzblock_to   IN s_to.

    IF sy-subrc EQ 0.

      SELECT *
        FROM /ico/mo_pr_cfth
        INTO TABLE gt_/ico/mo_pr_cfth
     FOR ALL ENTRIES IN gt_oiisocikn
       WHERE socnr EQ gt_oiisocikn-socnr
         AND ( gaugetype EQ '7' OR gaugetype EQ '1' ).

      IF sy-subrc EQ 0.

        SELECT *
          FROM oiisock
          INTO TABLE gt_oiisock
       FOR ALL ENTRIES IN gt_/ico/mo_pr_cfth
         WHERE socnr EQ gt_/ico/mo_pr_cfth-socnr.

      ENDIF.
    ENDIF.
  ENDIF.

  SORT gt_knvv.
  SORT gt_oiisocikn BY kunnr.
  SORT gt_/ico/mo_pr_cfth BY socnr gaugetype ASCENDING
                                    gaugedat DESCENDING.
  SORT gt_oiisock BY socnr.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_OUTTAB
*&---------------------------------------------------------------------*
FORM f_outtab.

  LOOP AT gt_oiisocikn INTO gs_oiisocikn.

    READ TABLE gt_knvv INTO gs_knvv
                        WITH KEY kunnr = gs_oiisocikn-kunnr BINARY SEARCH.
    IF sy-subrc EQ 0.

      READ TABLE gt_/ico/mo_pr_cfth INTO gs_/ico/mo_pr_cfth
                                WITH KEY socnr     = gs_oiisocikn-socnr
                                         gaugetype = '7' BINARY SEARCH.
      IF sy-subrc EQ 0.

        READ TABLE gt_oiisock INTO gs_oiisock
                          WITH KEY socnr = gs_/ico/mo_pr_cfth-socnr BINARY SEARCH.
        IF sy-subrc EQ 0.

          gs_outtab-kunnr      = gs_knvv-kunnr.
          gs_outtab-vwerk      = gs_knvv-vwerk.
          gs_outtab-vkorg      = gs_knvv-vkorg.
          gs_outtab-vtweg      = gs_knvv-vtweg.
          gs_outtab-spart      = gs_knvv-spart.
          gs_outtab-socnr      = gs_oiisocikn-socnr.
          gs_outtab-gaugedat   = gs_/ico/mo_pr_cfth-gaugedat.
          gs_outtab-vbeln      = gs_/ico/mo_pr_cfth-vbeln.
          gs_outtab-gauge_qty  = gs_/ico/mo_pr_cfth-gauge_qty.
          gs_outtab-gauge_pct7 = gs_/ico/mo_pr_cfth-gauge_qty / gs_oiisock-kapaz * 100. "GAUGETYPE = 7

          READ TABLE gt_/ico/mo_pr_cfth INTO gs_/ico/mo_pr_cfth
                                    WITH KEY socnr     = gs_oiisocikn-socnr
                                             gaugetype = '1' BINARY SEARCH.
          IF sy-subrc EQ 0.
            gs_outtab-gauge_pct1 = gs_/ico/mo_pr_cfth-gauge_qty / gs_oiisock-kapaz * 100. "GAUGETYPE = 1
          ENDIF.

          APPEND gs_outtab TO gt_outtab.
          CLEAR gs_outtab.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.

  SORT gt_outtab.
  DELETE ADJACENT DUPLICATES FROM gt_outtab.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SHOW_ALV
*&---------------------------------------------------------------------*
FORM f_show_alv.

  DATA: ls_layout TYPE slis_layout_alv.

  ls_layout-colwidth_optimize = 'X'.
  ls_layout-zebra = 'X'.

  PERFORM f_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'F_TOP_OF_PAGE'
      "i_callback_user_command = 'z_user_command'
      it_fieldcat            = gt_fieldcat[]
      i_save                 = 'X'
      is_layout              = ls_layout
*     is_variant             = g_variant
    TABLES
      t_outtab               = gt_outtab[]
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_FIELDCAT
*&---------------------------------------------------------------------*
FORM f_fieldcat.

  REFRESH gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'KUNNR'.
  gt_fieldcat-seltext_l   = 'Cliente'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'VWERK'.
  gt_fieldcat-seltext_l   = 'Centro Fornecedor'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'VKORG'.
  gt_fieldcat-seltext_l   = 'Organização Vendas'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'VTWEG'.
  gt_fieldcat-seltext_l   = 'Canal Distribuição'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'SPART'.
  gt_fieldcat-seltext_l   = 'Setor Atividade'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'SOCNR'.
  gt_fieldcat-seltext_l   = 'Nº COASEG'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'GAUGEDAT'.
  gt_fieldcat-seltext_l   = 'Data'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'VBELN'.
  gt_fieldcat-seltext_l   = 'Nº Documento'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'GAUGE_QTY'.
  gt_fieldcat-seltext_l   = 'Estoque'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'GAUGE_PCT7'.
  gt_fieldcat-seltext_l   = '% Entregue'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

  CLEAR gt_fieldcat.
  gt_fieldcat-fieldname   = 'GAUGE_PCT1'.
  gt_fieldcat-seltext_l   = '% Final'.
  "gt_fieldcat-outputlen   = 50.
  APPEND gt_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_TOP_OF_PAGE
*&---------------------------------------------------------------------*
FORM f_top_of_page.

*alv header declarations
  DATA: lt_header           TYPE slis_t_listheader,
        ls_header           TYPE slis_listheader,
        lv_lines_number     TYPE i,
        lv_lines_number_str TYPE string.

  CLEAR: lv_lines_number,
         lv_lines_number_str.

  DESCRIBE TABLE gt_outtab LINES lv_lines_number.
  lv_lines_number_str = lv_lines_number.

* Title
  CLEAR ls_header.
  ls_header-typ  = 'H'.
  ls_header-info = 'Relatório Entrega de Produto ao Cliente'.
  APPEND ls_header TO lt_header.


* Date
  CLEAR ls_header.
  ls_header-typ  = 'S'.
  ls_header-key = 'Data: '.
  CONCATENATE  sy-datum+6(2) '/'
               sy-datum+4(2) '/'
               sy-datum(4)
     INTO ls_header-info.   "todays date
  APPEND ls_header TO lt_header.

* Hour
  CLEAR ls_header.
  ls_header-typ  = 'S'.
  ls_header-key = 'Hora: '.
  CONCATENATE  sy-uzeit(2) ':'
               sy-uzeit+2(2) ':'
               sy-uzeit+4(2)
    INTO ls_header-info.   "todays hour
  APPEND ls_header TO lt_header.

*Line number
  CLEAR ls_header.
  ls_header-typ  = 'S'.
  ls_header-key = 'N°. de registros: '.
  CONCATENATE  lv_lines_number_str ''
    INTO ls_header-info.   "Internal table line number
  APPEND ls_header TO lt_header.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.

ENDFORM.
