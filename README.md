# Calculo-financiamento-DLL-Delphi
 Uso de DLL para realizar calculo de financiamento em Delphi

## ⚡️ Comando na DLL

* ### Uses
 ```delphi
uses Math;
```

* ### Type
 ```delphi
type
  TResultadoCalculo = record
  ValorParcela      : Double;
  TotalJuros        : Double;
  Montante          : Double;
  end;
```

* ### Function
 ```delphi
function CalculoFinanciamento(valor_bem, taxa_juros: Double; num_meses: Integer): TResultadoCalculo; Stdcall;
begin
  {Calcular o valor da parcela}
  Result.ValorParcela := ((taxa_juros / 100) * valor_bem) / (1 - Power(1 + (taxa_juros / 100), -num_meses));
  {Calcular o total de juros}
  Result.TotalJuros := (Result.ValorParcela * num_meses) - valor_bem;
  {Calcular o montante}
  Result.Montante := valor_bem + Result.TotalJuros;
end;
Exports
  CalculoFinanciamento Name 'Calculo';
```


## ⚡️ Carregae DLL em sistema

 
* ### Type
```delphi
type
  TResultadoCalculo = record
  ValorParcela      : Double;
  TotalJuros        : Double;
  Montante          : Double;
  end;

 TProc = function(valor_bem, taxa_juros: Double; num_meses: Integer): TResultadoCalculo; Stdcall;
```


* ### Procedure para calcular
```delphi
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
```
