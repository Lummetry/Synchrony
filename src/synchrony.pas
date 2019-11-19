program synchrony;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, frm_main_unit, frm_cedicrom_unit, sync_utils,
  frm_debug_unit, frm_records_unit, frm_config_unit
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tfrm_main, frm_main);
  Application.CreateForm(Tfrm_cedricrom, frm_cedricrom);
  _setup_controls(frm_cedricrom);
  log_init;
  db_init_maybe_load_data(frm_cedricrom);
  Application.CreateForm(Tfrm_debug, frm_debug);
  Application.CreateForm(Tfrm_records, frm_records);
  Application.CreateForm(Tfrm_config, frm_config);
  Application.Run;
end.

