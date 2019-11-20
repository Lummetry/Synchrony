unit sync_utils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, Calendar, DateTimePicker, csvdataset, db;

type
  TCustomField = class
  FieldName: string;
  FieldValue : string;
  FieldSize : integer;
end;

function extract_data(frm_target : TForm): TList;
procedure extract_and_save(frm_target : TForm);

procedure db_init_maybe_load_data(frm_target: TForm);
procedure db_add_data(lst_data: TList);
procedure db_save_file;


procedure log_init;
procedure log_clear;
procedure log_add(lst: TList);
procedure log_add_str(str: string);
procedure log_save;
procedure log_show;
procedure log_add_all_data;
procedure log_add_data;

procedure show_data_log;

procedure new_registration(frm_target: TForm; debug: Boolean);


procedure _setup_controls(frm_target:TForm);

procedure _clear_form(frm_target: TForm);




var
  ds_data: TCSVDataset;
  str_log_fn : string;

const
  str_data_fn = 'data.csv';
  b_save_after_add = False;


implementation

uses frm_records_unit, frm_debug_unit;

procedure log_init;
begin
  str_log_fn := FormatDateTime('YYYYMMDD_hhnn',Now()) + '_log.txt';
end;

procedure log_clear;
begin
  frm_debug.log.lines.clear;
end;

procedure log_add_str(str: string);
begin
  frm_debug.log.lines.add('['+TimeToStr(Now())+'] ' + str);
  log_save;
end;

procedure log_save;
begin
  try
    frm_debug.log.Lines.SaveToFile(str_log_fn);
  finally
  end;
end;

procedure log_show;
begin
  frm_debug.showmodal;
end;

procedure db_init_maybe_load_data(frm_target: TForm);
var
  lst_data : TList;
  i, n_fields, i_size : integer;
  s_name : string;
begin
  ds_data := TCSVDataset.Create(nil);
  ds_data.CSVOptions.FirstLineAsFieldNames := True;
  if FileExists(str_data_fn) then
  begin
    ds_data.LoadFromCSVFile(str_data_fn);
  end
  else
  begin
    lst_data := extract_data(frm_target);
    n_fields := lst_data.Count;
    for i := 0 to n_fields-1 do
    begin
      s_name := TCustomField(lst_data[i]).FieldName;
      i_size := TCustomField(lst_data[i]).FieldSize;
      ds_data.FieldDefs.Add(s_name, ftString, i_size);
    end;
    ds_data.CreateDataset;
    ds_data.Active:= True;
  end;
end;


procedure db_add_data(lst_data: TList);
var
  i : integer;
  s_fld, s_val : string;
begin
  if not ds_data.Active then
  begin
    log_add_str('Dataset not opened!');
    ShowMessage('Contactati echipa de intretinere. Cod #01');
    exit;
  end;
  log_add_str('Adding new record');
  log_add(lst_data);
  ds_data.Insert;
  for i:=0 to lst_data.count-1 do
  begin
    s_fld := TCustomField(lst_data[i]).FieldName;
    s_val := TCustomField(lst_data[i]).FieldValue;
    ds_data.FieldByName(s_fld).AsString := s_val;
    log_add_str('setting '+s_fld+'='+s_val);
  end;
  ds_data.Post;
  ds_data.First;
  s_fld := 'Edit1';
  log_add_str('Post-post '+s_fld+'='+ds_data.FieldByName(s_fld).asString);
end;

procedure db_save_file;
begin
  ds_data.SaveToCSVFile(str_data_fn);
end;

procedure _setup_controls(frm_target: TForm);
var
  i, n_ctrls : integer;
  ctrl : TControl;
begin
  n_ctrls := frm_target.ControlCount;
  for i:=0 to n_ctrls-1 do
  begin
    ctrl := frm_target.Controls[i];
    if ctrl is TCheckBox then
    begin
      TCheckBox(ctrl).tag := 101;
    end
    else
    if ctrl is TDateTimePicker then
    begin
      TDateTimePicker(ctrl).tag := 101;
    end
    else
    if ctrl is TEdit then
    begin
      TEdit(ctrl).tag := 101;
    end;
  end;
end;


procedure _clear_form(frm_target: TForm);
var
  i, n_ctrls : integer;
  ctrl : TControl;
begin
  n_ctrls := frm_target.ControlCount;
  for i:=0 to n_ctrls-1 do
  begin
    ctrl := frm_target.Controls[i];
    if ctrl is TCheckBox then
    begin
      TCheckBox(ctrl).Checked := False;
    end
    else
    if ctrl is TRadioGroup then
    begin
      TRadioGroup(ctrl).ItemIndex := -1;
    end
    else
    if ctrl is TDateTimePicker then
    begin
      TDateTimePicker(ctrl).Date := Now;
    end
    else
    if ctrl is TEdit then
    begin
      TEdit(ctrl).text := '';
    end;
  end;
end;


function bool_to_str(b:Boolean): string;
begin
  result := IntToStr(abs(integer(b)));
end;

function extract_data(frm_target : TForm): TList;
var
  i, n_ctrls, i_size : integer;
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
        val := bool_to_str(TCheckBox(ctrl).checked);
        i_size := 1;
      end
      else
      if ctrl is TDateTimePicker then
      begin
        val := DateToStr(TDateTimePicker(ctrl).date);
        i_size := 10;
      end
      else
      if ctrl is TEdit then
      begin
        val := TEdit(ctrl).text;
        i_size := 50;
      end
      else
       ShowMessage('DEBUG REPORT: UNK fld'+ctrl.name);
      fld_rec.FieldName:= ctrl.name;
      fld_rec.FieldValue:= val;
      fld_rec.FieldSize := i_size;
      lst_res.Add(fld_rec);
    end;
  end;
  result := lst_res
end;

procedure extract_and_save(frm_target: TForm);
var
  lst : TList;
begin
  lst := extract_data(frm_target);
  db_add_data(lst);
  if  b_save_after_add then
    db_save_file;
end;


procedure log_add(lst: TList);
var
  i : integer;
  fld : TCustomField;
  s : string;
begin
  s := '';
  for i:=0 to lst.Count-2 do
  begin
    fld := TCustomField(lst.Items[i]);
    s := s + fld.FieldName + ' = "' + fld.FieldValue + '", ';
  end;
  fld := TCustomField(lst.Items[lst.Count-1]);
  s := s + fld.FieldName + ' = ' + fld.FieldValue;
  log_add_str(s);
end;


function _data_to_list:TList;
var
  i : integer;
  lst : TList;
  fld : TCustomField;
begin
  lst := Tlist.Create;
  for i:=0 to ds_data.Fields.Count-1 do
  begin
    fld := TCustomField.Create;
    fld.FieldName := ds_data.Fields[i].Name;
    fld.FieldValue := ds_data.Fields[i].AsString;
    lst.Add(fld);
  end;
  result := lst;
end;

procedure log_add_all_data;
var
  cnt : integer;
begin
  ds_data.First;
  cnt := 1;
  while not ds_data.EOF do
  begin
    log_add_str('Inregistrare #'+IntToStr(cnt));
    log_add(_data_to_list);
    ds_data.Next;
    cnt := cnt + 1;
  end;
end;

procedure log_add_data;
begin
 log_add(_data_to_list)
end;

procedure show_data_log;
var
  dsrc : TDataSource;
begin
  if ds_data.Active then
  begin
    dsrc := TDataSource.Create(nil);
    dsrc.DataSet := ds_data;
    frm_records.dbg.DataSource := dsrc;
    frm_records.ShowModal;
  end
  else
  begin
    ShowMessage('Nu exista data disponibile momentan');
  end;
end;

procedure new_registration(frm_target: TForm; debug: Boolean);
begin
  _clear_form(frm_target);
  if frm_target.showModal = mrOK then
    extract_and_save(frm_target);
    if debug then
       log_show
  else
    ShowMessage('Salvarea a fost anulata');
end;


end.

