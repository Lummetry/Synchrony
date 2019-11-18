unit frm_debug_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tfrm_debug }

  Tfrm_debug = class(TForm)
    log: TMemo;
  private

  public

  end;

var
  frm_debug: Tfrm_debug;

implementation

{$R *.lfm}

end.

