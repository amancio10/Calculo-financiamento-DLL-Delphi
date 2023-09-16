program Calculo_financiamento;

uses
  Vcl.Forms,
  U_Principal in 'U_Principal.pas' {Frm_Calculo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrm_Calculo, Frm_Calculo);
  Application.Run;
end.
