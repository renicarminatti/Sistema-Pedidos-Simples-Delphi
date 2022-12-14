program Pedidos;

uses
  Vcl.Forms,
  uPDV in 'View\uPDV.pas' {fPDV},
  uDM in 'Model\DataModules\uDM.pas' {DM: TDataModule},
  Model.Cliente in 'Model\Model.Cliente.pas',
  Model.Item in 'Model\Model.Item.pas',
  Model.Pedido in 'Model\Model.Pedido.pas',
  Model.Produto in 'Model\Model.Produto.pas',
  Controller.Produtos in 'Controller\Controller.Produtos.pas',
  Controller.Pedidos in 'Controller\Controller.Pedidos.pas',
  Controller.Clientes in 'Controller\Controller.Clientes.pas',
  Controller.Item in 'Controller\Controller.Item.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfPDV, fPDV);
  Application.CreateForm(TDM, DM);
  Application.Run;

end.
