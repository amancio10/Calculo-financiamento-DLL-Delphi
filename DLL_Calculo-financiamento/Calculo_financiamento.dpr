library Calculo_financiamento;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters.

  Important note about VCL usage: when this DLL will be implicitly
  loaded and this DLL uses TWicImage / TImageCollection created in
  any unit initialization section, then Vcl.WicImageInit must be
  included into your library's USES clause. }

uses
  System.SysUtils,
  System.Classes,
  Math;

{$R *.res}

type
  TResultadoCalculo = record
  ValorParcela      : Double;
  TotalJuros        : Double;
  Montante          : Double;
  end;
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

begin
end.
