unit Controller.Item;

interface

uses Model.Item, Model.Pedido, uDM, SysUtils, Data.DB, FireDAC.Comp.Client;

type
  TControllerItens = class
  public
    function InserirItem(Item: TItem): Double;
    function Alterar(Item: TItem): Double;
    function Excluir(Item: TItem): Double;
  end;

implementation

uses Classes, Controller.Pedidos;

{ TControladorItens }

function TControllerItens.Alterar(Item: TItem): Double;
var
  Erro: string;
  Query: TFDQuery;
  ControllerPedido: TControllerPedidos;
  TotalPedido: Double;
begin
  Query := TFDQuery.Create(nil);
  ControllerPedido := TControllerPedidos.Create;
  try
    with Query do
    begin
      Connection := DM.conMySQL;
      Close;
      SQL.Clear;
      SQL.Add(' UPDATE ITENS SET            ');
      SQL.Add('  QUANTIDADE = :QUANTIDADE,  ');
      SQL.Add('  VALORUNITARIO = :UNITARIO, ');
      SQL.Add('  VALORTOTALITEM = :TOTAL    ');
      SQL.Add(' WHERE                       ');
      SQL.Add('  (NUMEROITEM = :NUMERO);    ');
      ParamByName('NUMERO').AsInteger := Item.Numero;
      ParamByName('QUANTIDADE').AsFloat := Item.Quantidade;
      ParamByName('UNITARIO').AsFloat := Item.ValorUnitario;
      ParamByName('TOTAL').AsFloat := Item.ValorTotalItem;
    end;
    try
      Query.ExecSQL;
      with Query do
      begin
        SQL.Clear;
        SQL.Add('SELECT SUM(VALORTOTALITEM) AS VALORTOTALITEM FROM ITENS');
        SQL.Add('WHERE NUMEROPEDIDO = :NUMEROPEDIDO');
        ParamByName('NUMEROPEDIDO').AsInteger := Item.NumeroPedido;
        Open;
        TotalPedido := FieldByName('VALORTOTALITEM').AsFloat;
        ControllerPedido.AtualizarTotal(Item.NumeroPedido);
      end;
    except
      on E: Exception do
      begin
        DM.conMySQL.Rollback;
        Erro := 'Falha ao Alterar o Item ' + IntToStr(Item.Numero);
        Erro := Erro + sLineBreak + E.Message;
        raise Exception.Create(Erro);
      end;
    end;
  finally
    FreeAndNil(Query);
    FreeAndNil(ControllerPedido);
  end;
  Result := TotalPedido;
end;

function TControllerItens.Excluir(Item: TItem): Double;
var
  Erro: string;
  Query: TFDQuery;
  ControllerPedido: TControllerPedidos;
  TotalPedido: Double;
begin
  Query := TFDQuery.Create(nil);
  ControllerPedido := TControllerPedidos.Create;
  try
    with Query do
    begin
      Connection := DM.conMySQL;
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM               ');
      SQL.Add(' ITENS                    ');
      SQL.Add('WHERE                     ');
      SQL.Add('(NUMEROITEM = :NUMERO);   ');
      ParamByName('NUMERO').AsInteger := Item.Numero;
    end;
    try
      Query.ExecSQL;
      with Query do
      begin
        SQL.Clear;
        SQL.Add('SELECT SUM(VALORTOTALITEM) AS VALORTOTALITEM FROM ITENS');
        SQL.Add('WHERE NUMEROPEDIDO = :NUMEROPEDIDO');
        ParamByName('NUMEROPEDIDO').AsInteger := Item.NumeroPedido;
        Open;
        TotalPedido := FieldByName('VALORTOTALITEM').AsFloat;
        ControllerPedido.AtualizarTotal(Item.NumeroPedido);
      end;

    except
      on E: Exception do
      begin
        DM.conMySQL.Rollback;
        Erro := 'Falha ao Excluir o Item';
        Erro := Erro + sLineBreak + E.Message;
      end;
    end;
  finally
    FreeAndNil(Query);
    FreeAndNil(ControllerPedido);
  end;
  Result := TotalPedido;
end;

function TControllerItens.InserirItem(Item: TItem): Double;
var
  Erro: string;
  Query: TFDQuery;
  Pedido: TPedido;
  ControllerPedido: TControllerPedidos;
  TotalPedido: Double;
begin
  Query := TFDQuery.Create(nil);
  ControllerPedido := TControllerPedidos.Create;

  try
    with Query do
    begin
      Connection := DM.conMySQL;
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO ITENS (        ');
      SQL.Add('   NUMEROPEDIDO,           ');
      SQL.Add('   CODIGOPRODUTO,          ');
      SQL.Add('   QUANTIDADE,             ');
      SQL.Add('   VALORUNITARIO,          ');
      SQL.Add('   VALORTOTALITEM          ');
      SQL.Add('    ) VALUES (             ');
      SQL.Add('    :NUMEROPEDIDO,         ');
      SQL.Add('    :CODIGOPRODUTO,        ');
      SQL.Add('    :QUANTIDADE,           ');
      SQL.Add('    :VALORUNITARIO,        ');
      SQL.Add('    :VALORTOTAL            ');
      SQL.Add('    );                     ');
      ParamByName('NUMEROPEDIDO').AsInteger := Item.NumeroPedido;
      ParamByName('CODIGOPRODUTO').AsInteger := Item.CodigoProduto;
      ParamByName('QUANTIDADE').AsFloat := Item.Quantidade;
      ParamByName('VALORUNITARIO').AsFloat := Item.ValorUnitario;
      ParamByName('VALORTOTAL').AsFloat := Item.ValorTotalItem;
    end;
    try
      Query.ExecSQL;
      with Query do
      begin
        SQL.Clear;
        SQL.Add('SELECT SUM(VALORTOTALITEM) AS VALORTOTALITEM FROM ITENS');
        SQL.Add('WHERE NUMEROPEDIDO = :NUMEROPEDIDO');
        ParamByName('NUMEROPEDIDO').AsInteger := Item.NumeroPedido;
        Open;
        TotalPedido := FieldByName('VALORTOTALITEM').AsFloat;
        ControllerPedido.AtualizarTotal(Item.NumeroPedido);
      end;
    except
      on E: Exception do
      begin
        Item.Numero := -1;
        DM.conMySQL.Rollback;
        Erro := 'Falha ao Adicionar Item ao Carrinho/Pedido';
        Erro := Erro + sLineBreak + E.Message;
        raise Exception.Create(Erro);
      end;
    end;
  finally
    FreeAndNil(Query);
    FreeAndNil(ControllerPedido);
  end;
  Result := TotalPedido;
end;

end.
