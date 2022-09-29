unit Controller.Produtos;

interface

uses Model.Produto, uDM, SysUtils, Data.DB, FireDAC.Comp.Client;

type
  TControllerProduto = class
  public

    procedure CarregarProduto(Codigo: Integer; Produto: TProduto); overload;

  end;

implementation

{ TConroladorProduto }

procedure TControllerProduto.CarregarProduto(Codigo: Integer;
  Produto: TProduto);
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
      SQL.Add(' SELECT                    ');
      SQL.Add('     CODIGO,               ');
      SQL.Add('     DESCRICAO,            ');
      SQL.Add('     PRECOVENDA            ');
      SQL.Add(' FROM                      ');
      SQL.Add('     PRODUTOS              ');
      SQL.Add(' WHERE                     ');
      SQL.Add('     (CODIGO = :CODIGO);   ');
      ParamByName('CODIGO').AsInteger := Codigo;
    end;
    try
      Query.Open;
      Produto.Codigo := Query.FieldByName('CODIGO').AsInteger;
      Produto.Descricao := Query.FieldByName('DESCRICAO').AsString;
      Produto.PrecoVenda := Query.FieldByName('PRECOVENDA').AsCurrency;
    except
      on E: Exception do
      begin
        Erro := 'Falha ao Carregar Dados do Produto ' + IntToStr(Codigo);
        Erro := Erro + sLineBreak + E.Message;
        raise Exception.Create(Erro);
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

end.
