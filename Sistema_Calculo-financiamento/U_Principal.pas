unit U_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Buttons, ShellAPI;

type
  TFrm_Calculo = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label2: TLabel;
    LbValorParcela: TLabel;
    Label9: TLabel;
    LbTotalJuros: TLabel;
    Label11: TLabel;
    LbMontante: TLabel;
    EditValorBem: TEdit;
    EditNumMeses: TEdit;
    EditTaxaJuros: TEdit;
    Btn_Calcular: TBitBtn;
    Btn_Limpar: TBitBtn;
    LbLink: TLabel;
    procedure Btn_CalcularClick(Sender: TObject);
    procedure Btn_LimparClick(Sender: TObject);
    procedure LbLinkClick(Sender: TObject);
    procedure LbLinkMouseEnter(Sender: TObject);
    procedure LbLinkMouseLeave(Sender: TObject);
    procedure EditValorBemKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Calculo: TFrm_Calculo;

implementation

type
  TResultadoCalculo = record
  ValorParcela      : Double;
  TotalJuros        : Double;
  Montante          : Double;
  end;

 TProc = function(valor_bem, taxa_juros: Double; num_meses: Integer): TResultadoCalculo; Stdcall;

{$R *.dfm}


procedure TFrm_Calculo.Btn_CalcularClick(Sender: TObject);
var
  NomeDLL   : String;
  HandleDLL : THandle;
  Proc      : TProc;
  resultado : TResultadoCalculo;
begin
  if (EditValorBem.Text  <> '') and
     (EditTaxaJuros.Text <> '') and
     (EditNumMeses.Text  <> '') then
  begin
    try
      HandleDLL := 0;
      NomeDLL   := 'Calculo_financiamento.dll';
      HandleDLL := LoadLibrary(PChar(NomeDLL));

     if HandleDLL <> 0 then
      begin
        @Proc := GetProcAddress(HandleDLL, 'Calculo');

       if @Proc <> nil then
        begin
          {Chame a função da DLL com os parâmetros fornecidos}
          resultado := Proc(StrToFloat (EditValorBem. Text),
                            StrToFloat (EditTaxaJuros.Text),
                            StrToInt   (EditNumMeses. Text));

          {Exibe os resultados nos label's}
          LbValorParcela.Caption := 'R$ ' + FormatFloat('#,##0.00', resultado.ValorParcela);
          LbTotalJuros.Caption   := 'R$ ' + FormatFloat('#,##0.00', resultado.TotalJuros  );
          LbMontante.Caption     := 'R$ ' + FormatFloat('#,##0.00', resultado.Montante    );

        end
        else
        begin
          MessageDlg('A função da DLL não foi encontrada!', mtError, [mbOK], 0);
        end;
      end
      else
      begin
        MessageDlg('A DLL não pôde ser carregada!', mtError, [mbOK], 0);
      end;
    finally
      FreeLibrary(HandleDLL);
    end;
  end
  else
  begin
    MessageDlg('Por favor, preencha todos os campos!', mtWarning, [mbOK], 0);
    EditValorBem.SetFocus;
  end;
end;

procedure TFrm_Calculo.Btn_LimparClick(Sender: TObject);
begin
 EditNumMeses.Clear;
 EditValorBem.Clear;
 EditTaxaJuros.Text := '2';

 LbMontante.Caption     := 'R$ 00.00';
 LbTotalJuros.Caption   := 'R$ 00.00';
 LbValorParcela.Caption := 'R$ 00.00';

 EditValorBem.SetFocus;
end;

procedure TFrm_Calculo.EditValorBemKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', ',', #8]) then
    Key := #0;
end;

procedure TFrm_Calculo.LbLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'www.linkedin.com/in/amancio-santos', nil, nil, SW_SHOWNORMAL);
end;

procedure TFrm_Calculo.LbLinkMouseEnter(Sender: TObject);
begin
  LbLink.Font.Style := Label1.Font.Style + [fsUnderline];
  LbLink.Font.Color := clHighlight;
end;

procedure TFrm_Calculo.LbLinkMouseLeave(Sender: TObject);
begin
  LbLink.Font.Style := Label1.Font.Style - [fsUnderline];
  LbLink.Font.Color := clDefault;
end;

end.
