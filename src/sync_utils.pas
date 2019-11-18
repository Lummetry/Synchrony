unit sync_utils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, Calendar, DateTimePicker, frm_debug_unit;

type
  TCustomField = class
  FieldName: string;
  FieldValue : string;
end;

function extract_data(frm_target : TForm): TList;
procedure clear_log;
procedure add_log(str: string);
procedure show_debug;


implementation

procedure clear_log;
begin
  frm_debug.log.lines.clear;
end;

procedure add_log(str: string);
begin
  frm_debug.log.lines.add(str)
end;

procedure show_debug;
begin
  frm_debug.showmodal;
end;

function extract_data(frm_target : TForm): TList;
var
  i, n_ctrls : integer;
  fld_rec : TCustomField;
  lst_res : TList;
  ctrl : TControl;
  val : string;
begin
  n_ctrls := frm_target.ControlCount;
  lst_res := TList.Create;
  for i:=0 to n_ctrls-1 do
  begin
    ctrl := frm_target.Controls[i];
    if ctrl.tag = 101 then
    begin
      fld_rec := TCustomField.Create;
      if ctrl is TCheckBox then
      begin

        val := BoolToStr(TCheckBox(ctrl).checked);
      end
      else
      if ctrl is TDateTimePicker then
      begin
        val := DateToStr(TDateTimePicker(ctrl).date);
      end
      else
      if ctrl is TEdit then
      begin
        val := TEdit(ctrl).text;
      end
      else
       ShowMessage('DEBUG REPORT: UNK fld'+ctrl.name);
      fld_rec.FieldName:= ctrl.name;
      fld_rec.FieldValue:= val;
      lst_res.Add(fld_rec);
    end;
  end;
  result := lst_res
end;

end.

