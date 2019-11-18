unit frm_cedicrom_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, Calendar, DateTimePicker;

type

  { Tfrm_cedricrom }

  Tfrm_cedricrom = class(TForm)
    background: TImage;
    urban: TCheckBox;
    menopauza: TCheckBox;
    lauzie: TCheckBox;
    alaptare: TCheckBox;
    radioterapie: TCheckBox;
    CheckBox14: TCheckBox;
    DIU: TCheckBox;
    leucoree: TCheckBox;
    contact: TCheckBox;
    spontan: TCheckBox;
    cauterizari: TCheckBox;
    rural: TCheckBox;
    biopsii: TCheckBox;
    cu_leziuni: TCheckBox;
    fara_leziuni: TCheckBox;
    roma: TCheckBox;
    ucraineana: TCheckBox;
    alta: TCheckBox;
    benigna: TCheckBox;
    maligna: TCheckBox;
    ciclu: TCheckBox;
    sarcina: TCheckBox;
    CNP1: TEdit;
    CNP2: TEdit;
    CNP10: TEdit;
    CNP11: TEdit;
    CNP12: TEdit;
    CNP4: TEdit;
    CNP3: TEdit;
    CNP6: TEdit;
    CNP5: TEdit;
    CNP7: TEdit;
    CNP8: TEdit;
    CNP13: TEdit;
    CNP9: TEdit;
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
    etnie: TEdit;
    Label1: TLabel;
    Title: TLabel;
    Title1: TLabel;
    Title10: TLabel;
    Title11: TLabel;
    Title12: TLabel;
    Title13: TLabel;
    Title14: TLabel;
    Title15: TLabel;
    Title16: TLabel;
    Title17: TLabel;
    Title18: TLabel;
    Title19: TLabel;
    Title2: TLabel;
    Title20: TLabel;
    Title21: TLabel;
    Title22: TLabel;
    Title23: TLabel;
    Title24: TLabel;
    Title25: TLabel;
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
    procedure stradaChange(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure TitleClick(Sender: TObject);
  private

  public

  end;

var
  frm_cedricrom: Tfrm_cedricrom;

implementation

{$R *.lfm}

{ Tfrm_cedricrom }

procedure Tfrm_cedricrom.TitleClick(Sender: TObject);
begin

end;

procedure Tfrm_cedricrom.Label1Click(Sender: TObject);
begin

end;

procedure Tfrm_cedricrom.CNP1Change(Sender: TObject);
begin

end;

procedure Tfrm_cedricrom.contactChange(Sender: TObject);
begin

end;

procedure Tfrm_cedricrom.stradaChange(Sender: TObject);
begin

end;

end.

