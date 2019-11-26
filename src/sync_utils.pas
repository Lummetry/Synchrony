unit sync_utils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, Calendar, DateTimePicker,MaskEdit, csvdataset, db;

type
  TCustomField = class
  FieldName: string;
  FieldValue : string;
  FieldSize : integer;
  FieldOrder: integer;
end;


type
  TTwoDates=class
    d_start : TDateTime;
    d_end : TDateTime;
    s_start : string;
    s_end : string;
  end;

type

  { TROID }

  TROID = class
    nume : string;
    prenume : string;
    serienr : string;
    nastere : string;
    endcnp : string;
    full_line : string;
    sex : string;
    cnp : string;

    public
      constructor Create;
      function all_ok:boolean;
      function get_CNP:string;
      function check_CNP : boolean;
      function get_judet:string;
      function get_judet_code:string;
      function get_judet_index:integer;
      procedure log;
end;


procedure init_all(frm_target : TForm);


procedure idr_execute_app;
procedure idr_stop_app;
procedure idr_clear_data;
procedure idr_clear_temp;
procedure idr_create_temp;
function idr_get_update: TStringList;
function idr_load_data:TStringList;
function idr_get_last_record : TROID;

procedure idr_autocomplete(frm_target:TForm);

function _get_idr_exe:string;
function _get_idr_data:string;
function _get_idr_data_temp:string;





function form_to_list_data(frm_target : TForm): TList;
procedure extract_and_save(frm_target : TForm);

procedure db_init_maybe_load_data(frm_target: TForm);
procedure db_add_data(lst_data: TList);
procedure db_save_file;
procedure db_prepare_data_grid;
procedure db_copy_data(str_dest:string);
function db_get_min_max_dates:TTwoDates;


procedure log_init;
procedure log_clear;
procedure log_add(lst_custom_fields: TList);
procedure log_add(str:string);
procedure log_add_str(str: string);
procedure log_save(force:boolean=False);
procedure log_show;
procedure log_add_all_data;
procedure log_add_data;

procedure show_data_log;

procedure new_registration(frm_target: TForm; debug: Boolean);
procedure save_and_reset(frm_target : TForm);

procedure _clear_form(frm_target: TForm);

function code_to_judet(str_code:string):string;


procedure __setup_controls(frm_target:TForm);

procedure _msg_win(str_str:string);



var
  ds_data: TCSVDataset;
  str_log_fn : string;
  str_data_fn : string;
  n_saves : integer;
  idr_handle: integer;
  i_idr_data_pos : integer;
  SHOW_DEBUG_ON_MAIN :  boolean;

const
  str_idr_exe = 'SwipeCmdPrompt.exe';
  str_idr_data = 'SwipeCmdPrompt.log';
  str_idr_folder = 'api';
  cstr_data_fn = 'data.csv';
  b_save_after_add = False;
  arr_concats : array[1..1] of string=('EXAMPLE_PLACEHOLDER');
  n_max_concats = 1000;
  USE_DS_SAVE = False;
  SAVE_EVERY = 10;

  c_fld_date = 'MarcaTemporala';

  c_str_id = 'CodelineData::LogDataItem() - puDocType:';
  c_str_ci = 'CodelineData::LogDataItem() - puDocNumber:';
  c_str_nume = 'CodelineData::LogDataItem() - puSurname:';
  c_str_prenume = 'CodelineData::LogDataItem() - puForenames:';
  c_str_nastere = 'CodelineData::LogDataItem() - puDateOfBirth:';
  c_str_national = 'CodelineData::LogDataItem() - puNationality:';
  c_str_end_cnp = 'CodelineData::LogDataItem() - puOptionalData1:';
  c_str_line2 = 'CodelineData::LogDataItem() - puCodeline2:';
  c_str_sex = 'CodelineData::LogDataItem() - puShortSex:';

  cnp_ctrl = '279146358279';

  judete : array[1..48] of string = (
  'Alba',
  'Arad',
  'Arges',
  'Bacau',
  'Bihor',
  'Bistrita-Nasaud',
  'Botosani',
  'Brasov',
  'Braila',
  'Buzau',
  'Caras-Severin',
  'Cluj',
  'Constanta',
  'Covasna',
  'Dambovita',
  'Dolj',
  'Galati',
  'Gorj',
  'Harghita',
  'Hunedoara',
  'Ialomita',
  'Iasi',
  'Ilfov',
  'Maramures',
  'Mehedinti',
  'Mures',
  'Neamt',
  'Olt',
  'Prahova',
  'Satu Mare',
  'Salaj',
  'Sibiu',
  'Suceava',
  'Teleorman',
  'Timis',
  'Tulcea',
  'Vaslui',
  'Valcea',
  'Vrancea',
  'Bucuresti',
  'Bucuresti - Sector 1',
  'Bucuresti - Sector 2',
  'Bucuresti - Sector 3',
  'Bucuresti - Sector 4',
  'Bucuresti - Sector 5',
  'Bucuresti - Sector 6',
  'Calarasi',
  'Giurgiu'

  );





implementation

uses frm_records_unit, frm_debug_unit, strutils, fpcsvexport, ShellApi, Windows,
  JwaWindows, jwatlhelp32, fileutil, dateutils, frm_wait_unit;




function ForcedCopyFile(const SrcFilename, DestFilename: String;
                  Flags: TCopyFileFlags=[cffOverwriteFile]; ExceptionOnError: Boolean=False): Boolean;
var
  SrcHandle: THandle;
  DestHandle: THandle;
  Buffer: array[1..4096] of byte;
  ReadCount, WriteCount, TryCount: LongInt;
begin
  Result := False;
  // check overwrite
  if (not (cffOverwriteFile in Flags)) and FileExists(DestFileName) then
    exit;
  // check directory
  if (cffCreateDestDirectory in Flags)
  and (not DirectoryExists(ExtractFilePath(DestFileName)))
  and (not ForceDirectories(ExtractFilePath(DestFileName))) then
    exit;
  TryCount := 0;
  While TryCount <> 3 Do Begin
    SrcHandle := FileOpen(SrcFilename, fmOpenRead or fmShareDenyNone);
    if THandle(SrcHandle)=feInvalidHandle then Begin
      Inc(TryCount);
      Sleep(10);
    End
    Else Begin
      TryCount := 0;
      Break;
    End;
  End;
  If TryCount > 0 Then
  begin
    if ExceptionOnError then
      raise EFOpenError.CreateFmt({SFOpenError}'Unable to open file "%s"', [SrcFilename])
    else
      exit;
  end;
  try
    DestHandle := FileCreate(DestFileName);
    if (THandle(DestHandle)=feInvalidHandle) then
    begin
      if ExceptionOnError then
        raise EFCreateError.CreateFmt({SFCreateError}'Unable to create file "%s"',[DestFileName])
      else
        Exit;
    end;
    try
      repeat
        ReadCount:=FileRead(SrcHandle,Buffer[1],High(Buffer));
        if ReadCount<=0 then break;
        WriteCount:=FileWrite(DestHandle,Buffer[1],ReadCount);
        if WriteCount<ReadCount then
        begin
          if ExceptionOnError then
            raise EWriteError.CreateFmt({SFCreateError}'Unable to write to file "%s"',[DestFileName])
          else
            Exit;
        end;
      until false;
    finally
      FileClose(DestHandle);
    end;
    if (cffPreserveTime in Flags) then
      FileSetDate(DestFilename, FileGetDate(SrcHandle));
    Result := True;
  finally
    FileClose(SrcHandle);
  end;
end;



procedure idr_clear_data;
begin
  log_add('Clearing IDR data file...');
  if DeleteFile(PChar(_get_idr_data)) then
   log_add('IDR data file deleted.')
  else
   log_add(' Error deleting IDR file!')
end;

function FindProcessByName(const ProcName: String): DWORD;
var
  Proc: TPROCESSENTRY32;
  hSnap: HWND;
  Looper: BOOL;
begin
  Result := 0;
  Proc.dwSize := SizeOf(Proc);
  hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  Looper := Process32First(hSnap, Proc);
  while Integer(Looper) <> 0 do
  begin
    if UpperCase(ExtractFileName(proc.szExeFile)) = UpperCase(ProcName) then
    begin
      Result:=proc.th32ProcessID;
      Break;
    end;
    Looper := Process32Next(hSnap, Proc);
  end;
  CloseHandle(hSnap);
end;

function GetProcessMainWindow(const PID: DWORD; const wFirstHandle: HWND): HWND;
var
  wHandle: HWND;
  ProcID: DWord;
begin
  Result := 0;
  wHandle := GetWindow(wFirstHandle, GW_HWNDFIRST);
  while wHandle > 0 do
  begin
    GetWindowThreadProcessID(wHandle, @ProcID);
    if (ProcID = PID) then
      //if (IsWindowVisible(wHandle)) and (GetForegroundWindow = wHandle) then
        begin
          Result := wHandle;
          Break;
        end;
    wHandle := GetWindow(wHandle, GW_HWNDNEXT);
  end;
end;


procedure idr_show_on_form(frm_target:TForm; msg:string; color:TColor=clBlack);
var
  i : integer;
  pnl_info : TPanel;
begin
 pnl_info := nil;
 for i:=0 to frm_target.ControlCount-1 do
  if frm_target.controls[i].name = 'pnl_info' then
   pnl_info := TPanel(frm_target.controls[i]);
 if pnl_info <> nil then
  pnl_info.caption := msg;
 pnl_info.Font.Color:=color;
end;

function idr_cnp_conflict(str_cnp:string):boolean;
var
  res : boolean;
begin
 res := False;
 result := res;
end;

function idr_cnp_conflict(rec:TROID):boolean;
var
  res : boolean;
  str_cnp : string;
begin
 str_cnp := rec.get_CNP;
 if ds_data.Locate('CNP',str_cnp, []) then
  begin
    res := True;
    log_add('Found existing CNP recorded on '+ds_data.FieldByName(c_fld_date).AsString);
    ShowMessage('Persoana exista deja in baza de date inregistrata la '+ds_data.FieldByName(c_fld_date).AsString);
  end
 else
  res := False;
 result := res;
end;


procedure idr_autocomplete(frm_target: TForm);
var
  rec : TROID;
  i : integer;
  ctrl : TControl;
  val : string;
begin
 rec := idr_get_last_record;
 if rec = nil then
  begin
    idr_show_on_form(frm_target, 'Nu exista date de la cititor', clRed);
    exit;
  end;
 if not rec.all_ok then
  begin
    idr_show_on_form(frm_target, 'Date de la cititor incomplete', clRed);
    exit;
  end;
 if idr_cnp_conflict(rec) then
  begin
   idr_show_on_form(frm_target, 'Citire completa. CNP deja inregistrat!',clRed);
   exit;
  end
 else
 if rec.get_CNP ='' then
  begin
   idr_show_on_form(frm_target, 'CNP Neclar! Va rugam repetati citirea',clRed);
   exit;
  end
 else
  idr_show_on_form(frm_target, 'Citire completa.');


 for i:=0 to frm_target.ControlCount-1 do
 begin
   ctrl := frm_target.Controls[i];
   if (ctrl is TEdit) then
    begin
      val := '';
      if ctrl.name = 'nume' then
       val := rec.nume
      else
      if ctrl.Name = 'prenume' then
       val := rec.prenume;
      if val <> '' then
       TEdit(ctrl).text := val;
    end
   else
   if (ctrl is TMaskEdit) then
    begin
      if ctrl.name = 'CNP' then
       begin
         TMaskEdit(ctrl).text := rec.cnp;
       end;
    end
     else
     if (ctrl is TComboBox) then
      begin
        if ctrl.name = 'judet' then
         begin
           TComboBox(ctrl).ItemIndex := rec.get_judet_index -1;
         end;
      end;
 end;
end;

function _get_idr_exe:string;
begin
 result := '"'+str_idr_folder+'\'+str_idr_exe+'"';
end;

function _get_idr_data:string;
begin
 result := str_idr_folder + '\' + str_idr_data;
end;

function _get_idr_data_temp: string;
begin
 result := str_idr_folder + '\' + str_idr_data +'temp.txt';
end;

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
  n_saves := 1;
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

procedure log_save(force: boolean);
begin
  try
    if force then
      frm_debug.log.Lines.SaveToFile('log/'+str_log_fn)
    else
    if (n_saves mod SAVE_EVERY) = 0 then
       frm_debug.log.Lines.SaveToFile('log/'+str_log_fn);
  except

  end;
  n_saves := n_saves + 1;
end;

procedure log_show;
begin
  if not frm_debug.Active then
   begin
     frm_debug.show;
     frm_debug.Left:=Screen.Width - frm_debug.Width;
     frm_debug.top := 0;
   end;
end;

procedure db_init_maybe_load_data(frm_target: TForm);
var
  lst_data : TList;
  i, n_fields, i_size : integer;
  s_name : string;
  rec : TCustomField;
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
    s_name := c_fld_date;
    ds_data.FieldDefs.Add(s_name, ftString, 20, True, 1);
    log_add('  Field: '+s_name);
    for i := 0 to n_fields-1 do
    begin
      rec := TCustomField(lst_data[i]);
      if rec.FieldOrder <> -1 then
      begin
        s_name := rec.FieldName;
        i_size := rec.FieldSize;
        ds_data.FieldDefs.Add(s_name, ftString, i_size, True, rec.FieldOrder);
        log_add('  Field: '+s_name+'  Size: '+IntToStr(i_size)+' Order: '+IntToStr(rec.fieldOrder));
      end;
    end;
    for i := 0 to n_fields-1 do
    begin
      rec := TCustomField(lst_data[i]);
      if rec.FieldOrder = -1 then
      begin
        s_name := rec.FieldName;
        i_size := rec.FieldSize;
        ds_data.FieldDefs.Add(s_name, ftString, i_size);
        log_add('  Field: '+s_name+'  Size: '+IntToStr(i_size));
      end;
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
  ds_data.FieldByName(c_fld_date).AsString:= FormatDateTime('YYYY-MM-DD hh:nn:ss',Now());
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
      if ds_data.State in dsEditModes then
             ds_data.Post;
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
  i : integer;
begin
  if ds_data.Active then
  begin
    dsrc := TDataSource.Create(nil);
    dsrc.DataSet := ds_data;
    frm_records.dbg.DataSource := dsrc;
    //for i :=0 to frm_records.dbg.Columns.Count-1 do
    frm_records.dbg.AutoAdjustColumns;
  end;
end;

procedure db_copy_data(str_dest: string);
var
  str_dest_fn : string;
begin
  str_dest_fn := str_dest + '/' + FormatDateTime('YYYYMMDD_hhnn',Now()) + '_data.csv';
  log_add('Copy to '+str_dest_fn);
  if CopyFile('data/data.csv', str_dest_fn) then
   log_add(' Done')
  else
   log_add(' Failed!');
end;

function db_get_min_max_dates: TTwoDates;
var
  d, d_min, d_max : TDateTime;
  s_min, s_max,s_d : string;
  res : TTwoDates;
  fmt : TFormatSettings;
begin
  ds_data.First;
  d_min := Now;
  fmt.DateSeparator:='-';
  fmt.TimeSeparator:=':';
  fmt.LongDateFormat:='YYYY-MM-DD';
  fmt.LongTimeFormat:='hh:nn:ss';
  fmt.ShortDateFormat:='YYYY-MM-DD';
  d_max := StrToDateTime('1999-01-01 00:00:00', fmt);
  while not ds_data.EOF do
  begin
    s_d := ds_data.FieldByName(c_fld_date).AsString;
    d := StrToDateTime(s_d, fmt);
    if CompareDateTime(d_min, d) > 0 then
    begin
     d_min := d;
     s_min := s_d;
    end;
    if CompareDateTime(d_max, d) < 0 then
    begin
     d_max := d;
     s_max := s_d;
    end;
    ds_data.Next;
  end;
  res := TTwoDates.Create;
  res.d_end:= d_max;
  res.d_start:=d_min;
  res.s_end := s_max;
  res.s_start := s_min;
  result := res;
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

procedure _msg_win(str_str: string);
begin
 frm_wait.inf.caption := str_str;
 frm_wait.show;
 Application.ProcessMessages;
 Application.ProcessMessages;
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
    if ctrl.name = 'pnl_info' then
     TPanel(ctrl).Caption := '';

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
      if pos('recolt', ctrl.Name) > 0 then
        TDateTimePicker(ctrl).Date := Now
      else
        TDateTimePicker(ctrl).Date := NullDate;
    end
    else
    if (ctrl is TEdit) or (ctrl is TMaskEdit) then
    begin
      TEdit(ctrl).text := '';
    end
    else
    if (ctrl is TComboBox) then
    begin
      TComboBox(ctrl).text := '';
      TComboBox(ctrl).ItemIndex:=-1;
    end;
  end;

end;

function judetcode_to_judetindex(idx:integer):integer;
begin
  if idx<50 then
     result := idx
  else
     result := idx-4;
end;

function code_to_judet(str_code: string): string;
var
  idx : integer;
begin
  idx := StrToInt(str_code);
  result := judete[judetcode_to_judetindex(idx)];
end;


function bool_to_str(b:Boolean): string;
begin
  result := IntToStr(abs(integer(b)));
end;

procedure init_all(frm_target: TForm);
begin

  if IsDebuggerPresent then
  begin
   SHOW_DEBUG_ON_MAIN:= True;
   log_add('Debugger present. Log will be displayed.');
  end
  else
  begin
   SHOW_DEBUG_ON_MAIN:= False;
   log_add('Debugger NOT present.');
  end;

  if not DirectoryExists('log') then
     CreateDir('log');
  if not DirectoryExists('data') then
     CreateDir('data');

  log_init;
  str_data_fn := 'data/' + cstr_data_fn;
  db_init_maybe_load_data(frm_target);

  idr_stop_app;
  idr_execute_app;
end;





procedure idr_execute_app;
var
  str_exe : string;
  res : HINST;
begin
  str_exe := _get_idr_exe;
  idr_clear_data;
  log_add('Starting IDR '+str_exe);
  res := ShellExecute(0, nil, PChar(str_exe),nil, nil,0);
  log_add('IDR start returned '+IntToStr(res));
  if res < 32 then
  begin
   log_add('ERROR STARTING IDR API');
   showMessage('Va rugam contactati intretinerea'#10#13'Sistemul de citire CI nu este diponibil!');
  end
  else
   log_add('IDR API OK.');


end;

procedure idr_stop_app;
var
  win_handle: THandle;
  proc : DWORD;
  res:LRESULT;
  str_win : string;
begin
  str_win := str_idr_exe;
  log_add('Closing IDR ['+str_win+']...');
  proc := FindProcessByName(str_win);
  log_add(' Found process '+IntToStr(proc));
  win_handle := GetProcessMainWindow(proc, Application.MainForm.Handle);
  log_add(' Found window '+IntToStr(win_handle));
  log_add(' Found '+IntToStr(win_handle));
  res := SendMessage(win_handle, WM_CLOSE, 0, 0);
  log_add('MSG Send. Result '+IntToStr(res));
  idr_clear_data;
  i_idr_data_pos := 0;
end;


procedure idr_clear_temp;
begin
  if FileExists(_get_idr_data_temp) then
  begin
    log_add('Clearing temp...');
    DeleteFile(PChar(_get_idr_data_temp));
  end;
end;

procedure idr_create_temp;
begin
  idr_clear_temp;
  log_add('Copying file...');
  if ForcedCopyFile(_get_idr_data, _get_idr_data_temp) then
   log_add(' Data temp done.')
  else
   log_add(' Data copy failed.');
end;

function idr_get_update: TStringList;
var
  sl_data, sl_new : TStringList;
  i : integer;
begin
  log_add('Loading IDR data...');
  sl_data := idr_load_data;
  sl_new := nil;
  if sl_data <> nil then
  begin
    log_add('Loaded '+IntToStr(sl_data.Count)+' lines. Updating from '+intToStr(i_idr_data_pos));
    sl_new := TStringList.Create;
    for i:=i_idr_data_pos to sl_data.Count-1 do
    begin
      sl_new.Add(sl_data.Strings[i]);
    end;
    i_idr_data_pos := sl_data.Count-1;
  end
  else
   log_add('No dada loaded');
  result := sl_new;
end;



function idr_load_data: TStringList;
var
  sl_res : TStringList;
  str_fn : string;
begin
  sl_res := TStringList.Create;
  idr_create_temp;
  str_fn := _get_idr_data_temp;
  log_add('  Loading ' + str_fn);
  try
    sl_res.LoadFromFile(str_fn);
  except
    sl_res := nil;
  end;
  result := sl_res;
end;

function idr_get_last_record: TROID;
var
  rec : TROID;
  sl_update : TStringList;
  i, i_start : integer;
  b_found : boolean;
  s_line, s_temp : string;
begin
  rec := nil;
  sl_update := idr_get_update;
  b_found := False;
  for i:= sl_update.Count-1 downto 0 do
  begin
    if pos(c_str_id, sl_update.strings[i]) > 0 then
    begin
     b_found := True;
     i_start := i;
     log_add('Found '+c_str_id+' at '+IntToStr(i_start));
     break;
    end;
  end;

  if b_found then
  begin
    rec := TROID.Create;
    for i:=i_start to sl_update.Count-1 do
    begin
      s_line := sl_update.strings[i];
      if pos(c_str_ci, s_line) > 0 then
         rec.serienr:= Trim(copy(s_line, pos(c_str_ci, s_line) + length(c_str_ci), 100))
      else
      if pos(c_str_end_cnp, s_line) > 0 then
      begin
        s_temp := Trim(copy(s_line, pos(c_str_end_cnp, s_line) + length(c_str_end_cnp), 100));
        rec.endcnp:= Copy(s_temp,2,100);
        rec.sex:=s_temp[1];
      end
      else
      if pos(c_str_nastere, s_line) > 0 then
         rec.nastere:= Trim(copy(s_line, pos(c_str_nastere, s_line) + length(c_str_nastere), 100))
      else
      if pos(c_str_line2, s_line) > 0 then
         rec.full_line:= Trim(copy(s_line, pos(c_str_line2, s_line)+ length(c_str_line2), 100))
      else
      if pos(c_str_nume, s_line) > 0 then
         rec.nume:= Trim(copy(s_line, pos(c_str_nume, s_line)+ length(c_str_nume), 100))
      else
      if pos(c_str_prenume, s_line) > 0 then
         rec.prenume:= Trim(copy(s_line, pos(c_str_prenume, s_line)+ length(c_str_prenume), 100));
    end;
    if rec.all_ok then
    begin
     log_add('Full data avail');
     rec.log;
     rec.cnp:=rec.get_CNP;
    end
    else
    begin
      log_add('Partial data avail...');
      rec.log;
    end;
  end
  else
   log_add('No update found');

  result := rec;
end;

function _get_field_order(str_fld:string):integer;
begin
  if str_fld = 'CNP' then
   result := 4
  else
  if stR_fld = 'nume' then
   result := 2
  else
  if str_fld = 'prenume' then
   result := 3
  else
  if str_fld = 'judet' then
   result := 5
  else
   result := -1;
end;



function form_to_list_data(frm_target : TForm): TList;
var
  i,j,p, n_ctrls, i_size, i_conc, year : integer;
  fld_rec, fld_conc : TCustomField;
  lst_res : TList;
  dt_val : TDate;
  ctrl : TControl;
  val, msg, str_nr, str_n, str_conc : string;
  n_concated : integer;
  arr_concat_vals:array[1..n_max_concats] of TCustomField;
  b_found : boolean;
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
      val := '';
      if ctrl is TCheckBox then
      begin
        val := bool_to_str(TCheckBox(ctrl).checked);
      end
      else
      if ctrl is TDateTimePicker then
      begin
        dt_val := TDateTimePicker(ctrl).date;
        year := YearOf(dt_val);
        if year < 3000 then
         val := DateToStr(dt_val);
      end
      else
      if ctrl is TRadioGroup then
      begin
        if TRadioGroup(ctrl).ItemIndex <> -1 then
          val := TRadioGroup(ctrl).Items[TRadioGroup(ctrl).ItemIndex]
        else
          val := '';
      end
      else
      if (ctrl is TEdit) or (ctrl is TMaskEdit) or (ctrl is TComboBox) then
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
      fld_rec.FieldOrder:= _get_field_order(ctrl.name);
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
    b_found := False;
    for j := 1 to 100 do
     for p := 1 to i_conc-1 do
     begin
       fld_rec := TCustomField(arr_concat_vals[p]);
       if (fld_rec.FieldName = str_conc) and (fld_rec.FieldOrder = j) then
       begin
         b_found := True;
         fld_conc.FieldValue := fld_conc.FieldValue + fld_rec.FieldValue;
         fld_conc.FieldSize := fld_conc.FieldSize + 1;
         log_add('Found '+ fld_conc.FieldName +' ' + fld_conc.FieldValue);
       end;
     end;
    if b_found then
        lst_res.Add(fld_conc)
    else
        log_add('  '+str_conc+' not found in form.');
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

{ TROID }

constructor TROID.Create;
begin
  self.endcnp:='';
  self.full_line:='';
  self.prenume:='';
  self.nume:='';
  self.nastere:='';
  self.serienr:='';
  self.endcnp:='';
  self.sex := '';
end;

function TROID.all_ok: boolean;
begin
 if (self.endcnp <> '') and (self.full_line <> '') and (self.prenume <>'') and (self.nume<>'') and (self.nastere<>'') and (self.serienr<>'') and (self.endcnp<>'')  and (self.sex <>'') then
  result := True
 else
  result := False;
end;

function TROID.get_CNP: string;
var
  str_cnp : string;
begin
  str_cnp := self.sex;
  str_cnp := str_cnp + self.nastere[7] + self.nastere[8];
  str_cnp := str_cnp + self.nastere[4] + self.nastere[5];
  str_cnp := str_cnp + self.nastere[1] + self.nastere[2];
  str_cnp := str_cnp + self.endcnp;
  self.cnp:= str_cnp;
  if self.check_CNP then
  begin
    log_add('CNP Check ok.');
    result := self.cnp;
  end
  else
  begin
    log_add('CNP Check failed.');
    result := '';
  end;
end;

function TROID.check_CNP: boolean;
var
  i_ctrl, i, val : integer;
begin
  if (self.cnp = '') or (length(self.cnp) <> 13) then
    result := False
  else
  begin
    log_add('Checking CNP: '+self.cnp);
    i_ctrl := StrToInt(self.cnp[13]);
    val := 0;
    for i:=1 to 12 do
    begin
      val := val + StrToInt(self.cnp[i]) * StrToInt(cnp_ctrl[i]);
    end;
    val :=  val mod 11;
    if val = 10 then val :=1;
    if val = i_ctrl then
    begin
      log_add(' CNP Check ok: '+IntToStr(val)+'='+IntToStr(i_ctrl));
      result:= True
    end
    else
    begin
      log_add(' CNP Check Failed: '+IntToStr(val)+'<>'+IntToStr(i_ctrl));
      result:= False
    end;
  end;
end;

function TROID.get_judet: string;
begin
  if length(self.endcnp) <> 6 then
   result := ''
  else
   result := code_to_judet(self.get_judet_code);
end;

function TROID.get_judet_code: string;
begin
  result := self.endcnp[1] +self.endcnp[2];
end;

function TROID.get_judet_index: integer;
var
  cod: integer;
begin
 cod := StrToInt(self.endcnp[1]+self.endcnp[2]);
 result := judetcode_to_judetindex(cod);
end;


procedure TROID.log;
begin
 log_add('Nume: '+self.nume);
 log_add('Prenume: '+self.prenume);
 log_add('Data: '+self.nastere);
 log_add('Serie: ' + self.serienr);
 log_add('EndCNP: ' + self.endcnp);
 log_add('Linie: ' + self.full_line);
end;




end.

