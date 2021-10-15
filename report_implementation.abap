CLASS lcl_main_report IMPLEMENTATION.

  METHOD init.

    call_fb05( ).

  ENDMETHOD.

  METHOD call_fb05.
  	"Tabelas
	DATA: lt_blntab   TYPE re_t_ex_blntab,
		  lt_return   TYPE bapiret2_t,
          lt_fttax    TYPE STANDARD TABLE OF fttax.

    "Estruturas
    DATA: ls_mensagem TYPE bapiret2.

    "Variáveis
    DATA: lv_mode(1) TYPE c VALUE 'N'.

    CALL FUNCTION 'POSTING_INTERFACE_START'
      EXPORTING
        i_function         = 'C'
        i_mode             = lv_mode
        i_user             = sy-uname
      EXCEPTIONS
        client_incorrect   = 1
        function_invalid   = 2
        group_name_missing = 3
        mode_invalid       = 4
        update_invalid     = 5
        OTHERS             = 6.

	mount_header( ).

    mount_item( ).

    mount_clearing_documents( ).

    CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
      EXPORTING
        i_auglv                    = 'EINGZAHL'
        i_tcode                    = 'FB05'
        i_sgfunct                  = 'C'
        i_no_auth                  = 'X'
        i_xsimu                    = space
      IMPORTING
        e_msgid                    = ls_mensagem-id
        e_msgno                    = ls_mensagem-number
        e_msgty                    = ls_mensagem-type
        e_msgv1                    = ls_mensagem-message_v1
        e_msgv2                    = ls_mensagem-message_v2
        e_msgv3                    = ls_mensagem-message_v3
        e_msgv4                    = ls_mensagem-message_v4
      TABLES
        t_blntab                   = lt_blntab
        t_ftclear                  = mt_ftclear
        t_ftpost                   = mt_ftpost
        t_fttax                    = lt_fttax
      EXCEPTIONS
        clearing_procedure_invalid = 1
        clearing_procedure_missing = 2
        table_t041a_empty          = 3
        transaction_code_invalid   = 4
        amount_format_error        = 5
        too_many_line_items        = 6
        company_code_invalid       = 7
        screen_not_found           = 8
        no_authorization           = 9
        OTHERS                     = 10.

  	IF ( sy-subrc <> 0 AND sy-msgty <> 'S' AND sy-msgty <> 'W' ) OR
     	ls_mensagem-type = 'E' OR rt_blntab IS INITIAL.

		IF ls_mensagem IS INITIAL.
		
      		"Obtêm o texto da mensagem
      		MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         		WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_msg.

     		APPEND VALUE #( id         = sy-msgid
            	            type       = sy-msgty
                            number     = sy-msgno
                            message    = lv_msg
                            message_v1 = sy-msgv1
                            message_v2 = sy-msgv2
                            message_v3 = sy-msgv3
                            message_v4 = sy-msgv4
                          ) TO lt_return.
    	ELSE.

      		APPEND ls_mensagem TO lt_return.

    	ENDIF.

  	ENDIF.

  ENDMETHOD.

  METHOD mount_header.
  	"Variáveis
  	DATA: lv_value TYPE bdc_fval.

    WRITE sy-datum TO lv_value.

    "Data do documento
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BLDAT'
                      iv_value  = lv_value ).

    FREE lv_value.
    WRITE sy-datum TO lv_value.

    "Data do lançamento
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BUDAT'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = 'AB'.

    "Tipo do Documento
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BLART'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = '1000'.

    "Empresa
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BUKRS'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = 'BRL'.

    "Moeda
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-WAERS'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = 'Compensação'.

    "Texto do Cabeçalho
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-BKTXT'
                      iv_value  = lv_value ).

    FREE lv_value.
    lv_value = 'Referência'.

    "Texto de Referência
    set_value_ftpost( iv_type   = 'K'
                      iv_screen = 1
                      iv_field  = 'BKPF-XBLNR'
                      iv_value  = lv_value ).

  ENDMETHOD.

  METHOD mount_item.
  	"Variáveis
    DATA: lv_tela  TYPE ftpost-count,
          lv_value TYPE bdc_fval.

    "Field Symbols
    FIELD-SYMBOLS <fs_s_item> LIKE LINE OF mt_table_saida.

    SORT mt_item ASCENDING BY buzei.

    LOOP AT mt_table_saida ASSIGNING <fs_s_saida>.

      ADD 1 TO lv_tela.

      FREE lv_value.
      lv_value = '40'.

      "Chave de Lançamento
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'RF05A-NEWBS'
                        iv_value  = lv_value ).


      FREE lv_value.
      lv_value = <fs_s_saida>-hkont_dest.

      "Conta contábil
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'BSEG-HKONT'
                        iv_value  = lv_value ).

      FREE lv_value.
      WRITE <fs_s_saida>-dmbtr TO lv_value CURRENCY 'BRL'.
      CONDENSE lv_value NO-GAPS.

      "Valor
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'BSEG-WRBTR'
                        iv_value  = lv_value ).

      FREE lv_value.
      lv_value = <fs_s_saida>-sgtxt.

      "Texto do Item
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'BSEG-SGTXT'
                        iv_value  = lv_value ).

      FREE lv_value.
      lv_value = <fs_s_saida>-prctr.

      "Centro de Lucro
      set_value_ftpost( iv_type   = 'P'
                        iv_screen = lv_tela
                        iv_field  = 'COBL-PRCTR'
                        iv_value  = lv_value ).

    ENDLOOP.

  ENDMETHOD.

  METHOD mount_clearing_documents.

    LOOP AT mt_table_saida ASSIGNING FIELD-SYMBOLS(<fs_s_saida>).

   	  APPEND INITIAL LINE TO mt_ftclear ASSIGNING FIELD-SYMBOLS(<fs_ftclear>).
      <fs_ftclear>-agkoa  = 'S'.                        "Account Type
      <fs_ftclear>-xnops  = abap_true.                  "Indicator: Select only open items which are not special G/L?
      <fs_ftclear>-selfd  = 'BELNR'.                    "Selection Field
      <fs_ftclear>-agbuk  = '1000'.                     "Company code
      <fs_ftclear>-agkon  = <fs_s_saida>-hkont_orig.    "Account
      <fs_ftclear>-selvon = <fs_s_saida>-selvon.        "Chave - documento contábil/ano/item
      <fs_ftclear>-selbis = <fs_s_saida>-selvon.        "Chave - documento contábil/ano/item

    ENDLOOP.

  ENDMETHOD.

  METHOD set_value_ftpost.
  	"Field Symbols
    FIELD-SYMBOLS <fs_s_ftpost> LIKE LINE OF mt_ftpost.

    APPEND INITIAL LINE TO mt_ftpost ASSIGNING <fs_s_ftpost>.
    <fs_s_ftpost>-stype = iv_type.
    <fs_s_ftpost>-count = iv_screen.
    <fs_s_ftpost>-fnam  = iv_field.

    TRY.
        <fs_s_ftpost>-fval  = iv_value.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
