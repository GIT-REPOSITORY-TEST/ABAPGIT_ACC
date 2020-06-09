*---------------------------------------------------------------------*
* Report            : /LION/R2R_R_ASSET_TRANS_UPLOAD
* Application Area  : R2R
* Functional Spec ID: R2R.E.062_3 - Asset Transaction Type Upload
* Author / Company  : Abilash / Accenture
* Date              : 10-JUL-2019
*---------------------------------------------------------------------*
* Description       : The purpose of this program is facilitate
*                     the mass upload of Asset based on transaction
*                     type into SAP S/4 HANA
*---------------------------------------------------------------------*
* Dependent Objects: NA
*---------------------------------------------------------------------*
*                    Modification History
* CHANGE HISTORY  -  Should be completed in reverse
*                    date order
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* ddmmyy 	<name> D08Knnnnnn <Defect#>
*                            <enter description of
*                              Change here>
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report /LION/R2R_R_ASSET_TRANS_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /lion/r2r_r_asset_trans_upload.

*TOP Declaration
INCLUDE /lion/r2r_r_asset_trans_top.

*Include For Selection Screen Declaration
INCLUDE /lion/r2r_r_asset_trans_sel.

INITIALIZATION.
* To Provide Download Template Button
  MOVE TEXT-005 TO sscrfields-functxt_01.
*Creating object for the class
  DATA(go_obj) = NEW /lion/r2r_cl_asst_transt_uploa( ).


AT SELECTION-SCREEN.
* To Process based on the action by the user
  IF sy-ucomm = gc_ucomm_d."'DOWNLOAD'.
* To provide a value for each radio button
    CLEAR gv_radio.
    IF rb_ret IS NOT INITIAL.
      gv_radio = gc_radio_ret.
    ELSEIF rb_int IS NOT INITIAL.
      gv_radio = gc_radio_int.
    ELSEIF rb_reval IS NOT INITIAL.
      gv_radio = gc_radio_rev.
    ELSEIF rb_write IS NOT INITIAL.
      gv_radio = gc_radio_wrt.
    ELSEIF rb_undep IS NOT  INITIAL.
      gv_radio = gc_radio_unp.
    ENDIF.
*Creating object for the class
    CALL METHOD go_obj->download_excel
      EXPORTING
        iv_radio = gv_radio. "Radio Button
  ENDIF.

START-OF-SELECTION.

* To provide a value for each radio button
  CLEAR gv_radio.
  IF rb_ret IS NOT INITIAL.
    gv_radio = gc_radio_ret.
  ELSEIF rb_int IS NOT INITIAL.
    gv_radio = gc_radio_int.
  ELSEIF rb_reval IS NOT INITIAL.
    gv_radio = gc_radio_rev.
  ELSEIF rb_write IS NOT INITIAL.
    gv_radio = gc_radio_wrt.
  ELSEIF rb_undep IS NOT  INITIAL.
    gv_radio = gc_radio_unp.
  ENDIF.
*Asset Upload based on Transaction Type
  CALL METHOD go_obj->validate_screen
    EXPORTING
      iv_filepath = p_file
      iv_bukrs    = p_bukrs
      iv_testrun  = p_test
      iv_radio    = gv_radio
    IMPORTING
      ex_output   = go_obj->gt_output.


END-OF-SELECTION.
  IF go_obj->gt_output IS NOT INITIAL.
    CALL METHOD go_obj->alv_display
      CHANGING
        ct_output = go_obj->gt_output.
  ENDIF.
