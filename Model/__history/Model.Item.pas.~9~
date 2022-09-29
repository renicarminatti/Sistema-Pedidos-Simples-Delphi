unit Model.Item;

interface

type
  TItem = class
  private
    FValorTotalItem: Double;
    FCodigoProduto: Integer;
    FValorUnitario: Double;
    FNumero: Integer;
    FQuantidade: Double;
    FNumeroPedido: Integer;
    procedure SetCodigoProduto(const Value: Integer);
    procedure SetNumero(const Value: Integer);
    procedure SetNumeroPedido(const Value: Integer);
    procedure SetQuantidade(const Value: Double);
    procedure SetValorTotalItem(const Value: Double);
    procedure SetValorUnitario(const Value: Double);
  published
  public
    property Numero: Integer read FNumero write SetNumero;
    property NumeroPedido: Integer read FNumeroPedido write SetNumeroPedido;
    property CodigoProduto: Integer read FCodigoProduto write SetCodigoProduto;
    property Quantidade: Double read FQuantidade write SetQuantidade;
    property ValorUnitario: Double read FValorUnitario write SetValorUnitario;
    property ValorTotalItem: Double read FValorTotalItem
      write SetValorTotalItem;
  end;

implementation

{ TItem }

procedure TItem.SetCodigoProduto(const Value: Integer);
begin
  FCodigoProduto := Value;
end;

procedure TItem.SetNumero(const Value: Integer);
begin
  FNumero := Value;
end;

procedure TItem.SetNumeroPedido(const Value: Integer);
begin
  FNumeroPedido := Value;
end;

procedure TItem.SetQuantidade(const Value: Double);
begin
  FQuantidade := Value;
end;

procedure TItem.SetValorTotalItem(const Value: Double);
begin
  FValorTotalItem := Value;
end;

procedure TItem.SetValorUnitario(const Value: Double);
begin
  FValorUnitario := Value;
end;

end.
