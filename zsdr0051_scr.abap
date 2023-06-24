*&---------------------------------------------------------------------*
*&  Include           ZSDR0051_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECTION-SCREEN SKIP.

SELECT-OPTIONS:
  s_kunnr  FOR knvv-kunnr OBLIGATORY,            "Cliente
  s_vwerk  FOR knvv-vwerk,                       "Centro Fornecedor
  s_vkorg  FOR knvv-vkorg,                       "Organização de Vendas
  s_spart  FOR knvv-spart,                       "Setor de Atividade
  s_vtweg  FOR knvv-vtweg,                       "Canal Distribuição

  s_socnr  for oiisocikn-socnr,                  "N° COASEG
  s_id     FOR oiisocikn-/ico/vari_id,           "Grp.do Val. Proposto
  s_from   FOR oiisocikn-zzblock_from,           "Bloq. de
  s_to     FOR oiisocikn-zzblock_to.             "Bloq. até

SELECTION-SCREEN END OF BLOCK b1.