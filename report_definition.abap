CLASS lcl_main_report DEFINITION.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF mty_s_header_data,
        bukrs TYPE bukrs,
        waers TYPE waers,
        bldat TYPE bldat,
        budat TYPE budat,
        bktxt TYPE bktxt,
        blart TYPE blart,
        xblnr TYPE xblnr1,
      END OF mty_s_header_data,

      BEGIN OF mty_s_item_data,
        zfbdt TYPE dzfbdt,
        newbs TYPE newbs,
        hkont TYPE hkont,
        wrtbr TYPE wrbtr,
        zuonr TYPE dzuonr,
        sgtxt TYPE sgtxt,
        prctr TYPE prctr,
        buzei TYPE buzei,
      END OF mty_s_item_data,

      BEGIN OF mty_s_documents,
        bukrs TYPE bukrs,
        koart TYPE koart,
        agums TYPE agums,
        hkont TYPE hkont,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        buzei TYPE buzei,
      END OF mty_s_documents .

    TYPES: mty_t_documents TYPE TABLE OF mty_s_documents WITH DEFAULT KEY,
           mty_t_item_data TYPE TABLE OF mty_s_item_data WITH DEFAULT KEY.

    TYPES:
      BEGIN OF mty_s_selecao,
        belnr      TYPE bsis_view-belnr,
        buzei      TYPE bsis_view-buzei,
        gjahr      TYPE bsis_view-gjahr,
        sgtxt      TYPE bsis_view-sgtxt,
        prctr      TYPE bsis_view-prctr,
        dmbtr      TYPE bsis_view-dmbtr,
        hkont_orig TYPE bsis_view-hkont,
        hkont_dest TYPE zsdt041-hkont,
        selvon     TYPE selxx_f05a,
      END OF mty_s_selecao.


    DATA: mt_ftpost      TYPE feb_t_ftpost,
          mt_item        TYPE mty_t_item_data,
          mt_documents   TYPE mty_t_documents,
          mt_ftclear     TYPE feb_t_ftclear,
          mt_table_saida TYPE TABLE mty_s_selecao,
          ms_header      TYPE mty_s_header_data.

    METHODS: init,
    	     call_fb05,
    	     mount_header,
             mount_item,
             mount_clearing_documents.

    METHODS: set_value_ftpost
      IMPORTING
        iv_type   TYPE stype_pi
        iv_screen TYPE count_pi
        iv_field  TYPE bdc_fnam
        iv_value  TYPE any.

ENDCLASS.
