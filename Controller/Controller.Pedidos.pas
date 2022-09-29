unit Controller.Pedidos;

interface

uses Model.Pedido, uDM, SysUtils, Data.DB, FireDAC.Comp.Client;

type
  TControllerPedidos = class
  private

  public
    function NovoPedido(Pedido: TPedido): Integer;
    procedure AlteraCliente(CodCliente, NumeroPedido: Integer);
    procedure AtualizarTotal(Numero: Integer);
    procedure Excluir(Numero: Integer);
    procedure CarregarPedido(Numero: Integer; Pedido: TPedido);
  end;

implementation

{ TControladorPedido }

procedure TControllerPedidos.AlteraCliente(CodCliente, NumeroPedido: Integer);
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
      SQL.Add('UPDATE PEDIDOS SET            ');
      SQL.Add('    CODIGOCLIENTE = :CLIENTE  ');
      SQL.Add('WHERE                         ');
      SQL.Add('    (NUMERO = :NUMERO);       ');
      ParamByName('NUMERO').AsInteger := NumeroPedido;
      ParamByName('CLIENTE').AsInteger := CodCliente;
    end;
    try
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        DM.conMySQL.Rollback;
        Erro := 'Erro ao alterar cliente no pedido numero: ' +
          IntToStr(NumeroPedido);
        Erro := Erro + sLineBreak + E.Message;
        raise Exception.Create(Erro);
      end;
    end;
  finally

    FreeAndNil(Query);
  end;
end;

procedure TControllerPedidos.AtualizarTotal(Numero: Integer);
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
      SQL.Add('UPDATE PEDIDOS SET                   ');
      SQL.Add('   VALORTOTAL =                      ');
      SQL.Add('   (SELECT                           ');
      SQL.Add('     SUM(QUANTIDADE * VALORUNITARIO) ');
      SQL.Add('     FROM ITENS                      ');
      SQL.Add('WHERE (NUMEROPEDIDO = :NUMERO)       ');
      SQL.Add(')                                    ');
      SQL.Add('WHERE                                ');
      SQL.Add('   (NUMERO = :NUMERO);               ');
      ParamByName('NUMERO').AsInteger := Numero;
    end;
    try
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        DM.conMySQL.Rollback;
        Erro := 'Erro no calculo do valor total [';
        Erro := Erro + IntToStr(Numero) + ']';
        Erro := Erro + sLineBreak + E.Message;
        raise Exception.Create(Erro);
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TControllerPedidos.CarregarPedido(Numero: Integer; Pedido: TPedido);
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
      SQL.Add(' NUMERO,             ');
      SQL.Add(' DATAEMISSAO,               ');
      SQL.Add(' CODIGOCLIENTE,             ');
      SQL.Add(' VALORTOTAL                  ');
      SQL.Add('FROM                 ');
      SQL.Add(' PEDIDOS            ');
      SQL.Add('WHERE                ');
      SQL.Add(' (NUMERO = :NUMERO); ');
      ParamByName('NUMERO').AsInteger := Numero;
    end;
    try
      Query.Open;
      Pedido.Numero := Query.FieldByName('NUMERO').AsInteger;;
      Pedido.DataEmissao := Query.FieldByName('DATAEMISSAO').AsDateTime;
      Pedido.CodigoCliente := Query.FieldByName('CODIGOCLIENTE').AsInteger;
      Pedido.ValorTotal := Query.FieldByName('VALORTOTAL').AsCurrency;
    except
      on E: Exception do
      begin
        Erro := 'Falha ao Carregar Pedido ' + IntToStr(Numero);
        Erro := Erro + sLineBreak + E.Message;
        raise Exception.Create(Erro);
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

function TControllerPedidos.NovoPedido(Pedido: TPedido): Integer;
var
  Erro: string;
  Query: TFDQuery;
begin

  Query := TFDQuery.Create(nil);
  try
    with Query do
    begin
      Connection := DM.conMySQL;
      Connection.StartTransaction;
      Close;
      SQL.Clear;
      SQL.Add(' INSERT INTO PEDIDOS (      ');
      SQL.Add('     DATAEMISSAO,           ');
      SQL.Add('     CODIGOCLIENTE,         ');
      SQL.Add('     VALORTOTAL             ');
      SQL.Add('      ) VALUES (            ');
      SQL.Add('       :DATAEMISSAO,        ');
      SQL.Add('       :CODIGOCLIENTE,      ');
      SQL.Add('       :VALORTOTAL          ');
      SQL.Add(');                          ');
      ParamByName('DATAEMISSAO').AsDateTime := Pedido.DataEmissao;
      ParamByName('CODIGOCLIENTE').AsInteger := Pedido.CodigoCliente;
      ParamByName('VALORTOTAL').AsCurrency := Pedido.ValorTotal;
    end;
    try
      Query.ExecSQL;
      with Query do
      begin
        SQL.Clear;
        SQL.Add('SELECT MAX(NUMERO) AS CODIGO FROM PEDIDOS;');
        Open;
        Pedido.Numero := FieldByName('CODIGO').AsInteger;
      end;
    except
      on E: Exception do
      begin
        Pedido.Numero := -1;
        DM.conMySQL.Rollback;
        Erro := 'Falha ao Inserir o Pedido';
        Erro := Erro + sLineBreak + E.Message;
        raise Exception.Create(Erro);
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TControllerPedidos.Excluir(Numero: Integer);
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
      SQL.Add('DELETE FROM PEDIDOS         ');
      SQL.Add('WHERE                       ');
      SQL.Add(' (NUMERO = :NUMERO);        ');
      ParamByName('NUMERO').AsInteger := Numero;
    end;
    try
      Query.ExecSQL;
    except
      on E: Exception do
      begin
        DM.conMySQL.Rollback;
        Erro := 'Falha ao Excluir Pedido ' + IntToStr(Numero);
        Erro := Erro + sLineBreak + E.Message;
      end;
    end;

    with Query do
    begin
      Connection := DM.conMySQL;
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM ITENS                ');
      SQL.Add('WHERE                            ');
      SQL.Add(' (NUMEROPEDIDO = :NUMEROPEDIDO); ');
      ParamByName('NUMEROPEDIDO').AsInteger := Numero;
    end;
    try
      Query.ExecSQL;

    except
      on E: Exception do
      begin
        DM.conMySQL.Rollback;
        Erro := 'Falha ao itens do pedido: ' + IntToStr(Numero);
        Erro := Erro + sLineBreak + E.Message;
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

end.
