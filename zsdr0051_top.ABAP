*&---------------------------------------------------------------------*
*&  Include           ZSDR0051_TOP
*&---------------------------------------------------------------------*

TABLES:
  knvv,
  oiisocikn.

*----------------------------------------------------------------------*
* Types
*----------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_outtab,
    kunnr      TYPE knvv-kunnr,
    vwerk      TYPE knvv-vwerk,
    vkorg      TYPE knvv-vkorg,
    vtweg      TYPE knvv-vtweg,
    spart      TYPE knvv-spart,
    socnr      TYPE oiisocikn-socnr,
    gaugedat   TYPE /ico/mo_pr_cfth-gaugedat,
    vbeln      TYPE /ico/mo_pr_cfth-vbeln,
    gauge_qty  TYPE /ico/mo_pr_cfth-gauge_qty,
    gauge_pct7 TYPE /ico/mo_pr_cfth-gauge_pct,
    gauge_pct1 TYPE /ico/mo_pr_cfth-gauge_pct,
  END OF ty_outtab.

*----------------------------------------------------------------------*
* Internal Tables
*----------------------------------------------------------------------*
DATA:
  gt_knvv            TYPE TABLE OF knvv,
  gt_oiisocikn       TYPE TABLE OF oiisocikn,
  gt_/ico/mo_pr_cfth TYPE TABLE OF /ico/mo_pr_cfth,
  gt_oiisock         TYPE TABLE OF oiisock,

  gt_outtab          TYPE TABLE OF ty_outtab,
  gt_fieldcat        TYPE slis_t_fieldcat_alv WITH HEADER LINE.

*----------------------------------------------------------------------*
* Structures
*----------------------------------------------------------------------*
DATA:
  gs_knvv            TYPE knvv,
  gs_oiisocikn       TYPE oiisocikn,
  gs_/ico/mo_pr_cfth TYPE /ico/mo_pr_cfth,
  gs_oiisock         TYPE oiisock,

  gs_outtab          TYPE ty_outtab.