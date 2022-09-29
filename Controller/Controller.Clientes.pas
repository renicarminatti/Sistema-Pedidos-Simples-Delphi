unit Controller.Clientes;

interface

uses Model.Cliente, uDM, SysUtils, Data.DB, FireDAC.Comp.Client;

type
  TControllerClientes = class
  private

  public
    procedure CarregaCliente(Codigo: Integer; Cliente: TCliente); overload;
  end;

implementation

{ TcontroladorCliente }

procedure TControllerClientes.CarregaCliente(Codigo: Integer;
  Cliente: TCliente);
var
  Erro: string;
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    with Query do
    begin
      Connection := DM.conMySQL;
      Close;
      SQL.Clear;
      SQL.Add('SELECT               ');
      SQL.Add(' CODIGO,             ');
      SQL.Add(' NOME,               ');
      SQL.Add(' CIDADE,             ');
      SQL.Add(' UF                  ');
      SQL.Add('FROM                 ');
      SQL.Add(' CLIENTES            ');
      SQL.Add('WHERE                ');
      SQL.Add(' (CODIGO = :CODIGO); ');
      ParamByName('CODIGO').AsInteger := Codigo;
    end;
    try
      Query.Open;
      Cliente.Codigo := Query.FieldByName('CODIGO').AsInteger;;
      Cliente.Nome := Query.FieldByName('NOME').AsString;
      Cliente.Cidade := Query.FieldByName('CIDADE').AsString;
      Cliente.UF := Query.FieldByName('UF').AsString;
    except
      on E: Exception do
      begin
        Erro := 'Falha ao Carregar Cliente ' + IntToStr(Codigo);
        Erro := Erro + sLineBreak + E.Message;
        raise Exception.Create(Erro);
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

end.
