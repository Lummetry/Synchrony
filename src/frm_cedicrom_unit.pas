unit frm_cedicrom_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, Calendar, Buttons, MaskEdit, DateTimePicker;

type

  { Tfrm_cedicrom }

  Tfrm_cedicrom = class(TForm)
    background: TImage;
    CNP1: TMaskEdit;
    mediul: TRadioGroup;
    etnia: TRadioGroup;
    histerectomie: TRadioGroup;
    status_postterapeutic: TRadioGroup;
    status_hormonal: TRadioGroup;
    aspectul_colului: TRadioGroup;
    sangerari: TRadioGroup;
    in_antecedente: TRadioGroup;
    salvare_continuare: TBitBtn;
    salvare: TBitBtn;
    salvare_inchidere: TBitBtn;
    DIU: TCheckBox;
    leucoree: TCheckBox;
    data_recoltare: TDateTimePicker;
    data_menstruatie: TDateTimePicker;
    nume: TEdit;
    centru: TEdit;
    medic: TEdit;
    biopsie_descriere: TEdit;
    prenume: TEdit;
    judet: TEdit;
    localitate: TEdit;
    strada: TEdit;
    tel: TEdit;
    cabinet: TEdit;
    medic_familie: TEdit;
    alta_etnie: TEdit;
    Label1: TLabel;
    Title: TLabel;
    Title1: TLabel;
    Title10: TLabel;
    Title11: TLabel;
    Title14: TLabel;
    Title16: TLabel;
    Title17: TLabel;
    Title18: TLabel;
    Title19: TLabel;
    Title2: TLabel;
    Title20: TLabel;
    Title26: TLabel;
    Title3: TLabel;
    Title4: TLabel;
    Title5: TLabel;
    Title6: TLabel;
    Title7: TLabel;
    Title8: TLabel;
    Title9: TLabel;
    procedure contactChange(Sender: TObject);
    procedure CNP1Change(Sender: TObject);
    procedure frm_cedicromSizeConstraintsChange(Sender: TObject);
    procedure mediulClick(Sender: TObject);
    procedure salvare_continuareClick(Sender: TObject);
    procedure stradaChange(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure TitleClick(Sender: TObject);
  private

  public

  end;

var
  frm_cedicrom: Tfrm_cedicrom;

implementation

{$R *.lfm}

{ Tfrm_cedicrom }

uses sync_utils;

procedure Tfrm_cedicrom.TitleClick(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.Label1Click(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.CNP1Change(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.frm_cedicromSizeConstraintsChange(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.mediulClick(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.salvare_continuareClick(Sender: TObject);
begin
  save_and_reset(self);
end;

procedure Tfrm_cedicrom.contactChange(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.stradaChange(Sender: TObject);
begin

end;

end.

