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
  FieldOrder: integer;
end;

procedure init_all(frm_target : TForm);

function form_to_list_data(frm_target : TForm): TList;
procedure extract_and_save(frm_target : TForm);

procedure db_init_maybe_load_data(frm_target: TForm);
procedure db_add_data(lst_data: TList);
procedure db_save_file;
procedure db_prepare_data_grid;


procedure log_init;
procedure log_clear;
procedure log_add(lst_custom_fields: TList);
procedure log_add(str:string);
procedure log_add_str(str: string);
procedure log_save;
procedure log_show;
procedure log_add_all_data;
procedure log_add_data;

procedure show_data_log;

procedure new_registration(frm_target: TForm; debug: Boolean);
procedure save_and_reset(frm_target : TForm);

procedure _clear_form(frm_target: TForm);


procedure __setup_controls(frm_target:TForm);


var
  ds_data: TCSVDataset;
  str_log_fn : string;
  str_data_fn : string;

const
  cstr_data_fn = 'data.csv';
  b_save_after_add = False;
  arr_concats : array[1..1] of string=('CNP');
  n_max_concats = 1000;
  USE_DS_SAVE = False;


implementation

uses frm_records_unit, frm_debug_unit, strutils, fpcsvexport;


function _get_str_from_name(str_name:string):string;
var
  i : integer;
  str_str : string;
begin
  str_str := '';
  for i := 1 to length(str_name) do
  begin
   if not AnsiMatchStr(str_name[i], ['1','2','3','4','5','6','7','8','9','0']) then
      str_str := str_str + str_name[i];
  end;
  result := str_str
end;

function _get_nr_from_name(str_name:string):string;
var
  i : integer;
  str_nr : string;
begin
  str_nr := '';
  for i := 1 to length(str_name) do
   if AnsiMatchStr(str_name[i], ['1','2','3','4','5','6','7','8','9','0']) then
      str_nr := str_nr + str_name[i];
  result := str_nr
end;



procedure log_init;
begin
  str_log_fn := FormatDateTime('YYYYMMDD_hhnn',Now()) + '_log.txt';
end;

procedure log_clear;
begin
  frm_debug.log.lines.clear;
end;

procedure log_add(str: string);
begin
  log_add_str(str);
end;

procedure log_add_str(str: string);
begin
  frm_debug.log.lines.add('['+TimeToStr(Now())+'] ' + str);
  log_save;
end;

procedure log_save;
begin
  try
    frm_debug.log.Lines.SaveToFile('log/'+str_log_fn);
  except

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
  log_add('Initializing database...');
  ds_data := TCSVDataset.Create(nil);
  ds_data.CSVOptions.FirstLineAsFieldNames := True;
  if FileExists(str_data_fn) then
  begin
    log_add('Loading ' + str_data_fn);
    ds_data.LoadFromCSVFile(str_data_fn);
    log_add('Done loading data - total records: ' + IntToStr(ds_data.RecordCount));
  end
  else
  begin
    lst_data := form_to_list_data(frm_target);
    n_fields := lst_data.Count;
    for i := 0 to n_fields-1 do
    begin
      s_name := TCustomField(lst_data[i]).FieldName;
      i_size := TCustomField(lst_data[i]).FieldSize;
      ds_data.FieldDefs.Add(s_name, ftString, i_size);
      log_add('  Field: '+s_name+'  Size: '+IntToStr(i_size));
    end;
    ds_data.CreateDataset;
    ds_data.Active:= True;
    log_add('Dataset created and activated')
  end;
end;



procedure db_add_data(lst_data: TList);
var
  i : integer;
  s_fld, s_val : string;
begin
  log_add_str('Adding new record ...');
  if not ds_data.Active then
  begin
    log_add_str('Dataset not opened!');
    ShowMessage('Contactati echipa de intretinere. Cod #01 - add_not_open_ds');
    exit;
  end;
  log_add(lst_data);
  ds_data.Insert;
  for i:=0 to lst_data.count-1 do
  begin
    s_fld := TCustomField(lst_data[i]).FieldName;
    s_val := TCustomField(lst_data[i]).FieldValue;
    ds_data.FieldByName(s_fld).AsString := s_val;
    log_add_str('  DS '+s_fld+'='+s_val);
  end;
  ds_data.Post;
  //ds_data.First;
  log_add_str('Post-post '+s_fld+'='+ds_data.FieldByName(s_fld).asString);
  log_add('Total records so far: ' + IntToStr(ds_data.RecordCount));
  db_save_file;
end;

procedure db_save_file;
var
  exporter : TCSVExporter;
  n_rec : integer;
begin
  log_add('Saving data file '+ str_data_fn);
  if FileExists(str_data_fn) and USE_DS_SAVE then
  begin
    log_add('Saving to existing csv');
    ds_data.SaveToCSVFile(str_data_fn);
    log_add('Done saving');
  end
  else
  begin
    exporter := TCSVExporter.Create(nil);
    if ds_data.Active then
    begin
      log_add('Exporting CSV '+str_data_fn);
      exporter.Dataset := ds_data;
      exporter.FileName:=str_data_fn;
      n_rec := exporter.Execute;
      log_add('Exported '+intToStr(n_rec)+' records.');
    end;
  end;
  log_add('Done saving');
end;

procedure db_prepare_data_grid;
var
  dsrc : TDataSource;
begin
  if ds_data.Active then
  begin
    dsrc := TDataSource.Create(nil);
    dsrc.DataSet := ds_data;
    frm_records.dbg.DataSource := dsrc;
  end;
end;

procedure __setup_controls(frm_target: TForm);
var
  i, n_ctrls : integer;
  ctrl : TControl;
begin
  log_add('Modifying tags on ' + frm_target.name);
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
  log_add('Clearing ' + frm_target.name);
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

procedure init_all(frm_target: TForm);
begin
  if not DirectoryExists('log') then
     CreateDir('log');
  if not DirectoryExists('data') then
     CreateDir('data');

  log_init;
  str_data_fn := 'data/' + cstr_data_fn;
  db_init_maybe_load_data(frm_target);
end;

function form_to_list_data(frm_target : TForm): TList;
var
  i,j,p, n_ctrls, i_size, i_conc : integer;
  fld_rec, fld_conc : TCustomField;
  lst_res : TList;
  ctrl : TControl;
  val, msg, str_nr, str_n, str_conc : string;
  n_concated : integer;
  arr_concat_vals:array[1..n_max_concats] of TCustomField;
begin
  log_add('Extracting data from ' + frm_target.name);
  n_ctrls := frm_target.ControlCount;
  lst_res := TList.Create;
  i_conc := 1;
  for i:=0 to n_ctrls-1 do
  begin
    ctrl := frm_target.Controls[i];
    if ctrl.tag > 0 then
    begin
      fld_rec := TCustomField.Create;
      i_size := ctrl.tag;
      if ctrl is TCheckBox then
      begin
        val := bool_to_str(TCheckBox(ctrl).checked);
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
      begin
        msg := 'Va rugam contactati intretinerea aplicatiei. DEBUG REPORT: UNK fld'+ctrl.name;
        log_add(msg);
        ShowMessage(msg);
      end;
      fld_rec.FieldName:= ctrl.name;
      fld_rec.FieldValue:= val;
      fld_rec.FieldSize := i_size;
      fld_rec.FieldOrder:= -1;
      str_n := _get_str_from_name(ctrl.name);
      if AnsiMatchStr(str_n,arr_concats) then
      begin
        fld_rec.FieldOrder := StrToInt(_get_nr_from_name(ctrl.name));
        fld_rec.FieldName := str_n;
        arr_concat_vals[i_conc] := fld_rec;
        i_conc := i_conc + 1;
      end
      else
      begin
        lst_res.Add(fld_rec);
      end;
    end;
  end;
  log_add('Processing concatenated fields');
  for i:=1 to length(arr_concats) do
  begin
    fld_conc := TCustomField.Create;
    str_conc := arr_concats[i];
    fld_conc.FieldName := str_conc;
    fld_conc.FieldSize := 0;
    log_add('Processing ' + str_conc);
    for j := 1 to 100 do
     for p := 1 to i_conc-1 do
     begin
       fld_rec := TCustomField(arr_concat_vals[p]);
       if (fld_rec.FieldName = str_conc) and (fld_rec.FieldOrder = j) then
       begin
         fld_conc.FieldValue := fld_conc.FieldValue + fld_rec.FieldValue;
         fld_conc.FieldSize := fld_conc.FieldSize + 1;
         log_add('Found '+ fld_conc.FieldName +' ' + fld_conc.FieldValue);
       end;
     end;
    lst_res.Add(fld_conc)
  end;
  log_add(lst_res);
  log_add('Done data extraction.');
  result := lst_res
end;

procedure extract_and_save(frm_target: TForm);
var
  lst : TList;
begin
  lst := form_to_list_data(frm_target);
  db_add_data(lst);
  if b_save_after_add then
    db_save_file;
end;


procedure log_add(lst_custom_fields: TList);
var
  i : integer;
  fld : TCustomField;
  s : string;
begin
  s := '';
  for i:=0 to lst_custom_fields.Count-2 do
  begin
    fld := TCustomField(lst_custom_fields.Items[i]);
    s := s + fld.FieldName + ' = "' + fld.FieldValue + '", ';
  end;
  fld := TCustomField(lst_custom_fields.Items[lst_custom_fields.Count-1]);
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
begin
  if ds_data.Active then
  begin
    db_prepare_data_grid;
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
  begin
    log_add('Exit with SAVE');
    extract_and_save(frm_target);
    if debug then
       log_show
  end
  else
    log_add('Exit WITHOUT save')
end;

procedure save_and_reset(frm_target: TForm);
begin
  extract_and_save(frm_target);
  _clear_form(frm_target);
end;


end.

